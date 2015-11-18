<%-- 
    Document   : topmenu
    Created on : Jun 2, 2014, 9:50:46 AM
    Author     : Peter T Mount
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<div id="top_menu_left" class="left"><tiles:insertAttribute name="topmenu.left"/></div>
<div id="top_menu_right" class="right"><tiles:insertAttribute name="topmenu.right"/></div>
<div class="clear"></div>