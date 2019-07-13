<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %> 

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"> 
<style>
.leftWrap {
	width: 12%;
    margin-top: 20px;
    margin-left: 1%;
    display: inline-block;
    float: left;
    border-color: #e6e6e6;
	border-style: solid;
	background-color: #323639; 
    
}
.mypage {
    padding: 10px;
    box-sizing: border-box;
   	width: 252px;
    color: #e6e6e6;
    
}
.mypage:hover > a, .mypage:hover {
    color: #7151fc;
}
.mypage a { 
    color: white;
    text-decoration:none;
}
</style>
</head>
<body>
		<sec:authentication property="principal" var="userInfo"/>
		
	<div class="leftWrap">
		<div class="mypage"><a href="/dokky/main">Dokky</a></div>
		<div class="mypage"><a href="/dokky/board/list?category=1">공지사항</a></div>
		<div class="mypage"><a href="/dokky/board/list?category=2">자유게시판</a></div>
		<div class="mypage"><a href="/dokky/board/list?category=3">묻고답하기</a></div>
		<div class="mypage"><a href="/dokky/board/list?category=4">칼럼/Tech</a></div>
		<div class="mypage"><a href="/dokky/board/list?category=5">정기모임/스터디</a></div>
		<sec:authorize access="isAuthenticated()">
			<div class="mypage"><a href="/dokky/mypage/myInfoForm?userId=${userInfo.username}">내 정보</a></div>
		</sec:authorize>
		<div class="mypage">Today : 1 / Total : 10</div>
		<div class="mypage">
			<sec:authorize access="isAuthenticated()">
				<form method='post' action="/dokky/customLogout">
				    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
				    <input type="submit" value="Logout">
				</form>
			</sec:authorize>
			<sec:authorize access="isAnonymous()"> 
				<a href="/dokky/customLogin">로그인</a>  
				<a href="/dokky/memberForm">회원가입</a>
			</sec:authorize>	
		</div>
		<div class="mypage"><a href="/dokky/admin/memberList">관리자 페이지</a></div>
	</div>
</body>
</html>