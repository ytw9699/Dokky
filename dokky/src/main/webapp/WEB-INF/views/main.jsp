<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>메인</title>
	
<style>
	body{
		background-color: #323639;  
		}
	.bodyWrap {
	    width: 80%; 
	    display: inline-block;
	    margin-left: 2%;
	    margin-top: 1%;
	    min-height: 500px; 
	    border-color: #e6e6e6;
		border-style: solid;
		background-color: #323639; 
		color: #e6e6e6;
	}
</style>
</head>

<%@include file="includes/left.jsp"%>

<body>

	<div class="bodyWrap">	 
	메인입니다.
		 <a href="/dokky/customLogin">로긴</a> 
	</div>
	
</body>

</html>