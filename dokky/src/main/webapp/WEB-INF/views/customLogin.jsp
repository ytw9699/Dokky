 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
 <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
 <%@include file="includes/left.jsp"%>
 
<!DOCTYPE html>
<html>
	<head>
	<meta charset="utf-8">
<style>
		@media screen and (max-width:500px){ 
			 .loginWrap {
			    width: 80%; 
			    display: inline-block;
			    margin-left: 15%;
			    margin-top: 1%;
			    min-height: 500px;  
			    border-color: #e6e6e6;
				border-style: solid;
				background-color: #323639; 
				color: #e6e6e6;
				display: inline-block;
			}          
		        }
        @media screen and (min-width: 501px) and (max-width:1500px){
           .loginWrap {
			    width: 80%; 
			    display: inline-block;
			    margin-left: 15%;
			    margin-top: 1%; 
			    min-height: 500px; 
			    border-color: #e6e6e6;
				border-style: solid;
				background-color: #323639; 
				color: #e6e6e6;
				display: inline-block;
			}
        }
        @media screen and (min-width: 1501px){    
		       .loginWrap {
			    width: 51%; 
			    display: inline-block;
			    margin-left: 29%;
			    margin-top: 1%;
			    min-height: 500px; 
			    border-color: #e6e6e6;
				border-style: solid;
				background-color: #323639; 
				color: #e6e6e6;
				display: inline-block;
			}
        }
        
	body{
		background-color: #323639;  
		}

	.container {
	    width: 50%;
	    display: inline-block;
	    margin-left: 10%;
	    margin-top: 6%;
	    min-height: 278px;
	    border-color: #e6e6e6;
	    border-style: solid;
	    background-color: #323639;
	    color: #e6e6e6; 
	}
	.form-group {
		/* display: inline-block; */  
	    margin-top: 3%;
	    margin-left:  30%;
	    width: 45%;
	    height: 50px;
	    font-size: 20px;
	   /*  border-color: #e6e6e6;
	    border-style: solid; */ 
    }
    
	  .form-control {
	    width: 100%;
	    /* margin: 6px; */
	    /* margin-left: -28px; */
	    border-radius: 9px;
	    font-size: 15px;
	    height: 49px;
	    border: 0.5px solid gray;
	    box-sizing: border-box;
	    padding-left: 38px; 
	}
	.next {
	    width: 12%;
	    margin: 0 auto;
	    margin-left: 6px;
	    border: none;
	    color: white;
	   /*  background-color: #7151fc; */
	    padding: 15px;
	    font-size: 15px;
	    border-radius: 9px;
	}
	
</style> 
	</head>
<body> 
<div class="loginWrap">
 <div class="container"> 
	<form role="form" method='post' action="/dokky/login">
			<div class="form-group">
				<input id="userId" class="form-control" placeholder="아이디를 입력하세요" name="username" type="text" autofocus> 
			</div>
			<div class="form-group">
				<input id="password" class="form-control" placeholder="비밀번호를 입력하세요" name="password" type="password" value="">
			</div>
			<div class="form-group"> 
				<label><input name="remember-me" type="checkbox">Remember Me</label>
			</div> 
			<div class="form-group">
				<a href="" id="login" class="next">로그인</a>
				<a href="/dokky/memberForm" class="next">회원가입</a>
			</div>
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
	</form> 
 </div>
</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  <script>
  
  function memberCheck(){
	  
     var userId = $('#userId').val();
     userId = $.trim(userId);//공백제거
     
		if(userId == ""){ 
			alert("아이디를 입력하세요."); 
			   return true;
		}
     
	var password = $('#password').val();
	password = $.trim(password);//공백제거
     
		if(password == ""){ 
			alert("비밀번호를 입력하세요."); 
			  return true;
		}
	return false;
  }
	     
	  $("#login").on("click", function(e){
		    e.preventDefault();
		    
		    if(memberCheck()){
		    return; 
		    }
		    
		    $("form").submit();
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
		      	alert("관리자에게 문의해주세요");
		      });
	      </script>
	</c:if>   
	<c:if test="${check != null}"> 
	      <script>
		      $(document).ready(function(){
		      	alert('${check}'); 
		      });
	      </script>
	</c:if>  
</body>
</html>
