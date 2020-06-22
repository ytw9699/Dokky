<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %> 
<%@include file="../includes/left.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"> 
	<title>Dokky - 탈퇴</title>
	<c:choose>
	   	  <c:when test="${pageContext.request.serverName == 'localhost'}">
				<link href="/resources/css/myWithdrawalForm.css" rel="stylesheet" type="text/css"/>
		  </c:when>
	      <c:otherwise>
	    		<link href="/ROOT/resources/css/myWithdrawalForm.css" rel="stylesheet" type="text/css"/>
	      </c:otherwise>
	</c:choose> 
</head>
<body>
	<sec:authentication property="principal" var="userInfo"/>
	
<div class="myWithdrawalFormWrap">	
		<div id="menuWrap">
			<div class="tab"> 
				<button onclick="location.href='myInfoForm?userId=${userInfo.username}'">개인정보 변경</button>
		        <button onclick="location.href='myBoardList?userId=${userInfo.username}'">나의 게시글</button> 
		        <button onclick="location.href='myReplylist?userId=${userInfo.username}'">나의 댓글</button> 
		        <button onclick="location.href='myScraplist?userId=${userInfo.username}'">나의 스크랩</button>
		        <button onclick="location.href='myCashInfo?userId=${userInfo.username}'">나의 캐시</button>
		        <button onclick="location.href='myWithdrawalForm?userId=${userInfo.username}'" class="active" >탈퇴 하기</button> 
		    </div>  
		</div>
		
		<div class="myWithdrawalContentWrap">
	     	<div class="myWithdrawalContent"> 
	     		<span id="accountVal">1. 탈퇴 후에도 게시물과 댓글은 삭제되지 않습니다. 원치 않으시면 게시글과 댓글을 삭제해주세요.</span>
	     		<span id="accountVal">2. 캐시내역과 신고내역등 일부 정보는 보관됩니다.</span>  
	     		<span id="accountVal">3. 탈퇴후 같은 계정으로 재가입 가능합니다.</span>  
	     	</div> 
	     	<div class="myWithdrawalButtonWrap"> 
		     	<form method='post' action="/mypage/myWithdrawal">
					<input type="submit" id="withdrawal" class="withdrawalButton" value="탈퇴하기"/>
					<input type="hidden" name="userId" value="${userInfo.username}" />
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
				</form> 
	     	</div>
    	</div>
</div> 
</body>
</html>