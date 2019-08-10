<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %> 

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"> 
<style>

      @media screen and (max-width:500px){ 
	              .leftWrap {
		   				width: 10%;
					    margin-top: 1%;
					    margin-left: 0%;
					    display: inline-block;
					    float: left;
					    border-color: #e6e6e6;
					    border-style: solid;
					    background-color: #323639;
					    position: fixed;
					}
           }
      @media screen and (min-width: 501px) and (max-width:1500px){
	           .leftWrap {
	   				width: 14%;
				    margin-top: 1%;
				    margin-left: 0%;
				    display: inline-block;
				    float: left;
				    border-color: #e6e6e6;
				    border-style: solid;
				    background-color: #323639;
				    position: fixed;
				}
      }
      @media screen and (min-width: 1501px){    
         	 .leftWrap {
	   				width: 10%;
				    margin-top: 1%;
				    margin-left: 18%;
				    display: inline-block;
				    float: left;
				    border-color: #e6e6e6;
				    border-style: solid;
				    background-color: #323639;
				    position: fixed;
				}
      }

.mypage {
    padding: 10px;
    box-sizing: border-box;
   	width: 100%;
    color: #e6e6e6;
    border-color: #e6e6e6;
    border-style: solid; 
    
}
.mypage:hover > a, .mypage:hover {
    color: #7151fc;
}
.mypage a { 
    color: white;
    text-decoration:none;
}

.perid-layer{
    display: none;
    border-style: solid;
    border-color: #e6e6e6;
    width: 6%;
    height: 55px;
    position: fixed;
    background-color: #323639;
	/* position : absolute; */ 
	/* style="display: block; position: absolute; width: 109px; z-index: 1000; top: 332px; left: 535px;" */
}
.perid-layer li {
    list-style: none;
    border-style: solid;
    border-color: #e6e6e6;
    width: 155%;  
    margin-left: -60%;
}
.perid-layer ul {
    border-style : solid;
    border-color: #e6e6e6;
    margin: auto;
   /*  width: 95%;
    margin-left: 18%; */
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
					  	  <a href="#" onClick="getUsermenu()" class="Usermenu">
						  	  <img width="30px" src="/dokky/resources/img/profile_img/<c:out value="${userInfo.username}" />" class="memberImage hideUsermenu" onerror="this.src='/dokky/resources/img/basicProfile.png'" />
						  	  <c:out value="${userInfo.member.nickName}"/>    
					  	  </a> 
					  	<%--    <a href="/dokky/mypage/myInfoForm?userId=${userInfo.username}" onmousedown="getUsermenu()">
						  	  <img width="30px" src="/dokky/resources/img/profile_img/<c:out value="${userInfo.username}" />" class="memberImage" onerror="this.src='/dokky/resources/img/basicProfile.png'" />
						  	  <c:out value="${userInfo.member.nickName}"/>
					  	  </a> --%>
					  	  
					  	  <div id="" class="perid-layer">
								<ul class="hideUsermenu"> 
									<li class="hideUsermenu"><a href="#" class="hideUsermenu"><span class="hideUsermenu">게시글보기</span></a></li>
									<li class="hideUsermenu"><a href="#" class="hideUsermenu"><span class="hideUsermenu">쪽지보내기</span></a></li>
								</ul>  
						  </div> 

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
	function getUsermenu() { //메뉴바 보이기 이벤트
		var userMenu = $(".perid-layer"); 
		userMenu.css("display","block"); 
	}
	 
	$('html').click(function(e) { //html안 Usermenu, hideUsermenu클래스를 가지고있는 곳 제외하고 클릭하면 숨김 이벤트발생
		if( !$(e.target).is('.Usermenu, .hideUsermenu') ) {  //("Usermenu") || $(e.target).hasClass("perid-layer")) { 	
		var userMenu = $(".perid-layer"); 
			userMenu.css("display","none"); 
		} 
	});

	
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