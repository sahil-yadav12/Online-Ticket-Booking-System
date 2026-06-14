package com.ticketbooking.controller;

import com.ticketbooking.dao.ScheduleDAO;
import com.ticketbooking.dao.SeatDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Map;

public class SearchController {

    private final ScheduleDAO scheduleDAO = new ScheduleDAO();
    private final SeatDAO     seatDAO     = new SeatDAO();

    public void search(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String routeType   = req.getParameter("routeType");
        String source      = req.getParameter("source");
        String destination = req.getParameter("destination");
        String date        = req.getParameter("date");

        try {
            List<Map<String, Object>> results =
                    scheduleDAO.searchSchedules(routeType, source, destination, date);
            req.setAttribute("schedules",    results);
            req.setAttribute("routeType",    routeType);
            req.setAttribute("source",       source);
            req.setAttribute("destination",  destination);
            req.setAttribute("date",         date);
        } catch (Exception e) {
            req.setAttribute("error", "Search failed: " + e.getMessage());
        }
        req.getRequestDispatcher("/jsp/booking/search.jsp").forward(req, resp);
    }

    public void seats(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!FrontController.requireLogin(req, resp)) return;

        int scheduleId = Integer.parseInt(req.getParameter("scheduleId"));
        try {
            Map<String, Object> schedule  = scheduleDAO.getScheduleById(scheduleId);
            List<Map<String, Object>> seats = seatDAO.getSeatsBySchedule(scheduleId);
            req.setAttribute("schedule", schedule);
            req.setAttribute("seats",    seats);
        } catch (Exception e) {
            req.setAttribute("error", "Could not load seats: " + e.getMessage());
        }
        req.getRequestDispatcher("/jsp/booking/seat_selection.jsp").forward(req, resp);
    }
}
