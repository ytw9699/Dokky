<%-- <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Dokky-404에러</title>
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
			  <div>404 ERROR</div>
			  <h1>해당 URL은 존재하지 않습니다.</h1>
			     죄송합니다. 현재 찾을 수 없는 페이지를 요청 하셨습니다. 존재하지 않는 주소를 입력하셨거나, 
			     요청하신 페이지의 주소가 변경,삭제되어 찾을 수 업습니다. 관리자에게 문의해주세요
		</div>
	</body>
</html>
 --%>