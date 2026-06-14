<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Select Seat – BookIt</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
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

<div class="container">
    <c:if test="${not empty error}">
        <div class="alert alert-error">${error}</div>
    </c:if>

    <c:if test="${not empty schedule}">
        <!-- Schedule summary -->
        <div class="card mb-2">
            <div class="d-flex align-center justify-between">
                <div>
                    <span class="badge badge-${fn:toLowerCase(schedule.routeType)}">${schedule.routeType}</span>
                    <h2 style="margin-top:.5rem;font-size:1.2rem;">
                        <c:choose>
                            <c:when test="${schedule.routeType == 'MOVIE'}">${schedule.operator}</c:when>
                            <c:otherwise>${schedule.source} → ${schedule.destination}</c:otherwise>
                        </c:choose>
                    </h2>
                    <p class="text-muted" style="font-size:.85rem;">
                        ${schedule.operator} &nbsp;|&nbsp;
                        Departs <fmt:formatDate value="${schedule.departureTime}" pattern="dd MMM yyyy, HH:mm"/>
                    </p>
                </div>
                <div style="text-align:right;">
                    <div style="font-family:var(--font-mono);font-size:1.6rem;color:var(--amber);">
                        ₹<fmt:formatNumber value="${schedule.price}" maxFractionDigits="0"/>
                    </div>
                    <div class="text-muted" style="font-size:.8rem;">${schedule.availableSeats} seats available</div>
                </div>
            </div>
        </div>

        <!-- Seat map -->
        <div class="card">
            <h3 style="margin-bottom:1rem;">Choose Your Seat</h3>

            <div class="seat-legend">
                <div class="legend-item"><div class="legend-dot available"></div>Available</div>
                <div class="legend-item"><div class="legend-dot selected"></div>Selected</div>
                <div class="legend-item"><div class="legend-dot booked"></div>Booked</div>
            </div>

            <div class="seat-grid" id="seatGrid">
                <c:forEach var="seat" items="${seats}">
                    <c:choose>
                        <c:when test="${seat.isBooked}">
                            <button class="seat-btn"
                                    data-seat-id="${seat.seatId}"
                                    data-seat-number="${seat.seatNumber}"
                                    disabled
                                    title="${seat.seatType}">
                                <span>${seat.seatNumber}</span>
                            </button>
                        </c:when>
                        <c:otherwise>
                            <button class="seat-btn"
                                    data-seat-id="${seat.seatId}"
                                    data-seat-number="${seat.seatNumber}"
                                    onclick="selectSeat(this)"
                                    title="${seat.seatType}">
                                <span>${seat.seatNumber}</span>
                            </button>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            </div>

            <!-- Booking footer -->
            <div id="bookingFooter" style="display:none;margin-top:1.5rem;padding-top:1rem;border-top:1px solid var(--border);">
                <div class="d-flex align-center justify-between">
                    <div>
                        <p class="text-muted" style="font-size:.85rem;">Selected Seat</p>
                        <p style="font-size:1.1rem;font-weight:700;" id="selectedSeatLabel">—</p>
                    </div>
                    <div style="text-align:right;">
                        <p class="text-muted" style="font-size:.85rem;">Total Amount</p>
                        <p style="font-size:1.3rem;font-weight:700;color:var(--amber);" id="totalAmount">
                            ₹<fmt:formatNumber value="${schedule.price}" maxFractionDigits="0"/>
                        </p>
                    </div>
                    <a id="proceedBtn" href="#" class="btn btn-primary">Proceed to Payment →</a>
                </div>
            </div>
        </div>
    </c:if>
</div>

<script>
    const scheduleId = ${schedule.scheduleId};
    const price      = ${schedule.price};
    const contextPath = '${pageContext.request.contextPath}';
    let selectedSeatId = null;

    function selectSeat(btn) {
        // Deselect previous
        document.querySelectorAll('.seat-btn.selected').forEach(b => b.classList.remove('selected'));

        btn.classList.add('selected');
        selectedSeatId = btn.dataset.seatId;
        const seatNum  = btn.dataset.seatNumber;

        document.getElementById('selectedSeatLabel').textContent = 'Seat ' + seatNum;
        document.getElementById('bookingFooter').style.display = '';
        document.getElementById('proceedBtn').href =
            contextPath + '/app?action=book&scheduleId=' + scheduleId + '&seatId=' + selectedSeatId;
    }
</script>
</body>
</html>
