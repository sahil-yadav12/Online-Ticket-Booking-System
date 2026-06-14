<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Error – BookIt</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<nav>
    <a class="nav-brand" href="${pageContext.request.contextPath}/index.jsp">BOOK<span>IT</span></a>
    <div class="nav-links"></div>
    <div class="nav-user"></div>
</nav>
<div class="container" style="max-width:480px;text-align:center;padding-top:4rem;">
    <div style="font-size:4rem;">⚠️</div>
    <h2 style="font-family:var(--font-mono);margin:1rem 0 .5rem;">Something went wrong</h2>
    <p class="text-muted">
        <c:choose>
            <c:when test="${not empty errorMessage}">${errorMessage}</c:when>
            <c:when test="${pageContext.errorData.statusCode == 404}">Page not found (404).</c:when>
            <c:otherwise>An unexpected server error occurred (500).</c:otherwise>
        </c:choose>
    </p>
    <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-primary mt-3">← Go Home</a>
</div>
</body>
</html>
