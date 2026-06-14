package com.ticketbooking.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Front Controller – single entry point for all /app/* requests.
 * Routes to the appropriate handler based on the "action" parameter.
 */
public class FrontController extends HttpServlet {

    private UserController    userCtrl;
    private SearchController  searchCtrl;
    private BookingController bookingCtrl;

    @Override
    public void init() {
        userCtrl    = new UserController();
        searchCtrl  = new SearchController();
        bookingCtrl = new BookingController();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        process(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        process(req, resp);
    }

    private void process(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        if (action == null) action = "";

        try {
            switch (action) {
                // ── Auth ───────────────────────────────────────────
                case "login"    -> userCtrl.login(req, resp);
                case "register" -> userCtrl.register(req, resp);
                case "logout"   -> userCtrl.logout(req, resp);
                case "profile"  -> userCtrl.profile(req, resp);

                // ── Search ─────────────────────────────────────────
                case "search"   -> searchCtrl.search(req, resp);
                case "seats"    -> searchCtrl.seats(req, resp);

                // ── Booking ────────────────────────────────────────
                case "book"     -> bookingCtrl.book(req, resp);
                case "confirm"  -> bookingCtrl.confirm(req, resp);
                case "history"  -> bookingCtrl.history(req, resp);
                case "detail"   -> bookingCtrl.detail(req, resp);
                case "cancel"   -> bookingCtrl.cancel(req, resp);
                case "payment"  -> bookingCtrl.payment(req, resp);

                default -> resp.sendRedirect(req.getContextPath() + "/index.jsp");
            }
        } catch (Exception e) {
            req.setAttribute("errorMessage", "An unexpected error occurred: " + e.getMessage());
            req.getRequestDispatcher("/jsp/error.jsp").forward(req, resp);
        }
    }

    /** Guard: redirects to login if not authenticated. Returns false if redirected. */
    static boolean requireLogin(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/user/login.jsp");
            return false;
        }
        return true;
    }
}
