<%-- 
    Document   : small
    Created on : Jun 26, 2014, 11:19:08 AM
    Author     : Peter T Mount
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://maidstoneweather.com/tlds/metoffice" prefix="metoffice" %>
<metoffice:sunRiseSet var="sun"/>
<metoffice:moonRiseSet var="moon"/>
<div class="symbol-box">
    <h3 class="symbol-header">Almanac</h3>
    <table>
        <tr>
            <th>Sunrise:</th>
            <td><fmt:formatDate value="${sun.official.rise}" pattern="HH:mm z" timeZone="Europe/London"/></td>
        </tr>
        <tr>
            <th>Sunset:</th>
            <td><fmt:formatDate value="${sun.official.set}" pattern="HH:mm z" timeZone="Europe/London"/></td>
        </tr>
        <tr>
            <th>Moonrise:</th>
            <td><fmt:formatDate value="${moon.riseSet.rise}" pattern="HH:mm z" timeZone="Europe/London"/></td>
        </tr>
        <tr>
            <th>Moonset:</th>
            <td><fmt:formatDate value="${moon.riseSet.set}" pattern="HH:mm z" timeZone="Europe/London"/></td>
        </tr>
        <tr>
            <td colspan='2' style='text-align: center;'>
                <div class='symbol-box' style='background: #000;'>
                    <img src="/images/moon/phase/50/${moon.ageInt}.png" title="${moon.ageInt} day old Moon"/>
                </div>
                ${moon.ageInt} days
            </td>
        </tr>
    </table>
</div>