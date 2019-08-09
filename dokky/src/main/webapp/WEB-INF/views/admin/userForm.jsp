<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %> 
<%@include file="../includes/left.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>계정관리 상세페이지</title>
<style>
		@media screen and (max-width:500px){ 
			     .userFormWrap {
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
		          .userFormWrap {
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
		          .userFormWrap {
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
	 
	.ContentWrap{box-sizing: border-box;
	    padding-top: 48px;
	    padding-left: 20px;
	    padding-right: 20px;
	    width: 95%;
		min-height: 750px;
	    margin: 0 auto; 
 	}
	#menuWrap .tab button {
		background-color: inherit;
		border: none;
		outline:none;
		cursor: pointer;
		padding: 14px 16px;
		transition: 0.3s;
		font-size: 20px;  
		color: #e6e6e6;
	}
	#menuWrap .tab button:hover {
	background-color: #7b7676;
	}
	/* #menuWrap .tabcontent {  
		display: none; 
		padding: 6px 12px;
		border: 1px;
	}  */
	.tableText{
		width: 10%;
		font-size: 20px;  
		color: #e6e6e6;
    }
	.tableValue{    
		height: 50px;
	    /* font-size: 18px;
	    color: #555; */
	 }
	 .inputInfo{
	 	margin-top: 3px;
	    font-size: 20px;
	    color: #555;
	    padding: 8px;
	    width: 30%;
	    border-radius: 8px;
	    border: 1px solid #b5b5b5;
	    height: 30px;
	 }
	 .submitInfo{  
	 	font-size: 20px;
	    background-color: #555;
	    border: 1px solid #555;
	    color: #e6e6e6;
	    padding: 8px;
	    border-radius: 8px;
	    width: 7%;
    }
      
   .changeButton button {
		background-color: inherit;
		border: none; 
		outline:none;
		cursor: pointer;
		padding: 14px 16px;
		transition: 0.3s;
		font-size: 20px;  
		color: #e6e6e6;
	}
	.changeButton button:hover {
	background-color: #7b7676;
	}
	
</style>  
</head>
<body>
<sec:authentication property="principal" var="userInfo"/>
<div class="userFormWrap">	
	<div class="ContentWrap">
		<div id="menuWrap"> 
			<div class="tab">    
		        <button onclick="location.href='userForm?userId=${user.userId}'">유저 개인정보</button> 
		        <button onclick="location.href='userCashHistory?userId=${user.userId}'">유저 캐시내역</button>
		        <button onclick="location.href='/dokky/userBoardList?userId=${user.userId}'">유저 활동</button>  
		    </div>   	 
		 </div> 
		 
		<div id="infomation" class="tabcontent">
	     	<table width="100%" style="margin-bottom: 30px;">
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
	     				이메일 
	     			</td>
	     			<td class="tableValue">
	     				${user.email}
	     			</td>
	     		</tr>
	     		<tr>
	     			<td class="tableText">
	     				연락처
	     			</td>
	     			<td class="tableValue">
	     				${user.phoneNum}	
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
	     				<fmt:formatDate value="${user.regDate}" pattern="yyyy년 MM월 dd일 hh:mm" />
	     			</td>
	     		</tr>
	     		<tr>
	     			<td class="tableText"> 
	     				최근 로그인
	     			</td>
	     			<td class="tableValue"> 
	     				<fmt:formatDate value="${user.loginDate}" pattern="yyyy년 MM월 dd일 hh:mm" />
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
							<c:when test="${user.authList[0].auth == 'ROLE_ADMIN' || user.authList[0].auth == 'ROLE_USER'}">
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
						        <button id="stop" data-user_id="${user.userId}">모든 글쓰기 제한</button> 
						        <button id="limit" data-user_id="${user.userId}">접속 제한</button> 
						        <button id="recovery" data-user_id="${user.userId}">계정 복구</button> 
			   			 </div>  
	     			</td> 
	     		</tr>
	     	</table>
	     	
     	</div>
	</div> 
</div> 
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script>

	var csrfHeaderName ="${_csrf.headerName}"; 
	var csrfTokenValue="${_csrf.token}";
	
	$(document).ajaxSend(function(e, xhr, options) { 
	    xhr.setRequestHeader(csrfHeaderName, csrfTokenValue); //모든 AJAX전송시 CSRF토큰을 같이 전송하도록 셋팅
	  });
	
	function limitRegistering(userId, callback, error) {
		$.ajax({
			type : 'put',
			url : '/dokky/admin/roleStop/'+ userId,
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
	function limitLogin(userId, callback, error) {
		$.ajax({
			type : 'put',
			url : '/dokky/admin/roleLimit/'+ userId,
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
	function recovery(userId, callback, error) {
		$.ajax({
			type : 'put',
			url : '/dokky/admin/roleUser/'+ userId,
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
		
		limitRegistering(userId, function(result){
		   	var currentState = $("#currentState");
		   	currentState.html("모든 글쓰기 제한");
	   	  });
	   	});
	
	$("#limit").on("click",function(event){//2. 접속 제한 이벤트 설치
		var userId = $(this).data("user_id");
		
		limitLogin(userId, function(result){
		   	var currentState = $("#currentState");
		   	currentState.html("접속 제한");
	   	  });
	   	});
	
	$("#recovery").on("click",function(event){//3. 권한 정상 되돌리기 이벤트 설치
		var userId = $(this).data("user_id");
		
		recovery(userId, function(result){
		   	var currentState = $("#currentState");
		   	currentState.html("정상");
	   	  });
	   	});
	
   	
</script>
</body>
</html>