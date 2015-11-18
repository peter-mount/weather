<%-- 
    Document   : home
    Created on : May 26, 2014, 6:51:22 PM
    Author     : Peter T Mount
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<div class="title">My System Roles</div>
<div>
    <table border="0">
        <thead>
            <tr><th>Role</th></tr>
        </thead>
        <tbody>
            <c:forEach var="role" items="${requestScope.roles}">
                <tr><td><c:out value="${role}"/></td></tr>
            </c:forEach>
        </tbody>
    </table>
</div>
