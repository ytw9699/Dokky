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
<style>
       @media screen and (max-width:500px){ 
		     .accessWrap {
				    width: 80%; 
				    display: inline-block;
				    margin-left: 15%;
				    margin-top: 1%;
				    min-height: 500px; 
					display: inline-block;
					border: 2px solid #dbdbdb;
					border-radius: 10px;
				}
        }
        @media screen and (min-width: 501px) and (max-width:1600px){
          .accessWrap {
			    	width: 80%; 
				    display: inline-block;
				    margin-left: 17%;
				    margin-top: 1%;
				    min-height: 500px; 
					display: inline-block;
					border: 2px solid #dbdbdb;
					border-radius: 10px;
			}
        }
        @media screen and (min-width: 1601px){    
		      .accessWrap {
			   		width: 51%; 
				    display: inline-block;
				    margin-left: 29%;
				    margin-top: 1%;
				    min-height: 500px; 
					display: inline-block;
					border: 2px solid #dbdbdb;
					border-radius: 10px;
			}
        }
        .content {
		    width: 54%;
		    margin-left: 23%;
		    margin-top: 23%;
		    color: #7151fc;
	    }
</style>
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