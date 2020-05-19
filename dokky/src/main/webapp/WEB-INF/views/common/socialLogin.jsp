 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
 <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
 <%@include file="../includes/left.jsp"%>
 
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8"> 
	<title>Dokky - 로그인</title>
	<link href="/ROOT/resources/css/socialLogin.css" rel="stylesheet" type="text/css"/>
</head>
<body> 
<div class="loginWrap">
	
	
	<div class="title">
			<a href="/socialLogin">Login</a>   
	</div>
<!--<div class="cutom-group">
		구글 또는 네이버 계정으로만 <br/><br/>
		로그인 및 회원가입을 할 수 있습니다.
	</div> -->
				
	<div class="container"> 
			<div class="cutom-group loginGroup">
				<img src="/ROOT/resources/img/googleLogo.png" id="google" class="logo"/>
				<img src="/ROOT/resources/img/naverLogo.png" id="naver" class="logo"/>
			</div>
	</div>
	
	<div class="footer">  
		<div class="info">
			이용약관 | 개인정보처리방침 | 책임의 한계와 법적고지 | 회원정보 고객센터
		</div>
		<div class="superAdmin">
			<a href="/superAdminLogin">SuperAdmin 로그인</a>  
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
  <!-- customLogout’에서 POST 방식으로 로그아웃을 하게 되면  내부적으로
		는 자동으로 로그인 페이지를 호출
		로그인 페이지는 스프링 시큐리티의 기본 설정 
		이므로 필요하다면 xml에서 logout-success-url 속성 등을 이용해서 변경
		 <security:logout logout-url="/customLogout" invalidate-session="true"  logout-success-url="/" /> -->
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
