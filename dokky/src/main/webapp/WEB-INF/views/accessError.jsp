<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ page import="java.util.*" %>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<h1>Access Denied Page1</h1> 

	<h2><c:out value="${SPRING_SECURITY_403_EXCEPTION.getMessage()}"/></h2>
	<!-- SPRING_SECURITY_403_EXCEPTION’이라는 이름으로 Access DeniedException 객체가 전달 -->
	
	<h2><c:out value="${msg}"/></h2>

</body>	
</html>
