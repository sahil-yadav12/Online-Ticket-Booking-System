package com.ticketbooking.dao;

import com.ticketbooking.util.DBConnection;
import com.ticketbooking.util.PasswordUtil;

import java.math.BigDecimal;
import java.sql.*;
import java.util.*;

/**
 * Data-Access Object for bookings and payments.
 * Depends on SeatDAO and ScheduleDAO (both standalone public classes).
 */
public class BookingDAO {

    private final SeatDAO     seatDAO     = new SeatDAO();
    private final ScheduleDAO scheduleDAO = new ScheduleDAO();

    /**
     * Creates a booking atomically:
     *  1. Lock & mark seat
     *  2. Decrement available_seats
     *  3. Insert booking row
     *  4. Insert payment row
     * Returns the new booking's reference string, or null on failure.
     */
    public String createBooking(int userId, int scheduleId, int seatId,
                                BigDecimal amount, String paymentMethod)
            throws SQLException {

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // 1. Lock seat
            if (!seatDAO.markBooked(conn, seatId)) {
                conn.rollback();
                return null; // seat already taken
            }

            // 2. Decrement schedule seat count
            scheduleDAO.decrementSeat(conn, scheduleId);

            // 3. Insert booking
            String ref = PasswordUtil.generateBookingRef();
            String bkSql = "INSERT INTO bookings " +
                           "(user_id, schedule_id, seat_id, total_amount, status, payment_status, booking_ref) " +
                           "VALUES (?,?,?,?,'CONFIRMED','PENDING',?)";
            int bookingId;
            try (PreparedStatement ps = conn.prepareStatement(bkSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, userId);
                ps.setInt(2, scheduleId);
                ps.setInt(3, seatId);
                ps.setBigDecimal(4, amount);
                ps.setString(5, ref);
                ps.executeUpdate();
                try (ResultSet gk = ps.getGeneratedKeys()) {
                    gk.next();
                    bookingId = gk.getInt(1);
                }
            }

            // 4. Simulate payment
            String txId = "TXN" + System.currentTimeMillis();
            String pmSql = "INSERT INTO payments (booking_id, amount, payment_method, transaction_id, status) " +
                           "VALUES (?,?,?,?,'SUCCESS')";
            try (PreparedStatement ps = conn.prepareStatement(pmSql)) {
                ps.setInt(1, bookingId);
                ps.setBigDecimal(2, amount);
                ps.setString(3, paymentMethod);
                ps.setString(4, txId);
                ps.executeUpdate();
            }

            // 5. Update booking payment_status
            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE bookings SET payment_status='PAID' WHERE booking_id=?")) {
                ps.setInt(1, bookingId);
                ps.executeUpdate();
            }

            conn.commit();
            return ref;

        } catch (SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ignored) {}
            throw e;
        } finally {
            DBConnection.close(conn);
        }
    }

    /** Returns all bookings for a user (JOIN-enriched). */
    public List<Map<String, Object>> getBookingsByUser(int userId) throws SQLException {
        String sql =
            "SELECT b.booking_id, b.booking_ref, b.booking_date, b.total_amount, " +
            "       b.status, b.payment_status, " +
            "       r.route_type, r.source, r.destination, r.operator, " +
            "       s.departure_time, se.seat_number " +
            "FROM bookings b " +
            "JOIN schedules s  ON b.schedule_id = s.schedule_id " +
            "JOIN routes r     ON s.route_id    = r.route_id " +
            "JOIN seats se     ON b.seat_id     = se.seat_id " +
            "WHERE b.user_id = ? ORDER BY b.booking_date DESC";

        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    row.put("bookingId",     rs.getInt("booking_id"));
                    row.put("bookingRef",    rs.getString("booking_ref"));
                    row.put("bookingDate",   rs.getTimestamp("booking_date"));
                    row.put("totalAmount",   rs.getBigDecimal("total_amount"));
                    row.put("status",        rs.getString("status"));
                    row.put("paymentStatus", rs.getString("payment_status"));
                    row.put("routeType",     rs.getString("route_type"));
                    row.put("source",        rs.getString("source"));
                    row.put("destination",   rs.getString("destination"));
                    row.put("operator",      rs.getString("operator"));
                    row.put("departureTime", rs.getTimestamp("departure_time"));
                    row.put("seatNumber",    rs.getString("seat_number"));
                    list.add(row);
                }
            }
        }
        return list;
    }

    /** Cancel a booking – frees seat, updates status, records refund. */
    public boolean cancelBooking(int bookingId, int userId) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // 1. Fetch + lock the booking row
            int seatId = -1, scheduleId = -1;
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT seat_id, schedule_id, status FROM bookings WHERE booking_id=? AND user_id=? FOR UPDATE")) {
                ps.setInt(1, bookingId);
                ps.setInt(2, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) { conn.rollback(); return false; }
                    if ("CANCELLED".equals(rs.getString("status"))) { conn.rollback(); return false; }
                    seatId     = rs.getInt("seat_id");
                    scheduleId = rs.getInt("schedule_id");
                }
            }

            // 2. Free seat + restore available count
            seatDAO.markFree(conn, seatId);
            scheduleDAO.incrementSeat(conn, scheduleId);

            // 3. Mark booking cancelled
            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE bookings SET status='CANCELLED', payment_status='REFUNDED' WHERE booking_id=?")) {
                ps.setInt(1, bookingId);
                ps.executeUpdate();
            }

            // 4. Insert refund payment record
            try (PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO payments (booking_id, amount, payment_method, transaction_id, status) " +
                    "SELECT booking_id, total_amount, 'REFUND', CONCAT('REF', ?), 'REFUNDED' FROM bookings WHERE booking_id=?")) {
                ps.setLong(1, System.currentTimeMillis());
                ps.setInt(2, bookingId);
                ps.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ignored) {}
            throw e;
        } finally {
            DBConnection.close(conn);
        }
    }

    /** Get single booking detail (user ownership check). */
    public Map<String, Object> getBookingDetail(int bookingId, int userId) throws SQLException {
        String sql =
            "SELECT b.*, r.route_type, r.source, r.destination, r.operator, " +
            "       s.departure_time, s.arrival_time, se.seat_number, se.seat_type " +
            "FROM bookings b " +
            "JOIN schedules s  ON b.schedule_id = s.schedule_id " +
            "JOIN routes r     ON s.route_id    = r.route_id " +
            "JOIN seats se     ON b.seat_id     = se.seat_id " +
            "WHERE b.booking_id = ? AND b.user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    row.put("bookingId",     rs.getInt("booking_id"));
                    row.put("bookingRef",    rs.getString("booking_ref"));
                    row.put("bookingDate",   rs.getTimestamp("booking_date"));
                    row.put("totalAmount",   rs.getBigDecimal("total_amount"));
                    row.put("status",        rs.getString("status"));
                    row.put("paymentStatus", rs.getString("payment_status"));
                    row.put("routeType",     rs.getString("route_type"));
                    row.put("source",        rs.getString("source"));
                    row.put("destination",   rs.getString("destination"));
                    row.put("operator",      rs.getString("operator"));
                    row.put("departureTime", rs.getTimestamp("departure_time"));
                    row.put("arrivalTime",   rs.getTimestamp("arrival_time"));
                    row.put("seatNumber",    rs.getString("seat_number"));
                    row.put("seatType",      rs.getString("seat_type"));
                    return row;
                }
            }
        }
        return null;
    }
}
