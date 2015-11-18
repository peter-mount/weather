<%-- 
    Document   : panel
    Created on : May 26, 2014, 2:52:16 PM
    Author     : Peter T Mount
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:choose>
    <c:when test="${not empty pageContext.request.userPrincipal}">
        Welcome <a href="/user/"><c:out value="${pageContext.request.userPrincipal.name}"/></a>
        <br/>
        <a href="/user/logout">Logout</a>
    </c:when>
    <c:otherwise>
        You are not logged in.
        <br/>
        <a href="https://${pageContext.request.serverName}/user/login">Login or Register</a>
    </c:otherwise>
</c:choose>
