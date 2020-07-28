<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"> 
<c:choose>
   	  <c:when test="${pageContext.request.serverName == 'localhost'}">
			<link href="/resources/css/left.css" rel="stylesheet" type="text/css"/>
	  </c:when>  
      <c:otherwise>
    		<link href="/ROOT/resources/css/left.css" rel="stylesheet" type="text/css"/>
      </c:otherwise>
</c:choose>
</head>  
<body>
		<c:set var="random"><%= java.lang.Math.round(java.lang.Math.random() * 123456) %></c:set>
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
					  	  <%-- <img id="leftProfile" src="/resources/img/profile_img/<c:out value="${userInfo.username}"/>.png" class="memberImage leftHideusermenu" onerror="this.src='/resources/img/profile_img/basicProfile.png'" /> --%>
					  	  <c:choose>
						   	  <c:when test="${pageContext.request.serverName == 'localhost'}">
									<img id="leftProfile" src="/resources/img/profile_img/<c:out value="${userInfo.username}"  />.png?${random}" class="memberImage leftHideusermenu" onerror="this.src='/resources/img/profile_img/basicProfile.png'" />
							  </c:when> 
						      <c:otherwise>
						    		<img id="leftProfile" src="/upload/<c:out value="${userInfo.username}"/>.png?${random}" class="memberImage leftHideusermenu" onerror="this.src='/ROOT/resources/img/profile_img/basicProfile.png'" />
						      </c:otherwise>
						  </c:choose>
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
	  
   	  <sec:authorize access="hasAnyRole('ROLE_ADMIN','ROLE_USER','ROLE_STOP')">
	  		<span class="mypage">
		  		<form class="logoutForm" method='post' action="/logout">
				    <input class="logoutBtn" type="submit" value="로그아웃">  
				    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
				</form> 
			</span>
	   </sec:authorize>
	   <sec:authorize access="hasRole('ROLE_SUPER')">
	  		<span class="mypage">
		  		<form class="logoutForm" method='post' action="/customLogout">
				    <input class="logoutBtn" type="submit" value="로그아웃">
				    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
				</form> 
			</span>
	   </sec:authorize>
	   
		  <a href="/board/allList?category=0&order=0">
			<span class="mypage">전체글보기</span>
		  </a>
		  <a href="/board/list?category=1&order=0">
			<span class="mypage">공지사항</span>
		  </a>
		  <a href="/board/list?category=2&order=0">
			<span class="mypage">자유게시판</span>
		  </a>
		  <a href="/board/list?category=3&order=0">
			<span class="mypage">묻고답하기</span>
		  </a>
		  <a href="/board/list?category=4&order=0">
			<span class="mypage">칼럼/Tech</span>
		  </a>
		  <a href="/board/list?category=5&order=0">
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
	
	<div id="deleteFakeDiv"></div>
	<div id="deleteDiv">
			<div id="deleteContent"></div>  
			<input type="button" id="deleteConfirm" value="삭제" /> 
			<input type="button" id="cancelConfirm" value="취소" /> 
	</div>
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	<script>
	
	var webSocket = null; //소켓 객체 전역변수
	
	function connect(){
	
		var serverName = '${pageContext.request.serverName}'; 
		
		if(serverName == 'localhost'){
		
			webSocket = new WebSocket("ws://localhost:8080/websocketHandler");
			//최초 접속이 일반 http request를 통해 handshaking과정을 통해 이루어 진다는 점

		}else{
			
			webSocket = new WebSocket("wss://dokky.ga:443/websocketHandler");
		}
		
		//WebSocket API
		
		webSocket.onopen = function (){ //소켓이 연결됬다면
			
			console.log("WebSocket is connected");
		
			webSocket.onmessage = function(event){//소켓 연결됬는데 메시지가 왔다면
				
				console.log("webSocket message");
				
				if(event.data == 'limitAndLogoutSuccessMessageToUser'){
					 
						openAlert("곧 관리자에 의해 접속 제한(로그아웃) 됩니다");
						
						setTimeout(function() {
							
							var logoutForm = $(".logoutForm");
							
							logoutForm.submit();;
							
						}, 5000); 
						
				}else if(event.data == 'limitAndLogoutSuccessMessageToAdmin'){
					
						openAlert("DB에서 접속 제한 후 사용자를 로그아웃 시켰습니다");
						
				}else if(event.data == 'limitSuccessMessageToAdmin'){
					
						openAlert("DB에서 접속 제한을 하였습니다");//
				}
			}
			
			webSocket.onclose = function(){ //소켓 연결됬는데 소켓이 다시 닫힌다면
				
				console.log("WebSocket is closed");
				
				setTimeout(function() {
					<sec:authorize access="hasAnyRole('ROLE_ADMIN','ROLE_USER','ROLE_SUPER','ROLE_STOP')">
						connect(); //1초마다 다시 재연결
					</sec:authorize>
				}, 1000); 
			}
			
			webSocket.onerror = function(err){//소켓 연결됬는데 에러가 있다면
				
				console.log("webSocket error, "+err);
			}
		}
	}
	
	<sec:authorize access="isAuthenticated()">
		if(webSocket == null){
			connect();
		}
	</sec:authorize>
	
	var username = null;
	var isLimited ; // 쓰기 제한된 계정의 true,false 여부
	
	<sec:authorize access="hasRole('ROLE_STOP')">
			isLimited = true;
	</sec:authorize>
	
	<sec:authorize access="isAuthenticated()"> 
		username = '${userInfo.username}';
	</sec:authorize>
	
	function deleting(content, callback) {  
		
		  deleteAlert(content);
		  
		  $("#deleteConfirm").on("click",function(){
			  closeDelete();
			  callback(); 
		  });
		  
		  $("#cancelConfirm").on("click",function(){
			  closeDelete();
		  });
	}

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
	
	function deleteAlert(content){
		
		$(".userMenubar").css("display","none");
		
		var deleteFakeDiv = $("#deleteFakeDiv");
		var deleteDiv = $("#deleteDiv");
		var deleteContent = $("#deleteContent");
		
		deleteContent.html(content); 
		 
		deleteFakeDiv.css("display","block");
		deleteDiv.css("display","block"); 
	}
	
	function closeDelete(){  
		
		var deleteFakeDiv = $("#deleteFakeDiv");
		var deleteDiv = $("#deleteDiv");
		
		deleteFakeDiv.css("display","none");
		deleteDiv.css("display","none");   
	}  

	function noteOpen(userId,nickname){
			
		$(".userMenubar").css("display","none");
		
		$("#leftUsermenuBar").css("display","none"); 
		
		if(isLimited){ 
	    	  openAlert("쓰기 기능이 제한되어있습니다.");
	    	  return;
	    }
		
		if(username == null){ 
			
			//$("#UserMenubar_board").css("display","block").addClass('addBlockClass');
			openAlert("로그인 해주세요");
			//alert("로그인 해주세요."); 
			
			return;
		}
		
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
		 	setInterval(schedule, 60000);//60초마다 알람,쪽지 카운트 불러오기
		</sec:authorize>
	});
	
	</script>
</body>
</html>