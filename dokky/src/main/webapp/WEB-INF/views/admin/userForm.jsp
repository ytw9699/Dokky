<!--
마지막 업데이트 2022-05-25
회원 개인정보 확인 및 권한,접속 제어 
-->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %> 
<%@include file="../includes/common.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>Dokky - 회원 정보 </title>
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
				<button class="active" onclick="location.href='/admin/userForm?userId=${user.userId}'">회원 정보</button>  
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
	     				<c:if test="${user.enabled == false}">
								(탈퇴 회원)
						</c:if>
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
	     				제한상태
	     			</td>
	     			<td id="limitState" class="tableValue"> 
		     			<c:choose>
		     				<c:when test="${user.accountNonLocked == true}">
								제한 없음
							</c:when>
							<c:when test="${user.accountNonLocked == false}">
								제한중
							</c:when>
		     			</c:choose>  
	     			</td>
	     		</tr>
	     		<tr>
	     			<td class="tableText"> 
	     				제한변경 
	     			</td>
	     			<td class="tableValue">
		     			<div class="changeButton">     
		     				<button class="submitInfo" id="limitBtn">접속 제한/복구</button> 
			   			 </div>  
	     			</td> 
	     		</tr>
	     		<tr>
	     			<td class="tableText"> 
	     				부여권한
	     			</td>
	     			<td id="authState" class="tableValue"> 
	     			</td>
	     		</tr>
	     		<tr>
	     			<td class="tableText"> 
	     				권한변경 
	     			</td>
	     			<td class="tableValue">
		     			<div class="changeButton">     
					        <button class="submitInfo" id="role_userBtn">일반 유저</button> 
					        <button class="submitInfo" id="role_adminBtn">일반 관리자</button> 
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
	var userId = '${user.userId}'; 
	var ROLE_USER = false;
	var ROLE_ADMIN = false;
	var ROLE_SUPER = false;
	var accountNonLocked = ${user.accountNonLocked};
	
	<c:forEach items="${user.authList}" var="AuthVO">
		<c:choose>
			<c:when test="${AuthVO.auth == 'ROLE_USER'}">
					ROLE_USER = true;
			</c:when>
				<c:when test="${AuthVO.auth == 'ROLE_ADMIN'}">
					ROLE_ADMIN = true;
			</c:when>
			<c:when test="${AuthVO.auth == 'ROLE_SUPER'}">
					ROLE_SUPER = true;
			</c:when>
		</c:choose>  
	</c:forEach> 
	
	$(document).ajaxSend(function(e, xhr, options) { 
	    xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
	});
	
	var errorFunction = function(status){
	   	
		if(status == "error"){ 
			openAlert("Server Error(관리자에게 문의해주세요)");
		}
   	}
	
	var updateAuthState = function(status){
		
		var authState = "";
		var count = 0;
		
		if(ROLE_USER == true){
			authState += "일반 유저";
			count = count + 1; 
		}
		
		if(ROLE_ADMIN == true){
			
			if(count > 0){
				authState += ", 일반 관리자";
			}else{
				authState += "일반 관리자";
			}
			count = count + 1; 
		}
		
		if(ROLE_SUPER == true){
			
			if(count > 0){
				authState += ", 슈퍼 관리자";
			}else{
				authState += "슈퍼 관리자";
			}
		}
		
		$("#authState").html(authState);
   	}
	
	updateAuthState();
	
	var sendAlarmMsg = function(alarmData){
		if(webSocket != null && alarmData != null ){
	   		webSocket.send("sendAlarmMsg,"+alarmData.target);
	   	}
   	}
	
	
	function createRoleAdmin(userId, role, alarmData, callback, error){
		
		$.ajax({
				type : 'post',
				url : '/superAdmin/createRoleAdmin/'+ userId + '/' + role,
				data : JSON.stringify(alarmData), 
				contentType : "application/json; charset=utf-8",
				beforeSend: function(xhr) {
			        xhr.setRequestHeader("AJAX", "true"); 
				},
				success : function(result, status, xhr){
					if (callback) {
						callback(result, status, xhr);
					}
				},
				error : function(xhr, status, er) {
					if (error) {
						error(status);
					}
				}
			});
	}
	
	function deleteRoleAdmin(userId, role, alarmData, callback, error){
		
		$.ajax({
			type : 'post',
			//권한 거부로 인해 리다이렉트시 delete 메소드를 지원안해서 무조건 post 로 하자Request method 'DELETE' not supported- CustomAccessDeniedHandler)
			url : '/superAdmin/deleteRoleAdmin/'+ userId + '/' + role,
			data : JSON.stringify(alarmData), 
			contentType : "application/json; charset=utf-8",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", "true"); 
			},
			success : function(result, status, xhr) {
				if (callback) {
					callback(result, status, xhr);
				}
			},
			error : function(xhr, status, er) {
				if (error) {
					error(status);
				}
			}
		});
	}
	
	function createRoleUser(userId, role, alarmData, callback, error){
		
		$.ajax({
				type : 'post',
				url : '/admin/createRoleUser/'+ userId + '/' + role,
				data : JSON.stringify(alarmData), 
				contentType : "application/json; charset=utf-8",
				beforeSend: function(xhr) {
			        xhr.setRequestHeader("AJAX", "true"); 
				},
				success : function(result, status, xhr){
					if (callback) {
						callback(result, status, xhr);
					}
				},
				error : function(xhr, status, er) {
					if (error) {
						error(status);
					}
				}
			});
	}
	
	function deleteRoleUser(userId, role, alarmData, callback, error){
		
		$.ajax({
			type : 'post',
			url : '/admin/deleteRoleUser/'+ userId + '/' + role,
			data : JSON.stringify(alarmData), 
			contentType : "application/json; charset=utf-8",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", "true"); 
			},
			success : function(result, status, xhr) {
				if (callback) {
					callback(result, status, xhr);
				}
			},
			error : function(xhr, status, er) {
				if (error) {
					error(status);
				}
			}
		});
	}
	
	function limitLogin(userId, alarmData, callback, error) {
		
		$.ajax({
			type : 'post',
			url : '/admin/limitLogin/'+ userId,
			data : JSON.stringify(alarmData), 
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", "true"); 
			},
			contentType : "application/json; charset=utf-8",
			success : function(result, status, xhr) {
				if (callback) {
					callback(result, status, xhr);
				}
			},
			error : function(xhr, status, er) {
				if (error) {
					error(xhr,er);
				}
			}
		});
	}
	
	function permitLogin(userId, alarmData, callback, error) {
		
		$.ajax({
			type : 'post',
			url : '/admin/permitLogin/'+ userId,
			data : JSON.stringify(alarmData), 
			contentType : "application/json; charset=utf-8",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", "true"); 
			},
			success : function(result, status, xhr) {
				if (callback) {
					callback(result, status, xhr);
				}
			},
			error : function(xhr, status, er) {
				if (error) {
					error(xhr,er);
				}
			}
		});
	}
	
	$("#role_userBtn").on("click",function(e){
		
		e.preventDefault();
		
		var alarmData = { 
				target:userId,  
				  kind:null, 
			writerNick:myNickName,
			  writerId:myId
 		 };
		
		if(ROLE_USER == false){
			
				alarmData.kind = 13;
				
				createRoleUser(userId, 'ROLE_USER', alarmData,
					
					function(result, status, xhr){
					
						if(status == "success"){ 
							
							if (xhr.getResponseHeader("Location") != null){
								
								 location.href = xhr.getResponseHeader("Location");
								
							}else{
								
								ROLE_USER = true;
								
								updateAuthState();
								
								openAlert("일반유저 권한부여 완료");
								
								sendAlarmMsg(alarmData);
							}
						}
				   	},
				   
				   	errorFunction
				); 
			
		}else if(ROLE_USER == true){
			
			alarmData.kind = 14;
				 
			deleteRoleUser(userId, 'ROLE_USER', alarmData,
				
				function(result, status, xhr){
				
					if(status == "success"){ 
						
						console.log(xhr.getResponseHeader("Location"));
						
						if (xhr.getResponseHeader("Location") != null){
							
							 location.href = xhr.getResponseHeader("Location");
							
						}else{
							
							ROLE_USER = false;
							
							updateAuthState();
							
							openAlert("일반유저 권한삭제 완료");
							
							sendAlarmMsg(alarmData);
						}
					}
			   	},
			   
			   	errorFunction
			); 
		}
	});
	
	$("#role_adminBtn").on("click",function(e){ 
		
		e.preventDefault();
		
		var alarmData = { 
				target:userId,  
				  kind:null, 
			writerNick:myNickName,
			  writerId:myId
 		 };
		
		if(ROLE_ADMIN == false){
					 
				alarmData.kind = 15;
			
				createRoleAdmin(userId, 'ROLE_ADMIN', alarmData,
					
					function(result, status, xhr){
					
						if(status == "success"){ 
							
							if (xhr.getResponseHeader("Location") != null){
								
								 location.href = xhr.getResponseHeader("Location");
								
							}else{
								
								ROLE_ADMIN = true;
								
								updateAuthState();
								
								openAlert("일반관리자 권한부여 완료");
								
								sendAlarmMsg(alarmData);
							}
						}
				   	},
				   
				   	errorFunction
				); 
			
		}else if(ROLE_ADMIN == true){
			
			alarmData.kind = 16;
				 
			deleteRoleAdmin(userId, 'ROLE_ADMIN', alarmData,
				
				function(result, status, xhr){
					
					if(status == "success"){
						
						if (xhr.getResponseHeader("Location") != null){
							
							 location.href = xhr.getResponseHeader("Location");
							
						}else{
							
							ROLE_ADMIN = false;
							
							updateAuthState();
							
							openAlert("일반관리자 권한삭제 완료");
							
							sendAlarmMsg(alarmData);
						}
					}
			   	},
			   
			   	errorFunction
			); 
		}
	});
	
	$("#limitBtn").on("click",function(event){
		
		var userId = '${user.userId}';
		
		if(ROLE_SUPER === true){
			openAlert("슈퍼관리자를 제한 할 수 없습니다.");
			return;
		}
		
		var alarmData = { 
				target:userId,  
				  kind:null, 
			writerNick:myNickName,
			  writerId:myId
 		};
		
		if(accountNonLocked == true){ 
			
			alarmData.kind = 11;
			
			limitLogin(userId, alarmData, function(result, status, xhr){
				
				if(status == "success"){
					
					if (xhr.getResponseHeader("Location") != null){
						
						 location.href = xhr.getResponseHeader("Location");
						
					}else{
						
						var limitState = $("#limitState");
					   	
						limitState.html("제한중");
						
						accountNonLocked = false;
					   	
					   	if(webSocket != null && alarmData != null ){
					   		webSocket.send("limit,"+alarmData.target);//웹소켓으로 사용자에게 경고창 띄우고 강제 로그아웃 시키기
					   	} 
					   	
						openAlert("제한 하였습니다");
					}
				}
	   	    });
			
		}else if(accountNonLocked == false){
			
			alarmData.kind = 12;
			
			permitLogin(userId, alarmData, function(result, status, xhr){
				
				if(status == "success"){
					
					if (xhr.getResponseHeader("Location") != null){
						
						 location.href = xhr.getResponseHeader("Location");
						
					}else{
						
						var limitState = $("#limitState");
					   	
						limitState.html("제한 없음");
						
						accountNonLocked = true;
					   	
					   	openAlert("제한을 풀었습니다");
					   	
					   	sendAlarmMsg(alarmData);
					}
				}
	   	    });
		}
   	});
   	
</script>
</body>
</html>