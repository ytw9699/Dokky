<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@include file="../includes/left.jsp"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8"> 
		<title>Dokky - 로그인</title>
			<c:choose>
			   	  <c:when test="${pageContext.request.serverName == 'localhost'}">
						<link href="/resources/css/socialLogin.css" rel="stylesheet" type="text/css"/>
				  </c:when>
			      <c:otherwise>
			    		<link href="/ROOT/resources/css/socialLogin.css" rel="stylesheet" type="text/css"/>
			      </c:otherwise>
			</c:choose>
	</head>
<body> 

<div class="loginWrap">
	<div class="title">
			<a href="/socialLogin">Login</a>   
	</div>
	
	<div class="container"> 
			<div class="cutom-group loginGroup">
				<c:choose>
				   	  <c:when test="${pageContext.request.serverName == 'localhost'}">
							<img src="/resources/img/googleLogo.png" id="google" class="logo"/>
							<img src="/resources/img/naverLogo.png" id="naver" class="logo"/>
					  </c:when>
				      <c:otherwise>
					    	<img src="/ROOT/resources/img/googleLogo.png" id="google" class="logo"/>
							<img src="/ROOT/resources/img/naverLogo.png" id="naver" class="logo"/>
				      </c:otherwise>
				</c:choose>
			</div>
	</div>
	
	<div class="footer">  
		<div class="info">
			이용약관 | 개인정보처리방침 | 책임의 한계와 법적고지 | 회원정보 고객센터
		</div>
		<div class="superAdmin">
			<a href="/superAdminLogin">SuperAdmin Login</a>  
		</div>
	</div> 
</div>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script>

	  $("#naver").on("click", function(e){
		    e.preventDefault();
		    
		    location.href='${naver_url}';
	  });
	  
	  $("#google").on("click", function(e){
		    e.preventDefault();
		    
		    location.href='${google_url}';
	  });
	  
</script>
	<c:if test="${param.error != null}">
	      <script>
		      $(document).ready(function(){
		      		openAlert("관리자에게 문의해주세요");
		      });
	      </script>
	</c:if>  
	 
	<c:if test="${check != null}"> 
	      <script>
		      $(document).ready(function(){
		      		openAlert('${check}'); 
		      });
	      </script>
	</c:if>  
</body>
</html>
