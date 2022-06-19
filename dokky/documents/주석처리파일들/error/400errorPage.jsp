<%-- <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Dokky-400에러</title>
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
			  <div>400 ERROR</div>
			  <h1>bad request</h1>
		</div>
	</body>
</html>
 --%>