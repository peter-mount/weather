<%-- 
    Document   : detail
    Created on : May 27, 2014, 4:38:04 PM
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

<div class="title">Sensor: <c:out value="${sensor.name}"/></div>
<div>
    <table border="0">
        <%--tr>
            <th valign="top">Description</th>
            <td align="left" valign="top"><c:out value="${sensor.description}"/></td>
        </tr--%>
        <tr>
            <th>Enabled</th>
            <td align="left"><c:out value="${sensor.enabled}"/></td>
        </tr>
        <tr>
            <th>Publicly Visible</th>
            <td align="left"><c:out value="${sensor.publiclyVisible}"/></td>
        </tr>
        <tr>
            <th>Created</th>
            <td align="left"><c:out value="${sensor.created}"/></td>
        </tr>
    </table>
</div>

<div class="title">Readings for <c:out value="date goes here"/></div>
<div>
    <table border="0">
        <thead>
            <tr>
                <th>Time</th>
                <th>Raw Value</th>
                <th>Text</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="reading" items="${requestScope.data}">
                <tr>
                    <td><c:out value="${reading.timestamp}"/></td>
                    <td align="right"><c:out value="${reading.value}"/></td>
                    <td><c:out value="${reading.text}"/></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>
