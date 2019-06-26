<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ include file="../includes/left.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>Dokky회원가입</title>
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
</style>
</head>
<body>
	<div class="bodyWrap">	
		 <form method='post' action="/dokky/members">	
		  	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
		  	
			<div class="bigbig">
			<div class="information">아이디</div>
				<input type="text" name="userId" class="inputclass"/>
			<br/>
		    <div class="information">비밀번호</div>
		   		 <input type="password" name="userPw" id="userpw" class="inputclass"/>
		    <br/>
		    <div class="information">비밀번호 재확인</div>
		   		 <input type="password" name="userpwCheck" id="userpwCheck" class="inputclass"/>
			<br/>
			<div class="information">닉네임</div>
				<input type="text" name="nickName" class="inputclass" />
			<br/>
			<div class="information">이메일</div>
				<input type="email" name="email" id="email" class="inputclass"/>
			<div class="information">핸드폰 번호(선택)</div>
				<input type="text" name="phoneNum" class="inputclass"/>
			<br/>
			<div class="information">계좌번호(선택)</div>
				<input type="text" name="account" class="inputclass"/>
			<br/>
			<div class="information">은행명(선택)</div>
				<input type="text" name="bankName" class="inputclass"/>
			<br/>
			</div>
			<div class="nextWrap">
				<input type="submit" class="pre" value="가입완료"/>
			</div>
		</form>
	</div>
</body>
</html>

