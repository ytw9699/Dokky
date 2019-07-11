<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
 
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
	.ContentWrap{box-sizing: border-box;
	    padding-top: 48px;
	    padding-left: 20px;
	    padding-right: 20px;
	    width: 95%;
		min-height: 750px;
	    margin: 0 auto; 
 	}
 	#menuWrap .tab button {
		background-color: inherit;
		border: none;
		outline:none; 
		cursor: pointer;
		padding: 14px 16px;
		transition: 0.3s;
		font-size: 20px;  
		color: #e6e6e6;
	} 
	#menuWrap .tab button:hover {
	background-color: #7b7676;
	}
</style>
</head> 

<%@include file="../includes/left.jsp"%>

<body> 
	<div class="bodyWrap">	 
	 <div class="ContentWrap"> 
		 <div id="menuWrap"> 
			<div class="tab">     
				<button onclick="location.href='cashRequest">계정관리</button> 
		        <button onclick="location.href='cashRequest'">결제관리</button>
		    </div> 
		 </div>
	 </div> 
	 
	</div> 
</body>
</html>