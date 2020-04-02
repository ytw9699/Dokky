<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %> 
<%@include file="../includes/left.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>Dokky - 비밀번호 변경</title>
	<link href="/resources/css/myRepasswordForm.css" rel="stylesheet" type="text/css">
</head>
<body>
	<sec:authentication property="principal" var="userInfo"/>
		
<div class="repasswordWrap">	
		<div id="menuWrap">
			<div class="tab"> 
				<button onclick="location.href='myInfoForm?userId=${userInfo.username}'">개인정보 변경</button>
		        <button onclick="location.href='myBoardList?userId=${userInfo.username}'">나의 게시글</button> 
		        <button onclick="location.href='myReplylist?userId=${userInfo.username}'">나의 댓글</button> 
		        <button onclick="location.href='myScraplist?userId=${userInfo.username}'">나의 스크랩</button>
		        <button onclick="location.href='myCashInfo?userId=${userInfo.username}'">나의 캐시</button>
		    </div> 
		</div>
		
		<div id="infomation" class="tabcontent">
	       <form method='post' action="/mypage/MyPassword" id="operForm">	
	     	  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
	     	  <input type="hidden" name="userId" value="${userInfo.username}" />
	     	<table id="inforTable">
	     		<tr>
	     			<td class="tableText"> 
	     			현재 비밀번호
	     			</td>
	     			<td class="tableValue">
	     				<input type="password" name="userPw" value="" class="inputInfo" oninput="checkLength(this,20)" autofocus>
	     			</td> 
	     		</tr>
	     		<tr>
	     			<td class="tableText">
	     			새 비밀번호
	     			</td>
	     			<td class="tableValue">
	     				<input type="password" name="newPw" value="" class="inputInfo" oninput="checkLength(this,20)">
	     			</td>
	     		</tr>
	     		<tr>
	     			<td class="tableText"> 
	     			새 비밀번호 확인  
	     			</td>
	     			<td class="tableValue">
	     				<input type="password" name="checkPw" value="" class="inputInfo" oninput="checkLength(this,20)">
	     			</td>
	     		</tr>
	     	</table>  
	     		<input type="button" id="SumbitMyInfo" value="변경하기" class="submitInfo" /> 
	      </form>
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

	var csrfHeaderName ="${_csrf.headerName}"; 
	var csrfTokenValue="${_csrf.token}";

	$(document).ajaxSend(function(e, xhr, options) { 
	    xhr.setRequestHeader(csrfHeaderName, csrfTokenValue); //모든 AJAX전송시 CSRF토큰을 같이 전송하도록 셋팅
	  });
		
		function checkPassword(checkData, callback, error) {
			$.ajax({
				type : 'post',
				url : '/mypage/checkPassword',
				data : JSON.stringify(checkData),
				contentType : "application/json; charset=utf-8",
				success : function(result, status, xhr) {
					if (callback) {
						callback(result,xhr);
					}
				},
				error : function(xhr, status, er) {
					if (error) {
						error(xhr,er);
					}
				}
			});
		}

	$("#SumbitMyInfo").on("click",function(event){
		var operForm = $("#operForm");
		var userPw = operForm.find("input[name='userPw']").val();
	    var userId = operForm.find("input[name='userId']").val();
	    var newPw   = operForm.find("input[name='newPw']").val();
		var checkPw = operForm.find("input[name='checkPw']").val();
		
	    if(userPw == ""){
	    	openAlert("현재 비밀번호를 입력해주세요");
	    	return;
	    }
	    if(newPw == ""){
	    	openAlert("새 비밀번호를 입력해주세요");
	    	return;
	    }
	    if(checkPw == ""){
	    	openAlert("새 비밀번호를 다시 입력해주세요"); 
	    	return;
	    }
	    
		var checkData = {	userPw : userPw,
							userId : userId
						};
		
		checkPassword(checkData, function(result,xhr){
			 if(xhr.status == '200'){
				
				if(newPw !== checkPw){
					openAlert("새 비밀번호가 서로 일치 하지 않습니다");
				}else{
					operForm.submit();
				}
	    	}
		    }
		,function(xhr,er){
			if(xhr.status == '404'){
			 openAlert("현재 비밀번호가 맞지 않습니다");
			}
		}
		);
		});
</script>
 		<c:choose>
		       <c:when test="${update eq 'complete'}">
		          		<script>
					      $(document).ready(function(){
					      	openAlert("비밀번호가 변경되었습니다");
					      });
				      	</script>
		       </c:when>
		       <c:when test="${update eq 'notComplete'}">
		       			<script>
					      $(document).ready(function(){
					      	openAlert("재시도해주세요");
					      });
				    	</script>
		       </c:when>
		</c:choose>
</body>
</html>