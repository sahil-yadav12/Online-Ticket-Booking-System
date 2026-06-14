<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Profile – BookIt</title>
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

<div class="container" style="max-width:480px;">
    <div class="card mt-3">
        <div style="text-align:center;padding:1.5rem 0;">
            <div style="width:72px;height:72px;border-radius:50%;background:var(--amber);
                        display:flex;align-items:center;justify-content:center;
                        font-size:1.8rem;font-weight:700;color:#000;margin:0 auto .75rem;">
                ${sessionScope.fullName.charAt(0)}
            </div>
            <h2 style="font-size:1.2rem;">${sessionScope.fullName}</h2>
            <p class="text-muted" style="font-size:.85rem;">@${sessionScope.username}</p>
        </div>
        <div style="border-top:1px solid var(--border);padding-top:1rem;">
            <div class="ticket-row d-flex justify-between" style="padding:.6rem 0;border-bottom:1px solid var(--border);">
                <span class="text-muted">Username</span>
                <span style="font-weight:600;">${sessionScope.username}</span>
            </div>
            <div class="ticket-row d-flex justify-between" style="padding:.6rem 0;">
                <span class="text-muted">Member Since</span>
                <span style="font-weight:600;">Active Member</span>
            </div>
        </div>
        <div class="mt-2 d-flex gap-2">
            <a href="${pageContext.request.contextPath}/app?action=history" class="btn btn-primary" style="flex:1;justify-content:center;">My Bookings</a>
            <a href="${pageContext.request.contextPath}/app?action=logout"  class="btn btn-secondary" style="flex:1;justify-content:center;">Logout</a>
        </div>
    </div>
</div>
</body>
</html>
