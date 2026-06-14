package com.ticketbooking.controller;

import com.ticketbooking.dao.UserDAO;
import com.ticketbooking.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class UserController {

    private final UserDAO userDAO = new UserDAO();

    public void login(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if ("POST".equalsIgnoreCase(req.getMethod())) {
            String username = req.getParameter("username");
            String password = req.getParameter("password");
            try {
                User user = userDAO.authenticate(username, password);
                if (user != null) {
                    HttpSession session = req.getSession(true);
                    session.setAttribute("userId",   user.getUserId());
                    session.setAttribute("username", user.getUsername());
                    session.setAttribute("fullName", user.getFullName());
                    resp.sendRedirect(req.getContextPath() + "/index.jsp");
                } else {
                    req.setAttribute("error", "Invalid username or password.");
                    req.getRequestDispatcher("/jsp/user/login.jsp").forward(req, resp);
                }
            } catch (Exception e) {
                req.setAttribute("error", "Login failed: " + e.getMessage());
                req.getRequestDispatcher("/jsp/user/login.jsp").forward(req, resp);
            }
        } else {
            req.getRequestDispatcher("/jsp/user/login.jsp").forward(req, resp);
        }
    }

    public void register(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if ("POST".equalsIgnoreCase(req.getMethod())) {
            String username = req.getParameter("username");
            String email    = req.getParameter("email");
            String password = req.getParameter("password");
            String fullName = req.getParameter("fullName");
            String phone    = req.getParameter("phone");

            try {
                if (userDAO.usernameExists(username)) {
                    req.setAttribute("error", "Username already taken.");
                    req.getRequestDispatcher("/jsp/user/register.jsp").forward(req, resp);
                    return;
                }
                if (userDAO.emailExists(email)) {
                    req.setAttribute("error", "Email already registered.");
                    req.getRequestDispatcher("/jsp/user/register.jsp").forward(req, resp);
                    return;
                }
                User user = new User(username, email, password, fullName, phone);
                if (userDAO.registerUser(user)) {
                    req.setAttribute("success", "Registration successful! Please log in.");
                    req.getRequestDispatcher("/jsp/user/login.jsp").forward(req, resp);
                } else {
                    req.setAttribute("error", "Registration failed. Try again.");
                    req.getRequestDispatcher("/jsp/user/register.jsp").forward(req, resp);
                }
            } catch (Exception e) {
                req.setAttribute("error", "Error: " + e.getMessage());
                req.getRequestDispatcher("/jsp/user/register.jsp").forward(req, resp);
            }
        } else {
            req.getRequestDispatcher("/jsp/user/register.jsp").forward(req, resp);
        }
    }

    public void logout(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session != null) session.invalidate();
        resp.sendRedirect(req.getContextPath() + "/index.jsp");
    }

    public void profile(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!FrontController.requireLogin(req, resp)) return;
        req.getRequestDispatcher("/jsp/user/profile.jsp").forward(req, resp);
    }
}
