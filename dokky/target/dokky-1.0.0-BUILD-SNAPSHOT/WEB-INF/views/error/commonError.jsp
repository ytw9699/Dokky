<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ page import="java.util.*" %>    
<%@include file="../includes/common.jsp"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Dokky - 에러 페이지</title>
<c:choose>
   	  <c:when test="${pageContext.request.serverName == 'localhost'}">
			<link href="/resources/css/error/commonError.css" rel="stylesheet" type="text/css"/>
	  </c:when>  
      <c:otherwise>
    		<link href="/ROOT/resources/css/error/commonError.css" rel="stylesheet" type="text/css"/>
      </c:otherwise>
</c:choose>
</head> 

<body>
	<div class="accessWrap">
		<div class="content">
			<h2><c:out value="${SPRING_SECURITY_403_EXCEPTION.getMessage()}"/></h2>
			<h2><c:out value="${message}"/></h2> 
		</div>  
	</div>
</body>	
</html>