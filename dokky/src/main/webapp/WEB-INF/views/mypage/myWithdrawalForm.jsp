<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %> 
<%@include file="../includes/common.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"> 
	<title>Dokky - 탈퇴</title>
	<c:choose>
	   	  <c:when test="${pageContext.request.serverName == 'localhost'}">
				<link href="/resources/css/mypage/myWithdrawalForm.css" rel="stylesheet" type="text/css"/>
		  </c:when>
	      <c:otherwise>
	    		<link href="/ROOT/resources/css/mypage/myWithdrawalForm.css" rel="stylesheet" type="text/css"/>
	      </c:otherwise>
	</c:choose> 
</head>
<body>
	<sec:authentication property="principal" var="userInfo"/>
	
<div class="myWithdrawalFormWrap">	
		<div id="menuWrap">
			<div class="tab"> 
				<button onclick="location.href='myInfoForm?userId=${userInfo.username}'">나의 정보</button>
		        <button onclick="location.href='myBoardList?userId=${userInfo.username}'">나의 게시글</button> 
		        <button onclick="location.href='myReplylist?userId=${userInfo.username}'">나의 댓글</button> 
		        <button onclick="location.href='myScraplist?userId=${userInfo.username}'">나의 스크랩</button>
		        <button onclick="location.href='myCashInfo?userId=${userInfo.username}'">나의 캐시</button>
		        <button onclick="location.href='myWithdrawalForm?userId=${userInfo.username}'" class="active" >탈퇴 하기</button> 
		    </div>  
		</div>
		
		<div class="myWithdrawalContentWrap">
	     	<div class="myWithdrawalContent"> 
	     		<div class="contentVal">- 탈퇴 후에도 회원님의 활동내역은 삭제되지 않습니다. </div>
	     		<div class="contentVal">- 원하지 않으시면 삭제후 탈퇴 해주세요.</div>
	     		<div class="contentVal">- 탈퇴 후에도 같은 계정으로 재가입은 가능합니다.</div>  
	     	</div> 
	     	<div class="myWithdrawalButtonWrap"> 
		     	<form method='post' action="/mypage/myWithdrawal">
					<input type="button" id="withdrawal" class="withdrawalButton" value="바로 탈퇴하기"/>
					<input type="hidden" name="userId" value="${userInfo.username}" />
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
				</form> 
	     	</div>
    	</div>
</div> 

<script>
	
	$("#withdrawal").on("click", function(event){
		
		event.preventDefault();
		
		if('${userInfo.username}' === 'admin'){ 
			
				openAlert("탈퇴 할 수 없는 아이디 입니다");
		}else{
			
				$("form").submit();	
		}
	}); 

</script>
</body>
</html>