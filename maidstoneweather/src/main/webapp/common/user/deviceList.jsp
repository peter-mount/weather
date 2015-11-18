<%-- 
    Document   : home
    Created on : May 26, 2014, 6:51:22 PM
    Author     : Peter T Mount
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<div class="title">My Devices</div>
<div>
    <table border="0">
        <thead>
            <tr>
                <th>Name</th>
                <th>Public</th>
                <th>Enabled</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="device" items="${requestScope.devices}">
                <tr>
                    <td align="right">
                        <a href="/user/sensor/${device.name}"><c:out value="${device.name}"/></a>
                    </td>
                    <td align="center">
                        <c:choose>
                            <c:when test="${device.publiclyVisible}">Y</c:when>
                            <c:otherwise>N</c:otherwise>
                        </c:choose>
                    </td>
                    <td align="center">
                        <c:choose>
                            <c:when test="${device.enabled}">Y</c:when>
                            <c:otherwise>N</c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>
