<%-- 
    Document   : home
    Created on : May 26, 2014, 6:51:22 PM
    Author     : Peter T Mount
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<div class="float_cols">
    <div class="float_col"><tiles:insertAttribute name="devices"/></div>
    <div class="float_col"><tiles:insertAttribute name="roles"/></div>
</div>
