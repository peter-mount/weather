<%-- 
    Document   : panel
    Created on : May 26, 2014, 2:52:16 PM
    Author     : Peter T Mount
--%>

<%@page import="onl.iot.modp.regforecast.RegionalForecastKey"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<% pageContext.setAttribute( "forecastRegions", RegionalForecastKey.getValues()); %>
<%--
<div style="font-style: italic;border-bottom: 1px solid black;margin: 0;padding:.1em;background: #f80;text-align: center;">
    Please note: The new site is now in live pre-test mode. Not everything is fully running yet but I've made it
    publicly accessible as I'm intending for it to go live on June 30<sup>th</sup>.
</div>
--%>
<c:choose>
    <c:when  test="${requestScope['javax.servlet.forward.servlet_path']== '/index.jsp'}">
        <c:set var="path" value="/home"/>
    </c:when>
    <c:otherwise>
        <c:set var="path" value="${requestScope['javax.servlet.forward.servlet_path']}"/>
    </c:otherwise>
</c:choose>
<div id="cssmenu">
    <ul>
        <li <c:if test="${path== '/home'}">class="active"</c:if>>
            <c:choose>
                <c:when test="${not empty pageContext.request.userPrincipal}">
                    <a href="/user/">Home</a>
                </c:when>
                <c:otherwise>
                    <a href="/">Home</a>
                </c:otherwise>
            </c:choose>
        </li>
        <li class="<%--has-sub--%><c:if test="${path.startsWith('/about')}"> active</c:if>"><a href="/about">About</a>
                <ul>
                    <%--
                    <li class="entry first"><a href="/about/mark1">Original Mark I Station</a></li>
                    <li class="has-sub entry last"><a href="/about/mark2">New Mark II Station</a>
                        <ul>
                            <li class="entry first"><a href="/about/mark2/webcam">Webcam</a></li>
                            <li class="entry"><a href="/about/mark2/skycam">Sky Camera</a></li>
                            <li class="entry"><a href="/about/mark2/full">Full Weather Station</a></li>
                            <li class="entry last"><a href="/about/mark2/source">Sources</a></li>
                        </ul>
                    </li>
                    --%>
                </ul>
            </li>
            <li class="has-sub<c:if test="${path== '/graphs'}"> active</c:if>">
                <a href="/graphs">Graphs</a>
                <ul>
                    <li><a href="/graphs#temp">Temperature</a></li>
                    <li><a href="/graphs#rain">Rainfall</a></li>
                    <li><a href="/graphs#pressure">Pressure</a></li>
                    <li><a href="/graphs#humidity">Humidity</a></li>
                    <li><a href="/graphs#cloud">Cloud Cover</a></li>
                    <li><a href="/graphs#uv">UV &amp; Ambient Light</a></li>
                    <li><a href="/graphs#system">System temperatures</a></li>
                </ul>
            </li>
            <li class="has-sub<c:if test="${path.startsWith('/map')}"> active</c:if>">
                <a href="/map">Weather Map</a>
                <ul>
                    <li class="entry first"><a href="/map/kent">Kent</a></li>
                    <li class="entry"><a href="/map/se">South East</a></li>
                    <li class="entry"><a href="/map/london">London</a></li>
                    <li class="entry last"><a href="/map/uk">UK</a></li>
                </ul>
            </li>
            <li <c:if test="${path== '/satellite'}">class="active"</c:if>>
                <a href="/satellite">Satellite</a>
            </li>
            <%--
            <li <c:if test="${path== '/space'}">class="active"</c:if>>
                <a href="/space">Space</a>
            </li>
            --%>
            <li <c:if test="${path== '/webcams'}">class="active"</c:if>>
                <a href="/webcams">Webcams</a>
            </li>
            <li class="has-sub<c:if test="${path.startsWith('/forecast')}"> active</c:if>">
                <a href="/forecast">Forecast</a>
                <ul>
                <c:forEach var="fcstarea" varStatus="fcstareastatus" items="${forecastRegions}">
                    <li class="entry<c:if test="${fcstareastatus.first}"> first</c:if><c:if test="${fcstareastatus.last}"> last</c:if>">
                        <a href="/forecast/${fcstarea.name}">${fcstarea.label}</a>
                    </li>
                </c:forEach>
            </ul>
        </li>
    </ul>
</div>
