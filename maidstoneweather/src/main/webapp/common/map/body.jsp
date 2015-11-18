<%-- 
    Document   : body
    Created on : Jun 2, 2014, 11:59:21 AM
    Author     : Peter T Mount
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div id="map-outer">
    <div id="map-top">
        <div id="map-top-left"></div>
        <div id="map-top-main">
            <div id="map-time-slider">
                <image id="map-time-now" src="/images/general/Refresh24.gif" title="Show Now"/>
                <image id="map-time-rewind" src="/images/media/Rewind24.gif" title="Fast Rewind"/>
                <image id="map-time-back" src="/images/media/StepBack24.gif" title="Backwards"/>
                <%-- Min -150 (10*15), max 540 (36 hours *15) --%>
                <input id="map-time-range" type="range" name="time" min="-9" max="0" step="1" value="0"/>
                <image id="map-time-forward" src="/images/media/StepForward24.gif" title="Forward"/>
                <image id="map-time-fastfwd" src="/images/media/FastForward24.gif" title="Fast Forward"/>
                <image id="map-time-play" src="/images/media/Play24.gif" title="Play"/>
                <image id="map-time-stop" src="/images/media/Stop24.gif" title="Stop"/>
            </div>
            <div id="map-time-shown"></div>
        </div>
    </div>
    <div id="map-inner">
        <div id="map-menu">
            <div class="map-pane">
                <div id="map-zoom-info" >
                    <div id="map-zoom-level" ></div>
                    <div id="map-presets"></div>
                    <div id="map-zoom-scale" ></div>
                    <div id="map-zoom-pos" ></div>
                </div>
                <div class="clear"></div>
            </div>
            <div class="leaflet-control-layers-separator"></div>
            <div class="map-pane">
                <div id="map-base-layers">
                    <h3>Base Layers</h3>
                    <ul></ul>
                </div>
                <div id="map-observation-layers">
                    <h3>Observations</h3>
                    <ul></ul>
                </div>
                <div id="map-forecast-layers">
                    <h3>Forecasts</h3>
                    <ul></ul>
                </div>
                <div id="map-aux-layers">
                    <h3>Other Overlays</h3>
                    <ul></ul>
                </div>
            </div>
            <div class="leaflet-control-layers-separator"></div>
        </div>
        <div id="map"></div>
    </div>
</div>
<script lang="Javascript">
    showMap();
</script>
