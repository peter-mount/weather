<%-- 
    Document   : panel
    Created on : May 26, 2014, 2:52:16 PM
    Author     : Peter T Mount
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<a href="/">Home</a>
<c:if test="${not empty breadcrumb}">
    <c:set var="path" value=""/>
    <c:forEach var="crumb" items="${breadcrumb}">
        / <a href="${path}/${crumb}"><c:out value="${crumb}" escapeXml="true"/></a>
        <c:set var="path" value="${path}/${crumb}"/>
    </c:forEach>
</c:if>
        