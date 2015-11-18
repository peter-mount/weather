<%-- 
    Document   : header
    Created on : May 26, 2014, 12:47:24 PM
    Author     : Peter T Mount
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<div id="main-header-outer">
    <div id="main-header-left"><tiles:insertAttribute name="header.left"/></div>
    <div id="main-header-center"><tiles:insertAttribute name="header.center"/></div>
    <div id="main-header-right"><tiles:insertAttribute name="header.right"/></div>
</div>
