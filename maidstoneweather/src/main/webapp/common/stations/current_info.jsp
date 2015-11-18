<%-- 
    Document   : current_info
    Created on : Jun 6, 2014, 12:29:34 PM
    Author     : Peter T Mount
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://iot.onl/tlds/sensors" prefix="sensor" %>
<sensor:device var="device" userId="1" name="${stationName}"/>
<sensor:sensorGroups var="groups" deviceId="${device.deviceId}"/>
<c:if test="${not empty includeTimer}">
    <script language="Javascript">
        $(function() {
            setInterval(function() {
                $("#stationinfo-${device.deviceId}").load("/station/info/${device.name}");
                        }, 60000);
                    });
    </script>
    <div id="stationinfo-${device.deviceId}">
    </c:if>
    <div class="station-current">
        <table class="station-current" cellspacing="0" cellpadding="0">
            <tr>
                <th class="station-name">
                    <span class="center">${device.label}</span>
                    <span class="right info">i</span>
                </th>
            </tr>

            <%--
            <c:forEach var="group" items="${device.cameras}">
                <tr><th>${group.label}</th></tr>
            --%>
            <tr>
                <td class="webcam-group">
                    <c:set var="uri" value="http://${device.name}.retep.org:8080"/>
                    <div class="webcam-preview">
                        <img src="${uri}/imageThumb.jpg" onerror="this.src='/images/offline-thumb.jpg'"/>
                        <span>Latest Image</span>
                    </div>
                    <div class="webcam-preview">
                        <img src="${uri}/cloud_thumb.jpg" onerror="this.src='/images/offline-thumb.jpg'"/>
                        <span>Cloud cover</span>
                    </div>
                    <%--
                                <c:forEach var="camera" items="${group.items}">
                                    <div class="webcam-preview">
                                        <img src="${camera.thumbnail}" onerror="this.src='/images/offline-thumb.jpg'"/>
                                        <span>${camera.label}</span>
                                    </div>
                                </c:forEach>
                    --%>
                </td>
            </tr>
            <%--
            </c:forEach>
            --%>

            <tr>
                <td>
                    <table cellspacing="0" cellpadding="0" width="100%">
                        <c:forEach var="group" items="${groups}">
                            <tr>
                                <th colspan="5">${group.label}</th>
                            </tr>
                            <c:forEach var="member" items="${group.members}">
                                <tr>
                                    <sensor:sensor var="sensor" detail="reading" sensorId="${member.sensorId}"/>
                                    <c:if test="${empty latest or reading.timestamp.time gt latest.time}">
                                        <c:set var="latest" value="${reading.timestamp}"/>
                                    </c:if>
                                    <td class="station-sensor-name">${sensor.label}</td>
                                    <sensor:sensorValue sensor="${sensor}" entry="${reading}" integer="integer" fraction="fraction"/>
                                    <c:choose>
                                        <c:when test="${sensor.info}">
                                            <td class="station-sensor-value" colspan="4">${reading.text}</td>
                                        </c:when>
                                        <c:when test="${sensor.scale==0}">
                                            <td class="station-sensor-value-l">${reading.value}</td>
                                            <td class="station-sensor-value-c"></td>
                                            <td class="station-sensor-value-r"></td>
                                            <td class="station-sensor-value-u">${sensor.unit}</td>
                                        </c:when>
                                        <c:otherwise>
                                            <td class="station-sensor-value-l">${integer}</td>
                                            <td class="station-sensor-value-c">.</td>
                                            <td class="station-sensor-value-r">${fraction}</td>
                                            <td class="station-sensor-value-u">${sensor.unit}</td>
                                        </c:otherwise>
                                    </c:choose>
                                </tr>
                            </c:forEach>
                        </c:forEach>
                        <tr>
                            <td class="station-sensor-name">Last report</td>
                            <td class="station-sensor-value" colspan="4">
                                <c:if test="${not empty latest}">
                                    <fmt:formatDate value="${latest}" pattern="MMM dd HH:mm"/> UT
                                </c:if>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </div>
    <c:if test="${not empty includeTimer}">
    </div>
</c:if>