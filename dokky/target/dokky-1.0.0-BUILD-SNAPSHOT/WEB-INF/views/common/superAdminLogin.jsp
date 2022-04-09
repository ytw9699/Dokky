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
				<link href="/resources/css/superAdminLogin.css" rel="stylesheet" type="text/css"/>
		  </c:when>
	      <c:otherwise>
	    		<link href="/ROOT/resources/css/superAdminLogin.css" rel="stylesheet" type="text/css"/>
	      </c:otherwise>
	</c:choose>
</head>
<body> 
<div class="loginWrap">

	<div class="title">
			SuperAdmin Login 
	</div>
	<div class="container"> 
		<form role="form" method='post' action="/login">
				<div class="form-group">
					<input id="userId" class="form-control" placeholder="아이디를 입력하세요." name="username" type="text" oninput="checkLength(this,20);" autofocus/>
				</div>
				
				<div class="form-group">
					<input id="password" class="form-control" placeholder="비밀번호를 입력하세요." name="password" type="password" value="" oninput="checkLength(this,20);"/>
				</div>
				
				<div class="form-group"> 
					<label id="loginLabel"><input name="remember-me" type="checkbox">로그인 상태 유지</label>
				</div> 
				
				<div class="form-group loginGroup">
					<button class="btn" id="login" >로그인</button>
					<!-- <button class="btn" id="join">관리자 회원가입</button> --> 
				</div>
				
			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
		</form> 
	</div>
	
	<div class="footer"> 
		<div class="info"> 
			이용약관 | 개인정보처리방침 | 책임의 한계와 법적고지 | 회원정보 고객센터 
		</div>
		<div class="socialLogin">
			<a href="/socialLogin">사용자 로그인</a>  
		</div>
	</div>
</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script>
	
	function checkLength(obj, maxByte) { 
		 
		if(obj.tagName === "INPUT" || obj.tagName === "TEXTAREA"){ 
			var str = obj.value; 
		}else if(obj.tagName === "DIV" ){
			var str = obj.innerHTML; 
		} 
			
		var stringByteLength = 0;
		var reStr;
			
		stringByteLength = (function(s,b,i,c){
			
		    for(b=i=0; c=s.charCodeAt(i++);){
		    
			    b+=c>>11?3:c>>7?2:1;
			    //3은 한글인 경우 한글자당 3바이트를 의미,영어는 1바이트 의미 3을2로바꾸면 한글은 2바이트 영어는 1바이트 의미
			    //현재 나의 오라클 셋팅 같은경우 한글을 한자당 3바이트로 처리
			    if (b > maxByte) { 
			    	break;
			    }
			    
			    reStr = str.substring(0,i);
		    }
		    
		    return b //b는 바이트수 의미
		    
		})(str);
		
		if(obj.tagName === "INPUT" || obj.tagName === "TEXTAREA"){ 
			if (stringByteLength > maxByte) {// 전체길이를 초과하면          
				openAlert(maxByte + " Byte 이상 입력할 수 없습니다");         
				obj.value = reStr;       
			}   
		}else if(obj.tagName === "DIV"){
			if (stringByteLength > maxByte) {// 전체길이를 초과하면          
				openAlert(maxByte + " Byte 이상 입력할 수 없습니다");         
				obj.innerHTML = reStr;    
			}   
		} 
		
		obj.focus();  
	}

    function memberCheck(){
		  
	    var userId = $('#userId').val();
	    userId = $.trim(userId);//공백제거
	     
		if(userId == ""){ 
			openAlert("아이디를 입력하세요"); 
			   return true;
		}
	     
		if(!(userId == "admin" || userId == "test" || userId == "dokky")){ 
			   
		   openAlert("슈퍼관리자만 로그인 할 수 있습니다"); 
		   return true;
		}
	     
		var password = $('#password').val();
		password = $.trim(password);//공백제거
	     
		if(password == ""){ 
			openAlert("비밀번호를 입력하세요"); 
			  return true;
		}
		
		return false;
    }
		     
	  $("#login").on("click", function(e){
		    e.preventDefault();
		    
		    if(memberCheck()){
		    	return; 
		    }
		    
		    /* if($('#userId').val() != 'admin'){ 
		    	openAlert("아이디를 다시 확인해주세요");
		    	return; 
		    } */
		    
		    $("form").submit();
	  });
	  
	/*   $("#join").on("click", function(e){

		  	e.preventDefault();
		    
	    	openAlert("슈퍼관리자로 현재 가입 할 수 없습니다"); 
	    	return; 
		     
		    location.href='/adminMemberForm'; 
	  }); */
	  
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
