<%-- 
    Document   : current
    Created on : Jun 5, 2014, 3:54:27 PM
    Author     : Peter T Mount
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="station-current"><tiles:insertAttribute name="weather.kell"/></div>
<div class="station-current"><tiles:insertAttribute name="weather.helene"/></div>
<div class="station-current"><tiles:insertAttribute name="weather.kari"/></div>
