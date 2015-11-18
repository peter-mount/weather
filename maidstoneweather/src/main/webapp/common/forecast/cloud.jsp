<%-- 
    Document   : homepage
    Created on : May 26, 2014, 12:11:06 PM
    Author     : Peter T Mount
--%>
<%@page import="com.maidstoneweather.astro.EphemerisManager"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://iot.onl/tlds/sensors" prefix="sensor" %>
<%@taglib uri="http://maidstoneweather.com/tlds/metoffice" prefix="metoffice" %>
<metoffice:sunRiseSet var="sun"/>
<metoffice:sunRiseSet var="sunTomorrow" day="tomorrow"/>
<metoffice:moonRiseSet var="moon"/>
<metoffice:moonRiseSet var="moonTomorrow" day="tomorrow"/>
<metoffice:meteors var="meteors"/>
<a name="astronomy"/>
<div class="symbol-box">
    <h2 class="symbol-header">Tonight's Astronomy Forecast for the UK</h2>
    <p>
        This is the Astronomy forecast for the evening of <fmt:formatDate value="${sun.official.set}" dateStyle="long" timeZone="Europe/London"/>.

    </p>
    <p>
        All times and elevations in this forecast are for Maidstone, Kent.
        For other parts of the UK the actual times will vary by a few minutes depending on how far East or West you are
        and elevations will vary depending on how far North or South you are from Maidstone.
    </p>
    <h3>The Sun</h3>
    <c:choose>
        <%-- Summer, astronomical twilight never ends --%>
        <c:when test="${empty sun.astronomical.set}">
            <p>
                The sun will set at <fmt:formatDate value="${sun.official.set}" pattern="HH:mm z" timeZone="Europe/London"/>
                tonight with civil twilight ending at <fmt:formatDate value="${sun.civil.set}" pattern="HH:mm z" timeZone="Europe/London"/>.
            </p>
            <p>
                Civil twilight will resume at <fmt:formatDate value="${sunTomorrow.civil.rise}" pattern="HH:mm z" timeZone="Europe/London"/>
                tomorrow morning with the sun finally rising at <fmt:formatDate value="${sunTomorrow.official.rise}" pattern="HH:mm z" timeZone="Europe/London"/>.
            </p>
        </c:when>
        <%-- Astronomical twilight ends at some point --%>
        <c:otherwise>
            <p>
                The sun will set tonight at <fmt:formatDate value="${sun.official.set}" pattern="HH:mm z" timeZone="Europe/London"/>
                with civil twilight ending at <fmt:formatDate value="${sun.civil.set}" pattern="HH:mm z" timeZone="Europe/London"/>
                and astronomical twilight ending at <fmt:formatDate value="${sun.astronomical.set}" pattern="HH:mm z" timeZone="Europe/London"/>.
            </p>
            <p>
                Astronomical twilight will then resume at <fmt:formatDate value="${sunTomorrow.astronomical.rise}" pattern="HH:mm z" timeZone="Europe/London"/>
                tomorrow morning with civil twilight resuming at <fmt:formatDate value="${sunTomorrow.civil.rise}" pattern="HH:mm z" timeZone="Europe/London"/>
                with the sun finally rising at <fmt:formatDate value="${sunTomorrow.official.rise}" pattern="HH:mm z" timeZone="Europe/London"/>.
            </p>
        </c:otherwise>
    </c:choose>

    <h3>The Moon</h3>
    <div class='right' style="margin-left: .5em;margin-top: .5em;margin-right: .1em;margin-bottom: .5em;">
        <div class='symbol-box' style='background: #000;'>
            <img src="/images/moon/phase/100/${moon.ageInt}.png" title="${moon.ageInt} day old Moon"/>
        </div>
            <div style="font-size: x-small;text-align: center;">The Moon at ${moon.ageInt} days</div>
    </div>
    <c:choose>
        <c:when test="${moon.riseSet.set.before(sunTomorrow.date)}">
            <p>
                The Moon is currently ${moon.ageInt} days old and
                sets tonight at <fmt:formatDate value="${moon.riseSet.set}" pattern="HH:mm z" timeZone="Europe/London"/>.
            <p>
                It will rise again tomorrow at
                <fmt:formatDate value="${moonTomorrow.riseSet.rise}" pattern="HH:mm z" timeZone="Europe/London"/>.
            </p>
        </c:when>
        <c:otherwise>
            <p>
                The Moon is currently ${moon.ageInt} days old and
                rises at <fmt:formatDate value="${moon.riseSet.rise}" pattern="HH:mm z" timeZone="Europe/London"/>
                setting tomorrow at <fmt:formatDate value="${moon.riseSet.set}" pattern="HH:mm z" timeZone="Europe/London"/>.
            </p>
        </c:otherwise>
    </c:choose>

    <h3>Tonight's Meteor prospects</h3>
    <p>
        The best times to observe meteors are for the hour just after or the hour before the morning twilight, with
        the morning period the best as meteors are usually approaching the Earth at that time so have a higher
        relative speed compared to the evening when the Earth is usually catching them up.
    </p>
    <p>
        This evenings best observing time is from <fmt:formatDate value="${meteors.eveningStart}" pattern="HH:mm" timeZone="Europe/London"/>
        until <fmt:formatDate value="${meteors.eveningEnd}" pattern="HH:mm z" timeZone="Europe/London"/> whilst tomorrow
        morning's best observing time for meteors is from <fmt:formatDate value="${meteors.morningStart}" pattern="HH:mm" timeZone="Europe/London"/>
        until <fmt:formatDate value="${meteors.morningEnd}" pattern="HH:mm z" timeZone="Europe/London"/>.
    </p>


    <c:choose>
        <c:when test="${moon.riseSet.set.after(sun.civil.set) and moon.riseSet.set.before(sunTomorrow.date)}">
            <p>
                The moon will be above the horizon during the evening making it harder to observe meteors so the
                morning period will be better.
            </p>
        </c:when>
        <c:when test="${moon.riseSet.set.before(sunTomorrow.civil.rise) and moon.riseSet.set.after(sunTomorrow.date)}">
            <p>
                The moon will be above the horizon during the morning period making it harder to observe meteors.
            </p>
            <p>
                The best time will be during the early evening instead.
            </p>
        </c:when>
        <c:when test="${moon.riseSet.rise.before(sun.civil.set) and moon.riseSet.set.after(sunTomorrow.civil.rise)}">
            <p>
                The moon will be above the horizon throughout the night making it difficult to observe any faint meteors.
            </p>
        </c:when>
        <c:when test="${moon.riseSet.set.before(sun.civil.set)}">
            <p>
                The moon will not be visible making it ideal for observing meteors tonight or tomorrow morning.
            </p>
        </c:when>
    </c:choose>

    <c:forEach var="meteor" varStatus="meteorStatus" items="${meteors.active}">
        <c:if test="${meteorStatus.first}">
            <p>
                Currently the
            </c:if>
            ${meteor.name} <fmt:formatDate value="${meteor.startDate}" pattern="YYYY MMM d"/>-<fmt:formatDate value="${meteor.endDate}" pattern="YYYY MMM d"/><c:if test="${not meteorStatus.last}">, </c:if>
            <c:if test="${meteorStatus.last}">
                meteor shower<c:if test="${not meteorStatus.first}">s</c:if> are visible tonight.
                </p>
        </c:if>
    </c:forEach>

    <c:forEach var="meteor" varStatus="meteorStatus" items="${meteors.next}">
        <c:if test="${meteorStatus.first}">
            <p>
                The next meteor shower<c:if test="${not meteorStatus.last}">s</c:if> are the
            </c:if>
            <c:if test="${not meteorStatus.first and meteorStatus.last}">and </c:if>
            ${meteor.name} from <fmt:formatDate value="${meteor.startDate}" pattern="MMMM d"/><c:if test="${not meteorStatus.last}">, </c:if><c:if test="${meteorStatus.last}">.
            </p>
        </c:if>
    </c:forEach>

    <h3>Tonight's Astrophotography prospects</h3>
    <c:choose>
        <c:when test="${moon.riseSet.set.before(sun.civil.set)}">
            <p>
                The moon will not be visible tonight which will make it ideal to observe fainter objects.
            </p>
        </c:when>
        <c:when test="${moon.riseSet.set.before(sun.civil.set)}">
            <p>
                The moon will not be visible tonight.
            </p>
        </c:when>
        <c:when test="${not empty sunTomorrow.astronomical.rise and moonTomorrow.riseSet.rise.before(sunTomorrow.astronomical.rise)}">
            <p>
                With the moon rising before astronomical twilight ends astrophotography will be affected and
                is best performed before moon rise.
            </p>
        </c:when>
        <c:when test="${not empty sun.astronomical.set and moon.riseSet.set.before(sun.astronomical.set)}">
            With the moon setting tonight at <fmt:formatDate value="${moon.riseSet.set}" pattern="HH:mm z" timeZone="Europe/London"/>
            and astronomical twilight ending at <fmt:formatDate value="${sun.astronomical.set}" pattern="HH:mm z" timeZone="Europe/London"/>
            the moon will not be visible making astronomical photography best from end of twilight until it
            resumes at <fmt:formatDate value="${sunTomorrow.astronomical.rise}" pattern="HH:mm z" timeZone="Europe/London"/>
            in the morning.
        </c:when>
        <c:when test="${not empty sun.astronomical.set and moon.riseSet.set.after(sun.astronomical.set) and moon.riseSet.set.before(sunTomorrow.astronomical.rise)}">
            With the moon setting tonight at <fmt:formatDate value="${moon.riseSet.set}" pattern="HH:mm z" timeZone="Europe/London"/>
            and astronomical twilight ending at <fmt:formatDate value="${sun.astronomical.set}" pattern="HH:mm z" timeZone="Europe/London"/>
            the moon will make it harder for fainter objects to be observed whilst it's above the horizon.
        </c:when>
        <c:when test="${not empty sun.astronomical.set and moon.riseSet.set.after(sun.astronomical.set)}">
            With the moon setting tonight at <fmt:formatDate value="${moon.riseSet.set}" pattern="HH:mm z" timeZone="Europe/London"/>
            and astronomical twilight ending at <fmt:formatDate value="${sun.astronomical.set}" pattern="HH:mm z" timeZone="Europe/London"/>
            the moon will make it harder for fainter objects like nebulae to be observed.
        </c:when>
        <c:when test="${not empty sun.astronomical.set and not empty sunTomorrow.astronomical.rise}">
            <p>
                With Astronomical twilight ending at <fmt:formatDate value="${sun.astronomical.set}" pattern="HH:mm z" timeZone="Europe/London"/>
                and resuming at <fmt:formatDate value="${sunTomorrow.astronomical.rise}" pattern="HH:mm z" timeZone="Europe/London"/>
                for fainter objects like nebulae and galaxies the better times to observe will be between those hours.
            </p>
        </c:when>
        <c:when test="${moon.riseSet.set.after(sun.civil.set) and moon.riseSet.set.before(sunTomorrow.date)}">
            <p>
                With the moon setting tonight at <fmt:formatDate value="${moon.riseSet.set}" pattern="HH:mm z" timeZone="Europe/London"/>
                it will be better to do any photography after that time as the moon will not washout the sky.
            </p>
        </c:when>
        <c:when test="${moonTomorrow.riseSet.rise.before(sunTomorrow.civil.rise)}">
            <p>
                With the moon rising at <fmt:formatDate value="${moon.riseSet.rise}" pattern="HH:mm z" timeZone="Europe/London"/>
                this morning it will affect early morning meteor observations.
            </p>
        </c:when>
        <c:when test="${moon.riseSet.rise.after(sun.civil.set)}">
            <p>
                With the moon rising at <fmt:formatDate value="${moon.riseSet.rise}" pattern="HH:mm z" timeZone="Europe/London"/>
                this evening the moon will make it harder to observe fainter objects like nebulae or galaxies.
            </p>
        </c:when>
        <c:when test="${moon.riseSet.set.before(sunTomorrow.civil.rise)}">
            <p>
                With the moon setting at <fmt:formatDate value="${moonTomorrow.riseSet.set}" pattern="HH:mm z" timeZone="Europe/London"/>
                in the morning astrophotography will be problematical as the moon will be above the horizon
                throughout the night making it harder to observe fainter objects like nebulae and galaxies.
            </p>
        </c:when>
        <c:when test="${moonTomorrow.riseSet.rise.before(sunTomorrow.civil.rise)}">
            <p>
                With the moon rising in the early hours of the morning
                <fmt:formatDate value="${moonTomorrow.riseSet.rise}" pattern="HH:mm z" timeZone="Europe/London"/>
                in the morning astrophotography will be problematical as the moon will be above the horizon
                washing out fainter objects like nebulae and galaxies.
            </p>
        </c:when>
    </c:choose>

    <c:if test="${empty sun.astronomical.set or empty sunTomorrow.astronomical.rise}">
        <p>
            Note: Due to the Sun's high elevation, Astronomical twilight will run throughout the night which will hinder
            astrophotography making fainter objects like nebulae and galaxies invisible.
        </p>
    </c:if>

    <h3>Tonight's Cloud &amp; Rain Forecast</h3>
    <p>
        The following images represent the forecasted cloud and precipitation for the UK at 9pm tonight, Midnight and
        at 3am tomorrow morning:
    </p>
    <div class="clear">
        <c:forEach var="image" items="${cloudImages}">
            <div class='symbol-box' style="display: inline-block">
                <div style='width:373px;height: 500px;'>
                    <div style='position: relative; width:100%;height: 100%;overflow: hidden;'>
                        <div dir="ltr" style="position: absolute; width: 100%; height: 100%; z-index: 105;">
                            <img class="olTileImage" src="//c.tiles.${serverName}/osm/5/15/10.png" id="null" style="visibility: inherit; opacity: 1; position: absolute; left: 10px; top: 199px; width: 256px; height: 256px;">
                            <img class="olTileImage" src="//a.tiles.${serverName}/osm/5/15/9.png" id="null" style="visibility: inherit; opacity: 1; position: absolute; left: 10px; top: -57px; width: 256px; height: 256px;">
                            <img class="olTileImage" src="//b.tiles.${serverName}/osm/5/16/10.png" id="null" style="visibility: inherit; opacity: 1; position: absolute; left: 266px; top: 199px; width: 256px; height: 256px;">
                            <img class="olTileImage" src="//c.tiles.${serverName}/osm/5/16/9.png" id="null" style="visibility: inherit; opacity: 1; position: absolute; left: 266px; top: -57px; width: 256px; height: 256px;">
                            <img class="olTileImage" src="//a.tiles.${serverName}/osm/5/14/10.png" id="null" style="visibility: inherit; opacity: 1; position: absolute; left: -246px; top: 199px; width: 256px; height: 256px;">
                            <img class="olTileImage" src="//c.tiles.${serverName}/osm/5/15/11.png" id="null" style="visibility: inherit; opacity: 1; position: absolute; left: 10px; top: 455px; width: 256px; height: 256px;">
                            <img class="olTileImage" src="//a.tiles.${serverName}/osm/5/14/9.png" id="null" style="visibility: inherit; opacity: 1; position: absolute; left: -246px; top: -57px; width: 256px; height: 256px;">
                            <img class="olTileImage" src="//b.tiles.${serverName}/osm/5/16/11.png" id="null" style="visibility: inherit; opacity: 1; position: absolute; left: 266px; top: 455px; width: 256px; height: 256px;">
                            <img class="olTileImage" src="//c.tiles.${serverName}/osm/5/14/11.png" id="null" style="visibility: inherit; opacity: 1; position: absolute; left: -246px; top: 455px; width: 256px; height: 256px;">
                        </div>
                        <div dir="ltr" style="position: absolute; width: 100%; height: 100%; z-index: 345; display: block;">
                            <img class="olTileImage" src="//modp.${serverName}/forecast/${cloudLayer.service.layerName}/${cloudPath}/${image[1]}.png" style="visibility: inherit; opacity: 1; position: absolute; left: -7px; top: -28px; width: 387px; height: 515px;">
                        </div>
                    </div>
                </div>
                <div style="text-align: center;font-weight: bold;"><fmt:formatDate value="${image[0]}" pattern="YYYY MMM dd HH:mm"/></div>
            </div>
        </c:forEach>
    </div>
</div>
