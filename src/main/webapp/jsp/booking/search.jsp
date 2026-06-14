<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Search Results – BookIt</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<nav>
    <a class="nav-brand" href="${pageContext.request.contextPath}/index.jsp">BOOK<span>IT</span></a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/app?action=search">Search</a>
        <c:if test="${not empty sessionScope.userId}">
            <a href="${pageContext.request.contextPath}/app?action=history">My Bookings</a>
        </c:if>
    </div>
    <div class="nav-user">
        <c:choose>
            <c:when test="${not empty sessionScope.userId}">
                <span>Hello, <strong>${sessionScope.fullName}</strong></span>
                <a href="${pageContext.request.contextPath}/app?action=logout" class="btn btn-secondary btn-sm">Logout</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/app?action=login"    class="btn btn-secondary btn-sm">Login</a>
                <a href="${pageContext.request.contextPath}/app?action=register" class="btn btn-primary    btn-sm">Register</a>
            </c:otherwise>
        </c:choose>
    </div>
</nav>

<!-- Compact search bar at top -->
<div style="background:var(--bg-card);border-bottom:1px solid var(--border);padding:1rem 2rem;">
    <form class="search-form" method="get" action="${pageContext.request.contextPath}/app" style="max-width:900px;margin:0 auto;">
        <input type="hidden" name="action" value="search">
        <select name="routeType" class="form-control" style="flex:0 0 130px;">
            <option value=""      ${empty routeType ? 'selected':''}>All Types</option>
            <option value="BUS"   ${'BUS'   == routeType ? 'selected':''}>🚌 Bus</option>
            <option value="TRAIN" ${'TRAIN' == routeType ? 'selected':''}>🚆 Train</option>
            <option value="MOVIE" ${'MOVIE' == routeType ? 'selected':''}>🎬 Movie</option>
        </select>
        <input type="text" name="source"      value="${source}"      placeholder="From">
        <input type="text" name="destination" value="${destination}" placeholder="To">
        <input type="date" name="date"        value="${date}">
        <button type="submit" class="btn btn-primary">Search</button>
    </form>
</div>

<div class="container">
    <c:if test="${not empty error}">
        <div class="alert alert-error">${error}</div>
    </c:if>

    <div class="d-flex align-center justify-between mb-2">
        <h2 style="font-size:1.1rem;font-weight:600;">
            <c:choose>
                <c:when test="${empty schedules}">No results found</c:when>
                <c:otherwise>${schedules.size()} result(s) found</c:otherwise>
            </c:choose>
        </h2>
    </div>

    <c:choose>
        <c:when test="${empty schedules}">
            <div class="card text-center" style="padding:3rem;">
                <div style="font-size:3rem;">🔍</div>
                <p class="text-muted mt-1">Try different dates, routes, or transport types.</p>
                <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-secondary mt-2">Back to Home</a>
            </div>
        </c:when>
        <c:otherwise>
            <c:forEach var="s" items="${schedules}">
                <div class="card">
                    <div class="schedule-card">
                        <!-- Route info -->
                        <div class="route-info">
                            <span class="badge badge-${fn:toLowerCase(s.routeType)}">${s.routeType}</span>
                            <div class="route-label mt-1">
                                <c:choose>
                                    <c:when test="${s.routeType == 'MOVIE'}">${s.operator}</c:when>
                                    <c:otherwise>${s.source} → ${s.destination}</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="operator">${s.operator}</div>
                        </div>

                        <!-- Time info -->
                        <div class="time-info">
                            <div class="time-block">
                                <div class="time">
                                    <fmt:formatDate value="${s.departureTime}" pattern="HH:mm"/>
                                </div>
                                <div class="label">
                                    <fmt:formatDate value="${s.departureTime}" pattern="dd MMM"/>
                                </div>
                            </div>
                            <div class="time-arrow">→</div>
                            <c:if test="${not empty s.arrivalTime}">
                                <div class="time-block">
                                    <div class="time">
                                        <fmt:formatDate value="${s.arrivalTime}" pattern="HH:mm"/>
                                    </div>
                                    <div class="label">
                                        <fmt:formatDate value="${s.arrivalTime}" pattern="dd MMM"/>
                                    </div>
                                </div>
                            </c:if>
                        </div>

                        <!-- Price & Book -->
                        <div class="price-block">
                            <div class="price">₹<fmt:formatNumber value="${s.price}" maxFractionDigits="0"/></div>
                            <div class="seats">${s.availableSeats} seats left</div>
                            <a href="${pageContext.request.contextPath}/app?action=seats&scheduleId=${s.scheduleId}"
                               class="btn btn-primary btn-sm mt-1">Select Seat</a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>
