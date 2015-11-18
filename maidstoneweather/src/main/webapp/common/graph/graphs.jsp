<%-- 
    Document   : homepage
    Created on : May 26, 2014, 12:11:06 PM
    Author     : Peter T Mount
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://iot.onl/tlds/sensors" prefix="sensor" %>
<%@ taglib uri="http://maidstoneweather.com/tlds/metoffice" prefix="metoffice" %>
<script language="javascript" type="text/javascript" src="/js/flot/jquery.flot.js"></script>
<script language="javascript" type="text/javascript" src="/js/flot/jquery.flot.stack.js"></script>
<script language="javascript" type="text/javascript" src="/js/flot/jquery.flot.time.js"></script>
<script language="javascript" type="text/javascript" src="/js/temp.js"></script>
<div id="home-outer">
    <div id="home-inner">
        <div id="home-center">
            <div class="weather-plots">
                <div>
                    <a name="temp"/>
                    <h3>Temperature</h3>
                    <div id="tempLegend" class="weather-plot-legend"></div>
                    <div id="tempPlot" class="weather-plot-small"></div>
                </div>

                <div>
                    <a name="rain"/>
                    <h3>Rainfall</h3>
                    <div id="rainLegend" class="weather-plot-legend"></div>
                    <div id="rainPlot" class="weather-plot-small"></div>
                </div>

                <div>
                    <a name="pressure"/>
                    <h3>Pressure</h3>
                    <div id="presLegend" class="weather-plot-legend"></div>
                    <div id="presPlot" class="weather-plot-small"></div>
                </div>

                <div>
                    <a name="humidity"/>
                    <h3>Humidity</h3>
                    <div id="humidLegend" class="weather-plot-legend"></div>
                    <div id="humidPlot" class="weather-plot-small"></div>
                </div>

                <div>
                    <h3>Cloud Cover</h3>
                    <a name="cloud"/>
                    <div id="skyLegend" class="weather-plot-legend"></div>
                    <div id="skyPlot" class="weather-plot-small"></div>
                </div>

                <div>
                    <a name="uv"/>
                    <h3>UV Exposure &amp; Ambient Light</h3>
                    <div id="uvLegend" class="weather-plot-legend"></div>
                    <div id="uvPlot" class="weather-plot-small"></div>
                </div>

                <div>
                    <a name="system"/>
                    <h3>System temperatures</h3>
                    <div id="sysTempLegend" class="weather-plot-legend"></div>
                    <div id="sysTempPlot" class="weather-plot-small"></div>
                </div>
            </div>
        </div>
        <div id="home-right"></div>
    </div>
</div>
