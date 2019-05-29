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
}
.mypage {
    padding: 10px;
    box-sizing: border-box;
   	width: 252px;
    color: #666;
}
.mypage:hover > a, .mypage:hover {
    color: #7151fc;
}
.mypage a {
    color: #666;
    text-decoration:none;
}
</style>
</head>
<body>
	<div class="leftWrap">
		<div class="mypage"><a href="/dokky/main">Dokky</a></div>
		<div class="mypage"><a href="/dokky/board/list?kind=1">공지사항</a></div>
		<div class="mypage"><a href="/dokky/board/list?kind=2">자유게시판</a></div>
		<div class="mypage"><a href="/dokky/board/list?kind=3">묻고답하기</a></div>
		<div class="mypage"><a href="/dokky/board/list?kind=4">칼럼/Tech</a></div>
		<div class="mypage"><a href="/dokky/board/list?kind=5">정기모임/스터디</a></div>
		<div class="mypage"><a href="/dokky/board/list?kind=6">마이페이지</a></div>
		<div class="mypage">Today : 1 / Total : 10</div>
		
	</div>
</body>
</html>