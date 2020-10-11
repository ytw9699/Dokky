<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<sec:authentication property="principal" var="userInfo"/>
<c:set var="random"><%= java.lang.Math.round(java.lang.Math.random() * 123456) %></c:set>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dokky - 채팅방</title>
	<c:choose>
   	  <c:when test="${pageContext.request.serverName == 'localhost'}">
			<link href="/resources/css/chatRoom.css" rel="stylesheet" type="text/css">
			<script type="text/javascript" src="/resources/js/common.js"></script>
	  </c:when>
      <c:otherwise>
    		<link href="/ROOT/resources/css/chatRoom.css" rel="stylesheet" type="text/css">
    		<script type="text/javascript" src="/ROOT/resources/js/common.js"></script>
      </c:otherwise>
	</c:choose>
</head>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

<body>
	<div class="bodyWrap">
		<div id="chatTitle">
		  <div id="innerTitleWrap">
				<div class="innerTitle">
						<c:choose>
						   	  <c:when test="${pageContext.request.serverName == 'localhost'}"> 
								 	<img src="/resources/img/profile_img/<c:out value="${chatMember.chat_memberId}"/>.png?${random}" class="memberImage" onerror="this.src='/resources/img/profile_img/basicProfile.png'"/>
							  </c:when> 
						      <c:otherwise> 
						    		<img src="/upload/<c:out value="${chatMember.chat_memberId}"/>.png?${random}" class="memberImage" onerror="this.src='/ROOT/resources/img/profile_img/basicProfile.png'" />
						      </c:otherwise>
						</c:choose>
				</div>
				<div class="innerTitle">
					<c:out value="${chatMember.chat_memberNick}" />
				</div> 
				<div class="innerTitle">
					<button id="leave">방 나가기 </button>
				</div>
		  </div>	
		</div>
		<div id="chatContents">
			<c:forEach items="${chatContents}" var="content">
				<c:choose>
					  <c:when test="${content.content_type == 1}"> <!-- 공지내용 -->
				   	  	 <div class="chat_wrap notice">
			   	  	 		<span class="chat_content">
				   	  	 		${content.chat_content}
				   	  	 	</span>
			             </div>
					  </c:when>
				   	  <c:when test="${content.chat_writerId == userInfo.username}"> <!-- 내가 쓴 채팅 내용 -->
				   	  	 <div class="chat_wrap myChat">
				   	  	 	<span class="chat_readCount" data-content_num="${content.chatContentNum}"> 
				   	  	 		${content.readCount}
				   	  	 	</span>
				   	  	 	<span class="chat_time">
				   	  	 		<fmt:formatDate value="${content.regDate}" pattern="yyyy-MM-dd HH:mm"/>
				   	  	 	</span>
				   	  	 	<span class="chat_content">
				   	  	 		${content.chat_content}
				   	  	 	</span>
			             </div>
					  </c:when>
				      <c:otherwise><!--  타인이 쓴 채팅 내용 -->
				      	<div class="chat_wrap">
				      		<span class="chat_content">
				   	  	 		${content.chat_writerNick} ${content.chat_content}
				   	  	 	</span>
				   	  	 	<span class="chat_time">
				   	  	 		<fmt:formatDate value="${content.regDate}" pattern="yyyy-MM-dd HH:mm" />
				   	  	 	</span>
				   	  	 	<span class="chat_readCount" data-content_num="${content.chatContentNum}"> 
				   	  	 		${content.readCount}
				   	  	 	</span>
			             </div>
				      </c:otherwise>
				</c:choose>
		    </c:forEach>
		</div>
		<div id="messageWrap">
				<span id="messgaeInputWrap">
					<textarea id="message" rows="3" placeholder="내용을 입력하세요" autofocus></textarea>
				</span>	
				<span id="sendBtnWrap">
					<button id="sendMessageBtn">전송</button>
				</span>
		</div>
	</div>
</body>

<script>

		var webSocketChat;
		var message;
		var chatRoomNum = '${chatRoomNum}';
		var csrfHeaderName ="${_csrf.headerName}"; 
		var csrfTokenValue="${_csrf.token}";
		var headCount = "${headCount}";
		var position = "in";
		
		$(document).ajaxSend(function(e, xhr, options) {
			
		     xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
	    });
		
		<sec:authorize access="isAuthenticated()">   
			  myId = '${userInfo.username}';  
			  myNickName = '${userInfo.member.nickName}';
		</sec:authorize>
		
		$(document).ready(function() {
			
        	window.scrollTo(0, $(document).height());
			
			var serverName = '${pageContext.request.serverName}'; 
			
			if(serverName == 'localhost'){
				
				webSocketChat = new WebSocket("ws://localhost:8080/chatWebsocketHandler");
				
			}else{
				
				webSocketChat = new WebSocket("wss://dokky.ga:443/chatWebsocketHandler");
			}
			
			webSocketChat.onopen = function(){ //웹소켓이 연결됬다면
				
				console.log("chatWebsocket connected");
				
				webSocketChat.send(JSON.stringify({chatRoomNum : chatRoomNum, type:'OPEN'}));//채팅방 열기
				
				webSocketChat.onmessage = function(event){//웹소켓이 연결됬는데 메시지가 왔다면
					
					console.log(event.data);
				
					var chatroom = document.getElementById('chatContents');
					
					var obj = JSON.parse(event.data);
					
					var isBottom;
					
					if($(window).scrollTop() + $(window).height() == $(document).height()){//스크롤이 맨 하단에서 감지되는지 여부 저장
						isBottom = true;
				    }
					
					if(obj.type == 'CHAT'){
						 
						 var regDate = parseInt(obj.regDate);
						 
						 var time = commonService.displayReplyTime(regDate);
						 
						 var getMessgae = obj.message;
						 
						 
						 if(obj.chat_writerId == myId){
							 
					        	chatroom.innerHTML = chatroom.innerHTML + "<div class='chat_wrap myChat'>"
																        	+"<span id="+obj.chatContentNum+" class='chat_readCount'>" 
																				+ obj.headCount 
																			+"</span>"
					        												+"<span class='chat_time'>" 
					        													+ time 
					        												+"</span>"
					     													+"<span class='chat_content'>"
					     														+ getMessgae 
					     													+ "</span>"
					     												+ "</div>";
				         }else{
				        	 chatContentNum
				             
				        	 	chatroom.innerHTML = chatroom.innerHTML + "<div class='chat_wrap'>"
				        	 												+ "<span class='chat_content'>" 
				        	 											    	+ obj.chat_writerNick +" "+ getMessgae 
				        	 												+ "<span>"
				        	 												+ "<span class='chat_time'>"
				        	 													+ time 
				        	 												+ "</span>"
				        	 												+"<span id="+obj.chatContentNum+" class='chat_readCount'>" 
																				+ obj.headCount 
																			+"</span>"
				        	 											+ "</div>";
				         }
						 
						 if(position == "in"){//사용자가 채팅방에 머무른다면
							 
							 var chatReadData = {  
									    chat_memberId    : myId,
									    chatContentNum   : obj.chatContentNum
					 				  };
						 
							 readChat(chatReadData, 
									 
										function(result, status){
										
											if(status == "success"){
												
												webSocketChat.send(JSON.stringify({chatRoomNum : chatRoomNum, type:'READ', chatContentNum : obj.chatContentNum}));
											}
								    	},
								    
								    	function(status){
								    	
											if(status == "error"){ 
												
												openAlert("Server Error(관리자에게 문의해주세요)");
											}
								    	}
								 );
						 }
			             
					}else if(obj.type == 'LEAVE'){
						
						 var getMessgae = obj.message;
						 
						 chatroom.innerHTML = chatroom.innerHTML + "<div class='chat_wrap notice'>"
						 											+ "<span class='chat_content'>"
																		 + getMessgae
																 	+ "</span>"
						 										 + "</div>";
						 										 
					}else if(obj.type == 'READ'){
						
						 var chatContentNum = obj.chatContentNum;
						 
						 var chatContent = $("#"+chatContentNum);
						 
						 chatContent.html(chatContent.html()-1);
					}
					
					if(isBottom == true){//스크롤이 맨 하단에서 감지된다면
						window.scrollTo(0, $(document).height());//스크롤 맨아래로 내리기
				    }
				}
				
				webSocketChat.onclose = function(){
					
					closed();
				}
				
				webSocketChat.onerror = function(err){
					
					console.log("chatWebsocket error, "+err);
				}
			}
			
		});
		
		function send(chatRoomNum, messageVal){
			
			if(webSocketChat != null){
				
				console.log("chatWebsocket send");
				
		        webSocketChat.send(JSON.stringify({chatRoomNum : chatRoomNum, type:'CHAT', message : messageVal, chat_writerId:myId , chat_writerNick: myNickName , headCount:headCount}));
		        
		        message.val("");
		        
		        setTimeout(function() {
		        	window.scrollTo(0, $(document).height());//스크롤 맨아래로
	        	}, 50);

			}else{
				
				console.log("chatWebsocket null");
			}
	    }
		
		function closed(){//방 닫기
			
			console.log("chatWebsocket closed");
			
			webSocketChat.send(JSON.stringify({chatRoomNum : chatRoomNum, type:'CLOSED'}));
			
		    webSocketChat.close();
		    
		    webSocketChat = null;
		}
		
		function leave(){//방 나가기
			
			console.log("chatWebsocket leave");
			
			webSocketChat.send(JSON.stringify({chatRoomNum : chatRoomNum, type : 'LEAVE', chat_writerId : myId , chat_writerNick: myNickName }));
		    
		}
		
		window.onbeforeunload = function() {//브라우저 종료 및 닫기 감지
			
			if(webSocketChat != null){
				closed();
			}
		}
		
		$("#sendMessageBtn").on("click", function(event){//메시지 보내기
			
			message = $("#message");
		
			var messageVal = message.val();
		
			send(chatRoomNum, messageVal);
			
		});
		
		$("#leave").on("click", function(event){//방 나가기
			
			leave();
			webSocketChat = null;
			window.close();
		});
		
		window.onblur = blurFunction;//채팅방을 벗어날때
		window.onfocus = focusFunction;//채팅방에 다시올때
		
		function blurFunction(){ 
			
			position = "out";
		}
		
		function focusFunction(){ 
			
			position = "in";
		}
		
		function readChat(chatReadData, callback, error) {
			
			$.ajax({
				type : 'post', 
				url : '/readChat',  
				data : JSON.stringify(chatReadData), 
				contentType : "application/json; charset=utf-8",
				success : function(result, status, xhr) {
					if (callback) {
						callback(result, status);
					}
				},
				error : function(xhr, status, er) {
					if (error) {
						error(status);
					}
				}
			});
		}
		
</script>

</html>