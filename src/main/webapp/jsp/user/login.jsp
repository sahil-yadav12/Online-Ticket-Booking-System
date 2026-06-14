<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login – BookIt</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<nav>
    <a class="nav-brand" href="${pageContext.request.contextPath}/index.jsp">BOOK<span>IT</span></a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/app?action=register">Register</a>
    </div>
    <div class="nav-user"></div>
</nav>

<div class="container" style="max-width:440px;">
    <div class="card mt-3">
        <h2 style="font-family:var(--font-mono);margin-bottom:1.5rem;font-size:1.3rem;">
            Sign In <span class="text-amber">→</span>
        </h2>

        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>
        <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/app?action=login">
            <div class="form-group">
                <label class="form-label">Username</label>
                <input class="form-control" type="text" name="username" required autofocus placeholder="your_username">
            </div>
            <div class="form-group">
                <label class="form-label">Password</label>
                <input class="form-control" type="password" name="password" required placeholder="••••••••">
            </div>
            <button type="submit" class="btn btn-primary w-100">Login</button>
        </form>

        <p class="text-center mt-2" style="font-size:.875rem;">
            No account? <a href="${pageContext.request.contextPath}/app?action=register" class="text-amber">Register here</a>
        </p>
    </div>
</div>
</body>
</html>
