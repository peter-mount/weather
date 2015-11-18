<%-- 
    Document   : panel
    Created on : May 26, 2014, 2:52:16 PM
    Author     : Peter T Mount
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
You are not logged in.
<br/>
<a href="https://<%=request.getServerName() + request.getContextPath()%>/user/login">Login</a>
| <a href="https://<%=request.getServerName() + request.getContextPath()%>/user/register">Register</a>
