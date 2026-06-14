<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Bookings – BookIt</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
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

<div class="container">
    <div class="d-flex align-center justify-between mb-2 mt-1">
        <h2 style="font-family:var(--font-mono);font-size:1.2rem;">My Bookings</h2>
        <a href="${pageContext.request.contextPath}/app?action=search" class="btn btn-primary btn-sm">+ New Booking</a>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-error">${error}</div>
    </c:if>
    <c:if test="${not empty success}">
        <div class="alert alert-success">${success}</div>
    </c:if>

    <c:choose>
        <c:when test="${empty bookings}">
            <div class="card text-center" style="padding:3rem;">
                <div style="font-size:3rem;">🎫</div>
                <p class="text-muted mt-1">You have no bookings yet.</p>
                <a href="${pageContext.request.contextPath}/app?action=search" class="btn btn-primary mt-2">Book Now</a>
            </div>
        </c:when>
        <c:otherwise>
            <c:forEach var="b" items="${bookings}">
                <div class="card">
                    <div class="d-flex align-center justify-between" style="flex-wrap:wrap;gap:.75rem;">
                        <!-- Left: route details -->
                        <div>
                            <div class="d-flex align-center gap-1" style="margin-bottom:.4rem;">
                                <span class="badge badge-${fn:toLowerCase(b.routeType)}">${b.routeType}</span>
                                <span class="badge badge-${fn:toLowerCase(b.status)}">${b.status}</span>
                            </div>
                            <div style="font-weight:700;font-size:1rem;">
                                <c:choose>
                                    <c:when test="${b.routeType == 'MOVIE'}">${b.operator}</c:when>
                                    <c:otherwise>${b.source} → ${b.destination}</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="text-muted" style="font-size:.82rem;margin-top:.25rem;">
                                ${b.operator}
                                &nbsp;|&nbsp; Seat ${b.seatNumber}
                                &nbsp;|&nbsp; <fmt:formatDate value="${b.departureTime}" pattern="dd MMM yyyy, HH:mm"/>
                            </div>
                        </div>

                        <!-- Middle: ref + date -->
                        <div style="text-align:center;">
                            <div style="font-family:var(--font-mono);font-size:.75rem;color:var(--text-muted);">REF</div>
                            <div style="font-family:var(--font-mono);font-weight:700;color:var(--amber);font-size:1rem;">${b.bookingRef}</div>
                            <div class="text-muted" style="font-size:.75rem;">
                                Booked <fmt:formatDate value="${b.bookingDate}" pattern="dd MMM"/>
                            </div>
                        </div>

                        <!-- Right: amount + actions -->
                        <div style="text-align:right;">
                            <div style="font-family:var(--font-mono);font-size:1.3rem;font-weight:700;color:var(--amber);">
                                ₹<fmt:formatNumber value="${b.totalAmount}" maxFractionDigits="0"/>
                            </div>
                            <div class="text-muted" style="font-size:.75rem;margin-bottom:.5rem;">${b.paymentStatus}</div>
                            <div class="d-flex gap-1">
                                <a href="${pageContext.request.contextPath}/app?action=detail&bookingId=${b.bookingId}"
                                   class="btn btn-secondary btn-sm">Details</a>
                                <c:if test="${b.status == 'CONFIRMED'}">
                                    <a href="${pageContext.request.contextPath}/app?action=cancel&bookingId=${b.bookingId}"
                                       class="btn btn-danger btn-sm"
                                       onclick="return confirm('Cancel booking ${b.bookingRef}? A refund will be initiated.')">
                                       Cancel
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>
