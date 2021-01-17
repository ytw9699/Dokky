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
									<div class="chatMenu inviteBtn hideclass">초대</div>
									<div class="chatMenu hideclass" id="leave">나가기</div>
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
									<div class="chatMenu inviteBtn hideclass">초대</div>
									<div class="chatMenu hideclass" id="leave">나가기</div>
							    </div> 
							</div>
					  </div>
				  </c:when>
			</c:choose>
			<div class="test">
				<button id="test">재연결</button>
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
		<div id="hidingMessage">
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
	
	<div id="backGround"></div> 
	<div id="userListWrap">
			<div class="title">
				초대할 회원을 선택해주세요 
			</div>
			<div id="chosenMembers">
			</div>
			<div id="searchWrap">
				<input id="search" type='text' value='' oninput="search(this,30)" placeholder=" 회원을 검색해주세요" autofocus/>
			</div>
			<div id="userList">
				<!-- 회원리스트 -->
			</div>
			<div class="buttonWrap">
				<div id="chatInviteWrap">
					<input type="button" id="chatInvite" value="초대" disabled='disabled'/>	
				</div>
				<div class="chatCancelWrap">
					<input type="button" id="chatCancel" value="취소" />				
				</div>
			</div>
	</div>
	<div id="chatMemberListWrap">
			<div class="memberListCancelWrap">
				<input type="button" id="memberListCancel" value="X" />				
			</div>
			<div class="chatMemberListTitle">
				채팅방 멤버 
			</div>
			<div id="chatMemberList">
			</div>
	</div>
							
</body>
<script>

		var chatWebSocket = null;
		var commonWebSocket = null;
		var message;
		var chatRoomNum = '${chatRoomNum}';
		var csrfHeaderName ="${_csrf.headerName}"; 
		var csrfTokenValue="${_csrf.token}";
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
			
			<sec:authorize access="isAuthenticated()">
			
					commonWebSocketConnect();		
					chatWebSocketConnect();
					
					setTimeout(function(){//방을 처음 생성하고 방 인원 모두에게 chatAlarm을 보내 채팅리스트를 업데이트 시키거나
									      //기존의 방에 입장하여 읽지않은 채팅메시지를 읽고 메시지 숫자를 업데이트 시켜주는 용도 
						
						if(commonWebSocket != null){ 
				        	
				        	if("${chat_type}" == 0){//1:1채팅방이라면
				        		
				        		var chat_memberId="${chatMember.chat_memberId}";
				        		commonWebSocket.send("chatAlarm,"+chat_memberId);
				        		commonWebSocket.send("chatAlarm,"+myId);
				        	
				        	}else if("${chat_type}" == 1){//멀티채팅방이라면
				        		
				        		commonService.getChatRoomMembers(chatRoomNum,
										
										function(result, status){
											
											if(status == "success"){
												
												for(var i in result){
													commonWebSocket.send("chatAlarm,"+result[i].chat_memberId);
												}
											}
										},
									    
										showError	
								);
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
			
			chatWebSocket.onopen = function(){
				
				console.log("chatWebsocket connected"); 
			
				chatWebSocket.send(JSON.stringify({chatRoomNum : chatRoomNum, type:'OPEN'}));//채팅방 열기
				
				inChatRoom();//처음에 방에 입장시, 꼭 채팅방 열기 메시지를 보낸후에(위 한줄 로직), 읽지 않은 메시지들이 있다면 읽어주는 처리를 한번해야한다.
				
				chatWebSocket.onmessage = function(event){
					
					console.log("chatWebSocket.onmessage");
					
					chatroom = document.getElementById('chatContents');
					
					var obj = JSON.parse(event.data);
					
					var isBottom;
					
					if($(window).scrollTop() + $(window).height() == $(document).height()){//스크롤이 맨 하단에서 감지되는지 여부 저장
						isBottom = true;
				    }else{
				    	isBottom = false;
				    }
					
					if(obj.type == 'CHAT'){
						 
						 var regDate = parseInt(obj.regDate);
						 
						 var time = commonService.displayDayTime(regDate);
						 
						 var getMessgae = obj.message;
						 
						 divideDate(regDate);
						 
						 if(!isBottom){
							 
							 if(obj.chat_writerId != myId){
								 
								 var hidingMessage = $("#hidingMessage");
								 
								 hidingMessage.html(obj.chat_writerNick + " : " +getMessgae);
								 
								 hidingMessage.css("display","block");
								 
								 hidingMessage.on("click", function(event){
										
									 hidingMessage.css("display","none");
									 $('html').scrollTop(document.body.scrollHeight);
								 });
							 }
						 }
						 
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
									    
									    	showError
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
						
						 if(obj.chat_writerId == myId){
							 
							 commonService.getChatRoomMembers(chatRoomNum,
										
									function(result, status){
										
										if(status == "success"){
											
											if(commonWebSocket != null){
												
												for(var i in result){
													
													commonWebSocket.send("chatAlarm,"+result[i].chat_memberId);	
												}
												
												commonWebSocket.send("chatAlarm,"+myId);
											}
										}
									},
								    
									showError		
							 );
							 
							 setTimeout(function() {
								 closed();	
							 }, 100);//0.1초 
								
						 }else{
							 
							 var regDate = parseInt(obj.regDate);
								
							 divideDate(regDate);
							 
							 var getMessgae = obj.message;
							 
							 chatroom.innerHTML = chatroom.innerHTML + "<div class='chat_wrap notice'>"
							 											+ "<span class='chat_notice_content'>"
																			 + getMessgae
																	 	+ "</span>"
							 										 + "</div>";
						 }
						 
					}else if(obj.type == 'READ'){
						
						 var chatContentNum = obj.chatContentNum;
						 
						 var chat_readCount = $("#"+chatContentNum);
						 
						 if(chat_readCount.html() == 1){
							 
							 chat_readCount.html("");
							 
						 }else{
							 chat_readCount.html(chat_readCount.html()-1);
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
						 
					}else if(obj.type == 'TITLE'){
						
						$(".innerTitle").html(obj.message);
						
					}else if(obj.type == 'INVITE'){
						
						var getMessgae = obj.message;
						
						chatroom.innerHTML = chatroom.innerHTML + "<div class='chat_wrap notice'>"
																	+ "<span class='chat_notice_content'>"
																	 + getMessgae
															 	+ "</span>"
																 + "</div>";
						
						if(commonWebSocket != null){
							commonWebSocket.send("chatAlarm,"+myId);
						}
						
						commonService.getChat_type(chatRoomNum,  
								
						   		function(result, status){
								
										if(result == "1"){//멀티채팅방이라면 
											
												$(".innerTitle").html(obj.memberNicks);
											
											    var memberIdArr = obj.memberIds.split(',');
											    
											    var headCount = memberIdArr.length;
											    
											    $(".memberCount").html("("+headCount+")");
											     
											   	var imgStr ="";
											   	
											    for(var i in memberIdArr){
											    	
											    	if(i < 4){
											    		
												    	if(serverName == 'localhost'){ 
												    		
												    		imgStr += "<img src='/resources/img/profile_img/"+memberIdArr[i]+".png?"+random+"' class='multiMemberImage' onerror='this.src=\"/resources/img/profile_img/basicProfile.png\"'/>&nbsp"
																	   
														}else{
															
															imgStr += "<img src='/upload/"+memberIdArr[i]+".png?"+random+"' class='multiMemberImage' onerror='this.src=\"/ROOT/resources/img/profile_img/basicProfile.png\"'/>&nbsp"
														}	
											    	}
											    	
											    	if(commonWebSocket != null){
										        		commonWebSocket.send("chatAlarm,"+memberIdArr[i]);
													}
											    }
											    
											    $(".allMemberImage").html(imgStr);
										    
										}else if(result == "0"){//1:1채팅방이라면
											
												if(commonWebSocket != null){
													var chat_memberId="${chatMember.chat_memberId}";
									        		commonWebSocket.send("chatAlarm,"+chat_memberId);
												}
										}
						    	},
							    
						    	showError
						);
					}
			
					if(isBottom == true){
						window.scrollTo(0, $(document).height());
				    }
				}
				
				chatWebSocket.onclose = function(event){
					
					console.log("chatWebSocket onclose");
					console.log(event);
					
					chatWebSocket = null;
					
					editCancle();
					openAlert("채팅연결이 끊겼습니다");
					
					setTimeout(function() {
						<sec:authorize access="hasAnyRole('ROLE_ADMIN','ROLE_USER','ROLE_SUPER','ROLE_STOP')">
							chatWebSocketConnect();
						</sec:authorize>
					}, 100);//0.1초
				}
				
				chatWebSocket.onerror = function(err){
					
					console.log("chatWebsocket error");
					console.log(err);
					openAlert("채팅연결 에러가 발생했습니다.");
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
			
			commonWebSocket.onopen = function (){
				
				console.log("commonWebsocket is connected");
			
				commonWebSocket.onmessage = function(event){
					
					console.log("commonWebsocket message");
				}
				
				commonWebSocket.onclose = function(){
					
					console.log("commonWebsocket is closed");
					
					setTimeout(function() {
						<sec:authorize access="hasAnyRole('ROLE_ADMIN','ROLE_USER','ROLE_SUPER','ROLE_STOP')">
							commonWebSocketConnect();
						</sec:authorize>
					}, 1000);
				}
				
				commonWebSocket.onerror = function(err){
					
					console.log("commonWebsocket error, "+err);
				}
			}
		}
		
		
		function send(chatRoomNum, messageVal){
			
			if(chatWebSocket != null){
				
				console.log("chatWebsocket send");
				
		        chatWebSocket.send(JSON.stringify({chatRoomNum : chatRoomNum, type:'CHAT', message : messageVal, chat_writerId:myId , chat_writerNick: myNickName}));
		        
		        message.val("");
		        
		        setTimeout(function() {
		        	window.scrollTo(0, $(document).height());
	        	}, 50);
		        
				setTimeout(function(){//시간 차이 때문에 조금 늦게 보내야 채팅 카운트 알림이 보내진다.
		    		
		    		if(commonWebSocket != null){
				        	
			    			commonService.getChat_type(chatRoomNum,  
			    					
				    			   		function(result, status){
			    				
				    					
				    							if(result == "1"){//멀티채팅방이라면 
				    								
				    								commonService.getChatRoomMembers(chatRoomNum,
				    										
				    										function(result, status){
				    											
				    											if(status == "success"){
				    												
				    												for(var i in result){
				    													commonWebSocket.send("chatAlarm,"+result[i].chat_memberId);
				    												}
				    											}
				    										},
				    									    
				    										showError	
				    								);
				    								
				    							}else if(result == "0"){//1:1채팅방이라면
				    								
				    								var chat_memberId="${chatMember.chat_memberId}";
				    				        		commonWebSocket.send("chatAlarm,"+chat_memberId);
				    				        		commonWebSocket.send("chatAlarm,"+myId);
				    							}
				    			    	},
				    				    
				    			    	showError
				    		);
					}
		    		
	        	}, 100);

			}else{
				
				openAlert("채팅연결이 끊겼습니다");
			}
	    }
		
		function closed(){//방 닫기
			
			if(chatWebSocket != null){
				
				console.log("chatWebsocket closed");
				
				chatWebSocket.send(JSON.stringify({chatRoomNum : chatRoomNum, type:'CLOSED'}));
			    chatWebSocket.close();
			    chatWebSocket = null;
			    
			}else{
				
				console.log("chatWebSocket is null");
			}		    
		
			window.close();
		}
		
		window.onbeforeunload = function(){//브라우저 종료 및 닫기 감지
				closed();
		}
		
		$("#sendMessageBtn").on("click", function(event){
			
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
			
				if(chatWebSocket != null){
					
					console.log("chatWebsocket leave");
					
					chatWebSocket.send(JSON.stringify({chatRoomNum : chatRoomNum, type : 'LEAVE', chat_writerId : myId , chat_writerNick: myNickName }));
				    
				}else{
					
					console.log("chatWebSocket is null");
					
					openAlert("채팅 연결이 끊겨 재연결중입니다.");
					
					<sec:authorize access="hasAnyRole('ROLE_ADMIN','ROLE_USER','ROLE_SUPER','ROLE_STOP')">
						chatWebSocketConnect();
					</sec:authorize>
				}	
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
								
								commonService.getChatRoomMembers(chatRoomNum,
										
										function(result, status){
											
											if(status == "success"){
												
												for(var i in result){
													commonWebSocket.send("chatAlarm,"+result[i].chat_memberId);
												}
											}
										},
									    
										showError	
								);
							}
							
							editCancle();
						}
					},
				    
					showError
			);
			
		});
		
		$(".chatMenuBtn").on("click",function(event){
			
				event.preventDefault();
			
				$(".chatMenuBar").css("display","block"); 
		});
		
		$('html').click(function(e){
			
			if( !$(e.target).is('.hideclass, .chatMenuBtn') ) {  
				
				$(".chatMenuBar").css("display","none");  	
			} 
		});   
		
		$(".inviteBtn").on("click",function(event){
			
			openInviteList();
   		}); 

		$("#chatCancel").on("click", function(event){
			
			closeUserList();	
		});
		
		$("#chatInvite").on("click", function(event){
			
			var chosenUser = $(".chosenUser").get();
			
			inviteUser(chosenUser);
		});
		
		$(".allMemberImage").on("click", function(event){
			
			openChatMemberList(); 
		});
		
		$("#memberListCancel").on("click", function(event){
			
			memberListCancel();
		});
		
		$(document).on("click",".userMenu", function(event){ 
			
			event.preventDefault();
			
			var	user_id = $(this).data("user_id");
			var userMenubar = $("#userMenubar_"+user_id);
			
			closeUserMenubar();
			
			userMenubar.css("display","block"); 
			userMenubar.addClass('addBlockClass'); 
		});
		
		
		$(document).on("click",".userBoardList", function(event){ 
			
			event.preventDefault();
			
			var chat_memberId = $(this).data("chat_userid");
	
			window.open('/userBoardList?userId='+chat_memberId);
			
			closeUserMenubar();
			memberListCancel();
		});
		
		$(document).on("click",".singleChat", function(event){ 
			
			event.preventDefault();
			
			<sec:authorize access="isAuthenticated()">   
				var myId = '${userInfo.username}';  
				var myNickName = '${userInfo.member.nickName}';
			</sec:authorize>
			
			if(myId == $(this).data("chat_userid")){
				
				openAlert("본인과는 채팅 할 수 없습니다");
				
				memberListCancel();
				
				return;
			}
		
			var chatRoomData = {   
									roomOwnerId : myId,
									roomOwnerNick : myNickName,
									chat_type : 0,
									headCount : 2
							   };
		
			var chatMemberData = {
					
									chat_memberId : $(this).data("chat_userid"),
									chat_memberNick : $(this).data("chat_nickname")
							  	 };
								
			var commonData = { 
								chatRoomVO : chatRoomData,
								chatMemberVO : chatMemberData
				 			 };
			
			commonService.createSingleChat(commonData,
		   			
			   		function(result, status){
					
						if(status == "success"){ 
							
							var popupX = (window.screen.width / 2) - (400 / 2);
	
							var popupY= (window.screen.height /2) - (500 / 2);
							
							window.open('/chatRoom/'+result+'?userId='+myId, "title"+result, 'height=500, width=400, screenX='+ popupX + ', screenY= '+ popupY);
							
							closeUserMenubar();
							memberListCancel();
						}
			    	},
				    
			    	function(status){
			    	
						if(status == "error"){ 
							
							openAlert("Server Error(관리자에게 문의해주세요)");
						}
			    	}
		   	); 
		});
		
		$("#test").on("click", function(event){
			closed();
			/* chatWebSocket.close(); */
		});
		
		window.onblur = outChatRoom;//채팅방에서 포커스가 벗어날때
		window.onfocus = inChatRoom;//채팅방에 포커스가 잡힐때
		
		function outChatRoom(){ 
			
			position = "out";
		}
		 
		function inChatRoom(){ 
			
			console.log("in");
			
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
							    
							    	showError
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
		
		function divideDate(regDate){//채팅 내용 사이에 날짜 구분해주기
			
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
		
		function openInviteList(){
			
			var backGround = $("#backGround");
			var userListWrap = $("#userListWrap");
				backGround.css("display","block");
				userListWrap.css("display","block");
				
			getChatInviteList( showInviteList, showError, chatRoomNum );
		} 
		
		function openChatMemberList(){
			
			var backGround = $("#backGround");
			var chatMemberListWrap = $("#chatMemberListWrap");
				backGround.css("display","block");
				chatMemberListWrap.css("display","block");
				
			commonService.getChatRoomMembers(chatRoomNum, showChatMemberList, showError);
		} 
		
		function getChatInviteList(callback, error, chatRoomNum, keyword ) {
			
			$.ajax({
				type : 'get', 
				url : '/getChatInviteList?chatRoomNum='+chatRoomNum+"&keyword="+keyword, 
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
		
		function showError(status){
	    	
			if(status == "error"){ 
				
				openAlert("Server Error");
			}
    	}
		
		function showChatMemberList(result, status){
			
			if(status == "success"){
				
				var length = result.length;
				var chatMemberList = $("#chatMemberList");
				var str = "";
				var nickName; 
				var userId; 
				
				for(var i = 0; i < length; i++){
						
				       nickName = result[i].chat_memberNick; 
				       userId = result[i].chat_memberId;
				      
					   str += "<div class='chatUserWrap' data-user_id='"+userId+"' data-nick_name='"+nickName+"'>"
				   		   str +=  "<span class='userImage'>"; 
							str +=   "<a href='#' class='userMenu' data-user_id='"+userId+"'>"
							   if(serverName == 'localhost'){ 
								   str += "<img src='/resources/img/profile_img/"+userId+".png?"+random+"' class='memberImage hideUsermenu' onerror='this.src=\"/resources/img/profile_img/basicProfile.png\"'/>&nbsp"
										   
							   }else{
								   str += "<img src='/upload/"+userId+".png?"+random+"' class='memberImage hideUsermenu' onerror='this.src=\"/ROOT/resources/img/profile_img/basicProfile.png\"'/>&nbsp"
							   }
						   str += 	 "</a>"; 
					   	   str +=  "</span>";  
					   	   str +=  "<span class='userNickname'>"
					   	   str +=		nickName
					   	   str +=  "</span>"; 
						   str += "<div id='userMenubar_"+userId+"' class='userMenubar'>" 
								str += "<ul class='hideUsermenu'>" 
									str += "<li class='hideUsermenu userBoardList' data-chat_userid='"+userId+"'>"
										str += "<a href='#' class='hideUsermenu'>"
												str += "<span class='hideUsermenu'>게시글보기</span>"
										str += "</a>"
									str += "</li>"
									str += "<li class='hideUsermenu'>"  
										str += "<a href='#' class='hideUsermenu' onclick=\"noteOpen('"+userId+"','"+nickName+"')\">"
											str += "<span class='hideUsermenu'>쪽지보내기</span>"
										str += "</a>"
									str += "</li>"
									str += "<li class='hideUsermenu singleChat' data-chat_nickname='"+nickName+"' data-chat_userid='"+userId+"'>"  
										str += "<a href='#' class='hideUsermenu'>"
											str += "<span class='hideUsermenu'>1:1채팅</span>"
										str += "</a>"
									str += "</li>"
								str += "</ul>"
						   str += "</div>";
					   str += "</div>"; 
				}
			
				chatMemberList.html(str);
			}
		}
		
		function showInviteList(inviteList, status){
			
			if(status == "success"){
				
				var length = inviteList.length;
				var userList = $("#userList");
				var str = "";
				var nickName; 
				var userId; 
				
				for (var i = 0; i < length || 0; i++){
					
				       nickName = inviteList[i].nickName; 
				       userId = inviteList[i].userId;
				      
				   	   str += "<div class='userWrap' data-user_id='"+userId+"' data-nick_name='"+nickName+"'>"
				   		   str +=  "<span class='userImage'>"; 
							   if(serverName == 'localhost'){ 
								   str += "<img src='/resources/img/profile_img/"+userId+".png?"+random+"' class='memberImage hideUsermenu' onerror='this.src=\"/resources/img/profile_img/basicProfile.png\"'/>&nbsp"
										   
							   }else{
								   str += "<img src='/upload/"+userId+".png?"+random+"' class='memberImage hideUsermenu' onerror='this.src=\"/ROOT/resources/img/profile_img/basicProfile.png\"'/>&nbsp"
							   }
					   	   str +=  "</span>";  
					   	   str +=  "<span class='userNickname'>"
					   	   str +=		nickName
					   	   str +=  "</span>"; 
				   	   str +=  "</div>";  
				}
				
				userList.html(str);
				
				$(".userWrap").on("click", function(event){
					
						var chosenMembers = $("#chosenMembers");
						var str = $.trim(chosenMembers.html());
						var user_id = $(this).data("user_id");
						var nick_name = $(this).data("nick_name");
						
						if(str == ""){
							
							str += "<span id='user"+user_id+"' class='chosenUser' data-user_id='"+user_id+"' data-nick_name='"+nick_name+"'>"+nick_name+"</span>";
							
						}else{
							
							var chosenUser = $("#user"+user_id);
							
							if(chosenUser.length > 0){
								
								chosenUser.remove();
								chosenMembers = $("#chosenMembers");
								str = $.trim(chosenMembers.html());
							
							}else{
								
								str += "<span id='user"+user_id+"' class='chosenUser' data-user_id='"+user_id+"' data-nick_name='"+nick_name+"'> "+nick_name+"</span>";
							}
						}
						
				   		chosenMembers.html(str);
				   		
				   		var chosenUsers = $(".chosenUser");
				   		
				   		if(chosenUsers.length > 0 ){
				   			
				   			var chatInvite = $("#chatInvite");
					   			chatInvite.attr("disabled", false);
					   			chatInvite.css("background-color","#7151fc");
					   			chatInvite.css("color","white");
					   			
				   		}else{
				   			
							var chatInvite = $("#chatInvite");
					   			chatInvite.attr("disabled", true);
					   			chatInvite.css("background-color","#EAEAEA");
					   			chatInvite.css("color","gray");
				   		}
				});
			}
    	}
		
		function closeUserList(){
			
			var backGround = $("#backGround");
			var userListWrap = $("#userListWrap");
			backGround.css("display","none");
			userListWrap.css("display","none");
			
			var chosenMembers = $("#chosenMembers");
			
			chosenMembers.html("");//선택한 멤버 초기화
			
			var search = $("#search");
			
			search.val("");//키워드 초기화
			
			var chatInvite = $("#chatInvite");//초대버튼 비활성화
   			chatInvite.attr("disabled", true); 
   			chatInvite.css("background-color","#EAEAEA");
   			chatInvite.css("color","gray");
		}
		
		function checkInputVal(obj, maxByte) { 
			 
			var str = obj.value; 
			var stringByteLength = 0;
			var reStr;
				
			stringByteLength = (function(s,b,i,c){
				
			    for(b=i=0; c=s.charCodeAt(i++);){
			    
				    b+=c>>11?3:c>>7?2:1;
				    if (b > maxByte) { 
				    	break;
				    }
				    
				    reStr = str.substring(0,i);
			    }
			    
			    return b
			    
			})(str);
			
			if (stringByteLength > maxByte) {          
				obj.value = reStr;
			}   
			
			obj.focus();  
		}
		
		function search(obj, maxByte){
			
			checkInputVal(obj,30);
			getChatInviteList( showInviteList, showError, chatRoomNum, obj.value );
		}
		
		function inviteUser(chosenUser){
			
			<sec:authorize access="isAuthenticated()">   
				var myId = '${userInfo.username}';  
				var myNickName = '${userInfo.member.nickName}';
			</sec:authorize>
			
			if(myId == null){ 
				
				openAlert("로그인 해주세요"); 
				
				return;
			}
			
			var chatRoomData = {   
									chat_memberId : myId,
									chat_memberNick : myNickName,
									chatRoomNum :  chatRoomNum
							   };
			
			var chatMemberVoArray = new Array(chosenUser.length); 
			
			for(var i = 0; i<chosenUser.length; i++) {
	        	
				 var chatMemberData = {
						
										chat_memberId : $(chosenUser[i]).data("user_id"),
										chat_memberNick : $(chosenUser[i]).data("nick_name"),
										chatRoomNum :  chatRoomNum
								  	};
				
				 chatMemberVoArray[i] = chatMemberData;
	        }
								
			var commonData = { 
								chatMemberVO : chatRoomData,
								chatMemberVoArray : chatMemberVoArray
				 			 };
			
			commonService.inviteChatMembers(commonData,  
					
			   		function(result, status){
						
						if(status == "success"){ 
							
							console.log("invited ChatMembers");
							
							closeUserList();
						}
			    	},
				    
			    	showError
		   	);
		}
		
		function noteOpen(userId,nickname){
			
			var popupX = (window.screen.width / 2) - (400 / 2);

			var popupY= (window.screen.height /2) - (500 / 2);
		         
	        window.open('/noteForm?userId='+userId+'&nickname='+nickname, 'ot', 'height=500, width=400, screenX='+ popupX + ', screenY= '+ popupY);
	        
	        closeUserMenubar();
	        memberListCancel();
	    }
		
		function memberListCancel(){
			
			var backGround = $("#backGround");
			var chatMemberListWrap = $("#chatMemberListWrap");
				backGround.css("display","none");
				chatMemberListWrap.css("display","none");	
		}
		
		function closeUserMenubar(){
			
			if($(".addBlockClass").length > 0){
				$(".addBlockClass").css("display","none");  
				$(".addBlockClass").removeClass('addBlockClass');
			}	
		}
		
			
</script>
</html>