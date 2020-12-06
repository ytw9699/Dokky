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
			 <c:choose>
			   	  <c:when test="${chat_type == 0}"> <!-- 1:1채팅방이라면 -->
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
							<div class="outChatRoom">
								<button id="leave">방 나가기 </button>
							</div>
					  </div>
				  </c:when> 
			      <c:when test="${chat_type == 1}"> <!-- 멀티채티방이라면 -->
			        	<div id="innerTitleWrap">
			        		<div class="innerTitle">
			        			멀티채팅방
							</div> 
							<div class="innerTitle">
								멀티채팅방
							</div> 
							<div class="outChatRoom">
								<button id="leave">방 나가기 </button>
							</div>
			  			</div>
				  </c:when>
			</c:choose>
			<div class="test">
				<button id="test">채팅 웹소켓 연결 끊기 </button>
			</div>
		</div>
		<div id="chatContents">
						<script>
							var contentRegDate;
	 						var saveDate;
	 					</script>
	 					
			<c:forEach items="${chatContents}" var="content">
			
			 			 <script>
				 			 	contentRegDate = '${content.regDate}'.substring(0,10);
				 			 	
				 			 	if(saveDate != contentRegDate){
				 			 		inputValue = true;
				 			 	}
				 			 	
				             	if(inputValue){
				             		document.write("<div class='chat_wrap todayDate'>"+"------------- "+'<fmt:formatDate value="${content.regDate}" pattern="yyyy년 MM월 dd일 E요일"/>'+" -------------"+"</div>");
				             		saveDate = contentRegDate;
				             		inputValue = false;
				             	}
			             </script>
			             
				<c:choose>
					  <c:when test="${content.content_type == 1}"> <!-- 공지내용 -->
				   	  	 <div class="chat_wrap notice">
			   	  	 		<span class="chat_notice_content">
				   	  	 		${content.chat_content}
				   	  	 	</span>
			             </div>
					  </c:when>
				   	  <c:when test="${content.chat_writerId == userInfo.username}"> <!-- 내가 쓴 채팅 내용 -->
				   	  	 <div class="chat_wrap myChat">
				   	  	 	<span id="${content.chatContentNum}" class="chat_readCount" data-content_num="${content.chatContentNum}">
				   	  	 		<c:if test="${content.readCount != 0}">
				   	  	 			${content.readCount}
				   	  	 		</c:if>
				   	  	 	</span>
				   	  	 	<span class="chat_time">
				   	  	 		<fmt:formatDate value="${content.regDate}" pattern="a HH:mm"/>
				   	  	 	</span>
				   	  	 	<span class="chat_content" data-content_num="${content.chatContentNum}" data-read_type="${content.read_type}"> 
				   	  	 		${content.chat_content}
				   	  	 	</span>
			             </div>
					  </c:when>
				      <c:otherwise><!--  타인이 쓴 채팅 내용 -->
				      	<div class="chat_wrap">
				      		<span class="chat_profile">
									<c:choose>
									   	  <c:when test="${pageContext.request.serverName == 'localhost'}"> 
											 	<img src="/resources/img/profile_img/<c:out value="${chatMember.chat_memberId}"/>.png?${random}" class="memberImage" onerror="this.src='/resources/img/profile_img/basicProfile.png'"/>
										  </c:when> 
									      <c:otherwise> 
									    		<img src="/upload/<c:out value="${chatMember.chat_memberId}"/>.png?${random}" class="memberImage" onerror="this.src='/ROOT/resources/img/profile_img/basicProfile.png'" />
									      </c:otherwise>
									</c:choose>
							</span>
				      		<span class="chat_nick">
				   	  	 		${content.chat_writerNick} 
				   	  	 	</span>
				      		<span class="chat_content" data-content_num="${content.chatContentNum}" data-read_type="${content.read_type}">
				   	  	 		${content.chat_content}
				   	  	 	</span>
				   	  	 	<span class="chat_time">
				   	  	 		<fmt:formatDate value="${content.regDate}" pattern="a HH:mm"/>
				   	  	 	</span>
				   	  	 	<span id="${content.chatContentNum}" class="chat_readCount" data-content_num="${content.chatContentNum}"> 
				   	  	 		<c:if test="${content.readCount != 0}">
				   	  	 			${content.readCount}
				   	  	 		</c:if>
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
	
	<div id="alertFakeDiv"></div> 
	<div id="alertDiv">
			<div id="alertContent"></div>  
			<input type="button" id="alertConfirm" value="확인" onclick="closeAlert();" /> 
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
	 	var inputValue = true;
	 	var chatroom;
	 	var serverName = '${pageContext.request.serverName}';
	 	var random = Math.random();
	 	
		$(document).ajaxSend(function(e, xhr, options) {
			
		     xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
	    });
		
		<sec:authorize access="isAuthenticated()">   
			  var myId = '${userInfo.username}';  
			  var myNickName = '${userInfo.member.nickName}';
		</sec:authorize>
		
		$(document).ready(function() {
			connect();
		});
		
		function connect(){
			
			window.scrollTo(0, $(document).height());
			
			var serverName = '${pageContext.request.serverName}'; 
			
			if(serverName == 'localhost'){
				
				webSocketChat = new WebSocket("ws://localhost:8080/chatWebsocketHandler");
				
			}else{
				
				webSocketChat = new WebSocket("wss://dokky.site:443/chatWebsocketHandler");
			}
			
			webSocketChat.onopen = function(){ //웹소켓이 연결됬다면
				
				console.log("chatWebsocket connected"); 
			
				webSocketChat.send(JSON.stringify({chatRoomNum : chatRoomNum, type:'OPEN'}));//채팅방 열기
				
				focusFunction();//처음에 방에 입장시, 꼭 채팅방 열기 메시지를 보낸후에(위 한줄 로직), 읽지 않은 메시지들이 있다면 읽어주는 처리를 한번해야한다.
				
				webSocketChat.onmessage = function(event){//웹소켓이 연결됬는데 메시지가 왔다면
					
					console.log("webSocketChat.onmessage");
					
					console.log(event.data);
				
					chatroom = document.getElementById('chatContents');
					
					var obj = JSON.parse(event.data);
					
					var isBottom;
					
					if($(window).scrollTop() + $(window).height() == $(document).height()){//스크롤이 맨 하단에서 감지되는지 여부 저장
						isBottom = true;
				    }
					
					if(obj.type == 'CHAT'){
						 
						 var regDate = parseInt(obj.regDate);
						 
						 var time = commonService.displayReplyTime(regDate);
						 
						 var getMessgae = obj.message;
						 
						 divideDate(regDate);//채팅 내용 사이에 날짜 구분해주기
						 
						 if(position == "in"){//사용자가 채팅방에 머무른다면
							 	
								 if(obj.chat_writerId == myId){
									 
									    chatroom.innerHTML += "<div class='chat_wrap myChat'>"
															        	+"<span id="+obj.chatContentNum+" class='chat_readCount' data-content_num="+obj.chatContentNum+">" 
																			+ obj.headCount 
																		+"</span>"
				        												+"<span class='chat_time'>" 
				        													+ time 
				        												+"</span>"
				     													+"<span class='chat_content' data-content_num="+obj.chatContentNum+" data-read_type="+1+">" 
				     														+ getMessgae 
				     													+ "</span>"
		     												+ "</div>";
						         }else{
						             
						        	 	chatroom.innerHTML += "<div class='chat_wrap'>"
														        	 	+"<span class='chat_profile'>";
														        	 	if(serverName == 'localhost'){ 
														        	 		   chatroom.innerHTML += "<img src='/resources/img/profile_img/"+obj.chat_writerId+".png?"+random+"' class='memberImage hideUsermenu' onerror='this.src=\"/resources/img/profile_img/basicProfile.png\"'/>&nbsp"
																					   
																		}else{
																			   chatroom.innerHTML += "<img src='/upload/"+obj.chat_writerId+".png?"+random+"' class='memberImage hideUsermenu' onerror='this.src=\"/ROOT/resources/img/profile_img/basicProfile.png\"'/>&nbsp"
																		}
																	    chatroom.innerHTML += "</span>"				        	 	
											        	 				+"<span class='chat_nick'>"
																	    	+ obj.chat_writerNick 
																		+ "</span>"
			        	 												+"<span class='chat_content' data-content_num="+obj.chatContentNum+" data-read_type="+1+">"
			        	 											    	+ getMessgae 
			        	 												+ "</span>"
			        	 												+ "<span class='chat_time'>"
			        	 													+ time 
			        	 												+ "</span>"
			        	 												+"<span id="+obj.chatContentNum+" class='chat_readCount' data-content_num="+obj.chatContentNum+">" 
																			+ obj.headCount 
																		+"</span>"
	        	 											 + "</div>";
						         }
								 
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
						 }else{//사용자가 채팅방에 머무르지 않는다면
							 
								 if(obj.chat_writerId == myId){
									 
					 					chatroom.innerHTML += "<div class='chat_wrap myChat'>"
				        												+"<span id="+obj.chatContentNum+" class='chat_readCount' data-content_num="+obj.chatContentNum+">"
																			+ obj.headCount 
																		+"</span>"
				        												+"<span class='chat_time'>" 
				        													+ time 
				        												+"</span>"
				     													+"<span class='chat_content' data-content_num="+obj.chatContentNum+" data-read_type="+0+">"
				     														+ getMessgae 
				     													+ "</span>"
			     												+ "</div>";
		        				 }else{
			 
							        	 chatroom.innerHTML += "<div class='chat_wrap'>"
														        	 	+"<span class='chat_profile'>";
														        	 	if(serverName == 'localhost'){ 
														        	 		   chatroom.innerHTML += "<img src='/resources/img/profile_img/"+obj.chat_writerId+".png?"+random+"' class='memberImage hideUsermenu' onerror='this.src=\"/resources/img/profile_img/basicProfile.png\"'/>&nbsp"
																					   
																		}else{
																			   chatroom.innerHTML += "<img src='/upload/"+obj.chat_writerId+".png?"+random+"' class='memberImage hideUsermenu' onerror='this.src=\"/ROOT/resources/img/profile_img/basicProfile.png\"'/>&nbsp"
																		}
																	    chatroom.innerHTML += "</span>"	
														        	 	+"<span class='chat_nick'>"
																	    	+ obj.chat_writerNick 
																		+ "</span>"
																		+"<span class='chat_content' data-content_num="+obj.chatContentNum+" data-read_type="+0+">"
																	    	+ getMessgae 
																		+ "</span>"
																		+ "<span class='chat_time'>"
																			+ time 
																		+ "</span>"
																		+"<span id="+obj.chatContentNum+" class='chat_readCount' data-content_num="+obj.chatContentNum+">" 
																		+ obj.headCount 
																		+"</span>"
																+ "</div>";
						         }
						 }
			             
					}else if(obj.type == 'LEAVE'){
						
						 var regDate = parseInt(obj.regDate);
						
						 divideDate(regDate);//채팅 내용 사이에 날짜 구분해주기
						 
						 var getMessgae = obj.message;
						 
						 chatroom.innerHTML = chatroom.innerHTML + "<div class='chat_wrap notice'>"
						 											+ "<span class='chat_notice_content'>"
																		 + getMessgae
																 	+ "</span>"
						 										 + "</div>";
						 headCount = headCount-1;
						 
						 if(obj.chat_writerId == myId){
							 closed();	 
							 window.close();
						 }
						 
					}else if(obj.type == 'READ'){
						
						 var chatContentNum = obj.chatContentNum;
						 
						 var chatContent = $("#"+chatContentNum);
						 
						 if(chatContent.html() == 1){
							 
							 chatContent.html("");
							 
						 }else{
							 chatContent.html(chatContent.html()-1);
						 }
						 
					}else if(obj.type == 'IN'){
						
						 var regDate = parseInt(obj.regDate);
						
						 divideDate(regDate);
						 
						 var getMessgae = obj.message;
						 
						 chatroom.innerHTML = chatroom.innerHTML + "<div class='chat_wrap notice'>"
						 											+ "<span class='chat_notice_content'>"
																		 + getMessgae
																 	+ "</span>"
						 										 + "</div>";
						 headCount = headCount+1;
					}
					
					if(isBottom == true){//스크롤이 맨 하단에서 감지된다면
						window.scrollTo(0, $(document).height());//스크롤 맨아래로 내리기
				    }
				}
				
				webSocketChat.onclose = function(){//연결된 소켓이 닫혔다면
					
					webSocketChat = null;
				
					openAlert("채팅연결이 끊겼습니다");
					console.log("webSocketChat closed");
					
					setTimeout(function() {
						<sec:authorize access="hasAnyRole('ROLE_ADMIN','ROLE_USER','ROLE_SUPER','ROLE_STOP')">
							connect(); //0.1초후 다시 재연결
						</sec:authorize>
					}, 100); 
				}
				
				webSocketChat.onerror = function(err){
					
					console.log("chatWebsocket error, "+err);
				}
				
			}	
		}
		
		function send(chatRoomNum, messageVal){
			
			if(webSocketChat != null){
				
				console.log("chatWebsocket send");
				
				console.log("headCount="+headCount);
				
		        webSocketChat.send(JSON.stringify({chatRoomNum : chatRoomNum, type:'CHAT', message : messageVal, chat_writerId:myId , chat_writerNick: myNickName , headCount:headCount}));
		        
		        message.val("");
		        
		        setTimeout(function() {
		        	window.scrollTo(0, $(document).height());//스크롤 맨아래로
	        	}, 50);
		        
		    	setTimeout(function(){ //시간 차이 때문에 조금 늦게 보내야 채팅 카운트 알림이 보내진다.
		    		
		    		var chat_memberId="${chatMember.chat_memberId}";
			    	
			    	var chat_type = "${chat_type}";
			    	
		    		if(opener.webSocket != null){//상대방 채팅 카운트 업데이트 시키기
				        	
				        	if(chat_type == 0){//1:1채팅방이라면
				        		
				        		opener.webSocket.send("chatAlarm,"+chat_memberId);
				        	
				        	}else if(chat_type == 1){//멀티채팅방이라면
				        		
				        	}
					}
		    		
	        	}, 100);

			}else{
				
				openAlert("채팅연결이 끊겼습니다");
				
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
			
			messageVal = $.trim(messageVal);
			
			if(messageVal == ""){ 
				openAlert("내용을 입력하세요"); 
				   return false;
			}
		
			send(chatRoomNum, messageVal);
			
		});
		
		
		$("#leave").on("click", function(event){//방 나가기
			
			leave();
			webSocketChat = null;
			window.close();
		});
		
		$("#test").on("click", function(event){
			webSocketChat.close();
		});
		
		window.onblur = blurFunction;//채팅방을 벗어날때
		window.onfocus = focusFunction;//채팅방에 다시올때
		
		function blurFunction(){ 
			
			position = "out";
		}
		
		function focusFunction(){ 
			
			console.log("focusFunction");
			
			position = "in";
			
			var chat_content = $(".chat_content");
			
			for(var i = 0; i < chat_content.length; i++){
				
				var content_object = $(chat_content[i]);
				
				if(content_object.data("read_type") == 0){
						
						var chatReadData = {  
								    chat_memberId    : myId,
								    chatContentNum   : content_object.data("content_num")
				 				  };
					 
						readChat(chatReadData,
								 
									function(result, status){
									
										if(status == "success"){
											
											if(result == "0"){//읽지 않았는데 , 디비에서 읽음 처리를 했을때
												
												content_object.replaceWith("<span class='chat_content' data-content_num="+content_object.data("content_num")+" data-read_type="+1+">"+content_object.html()+"</span>");
												
												if(webSocketChat != null){
													
													webSocketChat.send(JSON.stringify({chatRoomNum : chatRoomNum, type:'READ', chatContentNum : content_object.data("content_num")}));
												}
												
											}else if(result == "1"){//이미 디비에서 읽음 처리가 되었을때
												
												content_object.replaceWith("<span class='chat_content' data-content_num="+content_object.data("content_num")+" data-read_type="+1+">"+content_object.html()+"</span>");
											}
										}
							    	},
							    
							    	function(status){
							    	
										if(status == "error"){
											
											openAlert("Server Error(관리자에게 문의해주세요)");
										}
							    	}
						);
				}
	        }
			
			if(opener.webSocket != null){
				opener.webSocket.send("chatAlarm,"+myId);
			}
		}
		
		function readChat(chatReadData, callback, error) {
			
			$.ajax({
				type : 'post', 
				url : '/readChat', 
				async: false,
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
		
		function openAlert(content){
			
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
		}  
		
		function getTodayLabel(date) {
		    
		    var week = new Array('일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일');
		    
		    var today = date.getDay();
		    var todayLabel = week[today];
		    
		    return todayLabel;
		}
		
		function divideDate(regDate) {
			
			var currentChatDate = new Date(regDate)
				
			var substringDate = currentChatDate.toString().substring(0,10);
			 
			if(saveDate != substringDate){
				 
				chatroom.innerHTML = chatroom.innerHTML + "<div class='chat_wrap todayDate'>" + 
				
				currentChatDate.getFullYear()+"년 "+(currentChatDate.getMonth()+1)+"월 " + currentChatDate.getDate()+"일 " +getTodayLabel(currentChatDate) + "</div>";
				
				saveDate = substringDate;
			}
		}
		
</script>

</html>