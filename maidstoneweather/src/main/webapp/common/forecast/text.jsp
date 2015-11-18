<%-- 
    Document   : text

    Displays the current text weather forecast on the forecast page

    Created on : Jun 28, 2014, 23:36:00 PM
    Author     : Peter T Mount
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://iot.onl/tlds/sensors" prefix="sensor" %>
<%@taglib uri="http://maidstoneweather.com/tlds/metoffice" prefix="metoffice" %>
<div class="symbol-box">
    <c:forEach var="period" varStatus="status" items="${forecast.periods}">
        <c:forEach var="para" varStatus="paraStatus" items="${period.paragraphs}">
            <c:choose>
                <c:when test="${status.first and paraStatus.first}">
                    <h2 class="symbol-header">Weather forecast for ${area.label}</h2>
                    <h3>Issued at: ${forecast.issuedAt}</h3>
                </c:when>
                <c:otherwise>
                    <h3>${para.title}</h3>
                </c:otherwise>
            </c:choose>
            <p>${para.text}</p>
        </c:forEach>
    </c:forEach>
</div>
