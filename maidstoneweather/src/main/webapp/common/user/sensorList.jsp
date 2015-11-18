<%-- 
    Document   : home
    Created on : May 26, 2014, 6:51:22 PM
    Author     : Peter T Mount
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="title">Device: <c:out value="${device.name}"/></div>
<div>
    <table border="0">
        <tr>
            <th valign="top">Description</th>
            <td align="left" valign="top"><c:out value="${device.description}"/></td>
        </tr>
        <tr>
            <th>Enabled</th>
            <td align="left"><c:out value="${device.enabled}"/></td>
        </tr>
        <tr>
            <th>Publicly Visible</th>
            <td align="left"><c:out value="${device.publiclyVisible}"/></td>
        </tr>
        <tr>
            <th>Created</th>
            <td align="left"><c:out value="${device.created}"/></td>
        </tr>
    </table>
</div>

<div class="title">Sensors on <c:out value="${device.name}"/></div>
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
            <c:forEach var="sensor" items="${requestScope.sensors}">
                <tr>
                    <td align="right">
                        <a href="/sensor/history/${user.userId}-${device.deviceId}-${sensor.sensorId}/"><c:out value="${sensor.name}"/></a>
                    </td>
                    <td align="center">
                        <c:choose>
                            <c:when test="${sensor.publiclyVisible}">Y</c:when>
                            <c:otherwise>N</c:otherwise>
                        </c:choose>
                    </td>
                    <td align="center">
                        <c:choose>
                            <c:when test="${sensor.enabled}">Y</c:when>
                            <c:otherwise>N</c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>
