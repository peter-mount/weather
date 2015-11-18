<%-- 
    Document   : forecast_text

    Displays the current text weather forecast in a tabbed view

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
<script>
    $(document).ready(function() {
        $("#fcst-tabs").tabs({
            event: "mouseover"
        });
    });
</script>
<div id="fcst-tabs">
    <ul>
        <c:forEach var="period" varStatus="status" items="${forecast.periods}">
            <c:if test="${status.first}">
                <c:forEach var="para" varStatus="paraStatus" items="${period.paragraphs}">
                    <c:if test="${not paraStatus.first}">
                        <li>
                            <a href="#fcst-tabs-${status.index}-${paraStatus.index}"><c:out value="${para.title.replace(':','')}" escapeXml="true"/></a>
                        </li>
                    </c:if>
                </c:forEach>
            </c:if>
        </c:forEach>
        <li>
            <a href="#fcst-tabs-outlook">Outlook</a>
        </li>
    </ul>
    <c:forEach var="period" varStatus="status" items="${forecast.periods}">
        <c:if test="${status.first}">
            <c:forEach var="para" varStatus="paraStatus" items="${period.paragraphs}">
                <c:if test="${not paraStatus.first}">
                    <div id="fcst-tabs-${status.index}-${paraStatus.index}">
                        <p>${para.text}</p>
                    </div>
                </c:if>
            </c:forEach>
        </c:if>
        <c:if test="${status.index == 1}">
            <div id="fcst-tabs-outlook">
            </c:if>
            <c:if test="${not status.first}">
                <c:forEach var="para" varStatus="paraStatus" items="${period.paragraphs}">
                    <h3>${para.title}</h3>
                    <p>${para.text}</p>
                </c:forEach>
            </c:if>
            <c:if test="${status.last}">
            </div>
        </c:if>
    </c:forEach>
</div>
