<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Booking Detail – BookIt</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .ticket {
            border: 2px dashed rgba(245,166,35,0.35);
            border-radius: 14px;
            overflow: hidden;
            background: var(--bg-card);
        }
        .ticket-header {
            background: linear-gradient(135deg, #1a1e2e, #131726);
            padding: 1.5rem;
            border-bottom: 2px dashed rgba(245,166,35,0.25);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .ticket-body { padding: 1.5rem; }
        .ticket-row {
            display: flex;
            justify-content: space-between;
            padding: .6rem 0;
            border-bottom: 1px solid var(--border);
            font-size:.9rem;
        }
        .ticket-row:last-child { border-bottom: none; }
        .ticket-row .key  { color: var(--text-muted); }
        .ticket-row .val  { font-weight: 600; text-align: right; }
        .ticket-footer {
            background: var(--bg-elevated);
            padding: 1rem 1.5rem;
            border-top: 2px dashed rgba(245,166,35,0.25);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
    </style>
</head>
<body>
<nav>
    <a class="nav-brand" href="${pageContext.request.contextPath}/index.jsp">BOOK<span>IT</span></a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/app?action=search">Search</a>
        <a href="${pageContext.request.contextPath}/app?action=history" class="active">My Bookings</a>
    </div>
    <div class="nav-user">
        <span>Hello, <strong>${sessionScope.fullName}</strong></span>
        <a href="${pageContext.request.contextPath}/app?action=logout" class="btn btn-secondary btn-sm">Logout</a>
    </div>
</nav>

<div class="container" style="max-width:580px;">
    <div class="d-flex align-center gap-1 mt-2 mb-2">
        <a href="${pageContext.request.contextPath}/app?action=history" class="btn btn-secondary btn-sm">← Back</a>
        <h2 style="font-family:var(--font-mono);font-size:1.1rem;">Ticket Detail</h2>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-error">${error}</div>
    </c:if>

    <c:if test="${not empty booking}">
        <div class="ticket">
            <div class="ticket-header">
                <div>
                    <span class="badge badge-${fn:toLowerCase(booking.routeType)}">${booking.routeType}</span>
                    <div style="font-size:1.25rem;font-weight:700;margin-top:.4rem;">
                        <c:choose>
                            <c:when test="${booking.routeType == 'MOVIE'}">${booking.operator}</c:when>
                            <c:otherwise>${booking.source} → ${booking.destination}</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="text-muted" style="font-size:.82rem;">${booking.operator}</div>
                </div>
                <div style="text-align:right;">
                    <span class="badge badge-${fn:toLowerCase(booking.status)}">${booking.status}</span>
                    <div style="font-family:var(--font-mono);font-size:1.6rem;font-weight:700;color:var(--amber);margin-top:.4rem;">
                        ₹<fmt:formatNumber value="${booking.totalAmount}" maxFractionDigits="0"/>
                    </div>
                </div>
            </div>

            <div class="ticket-body">
                <div class="ticket-row">
                    <span class="key">Booking Reference</span>
                    <span class="val" style="font-family:var(--font-mono);color:var(--amber);">${booking.bookingRef}</span>
                </div>
                <div class="ticket-row">
                    <span class="key">Passenger</span>
                    <span class="val">${sessionScope.fullName}</span>
                </div>
                <div class="ticket-row">
                    <span class="key">Seat Number</span>
                    <span class="val">${booking.seatNumber} &nbsp;<span class="badge badge-pending">${booking.seatType}</span></span>
                </div>
                <div class="ticket-row">
                    <span class="key">Departure</span>
                    <span class="val"><fmt:formatDate value="${booking.departureTime}" pattern="dd MMM yyyy, HH:mm"/></span>
                </div>
                <c:if test="${not empty booking.arrivalTime}">
                <div class="ticket-row">
                    <span class="key">Arrival</span>
                    <span class="val"><fmt:formatDate value="${booking.arrivalTime}" pattern="dd MMM yyyy, HH:mm"/></span>
                </div>
                </c:if>
                <div class="ticket-row">
                    <span class="key">Booked On</span>
                    <span class="val"><fmt:formatDate value="${booking.bookingDate}" pattern="dd MMM yyyy, HH:mm"/></span>
                </div>
                <div class="ticket-row">
                    <span class="key">Payment Status</span>
                    <span class="val">
                        <c:choose>
                            <c:when test="${booking.paymentStatus == 'PAID'}">
                                <span class="badge badge-confirmed">${booking.paymentStatus}</span>
                            </c:when>
                            <c:when test="${booking.paymentStatus == 'REFUNDED'}">
                                <span class="badge badge-cancelled">${booking.paymentStatus}</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-pending">${booking.paymentStatus}</span>
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </div>

            <div class="ticket-footer">
                <div style="font-size:.8rem;color:var(--text-muted);">🔒 Powered by BookIt Secure Pay</div>
                <c:if test="${booking.status == 'CONFIRMED'}">
                    <a href="${pageContext.request.contextPath}/app?action=cancel&bookingId=${booking.bookingId}"
                       class="btn btn-danger btn-sm"
                       onclick="return confirm('Are you sure you want to cancel this booking?')">
                       Cancel Ticket
                    </a>
                </c:if>
            </div>
        </div>
    </c:if>
</div>
</body>
</html>
