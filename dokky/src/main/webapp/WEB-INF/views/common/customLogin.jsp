 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
 <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
 <%@include file="../includes/left.jsp"%>
 
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8"> 
	<title>Dokky - 로그인</title>
	<link href="/dokky/resources/css/customLogin.css" rel="stylesheet" type="text/css"/>
	<!-- <script src="https://apis.google.com/js/platform.js" async defer></script> -->
		 <script src="https://apis.google.com/js/platform.js?onload=init" async defer></script>
		 <!-- onload는 호출이끝났을때 init함수를 호출 --> 
	<!-- <meta name="google-signin-client_id" content="749898735018-a2kvi2854s1v85pfel1097as260uivu2.apps.googleusercontent.com"> -->
</head>
<body> 
<div class="loginWrap">

	<div class="title">
			Login 
	</div>
	<div class="container"> 
		<form role="form" method='post' action="/dokky/login">
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
					<!-- <div class="g-signin2" data-onsuccess="onSignIn"></div> 
					onSignIn은 로그인이끝났을때 onSignIn함수를 구글 자스 sdk가 호출할것이다
					-->
					<span id="name"></span>
					<input type="button" id="loginBtn" value="checking..." onclick="
					    if(this.value === 'Login'){
					      gauth.signIn().then(function(){//로그인하는것
					        console.log('gauth.signIn()');
					        checkLoginStatus();
					      });
					    } else {
					      gauth.signOut().then(function(){//로그아웃하는것
					        console.log('gauth.signOut()');
					        checkLoginStatus();
					      });
					    }
					  ">
					<button class="btn" id="login" >로그인</button>
					<button class="btn" id="join">회원가입</button>
				</div>
			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
		</form> 
	</div>
	
</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script>
	
	function checkLoginStatus(){
		
	    var loginBtn = document.querySelector('#loginBtn');
	    var nameTxt = document.querySelector('#name');
	    
	    if(gauth.isSignedIn.get()){//로그인 되어있으면 true
	      console.log('logined');
	      loginBtn.value = 'Logout';
	      
	      var profile = gauth.currentUser.get().getBasicProfile();//currentUser현재유저의 기본프로필을 얻는다라는뜻
	      
          nameTxt.innerHTML = '<strong>'+profile.getName()+'</strong> ';
          console.log(profile.getImageUrl());
	        
	    } else {
	      console.log('logouted');
	      loginBtn.value = 'Login';
	      
	      nameTxt.innerHTML = '';
	    }
    }
  
	function init(){
		
	      console.log('init');
	      
	      gapi.load('auth2', function() {//gapi는 구글api인데, OAuth와 관련된 라이브러리 기능들만을 부분적으로 로드하는 코드 이지 않을까,그 로드가 끝나면 함수가 실행될것이다.
	    	  
		        console.log('auth2');
		        
		        window.gauth = gapi.auth2.init({//init 초기화 //gauth는 전역변수
		          	client_id:'749898735018-a2kvi2854s1v85pfel1097as260uivu2.apps.googleusercontent.com'//파라미터에 객체전달
		        })//그러면 GoogleAuth를 리턴한다 그것을 gauth라는 이름의 변수에 담는다.
		        
		        gauth.then(function(){
		          	console.log('googleAuth success');
		          	checkLoginStatus();
		        }, function(){
		          	console.log('googleAuth fail');
		          	checkLoginStatus();
		        });
	      });
    }
	
	/* function onSignIn(googleUser) {
		  var profile = googleUser.getBasicProfile();
		  console.log('ID: ' + profile.getId()); // Do not send to your backend! Use an ID token instead.
		  console.log('Name: ' + profile.getName());
		  console.log('Image URL: ' + profile.getImageUrl());
		  console.log('Email: ' + profile.getEmail()); // This is null if the 'email' scope is not present.
	} */
	
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
				alert(maxByte + " Byte 이상 입력할 수 없습니다.");         
				obj.value = reStr;       
			}   
		}else if(obj.tagName === "DIV"){
			if (stringByteLength > maxByte) {// 전체길이를 초과하면          
				alert(maxByte + " Byte 이상 입력할 수 없습니다.");         
				obj.innerHTML = reStr;    
			}   
		} 
		
		obj.focus();  
	}

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
	  
	  $("#join").on("click", function(e){
		    e.preventDefault();
		    
		    location.href='/dokky/memberForm';
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
