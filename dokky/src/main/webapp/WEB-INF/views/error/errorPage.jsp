<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- <%@ page session="false" import="java.util.*"%> --%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Dokky-error</title>
		<link href="/resources/css/404errorPage.css" rel="stylesheet" type="text/css"/>
	</head>
	<%@include file="../includes/common.jsp"%>
	<body>
		<div class="bodyWrap">
		  <h4><c:out value="${exception.getMessage()}"></c:out></h4>
		  <%-- <ul>
		   <c:forEach items="${exception.getStackTrace() }" var="stack">
		     <li><c:out value="${stack}"></c:out></li>
		   </c:forEach>
		  </ul> --%>
		 </div>
	</body>
	
</html>
