 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
 <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="utf-8">
	<title>dokky로긴</title>  
	</head>
<body> 
<div class="container">
	<div class="row">
			<div class="panel-body">
				<form role="form" method='post' action="/dokky/login">
					<fieldset>
						<div class="form-group">
							<input class="form-control" placeholder="userid"
								name="username" type="text" autofocus>
						</div>
						<div class="form-group">
							<input class="form-control" placeholder="Password"
								name="password" type="password" value="">
						</div>
						<div class="checkbox">
							<label><input name="remember-me" type="checkbox">Remember Me</label>
						</div>
						<a href="index.html" class="btn btn-lg btn-success btn-block">Login</a>
					</fieldset>
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
				</form>
			</div>
			</div>
		</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  <script>
	  $(".btn-success").on("click", function(e){
		    e.preventDefault();
		    $("form").submit();
	  });
  </script>
  <!-- customLogout’에서 POST 방식으로 로그아웃을 하게 되면  내부적으로
		는 자동으로 로그인 페이지를 호출
		로그인 페이지는 스프링 시큐리티의 기본 설정 
		이므로 필요하다면 xml에서 logout-success-url 속성 등을 이용해서 변경
		 <security:logout logout-url="/customLogout" invalidate-session="true"  logout-success-url="/" /> -->
	<c:if test="${param.logout != null}">
	      <script>
		      $(document).ready(function(){
		      	alert("로그아웃하였습니다.");
		      });
	      </script>
	</c:if>  
</body>
</html>
