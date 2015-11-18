<%-- 
    Document   : map1layer
    Created on : Jun 29, 2014, 8:12:34 AM
    Author     : Peter T Mount

    Displays a simple map showing a single MODP layer in it's entirety over the UK
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
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
                <img class="olTileImage" src="//modp.${serverName}/forecast/<tiles:insertAttribute name="layer"/>/2014/6/29/3/6.png" style="visibility: inherit; opacity: 1; position: absolute; left: -7px; top: -28px; width: 387px; height: 515px;">
            </div>
        </div>
    </div>
    <div style="text-align: center;font-weight: bold;"><tiles:insertAttribute name="title"/></div>
</div>