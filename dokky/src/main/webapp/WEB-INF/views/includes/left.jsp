<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

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
	<div class="leftWrap">
		<div class="mypage"><a href="/dokky/main">Dokky</a></div>
		<div class="mypage"><a href="/dokky/board/list?category=1">공지사항</a></div>
		<div class="mypage"><a href="/dokky/board/list?category=2">자유게시판</a></div>
		<div class="mypage"><a href="/dokky/board/list?category=3">묻고답하기</a></div>
		<div class="mypage"><a href="/dokky/board/list?category=4">칼럼/Tech</a></div>
		<div class="mypage"><a href="/dokky/board/list?category=5">정기모임/스터디</a></div>
		<div class="mypage"><a href="/dokky/board/list?category=6">마이페이지</a></div>
		<div class="mypage">Today : 1 / Total : 10</div>
		
	</div>
</body>
</html>