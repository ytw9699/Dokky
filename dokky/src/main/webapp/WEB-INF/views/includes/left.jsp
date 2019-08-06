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
		<div class="mypage"><a href="/dokky/board/allList?category=0">전체글보기</a></div>
		<div class="mypage"><a href="/dokky/board/list?category=1">공지사항</a></div>
		<div class="mypage"><a href="/dokky/board/list?category=2">자유게시판</a></div>
		<div class="mypage"><a href="/dokky/board/list?category=3">묻고답하기</a></div>
		<div class="mypage"><a href="/dokky/board/list?category=4">칼럼/Tech</a></div>
		<div class="mypage"><a href="/dokky/board/list?category=5">정기모임/스터디</a></div>
		<sec:authorize access="isAuthenticated()">
			<div class="mypage"><a href="/dokky/mypage/myInfoForm?userId=${userInfo.username}">내 정보</a></div>
			<div class="mypage"><a href="/dokky/alarmList?userId=${userInfo.username}">알림</a>-</div>
			<div class="mypage"><a class="alarmCount" href="/dokky/alarmList?userId=${userInfo.username}"></a></div> 
		</sec:authorize>
		<div class="mypage">Today : ${sessionScope.todayCount} / Total : ${sessionScope.totalCount}</div>
		<div class="mypage">  
			<sec:authorize access="isAuthenticated()">
					<form id="logoutForm" method='post' action="/dokky/customLogout">
					  	  <a href="/dokky/mypage/myInfoForm?userId=${userInfo.username}">
					  	  <img width="30px" src="/dokky/resources/img/profile_img/<c:out value="${userInfo.username}" />" class="memberImage" onerror="this.src='/dokky/resources/img/basicProfile.png'" />
					  	  <c:out value="${userInfo.member.nickName}"/></a>
					    <input id="logoutBtn" type="submit" value="Logout">  
					</form>  
			</sec:authorize>
			<sec:authorize access="isAnonymous()"> 
				<a href="/dokky/customLogin">로그인</a>  
				<a href="/dokky/memberForm">회원가입</a>
			</sec:authorize>	
		</div>
		<div class="mypage"><a href="/dokky/admin/memberList">관리자</a></div>
	</div>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	<script>
	
	function getAlarmRealCount(userId, callback, error) {
		$.ajax({
			type : 'get',
			url : '/dokky/alarmRealCount/'+ userId,
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
	
	<sec:authorize access="isAuthenticated()"> 
		var alarmCount = $(".alarmCount");
		var userId = '${userInfo.username}';
	</sec:authorize>
	
	function schedule(){
	    getAlarmRealCount(userId, function(result){
	    	alarmCount.html(result);
	 	 });
	} 
	
	$(document).ready(function() {
		<sec:authorize access="isAuthenticated()">  
			schedule();
		 	setInterval(schedule, 30000);//30초마다 알람카운트 불러오기
		</sec:authorize>
		
		 var parameterName = '${_csrf.parameterName}';
		 var token = '${_csrf.token}';
		 var logoutForm = $("#logoutForm");
		  
		  $("#logoutBtn").on("click", function(e){
			  
			  var str = "<input type='hidden' name='"+parameterName+"' value='"+token+"'>";
			  
			  logoutForm.append(str).submit();
			  
		  }); 
	});
	
	</script>
</body>
</html>