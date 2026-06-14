<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register – BookIt</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<nav>
    <a class="nav-brand" href="${pageContext.request.contextPath}/index.jsp">BOOK<span>IT</span></a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/app?action=login">Login</a>
    </div>
    <div class="nav-user"></div>
</nav>

<div class="container" style="max-width:480px;">
    <div class="card mt-3">
        <h2 style="font-family:var(--font-mono);margin-bottom:1.5rem;font-size:1.3rem;">
            Create Account <span class="text-amber">→</span>
        </h2>

        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/app?action=register">
            <div class="grid-2">
                <div class="form-group">
                    <label class="form-label">Full Name</label>
                    <input class="form-control" type="text" name="fullName" required placeholder="Rahul Sharma">
                </div>
                <div class="form-group">
                    <label class="form-label">Phone</label>
                    <input class="form-control" type="tel" name="phone" placeholder="+91 9876543210">
                </div>
            </div>
            <div class="form-group">
                <label class="form-label">Email</label>
                <input class="form-control" type="email" name="email" required placeholder="you@example.com">
            </div>
            <div class="form-group">
                <label class="form-label">Username</label>
                <input class="form-control" type="text" name="username" required placeholder="choose_username">
            </div>
            <div class="form-group">
                <label class="form-label">Password</label>
                <input class="form-control" type="password" name="password" required minlength="6" placeholder="Min 6 characters">
            </div>
            <button type="submit" class="btn btn-primary w-100">Create Account</button>
        </form>

        <p class="text-center mt-2" style="font-size:.875rem;">
            Already have an account? <a href="${pageContext.request.contextPath}/app?action=login" class="text-amber">Sign in</a>
        </p>
    </div>
</div>
</body>
</html>
