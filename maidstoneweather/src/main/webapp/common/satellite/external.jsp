<%-- 
    Document   : external
    Created on : Jun 2, 2014, 10:28:18 AM
    Author     : Peter T Mount
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<div class="clear">
    <div class="left"><tiles:insertAttribute name="menu"/></div>
    <div class="center">
        <h1><tiles:insertAttribute name="title"/></h1>
        <img src="<tiles:insertAttribute name="image"/>" alt="<tiles:insertAttribute name="title"/>" title="<tiles:insertAttribute name="title"/>"/>
        <br/>
        <tiles:insertAttribute name="copy"/>
    </div>
</div>
