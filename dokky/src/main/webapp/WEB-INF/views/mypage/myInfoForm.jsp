<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %> 
<%@include file="../includes/left.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>마이페이지</title>
<style>
	body{
		background-color: #323639;  
		}
	.bodyWrap {
	    width: 80%; 
	    display: inline-block;
	    margin-left: 2%;
	    margin-top: 1%;
	    min-height: 500px; 
	    border-color: #e6e6e6;
		border-style: solid;
		background-color: #323639; 
		color: #e6e6e6;
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
	
</style>  
</head>
<body>
<sec:authentication property="principal" var="userInfo"/>
<div class="bodyWrap">	
	<div class="ContentWrap">
		<div id="menuWrap">
			<div class="tab">  
				<button onclick="location.href='myInfoForm?userId=${userInfo.username}'">개인정보 변경</button>
		        <button onclick="location.href='rePasswordForm?userId=${userInfo.username}'">비밀번호 변경</button> 
		        <button onclick="location.href='myBoardList?userId=${userInfo.username}'">나의 게시글</button> 
		        <button onclick="location.href='myReplylist?userId=${userInfo.username}'">나의 댓글</button> 
		        <button onclick="location.href='myInfoForm?userId=${userInfo.username}'">스크랩</button>
		        <button onclick="location.href='myInfoForm?userId=${userInfo.username}'">캐시</button>  
		    </div> 
		</div>
		<div id="infomation" class="tabcontent">
	       <form method='post' action="/dokky/mypage/myInfo" id="operForm">	
	     	  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
	     	<table width="100%" style="margin-bottom: 30px;">
	     		<tr>
	     			<td class="tableText">
	     				아이디
	     			</td>
	     			<td class="tableValue">
	     				<input type="text" name="userId" value="${myInfo.userId}" class="inputInfo" readonly="readonly">
	     			</td>
	     		</tr>
	     		<tr>
	     			<td class="tableText">
	     				닉네임
	     			</td>
	     			<td class="tableValue">
	     				<input type="text" name="nickName" value="${myInfo.nickName}" class="inputInfo">
	     			</td>
	     		</tr>
	     		<tr>
	     			<td class="tableText">
	     			비밀번호
	     			</td>
	     			<td class="tableValue">
	     				<input type="password" name="userPw" value="" class="inputInfo">
	     			</td>
	     		</tr>
	     		<tr> 
	     			<td class="tableText">
	     				이메일 
	     			</td>
	     			<td class="tableValue">
	     				<input type="text" name="email" value="${myInfo.email}" class="inputInfo" >
	     			</td>
	     		</tr>
	     		<tr>
	     			<td class="tableText">
	     				연락처
	     			</td>
	     			<td class="tableValue">
	     				<input type="text" name="phoneNum"  value="${myInfo.phoneNum}" class="inputInfo" >	
	     			</td>
	     		</tr>
	     		<tr>
	     			<td class="tableText">
	     				은행명
	     			</td>
	     			<td class="tableValue">
	     				<input type="text" name="bankName"  value="${myInfo.bankName}" class="inputInfo" >	
	     			</td>
	     		</tr>
	     		<tr>
	     			<td class="tableText">
	     				계좌번호
	     			</td>
	     			<td class="tableValue">
	     				<input type="text" name="account"  value="${myInfo.account}" class="inputInfo" >	
	     			</td>
	     		</tr>
	     		<tr>
	     			<td class="tableText">
	     				가입일
	     			</td>
	     			<td class="tableValue"> 
	     				<fmt:formatDate value="${myInfo.regDate}" pattern="yyyy년 MM월 dd일 hh:mm" />
	     			</td>
	     		</tr>
	     		<tr>
	     			<td class="tableText">
	     				최근 로그인
	     			</td>
	     			<td class="tableValue"> 
	     				<fmt:formatDate value="${myInfo.loginDate}" pattern="yyyy년 MM월 dd일 hh:mm" />
	     			</td>
	     		</tr>
	     	</table> 
	     		<input type="button" id="SumbitMyInfo" value="변경하기" class="submitInfo" /> 
	      </form>
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
		
		function checkPassword(checkData, callback, error) {
			$.ajax({
				type : 'post',
				url : '/dokky/mypage/checkPassword',
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
	    
		var checkData = {	userPw : userPw,
							userId : userId
						};
		
		checkPassword(checkData, function(result,xhr){
			 if(xhr.status == '200'){
				 operForm.submit(); 
	    	}
		    }
		,function(xhr,er){
			if(xhr.status == '404'){
			 alert("비밀번호가 맞지 않습니다.");
			}
		}
		);
		});
</script>
 		<c:choose>
		       <c:when test="${update eq 'complete'}">
		          		<script>
					      $(document).ready(function(){
					      	alert("변경되었습니다.");
					      });
				      	</script>
		       </c:when>
		       <c:when test="${update eq 'notComplete'}">
		       			<script>
					      $(document).ready(function(){
					      	alert("재시도해주세요.");
					      });
				    	</script>
		       </c:when>
		</c:choose>
</body>
</html>