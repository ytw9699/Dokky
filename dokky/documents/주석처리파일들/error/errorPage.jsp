<%-- <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Dokky-error</title>
		<c:choose>
		   	  <c:when test="${pageContext.request.serverName == 'localhost'}">
					<link href="/resources/css/error/errorPage.css" rel="stylesheet" type="text/css"/>
			  </c:when>  
		      <c:otherwise>
		      		<link href="/ROOT/resources/css/error/errorPage.css" rel="stylesheet" type="text/css"/>	
		      </c:otherwise>
		</c:choose>
	</head>
	<%@include file="../includes/common.jsp"%>
	<body>
		<div class="bodyWrap">
		  <h4><c:out value="${exception.getMessage()}"></c:out></h4>
		 </div>
	</body>
</html>
 --%>