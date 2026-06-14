<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BookIt – Online Ticket Booking</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<!-- Navigation -->
<nav>
    <a class="nav-brand" href="${pageContext.request.contextPath}/index.jsp">BOOK<span>IT</span></a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/app?action=search" class="active">Search</a>
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

<!-- Hero -->
<section class="hero">
    <h1>Book Your Journey with <em>BookIt</em></h1>
    <p>Bus · Train · Movie — all in one place</p>

    <!-- Type tabs -->
    <div class="type-tabs">
        <button class="type-tab active" onclick="setType('BUS',  this)">🚌 Bus</button>
        <button class="type-tab"        onclick="setType('TRAIN',this)">🚆 Train</button>
        <button class="type-tab"        onclick="setType('MOVIE',this)">🎬 Movie</button>
    </div>

    <!-- Search form -->
    <form class="search-form" method="get" action="${pageContext.request.contextPath}/app">
        <input type="hidden" name="action"    value="search">
        <input type="hidden" name="routeType" id="routeType" value="BUS">

        <input type="text" name="source"      id="source"      placeholder="From (city)"  value="">
        <input type="text" name="destination" id="destination" placeholder="To (city)"    value="">
        <input type="date" name="date"        id="date"        value="">
        <button type="submit" class="btn btn-primary">Search →</button>
    </form>
</section>

<!-- Features -->
<div class="container">
    <div class="grid-2" style="margin-top:2rem; grid-template-columns: repeat(3,1fr);">
        <div class="card" style="text-align:center;">
            <div style="font-size:2rem;margin-bottom:.5rem">🚌</div>
            <div class="card-title">Bus Tickets</div>
            <p class="text-muted" style="font-size:.85rem">KSRTC, VRL, SRS &amp; more operators</p>
        </div>
        <div class="card" style="text-align:center;">
            <div style="font-size:2rem;margin-bottom:.5rem">🚆</div>
            <div class="card-title">Train Tickets</div>
            <p class="text-muted" style="font-size:.85rem">All Indian Railways routes</p>
        </div>
        <div class="card" style="text-align:center;">
            <div style="font-size:2rem;margin-bottom:.5rem">🎬</div>
            <div class="card-title">Movie Tickets</div>
            <p class="text-muted" style="font-size:.85rem">PVR, INOX &amp; leading theatres</p>
        </div>
    </div>
</div>

<script>
function setType(type, el) {
    document.getElementById('routeType').value = type;
    document.querySelectorAll('.type-tab').forEach(t => t.classList.remove('active'));
    el.classList.add('active');
    // Show/hide city fields for movies
    const cityFields = document.querySelectorAll('#source, #destination');
    cityFields.forEach(f => { f.style.display = type === 'MOVIE' ? 'none' : ''; });
}
</script>
</body>
</html>
