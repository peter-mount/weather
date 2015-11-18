<%-- 
    Document   : forecast_text

    Displays the current forecast box

    Created on : Jun 24, 2014, 12:18:16 PM
    Author     : Peter T Mount
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://iot.onl/tlds/sensors" prefix="sensor" %>
<%@taglib uri="http://maidstoneweather.com/tlds/metoffice" prefix="metoffice" %>
<metoffice:regionalForecast area="se" var="forecast"/>
<c:forEach var="period" varStatus="status" items="${forecast.periods}">
    <c:if test="${status.first}">
        <c:forEach var="para" varStatus="paraStatus" items="${period.paragraphs}">
            <c:if test="${paraStatus.index eq 1}">
                <div class="symbol-box">
                    <h2 class="symbol-header"><c:out value="${para.title.replace(':','')}" escapeXml="true"/></h2>
                    <p>${para.text}</p>
                    <p>For a more complete forecast including tonight's astronomical conditions go to the <a href="/forecast">Forecast</a> page.</p>
                </div>
            </c:if>
        </c:forEach>
    </c:if>
</c:forEach>
