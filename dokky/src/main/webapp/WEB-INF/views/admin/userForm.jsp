<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %> 
<%@include file="../includes/left.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>Dokky - 회원 개인정보 </title>   
	<c:choose>
	  	  <c:when test="${pageContext.request.serverName == 'localhost'}">
				<link href="/resources/css/userForm.css" rel="stylesheet" type="text/css"/>
	  	 </c:when>
	     <c:otherwise>
	   			<link href="/ROOT/resources/css/userForm.css" rel="stylesheet" type="text/css"/>
	     </c:otherwise>
	</c:choose>
</head>
<body>
<sec:authentication property="principal" var="userInfo"/>

<div class="userFormWrap">	

		<div id="menuWrap"> 
			<div class="tab">  
				<button class="active" onclick="location.href='/admin/userForm?userId=${user.userId}'">회원 개인정보</button>  
		        <button onclick="location.href='/admin/userCashHistory?userId=${user.userId}'">회원 캐시내역</button>
		        <button onclick="location.href='/userBoardList?userId=${user.userId}&pageLocation=admin'">회원 활동</button>
		    </div>   	 
		</div> 
		 
     	<div class="listWrapper">
			<table id="inforTable">
				<tr>
	     			<td class="tableText">
	     				아이디
	     			</td>
	     			<td class="tableValue">
	     				${user.userId}
	     			</td>
	     		</tr>
	     		<tr>
	     			<td class="tableText">
	     				닉네임
	     			</td>
	     			<td class="tableValue">
	     				${user.nickName}
	     			</td>
	     		</tr>
	     		<tr>
	     			<td class="tableText">
	     				은행명
	     			</td>
	     			<td class="tableValue">
	     				${user.bankName}
	     			</td>
	     		</tr>
	     		<tr>
	     			<td class="tableText">
	     				계좌번호
	     			</td>
	     			<td class="tableValue">
	     				${user.account}	
	     			</td>
	     		</tr>
	     		<tr>
	     			<td class="tableText">
	     				가입일
	     			</td>
	     			<td class="tableValue"> 
	     				<fmt:formatDate value="${user.regDate}" pattern="yyyy-MM-dd HH:mm" />
	     			</td>
	     		</tr>
	     		<tr>
	     			<td class="tableText"> 
	     				최근 로그인
	     			</td>
	     			<td class="tableValue"> 
	     				<fmt:formatDate value="${user.preLoginDate}" pattern="yyyy-MM-dd HH:mm" />
	     			</td>
	     		</tr>
	     		<tr>
	     			<td class="tableText"> 
	     				계정상태 
	     			</td>
	     			<td id="currentState" class="tableValue"> 
		     			<c:choose>
		     				<c:when test="${user.authList[0].auth == 'ROLE_STOP'}">
								모든 글쓰기 제한
							</c:when>
							<c:when test="${user.authList[0].auth == 'ROLE_ADMIN' || user.authList[0].auth == 'ROLE_USER' || user.authList[0].auth == 'ROLE_SUPER'}">
								정상 
							</c:when>
							<c:when test="${user.authList[0].auth == 'ROLE_LIMIT'}">
								접속 제한 
							</c:when>
		     			</c:choose>  
	     			</td>
	     		</tr>
	     		<tr>
	     			<td class="tableText"> 
	     				계정상태 변경 
	     			</td>
	     			<td class="tableValue">
		     			<div class="changeButton">     
					        <button class="submitInfo" id="stop" data-user_id="${user.userId}">모든 글쓰기 제한</button> 
					        <button class="submitInfo" id="limit" data-user_id="${user.userId}">접속 제한</button> 
					        <button class="submitInfo" id="recovery" data-user_id="${user.userId}">계정 복구</button> 
			   			 </div>  
	     			</td> 
	     		</tr>
	     	</table>
	   </div>
</div> 
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script>

	var csrfHeaderName ="${_csrf.headerName}"; 
	var csrfTokenValue="${_csrf.token}";
	var myId = '${userInfo.username}'; 
	var myNickName = '${userInfo.member.nickName}';
	
	$(document).ajaxSend(function(e, xhr, options) { 
	    xhr.setRequestHeader(csrfHeaderName, csrfTokenValue); //모든 AJAX전송시 CSRF토큰을 같이 전송하도록 셋팅
	  });
	
	function limitRegistering(userId, alarmData, callback, error) {

		$.ajax({
				type : 'put', 
				url : '/admin/roleStop/'+ userId,
				data : JSON.stringify(alarmData), 
				contentType : "application/json; charset=utf-8",
				success : function(result, status, xhr) {
					if (callback) {
						callback(result);
					}
				},
				error : function(xhr, status, er) {
					if (error) {
						error(er);
					}
				}
		});
	}
	
	function limitLogin(userId, callback, error) {
		$.ajax({
			type : 'put',
			url : '/admin/roleLimit/'+ userId,
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
	
	function recovery(userId, alarmData, callback, error) {
			
			$.ajax({
				type : 'put',
				url : '/admin/roleUser/'+ userId,
				data : JSON.stringify(alarmData), 
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

	$("#stop").on("click",function(event){//1. 게시글,댓글 제한 이벤트 설치
		
			var userId = $(this).data("user_id"); 
			
			if(userId === 'admin'){
				openAlert("슈퍼관리자의 계정상태를 변경할 수 없습니다");
				return;
			}
			
			var alarmData = { 
									target:userId,  
									  kind:10, 
								writerNick:myNickName,
								  writerId:myId
			         		};
			
			limitRegistering(userId, alarmData, function(result){
				
					if(result == 'success'){
						var currentState = $("#currentState");
					   	currentState.html("모든 쓰기 기능 제한");
					   	openAlert("모든 쓰기 기능을 제한 하였습니다");
					}
	   	    });
   	});
	
	$("#limit").on("click",function(event){//2. 접속 제한 이벤트 설치
		var userId = $(this).data("user_id");
	
		if(userId === 'admin'){
			openAlert("슈퍼관리자의 계정상태를 변경할 수 없습니다");
			return;
		}
		
		limitLogin(userId, function(result){
			
		   	var currentState = $("#currentState");
		   	
		   	currentState.html("접속 제한");
		   	
		   	openAlert("접속을 제한 하였습니다");
		   	
		   	if(webSocket != null){
		   		webSocket.send("limit,"+userId);//웹소켓으로 사용자 로그아웃 시키기	
		   	}		   	
			
	   	  });
   	});
	
	$("#recovery").on("click",function(event){//3. 권한 정상 되돌리기 이벤트 설치
		
		var userId = $(this).data("user_id");
	
		if(userId === 'admin'){
			openAlert("슈퍼관리자의 계정상태를 변경할 수 없습니다");
			return;
		}
		
		var alarmData = { 
								target:userId,  
								  kind:11, 
							writerNick:myNickName,
							  writerId:myId
				 		};
		
		recovery(userId, alarmData, function(result){
			
			if(result == 'success'){
				
				var currentState = $("#currentState");
			   	currentState.html("정상");
			   	openAlert("계정을 정상으로 복구 하였습니다");
			}
   	    });
   	});
	
   	
</script>
</body>
</html>