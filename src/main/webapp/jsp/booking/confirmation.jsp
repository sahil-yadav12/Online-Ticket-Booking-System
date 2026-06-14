<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Booking Confirmed – BookIt</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        @keyframes pop {
            0%   { transform: scale(0.6); opacity: 0; }
            70%  { transform: scale(1.1); }
            100% { transform: scale(1);   opacity: 1; }
        }
        .check-icon { animation: pop .5s ease forwards; display: inline-block; }
    </style>
</head>
<body>
<nav>
    <a class="nav-brand" href="${pageContext.request.contextPath}/index.jsp">BOOK<span>IT</span></a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/app?action=search">Search</a>
        <a href="${pageContext.request.contextPath}/app?action=history">My Bookings</a>
    </div>
    <div class="nav-user">
        <span>Hello, <strong>${sessionScope.fullName}</strong></span>
        <a href="${pageContext.request.contextPath}/app?action=logout" class="btn btn-secondary btn-sm">Logout</a>
    </div>
</nav>

<div class="container" style="max-width:540px;">
    <div class="mt-3">
        <c:choose>
            <c:when test="${not empty bookingRef}">
                <div class="confirmation-box">
                    <div class="check-icon">✅</div>
                    <h2 style="font-size:1.3rem;margin-bottom:.5rem;">Booking Confirmed!</h2>
                    <p class="text-muted">Your booking reference number is</p>
                    <div class="ref">${bookingRef}</div>
                    <p class="text-muted" style="font-size:.85rem;">
                        Save this number. You'll need it for check-in and cancellations.
                    </p>
                    <div class="d-flex gap-2 justify-between mt-3" style="flex-wrap:wrap;">
                        <a href="${pageContext.request.contextPath}/app?action=history" class="btn btn-primary">View My Bookings</a>
                        <a href="${pageContext.request.contextPath}/app?action=search"  class="btn btn-secondary">Book Another</a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="alert alert-error">${not empty error ? error : 'Booking could not be completed.'}</div>
                <a href="javascript:history.back()" class="btn btn-secondary mt-2">← Go Back</a>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>
