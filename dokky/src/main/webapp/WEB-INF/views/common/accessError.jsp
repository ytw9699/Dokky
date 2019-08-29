<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ page import="java.util.*" %>    
<%@include file="../includes/left.jsp"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>접근 제한 페이지</title>
<style>
	 @media screen and (max-width:500px){ 
	           .accessWrap {
				    width: 50%;
				    display: inline-block; 
				    margin-left: 29%;
				    margin-top: 1%;
				    min-height: 500px;
				    border-color: #e6e6e6;
				    border-width: 1px;
				    border-style: solid;
				    background-color: #323639;
				    color: #e6e6e6;
				}
        }
        @media screen and (min-width: 501px) and (max-width:1500px){
          	.accessWrap {
			    width: 80%;
			    display: inline-block;
			    margin-left: 15%;
			    margin-top: 1%;
			    min-height: 500px;
			    border-color: #e6e6e6;
			    border-style: solid;
			    border-width: 1px;
			    background-color: #323639;
			    color: #e6e6e6;
			}
        }
        @media screen and (min-width: 1501px){    
            .accessWrap {
			    width: 51%;
			    display: inline-block; 
			    margin-left: 29%;
			    margin-top: 1%;
			    min-height: 500px;
			    border-color: #e6e6e6;
			    border-style: solid;
			    border-width: 1px;
			    background-color: #323639;
			    color: #e6e6e6;
			}
        }
        body{
			background-color: #323639;   
		}  
</style>
</head> 
<body>
	<div class="accessWrap"> 
			<h1>접근이 제한 되었습니다. 관리자에게 문의 해주세요.</h1> 
			<h2><c:out value="${SPRING_SECURITY_403_EXCEPTION.getMessage()}"/></h2>
			<!-- SPRING_SECURITY_403_EXCEPTION’이라는 이름으로 Access DeniedException 객체가 전달 -->
			<h2><c:out value="${msg}"/></h2>
	</div>
</body>	
</html>