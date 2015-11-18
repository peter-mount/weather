<%-- 
    Document   : panel
    Created on : May 26, 2014, 2:52:16 PM
    Author     : Peter T Mount
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<form method="post" action="https://<%=request.getServerName() + request.getContextPath()%>/user/login">
    <table border="0">
        <tr><th>Username</th><td><input name="user" type="text" size="10"/></td></tr>
        <tr><th>Password</th><td><input name="password" type="password" size="10"/></td></tr>
        <tr><th>&nbsp;</th><td><input name="submit" type="submit" size="10" value="Login"/></td></tr>
    </table>
</form>
