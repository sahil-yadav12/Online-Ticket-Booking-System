package com.ticketbooking.dao;

import com.ticketbooking.util.DBConnection;

import java.sql.*;
import java.util.*;

/**
 * DAO for schedules + routes (search functionality).
 */
public class ScheduleDAO {

    /**
     * Search available schedules.
     * @param routeType  BUS | TRAIN | MOVIE (or null for all)
     * @param source     origin city (ignored for MOVIE)
     * @param destination destination city (ignored for MOVIE)
     * @param date       travel date in "yyyy-MM-dd" format
     */
    public List<Map<String, Object>> searchSchedules(
            String routeType, String source, String destination, String date)
            throws SQLException {

        StringBuilder sql = new StringBuilder(
            "SELECT s.schedule_id, s.departure_time, s.arrival_time, s.price, " +
            "       s.available_seats, s.total_seats, s.status, " +
            "       r.route_type, r.source, r.destination, r.operator " +
            "FROM schedules s JOIN routes r ON s.route_id = r.route_id " +
            "WHERE s.status = 'ACTIVE' AND s.available_seats > 0 ");

        List<Object> params = new ArrayList<>();

        if (routeType != null && !routeType.isEmpty()) {
            sql.append("AND r.route_type = ? ");
            params.add(routeType.toUpperCase());
        }
        if (source != null && !source.isEmpty()) {
            sql.append("AND r.source LIKE ? ");
            params.add("%" + source + "%");
        }
        if (destination != null && !destination.isEmpty()) {
            sql.append("AND r.destination LIKE ? ");
            params.add("%" + destination + "%");
        }
        if (date != null && !date.isEmpty()) {
            sql.append("AND DATE(s.departure_time) = ? ");
            params.add(date);
        }
        sql.append("ORDER BY s.departure_time");

        List<Map<String, Object>> results = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    row.put("scheduleId",     rs.getInt("schedule_id"));
                    row.put("departureTime",  rs.getTimestamp("departure_time"));
                    row.put("arrivalTime",    rs.getTimestamp("arrival_time"));
                    row.put("price",          rs.getBigDecimal("price"));
                    row.put("availableSeats", rs.getInt("available_seats"));
                    row.put("totalSeats",     rs.getInt("total_seats"));
                    row.put("status",         rs.getString("status"));
                    row.put("routeType",      rs.getString("route_type"));
                    row.put("source",         rs.getString("source"));
                    row.put("destination",    rs.getString("destination"));
                    row.put("operator",       rs.getString("operator"));
                    results.add(row);
                }
            }
        }
        return results;
    }

    /** Get single schedule details. */
    public Map<String, Object> getScheduleById(int scheduleId) throws SQLException {
        String sql =
            "SELECT s.*, r.route_type, r.source, r.destination, r.operator " +
            "FROM schedules s JOIN routes r ON s.route_id = r.route_id " +
            "WHERE s.schedule_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, scheduleId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    row.put("scheduleId",     rs.getInt("schedule_id"));
                    row.put("departureTime",  rs.getTimestamp("departure_time"));
                    row.put("arrivalTime",    rs.getTimestamp("arrival_time"));
                    row.put("price",          rs.getBigDecimal("price"));
                    row.put("availableSeats", rs.getInt("available_seats"));
                    row.put("totalSeats",     rs.getInt("total_seats"));
                    row.put("status",         rs.getString("status"));
                    row.put("routeType",      rs.getString("route_type"));
                    row.put("source",         rs.getString("source"));
                    row.put("destination",    rs.getString("destination"));
                    row.put("operator",       rs.getString("operator"));
                    return row;
                }
            }
        }
        return null;
    }

    /** Decrement available seats by 1 (called within booking transaction). */
    public void decrementSeat(Connection conn, int scheduleId) throws SQLException {
        String sql = "UPDATE schedules SET available_seats = available_seats - 1 WHERE schedule_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, scheduleId);
            ps.executeUpdate();
        }
    }

    /** Increment available seats by 1 (called on cancellation). */
    public void incrementSeat(Connection conn, int scheduleId) throws SQLException {
        String sql = "UPDATE schedules SET available_seats = available_seats + 1 WHERE schedule_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, scheduleId);
            ps.executeUpdate();
        }
    }
}
