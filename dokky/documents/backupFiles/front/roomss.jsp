<%-- <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ include file="../includes/common.jsp"%>

<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>채팅 서비스</title>
    <!-- Bootstrap core CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">

    <!-- 부가적인 테마 -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">

    <!-- 합쳐지고 최소화된 최신 자바스크립트 -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
	<c:choose>
		   	  <c:when test="${pageContext.request.serverName == 'localhost'}">
				 <link href="/resources/css/room.css" rel="stylesheet" type="text/css"/>
			  </c:when>
	          <c:otherwise>
	        	<link href="/ROOT/resources/css/room.css" rel="stylesheet" type="text/css"/>
	          </c:otherwise>
       </c:choose>
</head>
<body>
	<div class = "bodyWrap">
		<input type="text" id="nickname" class="form-inline" placeholder="닉네임을 입력해주세요" required autofocus>
		<button class = "btn btn-primary" id ="name">확인</button>
		<label for="roomId" class="label label-default">방 번호</label>
		<label th:text="*{room.roomId}" id="roomId" class="form-inline"></label>
		<br>
		<label for="roomName" class="label label-default">방 이름</label>
		<label th:text="*{room.name}" id="roomName" class="form-inline"></label>
		<div id = "chatroom" style = "overflow:auto; width:400px;  height: 600px; border:1px solid; background-color : gray"></div>
		<input type = "text" id = "message" style = "height : 30px; width : 340px" placeholder="내용을 입력하세요" autofocus>
		<button class = "btn btn-primary" id = "send">전송</button>
	</div>
</body>
<script th:inline = "javascript">

    var webSocketChat;
    var nickname;
    /* <![CDATA[*/
    var roomId = '${room.roomId}';
    /*[[${room.roomId}]]*/
    /* ]]> */
    document.getElementById("name").addEventListener("click",function(){
        nickname = document.getElementById("nickname").value;
        
        //document.getElementById("nickname").style.display = "none";
        //document.getElementById("name").style.display = "none";
        connect();
    })
    document.getElementById("send").addEventListener("click",function(){
        send();
    })
    
    
    function connect(){
		
		var serverName = '${pageContext.request.serverName}'; 
		
		if(serverName == 'localhost'){
			
			webSocketChat = new WebSocket("ws://localhost:8080/chatWebsocketHandler");
			
		}else{
			webSocketChat = new WebSocket("wss://dokky.ga:443/chatWebsocketHandler");
		}
		
		
		webSocketChat.onopen = function (){ //소켓이 연결됬다면
			
			console.log("chatWebsocket is connected");
		
			webSocketChat.send(JSON.stringify({chatRoomId : roomId, type:'ENTER', writer:nickname}));
		
			
			webSocketChat.onmessage = function(event){//소켓 연결됬는데 메시지가 왔다면
				
				console.log("chatWebsocket message");
			
				data = event.data;
		        chatroom = document.getElementById("chatroom");
		        chatroom.innerHTML = chatroom.innerHTML + "<br>" + data;
				
			}
			
			webSocketChat.onclose = function(){ //소켓 연결됬는데 소켓이 다시 닫힌다면
				
				closed();
			}
			
			webSocketChat.onerror = function(err){//소켓 연결됬는데 에러가 있다면
				
				console.log("chatWebsocket error, "+err);
			}
		}
	}
    
	function send(){
		
		if(webSocketChat != null){
			
			console.log("chatWebsocket is send");
			
	        msg = document.getElementById("message").value;
	        webSocketChat.send(JSON.stringify({chatRoomId : roomId, type:'CHAT', writer:nickname, message : msg}));
	        document.getElementById("message").value = "";
		
		}else{
			
			console.log("chatWebsocket is null");
		}
    }
	
	function closed(){
		
		console.log("chatWebsocket is closed");
		
		webSocketChat.send(JSON.stringify({chatRoomId : roomId, type:'LEAVE', writer:nickname}));
		
	    webSocketChat.close();
	    
	    webSocketChat = null;
	}
	
	window.onbeforeunload = function() {
		if(webSocketChat != null){
			
			closed();
		
		}
	}
    
   /*  function connect(){
    	
        webSocket = new WebSocket("ws://localhost:8080/websocketHandler");
        webSocket.onopen = onOpen;
        webSocket.onclose = onClose;
        webSocket.onmessage = onMessage;
    }
   
    function onOpen(){
    	
    	console.log("WebSocket is connected");
    	
        webSocket.send(JSON.stringify({chatRoomId : roomId, type:'ENTER', writer:nickname}));
    }
    
 	function send(){
    	
    	console.log("WebSocket is send");
    	
        msg = document.getElementById("message").value;
        webSocket.send(JSON.stringify({chatRoomId : roomId, type:'CHAT', writer:nickname, message : msg}));
        document.getElementById("message").value = "";
    }
 	
 	function onMessage(e){
     	
         data = e.data;
         chatroom = document.getElementById("chatroom");
         chatroom.innerHTML = chatroom.innerHTML + "<br>" + data;
     }
   
    function onClose(){
    	
    	console.log("WebSocket is closed");
    	
    	webSocket.send(JSON.stringify({chatRoomId : roomId, type:'LEAVE', writer:nickname}));
    	
        webSocket.close();
    } */

</script>
</html> --%>