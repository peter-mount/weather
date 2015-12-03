<%-- 
    Document   : home
    Created on : Oct 21, 2014, 11:20:44 AM
    Author     : Peter T Mount
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="cms" uri="http://uktra.in/tld/cms" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<cms:page page="LeftTop"/>
<cms:page page="LeftCenter"/>
<tiles:insertAttribute name="ads"/>
<cms:page page="LeftBottom"/>
