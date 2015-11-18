<%-- 
    Document   : homepage
    Created on : May 26, 2014, 12:11:06 PM
    Author     : Peter T Mount
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<tiles:insertAttribute name="abstract"/>
<div id="home-outer">
    <div id="home-inner">
        <div id="home-center">
            <tiles:insertAttribute name="forecast"/>
            <tiles:insertAttribute name="current"/>
        </div>
        <div id="home-right">
            <tiles:insertAttribute name="sunrise"/>
            <tiles:insertAttribute name="flood-alert"/>
        </div>
    </div>
</div>
