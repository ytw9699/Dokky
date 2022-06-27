<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@include file="../includes/common.jsp"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8"> 
		<title>Dokky - 로그인</title>
			<c:choose>
			   	  <c:when test="${pageContext.request.serverName == 'localhost'}">
						<link href="/resources/css/common/socialLogin.css" rel="stylesheet" type="text/css"/>
				  </c:when>
			      <c:otherwise>
			    		<link href="/ROOT/resources/css/common/socialLogin.css" rel="stylesheet" type="text/css"/>
			      </c:otherwise>
			</c:choose>
	</head>
<body> 

<div class="loginWrap">
	<div class="title">
			<a href="/socialLogin">Social Login</a>   
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
		</div>
		<div class="superAdmin">
			<a href="/superAdminLogin">SuperAdmin Login</a>  
		</div>
	</div> 
</div>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script>
	
	var csrfHeaderName ="${_csrf.headerName}"; 
	var csrfTokenValue="${_csrf.token}";

	$(document).ajaxSend(function(e, xhr, options) { 
	    xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
	});

	var delteSavedRequest = function(){
		$.ajax({
				type : 'delete',
				url : '/SavedRequest'
			});
	}
	
	var onbeforeunload = function() {   
		delteSavedRequest();
	} 
	
	window.onbeforeunload = onbeforeunload;
		     
	  $("#naver").on("click", function(e){
		    e.preventDefault();
		    delteSavedRequest = null;
		    location.href='${naver_url}';
	  });
	  
	  $("#google").on("click", function(e){
		    e.preventDefault();
		    delteSavedRequest = null;
		    location.href='${google_url}';
	  });
	  
</script>
	
	<c:if test="${errormsg != null}">
	      <script>
		      $(document).ready(function(){
		      	openAlert('${errormsg}'); 
		      });
	      </script>
	</c:if>  
	
</body>
</html>
