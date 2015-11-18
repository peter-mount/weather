<%-- 
    Document   : main
    Created on : May 26, 2014, 11:38:41 AM
    Author     : Peter T Mount
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><tiles:insertAttribute name="title"/></title>
        <link rel="stylesheet" href="/css/main.css" />
        <link rel="stylesheet" href="/css/weather.css" />
        <link rel="stylesheet" href="/css/symbols.css" />
        <link rel="stylesheet" href="/css/menu.css" />
        <link rel="stylesheet" href="/css/jquery-ui.css" />
        <tiles:insertAttribute name="javascript"/>
    </head>
    <body>
        <div id="main-outer">
            <div id="top-menu"><tiles:insertAttribute name="topmenu"/></div>
            <div id="main-body">
                <div id="main-content"><tiles:insertAttribute name="body"/></div>
            </div>
            <div id="footer"><tiles:insertAttribute name="footer"/></div>
        </div>
    </body>
</html>
