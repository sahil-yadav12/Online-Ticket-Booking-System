<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Payment – BookIt</title>
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

<div class="container" style="max-width:600px;">
    <c:if test="${not empty error}">
        <div class="alert alert-error">${error}</div>
    </c:if>

    <div class="card mt-3">
        <h2 style="font-family:var(--font-mono);margin-bottom:1.5rem;font-size:1.2rem;">
            💳 Payment <span class="text-amber">Simulation</span>
        </h2>

        <!-- Order summary -->
        <c:if test="${not empty schedule}">
        <div style="background:var(--bg-elevated);border-radius:var(--radius);padding:1rem;margin-bottom:1.5rem;">
            <p class="text-muted" style="font-size:.8rem;text-transform:uppercase;letter-spacing:.06em;margin-bottom:.5rem;">Order Summary</p>
            <div class="d-flex justify-between align-center">
                <div>
                    <strong>
                        <c:choose>
                            <c:when test="${schedule.routeType == 'MOVIE'}">${schedule.operator}</c:when>
                            <c:otherwise>${schedule.source} → ${schedule.destination}</c:otherwise>
                        </c:choose>
                    </strong>
                    <p class="text-muted" style="font-size:.85rem;margin-top:.2rem;">
                        <fmt:formatDate value="${schedule.departureTime}" pattern="dd MMM yyyy, HH:mm"/>
                        &nbsp;|&nbsp; ${schedule.operator}
                    </p>
                </div>
                <div style="text-align:right;">
                    <div style="font-family:var(--font-mono);font-size:1.4rem;color:var(--amber);font-weight:700;">
                        ₹<fmt:formatNumber value="${schedule.price}" maxFractionDigits="0"/>
                    </div>
                </div>
            </div>
        </div>
        </c:if>

        <!-- Payment form -->
        <form method="post" action="${pageContext.request.contextPath}/app?action=confirm" onsubmit="return simulatePayment(event)">
            <input type="hidden" name="scheduleId" value="${scheduleId}">
            <input type="hidden" name="seatId"     value="${seatId}">
            <input type="hidden" name="amount"     value="${schedule.price}">

            <p style="font-size:.9rem;font-weight:600;margin-bottom:.75rem;">Select Payment Method</p>
            <div class="payment-methods">
                <label class="payment-option">
                    <input type="radio" name="paymentMethod" value="CREDIT_CARD" checked>
                    <div class="pm-icon">💳</div>
                    <div class="pm-name">Credit Card</div>
                </label>
                <label class="payment-option">
                    <input type="radio" name="paymentMethod" value="DEBIT_CARD">
                    <div class="pm-icon">🏧</div>
                    <div class="pm-name">Debit Card</div>
                </label>
                <label class="payment-option">
                    <input type="radio" name="paymentMethod" value="UPI">
                    <div class="pm-icon">📱</div>
                    <div class="pm-name">UPI</div>
                </label>
                <label class="payment-option">
                    <input type="radio" name="paymentMethod" value="NET_BANKING">
                    <div class="pm-icon">🏦</div>
                    <div class="pm-name">Net Banking</div>
                </label>
            </div>

            <!-- Simulated card fields (UI only) -->
            <div id="cardFields">
                <div class="form-group">
                    <label class="form-label">Card Number</label>
                    <input class="form-control" type="text" placeholder="4242 4242 4242 4242" maxlength="19" oninput="formatCard(this)">
                </div>
                <div class="grid-2">
                    <div class="form-group">
                        <label class="form-label">Expiry</label>
                        <input class="form-control" type="text" placeholder="MM / YY" maxlength="7">
                    </div>
                    <div class="form-group">
                        <label class="form-label">CVV</label>
                        <input class="form-control" type="password" placeholder="•••" maxlength="3">
                    </div>
                </div>
            </div>

            <div id="upiField" style="display:none;">
                <div class="form-group">
                    <label class="form-label">UPI ID</label>
                    <input class="form-control" type="text" placeholder="yourname@upi">
                </div>
            </div>

            <div id="loadingState" style="display:none;" class="alert alert-info">
                ⏳ Processing payment... please wait.
            </div>

            <button type="submit" class="btn btn-primary w-100" id="payBtn" style="margin-top:.5rem;">
                Pay ₹<fmt:formatNumber value="${schedule.price}" maxFractionDigits="0"/> →
            </button>
        </form>

        <p class="text-center text-muted mt-2" style="font-size:.78rem;">
            🔒 This is a simulated payment. No real transaction occurs.
        </p>
    </div>
</div>

<script>
// Show/hide fields by payment method
document.querySelectorAll('input[name="paymentMethod"]').forEach(radio => {
    radio.addEventListener('change', function() {
        document.getElementById('cardFields').style.display =
            (this.value === 'CREDIT_CARD' || this.value === 'DEBIT_CARD') ? '' : 'none';
        document.getElementById('upiField').style.display =
            this.value === 'UPI' ? '' : 'none';
    });
});

function formatCard(input) {
    let v = input.value.replace(/\D/g, '').substring(0, 16);
    input.value = v.replace(/(.{4})/g, '$1 ').trim();
}

function simulatePayment(e) {
    document.getElementById('loadingState').style.display = '';
    document.getElementById('payBtn').disabled = true;
    document.getElementById('payBtn').textContent = 'Processing...';
    return true; // allow form submit
}
</script>
</body>
</html>
