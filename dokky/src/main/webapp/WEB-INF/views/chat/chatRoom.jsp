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
							<div class="allMemberImage">
									<c:choose>
									   	  <c:when test="${pageContext.request.serverName == 'localhost'}"> 
											 	<img src="/resources/img/profile_img/<c:out value="${chatMember.chat_memberId}"/>.png?${random}" class="singleMemberImage" onerror="this.src='/resources/img/profile_img/basicProfile.png'"/>
										  </c:when> 
									      <c:otherwise> 
									    		<img src="/upload/<c:out value="${chatMember.chat_memberId}"/>.png?${random}" class="singleMemberImage" onerror="this.src='/ROOT/resources/img/profile_img/basicProfile.png'" />
									      </c:otherwise>
									</c:choose>
							</div>
							<div class="innerTitle">
								<c:out value="${chatMember.chat_memberNick}" />
							</div> 
							<div class="chatRoomMenu">
								<a href="#" class="chatMenuBtn"> 
									··· 
								</a>
								<div class="chatMenuBar hideclass">
									<div class="chatMenu hideclass"> 초대</div>
									<div class="chatMenu hideclass" id="leave"> 나가기</div>
							    </div> 
							</div>
					  </div>
				  </c:when> 
			      <c:when test="${chat_type == 1}"> <!-- 멀티채팅방이라면 -->
			        	<div id="innerTitleWrap">
			        		<div class="allMemberImage">
										<c:choose>
										   	  <c:when test="${pageContext.request.serverName == 'localhost'}"> 
												 	<c:forEach items="${chatMembers}" var="member" begin="0" end="3"> 
															<img src="/resources/img/profile_img/<c:out value="${member.chat_memberId}"/>.png?${random}" class="multiMemberImage" onerror="this.src='/resources/img/profile_img/basicProfile.png'"/>
													</c:forEach>
											  </c:when> 
										      <c:otherwise> 
										      		<c:forEach items="${chatMembers}" var="member" begin="0" end="3">
														<img src="/upload/<c:out value="${member.chat_memberId}"/>.png?${random}" class="multiMemberImage" onerror="this.src='/ROOT/resources/img/profile_img/basicProfile.png'" />
													</c:forEach>
										      </c:otherwise>
										</c:choose>
							</div>
			        		<div class="innerTitle" onclick="openEdit();">
			        			<c:if test="${chatTitleInfo.chat_title == null}">
			        				<c:forEach items="${chatMembers}" var="member" varStatus="status">
										<c:if test="${!status.last}">
											${member.chat_memberNick}, 
										</c:if> 
										<c:if test="${status.last}">
											${member.chat_memberNick}
										</c:if>  
								 	</c:forEach>
			        			</c:if>
			        			<c:if test="${chatTitleInfo.chat_title != null}">
			        				${chatTitleInfo.chat_title}
			        			</c:if>
							</div> 
							<div class="memberCount">
							 	(${headCount})
							</div>
							<div class="chatRoomMenu">
								<a href="#" class="chatMenuBtn"> 
									··· 
								</a>
								<div class="chatMenuBar hideclass">
									<div class="chatMenu hideclass"> 초대</div>
									<div class="chatMenu hideclass" id="leave"> 나가기</div>
							    </div> 
							</div>
			  			</div>
				  </c:when>
			</c:choose>
			<!-- <div class="test">
				<button id="test">재연결</button>
			</div> -->
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
				   	  	 	<div id="${content.chatContentNum}" class="chat_readCount" data-content_num="${content.chatContentNum}">
				   	  	 		<c:if test="${content.readCount != 0}">
				   	  	 			${content.readCount}
				   	  	 		</c:if>
				   	  	 	</div>
				   	  	 	<div class="chat_time">
				   	  	 		<fmt:formatDate value="${content.regDate}" pattern="a HH:mm"/>
				   	  	 	</div>
				   	  	 	<div class="chat_content" data-content_num="${content.chatContentNum}" data-content_writerId="${content.chat_writerId}" data-read_type="${content.read_type}"> 
				   	  	 		${content.chat_content}
				   	  	 	</div>
			             </div>
					  </c:when>
				      <c:otherwise><!--  타인이 쓴 채팅 내용 -->
				      	<div class="chat_wrap">
				      		<div class="chat_profile">
			      				<div class="chat_image">
									<c:choose>
									   	  <c:when test="${pageContext.request.serverName == 'localhost'}"> 
											 	<img src="/resources/img/profile_img/<c:out value="${chatMember.chat_memberId}"/>.png?${random}" class="memberImage" onerror="this.src='/resources/img/profile_img/basicProfile.png'"/>
										  </c:when> 
									      <c:otherwise> 
									    		<img src="/upload/<c:out value="${chatMember.chat_memberId}"/>.png?${random}" class="memberImage" onerror="this.src='/ROOT/resources/img/profile_img/basicProfile.png'" />
									      </c:otherwise>
									</c:choose>
								</div>
								<div class="chat_nick">
									${content.chat_writerNick}
								</div>
							</div>
				      		<div class="chat_content yourContent" data-content_num="${content.chatContentNum}" data-content_writerId="${content.chat_writerId}" data-read_type="${content.read_type}">
				   	  	 		${content.chat_content}
				   	  	 	</div>
				   	  	 	<div class="chat_time">
				   	  	 		<fmt:formatDate value="${content.regDate}" pattern="a HH:mm"/>
				   	  	 	</div>
				   	  	 	<div id="${content.chatContentNum}" class="chat_readCount" data-content_num="${content.chatContentNum}"> 
				   	  	 		<c:if test="${content.readCount != 0}">
				   	  	 			${content.readCount}
				   	  	 		</c:if>
				   	  	 	</div>
			             </div>
				      </c:otherwise>
				</c:choose>
		    </c:forEach>
		</div>
		<div id="messageWrap">
				<span id="messgaeInputWrap">
					<textarea id="message" rows="3" placeholder="내용을 입력하세요" oninput="checkLength(this,2000);" autofocus></textarea>
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
	
	<div id="editTitle"> 
			<input type="text" id="inputTitle" placeholder="제목을 적어주세요" value="">
			<input type="button" id="editSubmit" class="editBtn" value="확인" /> 
			<input type="button" id="editCancle" class="editBtn" value="취소" onclick="editCancle();" />
	</div>
							
</body>
<script>

		var chatWebSocket = null;
		var commonWebSocket = null;
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
	 	var chatMembersArray = new Array();
	 	
		$(document).ajaxSend(function(e, xhr, options) {
			
		     xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
	    });
		
		<sec:authorize access="isAuthenticated()">   
			  var myId = '${userInfo.username}';  
			  var myNickName = '${userInfo.member.nickName}';
		</sec:authorize>
		
		$(document).ready(function() {
			<sec:authorize access="isAuthenticated()">
					commonWebSocketConnect();			
					chatWebSocketConnect();
					
					setTimeout(function() { 
						
						if(commonWebSocket != null){ 
				        	
							var chat_type = "${chat_type}";
							
				        	if(chat_type == 0){//1:1채팅방이라면
				        		
				        		var chat_memberId="${chatMember.chat_memberId}";
				        		commonWebSocket.send("chatAlarm,"+chat_memberId);
				        		commonWebSocket.send("chatAlarm,"+myId);
				        	
				        	}else if(chat_type == 1){//멀티채팅방이라면
				        		
				        		for(var i=0; i<chatMembersArray.length; i++){ 
				        			commonWebSocket.send("chatAlarm,"+chatMembersArray[i]);
				        		}
				        	}
						}
						
					}, 100); 
						
			</sec:authorize>
		});
		
		function chatWebSocketConnect(){
			
			window.scrollTo(0, $(document).height());
			
			var serverName = '${pageContext.request.serverName}'; 
			
			if(serverName == 'localhost'){
				
				chatWebSocket = new WebSocket("ws://localhost:8080/chatWebsocketHandler");
				
			}else{
				
				chatWebSocket = new WebSocket("wss://dokky.site:443/chatWebsocketHandler");
			}
			
			chatWebSocket.onopen = function(){ //웹소켓이 연결됬다면
				
				console.log("chatWebsocket connected"); 
			
				chatWebSocket.send(JSON.stringify({chatRoomNum : chatRoomNum, type:'OPEN'}));//채팅방 열기
				
				focusFunction();//처음에 방에 입장시, 꼭 채팅방 열기 메시지를 보낸후에(위 한줄 로직), 읽지 않은 메시지들이 있다면 읽어주는 처리를 한번해야한다.
				
				chatWebSocket.onmessage = function(event){//웹소켓이 연결됬는데 메시지가 왔다면
					
					console.log("chatWebSocket.onmessage");
					
					console.log(event.data);
				
					chatroom = document.getElementById('chatContents');
					
					var obj = JSON.parse(event.data);
					
					var isBottom;
					
					if($(window).scrollTop() + $(window).height() == $(document).height()){//스크롤이 맨 하단에서 감지되는지 여부 저장
						isBottom = true;
				    }
					
					if(obj.type == 'CHAT'){
						 
						 var regDate = parseInt(obj.regDate);
						 
						 var time = commonService.displayDayTime(regDate);
						 
						 var getMessgae = obj.message;
						 
						 divideDate(regDate);//채팅 내용 사이에 날짜 구분해주기
						 
						 if(position == "in"){//사용자가 채팅방에 머무른다면
							 	
								 if(obj.chat_writerId == myId){
									 
									    chatroom.innerHTML += "<div class='chat_wrap myChat'>"
															        	+"<div id="+obj.chatContentNum+" class='chat_readCount' data-content_num="+obj.chatContentNum+">" 
																			+ obj.headCount 
																		+"</div>"
				        												+"<div class='chat_time'>" 
				        													+ time 
				        												+"</div>"
				     													+"<div class='chat_content' data-content_writerId="+obj.chat_writerId+" data-content_num="+obj.chatContentNum+" data-read_type="+1+">"
				     														+ getMessgae 
				     													+ "</div>"
		     												+ "</div>";
						         }else{
						        	 	
							        	 var img;
		        					     
			        					 if(serverName == 'localhost'){ 
			        						 img = "<img src='/resources/img/profile_img/"+obj.chat_writerId+".png?"+random+"' class='memberImage hideUsermenu' onerror='this.src=\"/resources/img/profile_img/basicProfile.png\"'/>&nbsp"
													   
										 }else{
											 img = "<img src='/upload/"+obj.chat_writerId+".png?"+random+"' class='memberImage hideUsermenu' onerror='this.src=\"/ROOT/resources/img/profile_img/basicProfile.png\"'/>&nbsp"
										 }
		        					 
							        	 chatroom.innerHTML += "<div class='chat_wrap'>"
														        	 	+"<div class='chat_profile'>" 
															        	 	+"<div class='chat_image'>"
															        	 		+ img 
															        	 	+"</div>"
															        	 	+"<div class='chat_nick'>"
															        	 		+ obj.chat_writerNick
															        	 	+"</div>"
															        	+"</div>"
														        	 	+"<div class='chat_content yourContent' data-content_writerId="+obj.chat_writerId+" data-content_num="+obj.chatContentNum+" data-read_type="+1+">"
																	    	+ getMessgae 
																		+ "</div>"
																		+ "<div class='chat_time'>"
																			+ time  
																		+ "</div>"
																		+"<div id="+obj.chatContentNum+" class='chat_readCount' data-content_num="+obj.chatContentNum+">" 
																		+ obj.headCount 
																		+"</div>"
																+ "</div>";
						         }
								 
								 var chatReadData = {  
										    chat_memberId    : myId,
										    chatContentNum   : obj.chatContentNum
						 				  };
							 
								 readChat(chatReadData, 
										 
											function(result, status){
											
												if(status == "success"){
													
													chatWebSocket.send(JSON.stringify({chatRoomNum : chatRoomNum, type:'READ', chatContentNum : obj.chatContentNum}));
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
				        												+"<div id="+obj.chatContentNum+" class='chat_readCount' data-content_num="+obj.chatContentNum+">"
																			+ obj.headCount 
																		+"</div>"
				        												+"<div class='chat_time'>" 
				        													+ time 
				        												+"</div>"
				        												+"<div class='chat_content' data-content_writerId="+obj.chat_writerId+" data-content_num="+obj.chatContentNum+" data-read_type="+0+">"
				     														+ getMessgae 
				     													+ "</div>"
			     												+ "</div>";
		        				 }else{	
		        					     var img;
		        					     
			        					 if(serverName == 'localhost'){
			        						 img = "<img src='/resources/img/profile_img/"+obj.chat_writerId+".png?"+random+"' class='memberImage hideUsermenu' onerror='this.src=\"/resources/img/profile_img/basicProfile.png\"'/>&nbsp"
													   
										 }else{
											 img = "<img src='/upload/"+obj.chat_writerId+".png?"+random+"' class='memberImage hideUsermenu' onerror='this.src=\"/ROOT/resources/img/profile_img/basicProfile.png\"'/>&nbsp"
										 }
		        					 
							        	 chatroom.innerHTML += "<div class='chat_wrap'>"
													        			+"<div class='chat_profile'>" 
															        	 	+"<div class='chat_image'>"
															        	 		+ img
															        	 	+"</div>"
															        	 	+"<div class='chat_nick'>"
															        	 		+ obj.chat_writerNick
															        	 	+"</div>"
															        	+"</div>"
														        	 	+"<div class='chat_content yourContent' data-content_writerId="+obj.chat_writerId+" data-content_num="+obj.chatContentNum+" data-read_type="+0+">"
																	    	+ getMessgae 
																		+ "</div>"
																		+ "<div class='chat_time'>"
																			+ time  
																		+ "</div>"
																		+"<div id="+obj.chatContentNum+" class='chat_readCount' data-content_num="+obj.chatContentNum+">" 
																		+ obj.headCount 
																		+"</div>"
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
						 
					}else if(obj.type == 'TITLE'){
						
						$(".innerTitle").html(obj.message);
					}
			
					if(isBottom == true){//스크롤이 맨 하단에서 감지된다면
						window.scrollTo(0, $(document).height());//스크롤 맨아래로 내리기
				    }
				}
				
				chatWebSocket.onclose = function(){//연결된 소켓이 닫혔다면
					
					chatWebSocket = null;
					
					editCancle();
					openAlert("채팅연결이 끊겼습니다");
					console.log("chatWebSocket closed");
					
					setTimeout(function() {
						<sec:authorize access="hasAnyRole('ROLE_ADMIN','ROLE_USER','ROLE_SUPER','ROLE_STOP')">
							chatWebSocketConnect(); //0.1초후 다시 재연결
						</sec:authorize>
					}, 100); 
				}
				
				chatWebSocket.onerror = function(err){
					
					console.log("chatWebsocket error, "+err);
				}
				
			}	
		}
		
		function commonWebSocketConnect(){
		
			var serverName = '${pageContext.request.serverName}'; 
			
			if(serverName == 'localhost'){
			
				commonWebSocket = new WebSocket("ws://localhost:8080/commonWebsocketHandler");

			}else{
				
				commonWebSocket = new WebSocket("wss://dokky.site:443/commonWebsocketHandler");
			}
			
			commonWebSocket.onopen = function (){ //소켓이 연결됬다면
				
				console.log("commonWebsocket is connected");
			
				commonWebSocket.onmessage = function(event){//소켓 연결됬는데 메시지가 왔다면
					
					console.log("commonWebsocket message");
				}
				
				commonWebSocket.onclose = function(){ //소켓 연결됬는데 소켓이 다시 닫혔다면
					
					console.log("commonWebsocket is closed");
					
					setTimeout(function() {
						<sec:authorize access="hasAnyRole('ROLE_ADMIN','ROLE_USER','ROLE_SUPER','ROLE_STOP')">
							commonWebSocketConnect(); //1초후 다시 재연결
						</sec:authorize>
					}, 1000); 
				}
				
				commonWebSocket.onerror = function(err){//소켓 연결됬는데 에러가 있다면
					
					console.log("commonWebsocket error, "+err);
				}
			}
		}
		
		
		function send(chatRoomNum, messageVal){
			
			if(chatWebSocket != null){
				
				console.log("chatWebsocket send");
				
				console.log("headCount="+headCount);
				
		        chatWebSocket.send(JSON.stringify({chatRoomNum : chatRoomNum, type:'CHAT', message : messageVal, chat_writerId:myId , chat_writerNick: myNickName , headCount:headCount}));
		        
		        message.val("");
		        
		        setTimeout(function() {
		        	window.scrollTo(0, $(document).height());//스크롤 맨아래로
	        	}, 50);
		        
				setTimeout(function(){ //시간 차이 때문에 조금 늦게 보내야 채팅 카운트 알림이 보내진다.
		    		
			    	var chat_type = "${chat_type}";
			    	
		    		if(commonWebSocket != null){//상대방 채팅 카운트 업데이트 시키기
				        	
				        	if(chat_type == 0){//1:1채팅방이라면
				        		
				        		var chat_memberId="${chatMember.chat_memberId}";
				        		commonWebSocket.send("chatAlarm,"+chat_memberId);
				        		commonWebSocket.send("chatAlarm,"+myId);
				        	
				        	}else if(chat_type == 1){//멀티채팅방이라면
				        		
				        		for(var i=0; i<chatMembersArray.length; i++){ 
				        			commonWebSocket.send("chatAlarm,"+chatMembersArray[i]);
				        		}
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
			
			chatWebSocket.send(JSON.stringify({chatRoomNum : chatRoomNum, type:'CLOSED'}));
			
		    chatWebSocket.close();
		    
		    chatWebSocket = null;
		}
		
		function leave(){//방 나가기
			
			console.log("chatWebsocket leave");
			
			chatWebSocket.send(JSON.stringify({chatRoomNum : chatRoomNum, type : 'LEAVE', chat_writerId : myId , chat_writerNick: myNickName }));
		}
		
		window.onbeforeunload = function() {//브라우저 종료 및 닫기 감지
			
			if(chatWebSocket != null){
				closed();
			}
		}
		
		$("#sendMessageBtn").on("click", function(event){//메시지 보내기
			
			message = $("#message");
		
			var messageVal = message.val();
			
			messageVal = $.trim(messageVal);
			
			if(messageVal == ""){ 
				openAlert("메시지를 입력하세요"); 
				   return false;
			}
		
			send(chatRoomNum, messageVal);
			
		});
		
		
		$("#leave").on("click", function(event){//방 나가기
			
			leave();
			chatWebSocket = null;
			window.close();
		});
		
		$("#editSubmit").on("click", function(event){
			
			var title = $("#inputTitle").val();
			title = $.trim(title);
				
			if(title == "" || title == null){
				
				editCancle();
				
				return;
			}
			
			var chatRoomVO = {
								chatRoomNum : chatRoomNum,
								chat_title : title,
								roomOwnerId : myId
						  }
			
			updateTitle(chatRoomVO, 
					
					function(result, status){
				
						if(status == "success"){
							
							$(".innerTitle").html(title);
							
							if(chatWebSocket != null){ 
								
								chatWebSocket.send(JSON.stringify({chatRoomNum : chatRoomNum, type:'TITLE', message : title}));
							}
							
							if(commonWebSocket != null){ 
								
								for(var i=0; i<chatMembersArray.length; i++){ 
				        			commonWebSocket.send("chatAlarm,"+chatMembersArray[i]);
				        		}
							}
							
							editCancle();
						}
					},
				    
			    	function(status){
			    	
						if(status == "error"){
							
							editCancle();
							openAlert("Server Error(관리자에게 문의해주세요)");
						}
			    	}
			
			);
			
		});
		
		$(".chatMenuBtn").on("click",function(event){//이동
			
			event.preventDefault();
		
			$(".chatMenuBar").css("display","block"); 
		});
		
		$('html').click(function(e){
			
			if( !$(e.target).is('.hideclass, .chatMenuBtn') ) {  
				
				$(".chatMenuBar").css("display","none");  	
			} 
		});   
	
		
		$("#test").on("click", function(event){
			chatWebSocket.close();
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
											
											var chat_writerId = content_object.data("content_writerId");
											
											if(result == "0"){//읽지 않았는데 , 디비에서 읽음 처리를 했을때
												
												if(chat_writerId != myId){
													content_object.replaceWith("<div class='chat_content yourContent' data-content_num="+content_object.data("content_num")+" data-read_type="+1+">"+content_object.html()+"</div>");	
												}else{
													content_object.replaceWith("<div class='chat_content' data-content_num="+content_object.data("content_num")+" data-read_type="+1+">"+content_object.html()+"</div>");
												}
												
												if(chatWebSocket != null){
													
													chatWebSocket.send(JSON.stringify({chatRoomNum : chatRoomNum, type:'READ', chatContentNum : content_object.data("content_num")}));
												}
												
											}else if(result == "1"){//이미 디비에서 읽음 처리가 되었을때
												
												if(chat_writerId != myId){
													content_object.replaceWith("<div class='chat_content yourContent' data-content_num="+content_object.data("content_num")+" data-read_type="+1+">"+content_object.html()+"</div>");
												}else{
													content_object.replaceWith("<div class='chat_content' data-content_num="+content_object.data("content_num")+" data-read_type="+1+">"+content_object.html()+"</div>");
												}
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
			
			if(commonWebSocket != null){
				commonWebSocket.send("chatAlarm,"+myId);
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
		
		function updateTitle(chatRoomVO, callback, error) {

			$.ajax({
					type : 'put',
					url : '/chatTitle',
					data : JSON.stringify(chatRoomVO),
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
		
		function checkLength(obj, maxByte) { 
			 
			if(obj.tagName === "INPUT" || obj.tagName === "TEXTAREA"){ 
				var str = obj.value; 
			}else if(obj.tagName === "DIV" ){
				var str = obj.innerHTML; 
			} 
				
			var stringByteLength = 0;
			var reStr;
				
			stringByteLength = (function(s,b,i,c){
				
			    for(b=i=0; c=s.charCodeAt(i++);){
			    
				    b+=c>>11?2:c>>7?2:1;
				    if (b > maxByte) { 
				    	break;
				    }
				    
				    reStr = str.substring(0,i);
			    }
			    
			    return b
			    
			})(str);
			
			if(obj.tagName === "INPUT" || obj.tagName === "TEXTAREA"){ 
				if (stringByteLength > maxByte) {// 전체길이를 초과하면          
					openAlert(maxByte + " Byte 이상 입력할 수 없습니다");         
					obj.value = reStr;       
				}   
			}else if(obj.tagName === "DIV"){
				if (stringByteLength > maxByte) {// 전체길이를 초과하면          
					openAlert(maxByte + " Byte 이상 입력할 수 없습니다");         
					obj.innerHTML = reStr;    
				}   
			} 
			
			obj.focus();  
		}
		
		
		function openEdit(){
			
			 if(myId != "${chatTitleInfo.roomOwnerId}"){
				
				 openAlert("제목은 방장만 수정 할 수 있습니다");
				 
			 }else{
				
				 var alertFakeDiv = $("#alertFakeDiv");
				 var inputTitle = $("#inputTitle");
				 var editTitle = $("#editTitle");
				 inputTitle.focus();
				 alertFakeDiv.css("display","block");
				 editTitle.css("display","block");
				 
			 }
		}
		
		function editCancle(){  
			
			var alertFakeDiv = $("#alertFakeDiv");
			var editTitle = $("#editTitle");
			var inputTitle = $("#inputTitle");
			 
			alertFakeDiv.css("display","none");
			editTitle.css("display","none"); 
			inputTitle.val("");
		}  
		
			
</script>

<c:if test="${chat_type == 1}"><!-- 멀티채팅방이라면 -->
	<c:forEach items="${chatMembers}" var="member">
		<script> 
			chatMembersArray.push("${member.chat_memberId}");
		</script>
	</c:forEach>
</c:if>
	
</html>