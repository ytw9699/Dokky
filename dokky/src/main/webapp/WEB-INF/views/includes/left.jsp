<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"> 
<link href="/resources/css/left.css" rel="stylesheet" type="text/css"/>
</head>  
<body>
		<sec:authentication property="principal" var="userInfo"/>
		
	<div class="leftWrap">
		
		<a class="name" href="/main">
			<span class="leftTitle">
				Dokky
			</span> 
		</a>
		
	  <sec:authorize access="isAuthenticated()">
		<div class="mypage topMypage">  
					<a href="#" class="leftUsermenu">
					  	  <%-- <img id="leftProfile" src="/display?fileName=<c:out value="${userInfo.username}"/>.png" class="memberImage leftHideusermenu" onerror="this.src='/resources/img/basicProfile.png'"/> --%>
					  	  <img id="leftProfile" src="/resources/img/profile_img/<c:out value="${userInfo.username}"/>.png" class="memberImage leftHideusermenu" onerror="this.src='/resources/img/profile_img/basicProfile.png'" />
					  	  <c:out value="${userInfo.member.nickName}"/>     
			  	    </a> 
			  	    <div id="leftUsermenuBar">
							<ul class="leftHideusermenu"> 
								<li class="leftHideusermenu">
									<a href="/userBoardList?userId=${userInfo.username}" class="leftHideusermenu">
										<span class="leftHideusermenu">게시글보기</span>
									</a>
								</li>
								<li class="leftHideusermenu">
									<a href="#" class="leftHideusermenu" onclick="noteOpen('${userInfo.username}','${userInfo.member.nickName}')">
										<span class="leftHideusermenu">쪽지보내기</span> 
									</a>
								</li>
							</ul> 
				    </div> 
					<!-- <form id="logoutForm" method='post' action="/customLogout"> -->
		</div>
	  </sec:authorize>
		
	  <sec:authorize access="isAnonymous()">  
		  <a href="/socialLogin">
		  	<span class="mypage topMypage">로그인/회원가입</span>
	  	  </a> 
	  	  <!-- <a href="/memberForm">
		  	<span class="mypage">회원가입</span>
	  	  </a> -->
	  </sec:authorize>
	  
   	  <sec:authorize access="hasAnyRole('ROLE_ADMIN','ROLE_USER')">
	  		<span class="mypage">
		  		<form class="logoutForm" method='post' action="/logout">
				    <input class="logoutBtn" type="submit" value="로그아웃">  
				</form> 
			</span>
	   </sec:authorize>
	   <sec:authorize access="hasRole('ROLE_SUPER')">
	  		<span class="mypage">
		  		<form class="logoutForm" method='post' action="/customLogout">
				    <input class="logoutBtn" type="submit" value="로그아웃">
				</form> 
			</span>
	   </sec:authorize>
			
		  <a href="/board/allList?category=0">
			<span class="mypage">전체글보기</span>
		  </a>
		  <a href="/board/list?category=1">
			<span class="mypage">공지사항</span>
		  </a>
		  <a href="/board/list?category=2">
			<span class="mypage">자유게시판</span>
		  </a>
		  <a href="/board/list?category=3">
			<span class="mypage">묻고답하기</span>
		  </a>
		  <a href="/board/list?category=4">
			<span class="mypage">칼럼/Tech</span>
		  </a>
		  <a href="/board/list?category=5">
			<span class="mypage">정기모임/스터디</span>
		  </a>
			
		<sec:authorize access="isAuthenticated()">
			<a href="/alarmList?userId=${userInfo.username}">
				<span class="mypage">
						알림 <span class="alarmCount"></span>
				</span>
			</a>
			<a href="/fromNoteList?userId=${userInfo.username}"> 
				<span class="mypage">
						쪽지 <span class="noteCount"></span>
				</span>
			</a> 
			<a href="/mypage/myInfoForm?userId=${userInfo.username}">
				<span class="mypage">내 정보</span>
			</a>
			
		</sec:authorize>
		
			<a href="/admin/userList">
		    	<span class="mypage">Admin</span>
			</a>
		
		<%-- <sec:authorize access="hasAnyRole('ROLE_ADMIN','ROLE_SUPER')">
			<a href="/admin/userList">
		    	<span class="mypage">Admin</span>
			</a>
		</sec:authorize> --%>
		
		<%-- <sec:authorize access="!hasAnyRole('ROLE_ADMIN','ROLE_SUPER')">
			<a href="/socialLogin">
		    	<span class="mypage">Admin</span>
			</a>
		</sec:authorize> --%>
		
		<sec:authorize access="!hasRole('ROLE_SUPER')">
			<a href="/superAdminLogin">
	    		<span class="mypage">SuperAdmin</span>
			</a>
		</sec:authorize>
    
		<sec:authorize access="hasRole('ROLE_SUPER')">
			<a href="/admin/authorizationList">
	    		<span class="mypage">SuperAdmin</span>
			</a>
		</sec:authorize>
		
		<div class="visitCount">
			<div>
				Today : ${sessionScope.todayCount} 
			</div> 
			<div>  
				Total : ${sessionScope.totalCount}  
			</div> 
		</div>
		
	</div> 
	
	<div id="alertFakeDiv"></div> 
	<div id="alertDiv">
			<div id="alertContent"></div>  
			<input type="button" id="alertConfirm" value="확인" onclick="closeAlert();" /> 
	</div> 
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	<script>
	
	var username = null;
	
	<sec:authorize access="isAuthenticated()"> 
		username = '${userInfo.username}';
	</sec:authorize>

	 
	$(".leftUsermenu").on("click",function(event){//메뉴바 보이기 이벤트 
			 
			event.preventDefault();

			$("#leftUsermenuBar").css("display","block"); 
	});
	 
	$('html').click(function(e) { //html안 Usermenu, leftHideusermenu클래스를 가지고있는 곳 제외하고 클릭하면 숨김 이벤트발생
		
			if( !$(e.target).is('.leftUsermenu, .leftHideusermenu') ) {  
				
				$("#leftUsermenuBar").css("display","none");  	
			} 
	});   
	
	function openAlert(content){
		
		$(".userMenubar").css("display","none");
		
		var alertFakeDiv = $("#alertFakeDiv");
		var alertDiv = $("#alertDiv");
		var alertContent = $("#alertContent");
		
		alertContent.html(content); 
		 
		alertFakeDiv.css("display","block");
		alertDiv.css("display","block"); 
	}
	
	function closeAlert(content){  
		
		var alertFakeDiv = $("#alertFakeDiv");
		var alertDiv = $("#alertDiv");
		
		alertFakeDiv.css("display","none");
		alertDiv.css("display","none"); 
		//alertContent.html(""); 
	}  

	function noteOpen(userId,nickname){
			
		if(username == null){ 
			
			//$("#UserMenubar_board").css("display","block").addClass('addBlockClass');
			openAlert("로그인 해주세요");
			//alert("로그인 해주세요."); 
			
			return;
		}
		
		$(".userMenubar").css("display","none");
		
		var popupX = (window.screen.width / 2) - (400 / 2); 

		var popupY= (window.screen.height /2) - (500 / 2);
	         
        window.open('/minRegNote?userId='+userId+'&nickname='+nickname, 'ot', 'height=500, width=400, screenX='+ popupX + ', screenY= '+ popupY);
    }
	
	function getAlarmRealCount(userId, callback, error) {
		$.ajax({
			type : 'get',
			url : '/alarmRealCount/'+ userId,
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
	 
	function getNoteCount(userId, callback, error) {
		$.ajax({
			type : 'get',
			url : '/noteCount/'+ userId,
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
		var noteCount = $(".noteCount");
		var userId = '${userInfo.username}'; 
	</sec:authorize>
	
	function schedule(){
	    getAlarmRealCount(userId, function(result){
	    	alarmCount.html(result);
	 	 });
	    
	    getNoteCount(userId, function(result){
	    	noteCount.html(result);
	 	 });
	} 
	
	$(document).ready(function() {
		<sec:authorize access="isAuthenticated()">  
			schedule();
		 	setInterval(schedule, 60000);//60초마다 알람카운트 불러오기
		</sec:authorize>
		
		 var parameterName = '${_csrf.parameterName}';
		 var token = '${_csrf.token}';
		 var logoutForm = $(".logoutForm");
		  
		  $(".logoutBtn").on("click", function(e){
			  
			  var str = "<input type='hidden' name='"+parameterName+"' value='"+token+"'>";
			  
			  logoutForm.append(str).submit();
			  
		  }); 
	});
	
	</script>
</body>
</html>