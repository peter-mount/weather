<%-- 
    Document   : panel
    Created on : May 26, 2014, 2:52:16 PM
    Author     : Peter T Mount
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<div class="error"><tiles:insertAttribute name="error"/></div>
<table id="login_page">
    <tr>
        <th>Please Login</th>
        <th>Alternatively Register</th>
    </tr>
    <tr>
        <td><tiles:insertAttribute name="login.body"/></td>
        <td><tiles:insertAttribute name="login.register"/></td>
    </tr>
</table>
