package com.ticketbooking.dao;

import com.ticketbooking.util.DBConnection;

import java.sql.*;
import java.util.*;

/**
 * Data-Access Object for the seats table.
 */
public class SeatDAO {

    /** Returns all seats for a given schedule with their booking status. */
    public List<Map<String, Object>> getSeatsBySchedule(int scheduleId) throws SQLException {
        String sql = "SELECT seat_id, seat_number, seat_type, is_booked " +
                     "FROM seats WHERE schedule_id = ? ORDER BY seat_number";
        List<Map<String, Object>> seats = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, scheduleId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> s = new LinkedHashMap<>();
                    s.put("seatId",     rs.getInt("seat_id"));
                    s.put("seatNumber", rs.getString("seat_number"));
                    s.put("seatType",   rs.getString("seat_type"));
                    s.put("isBooked",   rs.getBoolean("is_booked"));
                    seats.add(s);
                }
            }
        }
        return seats;
    }

    /**
     * Lock and mark a seat as booked within an existing transaction.
     * Uses SELECT FOR UPDATE to prevent concurrent double-booking.
     * Returns false if the seat is already booked.
     */
    public boolean markBooked(Connection conn, int seatId) throws SQLException {
        String check = "SELECT is_booked FROM seats WHERE seat_id = ? FOR UPDATE";
        try (PreparedStatement ps = conn.prepareStatement(check)) {
            ps.setInt(1, seatId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next() || rs.getBoolean("is_booked")) return false;
            }
        }
        String upd = "UPDATE seats SET is_booked = TRUE WHERE seat_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(upd)) {
            ps.setInt(1, seatId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Free a seat back to available (called on booking cancellation).
     */
    public boolean markFree(Connection conn, int seatId) throws SQLException {
        String sql = "UPDATE seats SET is_booked = FALSE WHERE seat_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, seatId);
            return ps.executeUpdate() > 0;
        }
    }
}
