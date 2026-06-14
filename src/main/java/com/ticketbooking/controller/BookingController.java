package com.ticketbooking.controller;

import com.ticketbooking.dao.BookingDAO;
import com.ticketbooking.dao.ScheduleDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.Map;

public class BookingController {

    private final BookingDAO  bookingDAO  = new BookingDAO();
    private final ScheduleDAO scheduleDAO = new ScheduleDAO();

    /** Load seat + schedule info, forward to payment form. */
    public void book(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!FrontController.requireLogin(req, resp)) return;

        try {
            int scheduleId = Integer.parseInt(req.getParameter("scheduleId"));
            int seatId     = Integer.parseInt(req.getParameter("seatId"));
            Map<String, Object> schedule = scheduleDAO.getScheduleById(scheduleId);
            req.setAttribute("schedule",   schedule);
            req.setAttribute("scheduleId", scheduleId);
            req.setAttribute("seatId",     seatId);
        } catch (Exception e) {
            req.setAttribute("error", "Error loading booking: " + e.getMessage());
        }
        req.getRequestDispatcher("/jsp/booking/payment.jsp").forward(req, resp);
    }

    /** Process payment form — atomically create booking + payment row. */
    public void confirm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!FrontController.requireLogin(req, resp)) return;

        try {
            int        userId        = (int) req.getSession().getAttribute("userId");
            int        scheduleId    = Integer.parseInt(req.getParameter("scheduleId"));
            int        seatId        = Integer.parseInt(req.getParameter("seatId"));
            String     paymentMethod = req.getParameter("paymentMethod");
            BigDecimal amount        = new BigDecimal(req.getParameter("amount"));

            String ref = bookingDAO.createBooking(userId, scheduleId, seatId, amount, paymentMethod);
            if (ref != null) {
                req.setAttribute("bookingRef", ref);
                req.setAttribute("success", "Booking confirmed! Reference: " + ref);
            } else {
                req.setAttribute("error", "Seat already taken. Please choose another.");
            }
        } catch (Exception e) {
            req.setAttribute("error", "Booking failed: " + e.getMessage());
        }
        req.getRequestDispatcher("/jsp/booking/confirmation.jsp").forward(req, resp);
    }

    public void history(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!FrontController.requireLogin(req, resp)) return;
        try {
            int userId = (int) req.getSession().getAttribute("userId");
            req.setAttribute("bookings", bookingDAO.getBookingsByUser(userId));
        } catch (Exception e) {
            req.setAttribute("error", "Could not load history: " + e.getMessage());
        }
        req.getRequestDispatcher("/jsp/booking/history.jsp").forward(req, resp);
    }

    public void detail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!FrontController.requireLogin(req, resp)) return;
        try {
            int userId    = (int) req.getSession().getAttribute("userId");
            int bookingId = Integer.parseInt(req.getParameter("bookingId"));
            req.setAttribute("booking", bookingDAO.getBookingDetail(bookingId, userId));
        } catch (Exception e) {
            req.setAttribute("error", "Could not load booking: " + e.getMessage());
        }
        req.getRequestDispatcher("/jsp/booking/detail.jsp").forward(req, resp);
    }

    public void cancel(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!FrontController.requireLogin(req, resp)) return;
        try {
            int userId    = (int) req.getSession().getAttribute("userId");
            int bookingId = Integer.parseInt(req.getParameter("bookingId"));
            boolean ok    = bookingDAO.cancelBooking(bookingId, userId);
            req.setAttribute(ok ? "success" : "error",
                             ok ? "Booking cancelled. Refund initiated." : "Cancellation failed.");
            req.setAttribute("bookings", bookingDAO.getBookingsByUser(userId));
        } catch (Exception e) {
            req.setAttribute("error", "Cancel failed: " + e.getMessage());
        }
        req.getRequestDispatcher("/jsp/booking/history.jsp").forward(req, resp);
    }

    public void payment(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!FrontController.requireLogin(req, resp)) return;
        req.getRequestDispatcher("/jsp/booking/payment.jsp").forward(req, resp);
    }
}
