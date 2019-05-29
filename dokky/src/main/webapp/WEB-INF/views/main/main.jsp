<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
   <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
   <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
   <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
   <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
   <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script src="//code.jquery.com/jquery-1.11.0.min.js"></script>
	<title>MyPortFolio</title>
	
<style>
.bodyWrap {
    width: 85%;
    display: inline-block;
    margin-left: 2%;
    margin-top: 1%;
    min-height: 500px;
}
    
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
		<div class="mypage"><a href="/MyPortFolio/main">MyPortFolio</a></div>
		<div class="mypage"><a href="">Welcome</a></div>
		<div class="mypage"><a href="">Profile</a></div>
		<div class="mypage"><a href="">Project</a></div>
		<div class="mypage">
			<form action="/picksell/mainSearchList" method="GET">
				<input type="text" name="searchKeyword" placeholder="검색어를 입력해주세요" class="searchINPUT" />
				<input type="submit" value="검색" class="searchSUBMIT" />
			</form>
		</div>
		<div class="mypage">Today : 1 / Total : 10</div>
		<div class="mypage"><a href="https://github.com/ytw9699" target="blank">https://github.com/ytw9699</a></div>
		<div class="mypage"><a href="https://cg-developer.tistory.com/236?category=776474" target="blank">https://cg-developer.tistory.com</a></div>
		<div class="mypage"><a href="mailto:ytw9699@gmail.com">ytw9699@gmail.com</a></div>
		
	</div>
	
	<div class="bodyWrap">	
		<div><h1>Welcome</h1></div>
		<div>저의 포트폴리오를 보러오신것을 환영합니다.</div> 
		<br/>
		<div><h1>Profile</h1></div>
			<div>
				<div>윤태원(남)</div>
				<div>31살(89년생)</div>
				<div>명지전문대 경영학과 전문 학사 졸업  ~2014.02</div>
				<div>경기대학교 경영학과 학사 졸업 ~2017.08</div>
				<div>KH정보교육원 수료 ~2018.07</div>
				<div>정보처리기사 자격증 취득 ~2018.11</div>
				<div>기술 블로깅 ~2019.03</div>
				<div>개인프로젝트 ~2019.05</div> 
			</div>
		<div><h1>Project</h1></div>
			<div>1.종합쇼핑몰 - 스프링 프레임워크/개인</div>
			<div>2.개발자 커뮤니티 - 스프링 부트/개인</div>
			<div>3.미정- 스프링 프레임워크/개인</div>
	</div>
	
</body>

</html>