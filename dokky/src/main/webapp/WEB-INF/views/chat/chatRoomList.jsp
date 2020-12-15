<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ include file="../includes/common.jsp"%>
<c:set var="random"><%= java.lang.Math.round(java.lang.Math.random() * 123456) %></c:set>
<jsp:useBean id="today" class="java.util.Date" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dokky - 채팅리스트</title>
	<c:choose>
   	  <c:when test="${pageContext.request.serverName == 'localhost'}">
			<link href="/resources/css/chatRoomList.css" rel="stylesheet" type="text/css">
	  </c:when>
      <c:otherwise>
    		<link href="/ROOT/resources/css/chatRoomList.css" rel="stylesheet" type="text/css">
      </c:otherwise>
	</c:choose>
</head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<body>
	<div class="bodyWrap">
		<div class="chatTitleWrap">
			 <span class="chatTitle">
				     		채팅리스트
		     </span>   
     		 <span class="chatBtn">
      			<input type="button" id="newChatBtn" value="새로운 채팅"/>
     		 </span>
	    </div>
		<div class="chatList">
			<c:forEach items="${chatRoomList}" var="chatRoomDTO">
				<c:if test="${chatRoomDTO.chatRoomVo.chat_type == 0 }"><!-- 1:1채팅방 이라면 -->
					<div class="listContent singleChat" id="${chatRoomDTO.chatRoomVo.chatRoomNum}" data-chat_nickname="${chatRoomDTO.chatReadVoList[0].chat_memberNick}" data-chat_userid="${chatRoomDTO.chatReadVoList[0].chat_memberId}">
				</c:if>
				<c:if test="${chatRoomDTO.chatRoomVo.chat_type == 1 }"><!-- 멀티 채팅방 이라면 -->
					<div class="listContent multiChat" id="${chatRoomDTO.chatRoomVo.chatRoomNum}" data-chatroom_num="${chatRoomDTO.chatRoomVo.chatRoomNum}">
				</c:if>
					<div class="firstWrap">
						<c:if test="${chatRoomDTO.chatRoomVo.chat_type == 0 }">
							<c:choose>
							   	  <c:when test="${pageContext.request.serverName == 'localhost'}"> 
									 	<img src="/resources/img/profile_img/<c:out value="${chatRoomDTO.chatReadVoList[0].chat_memberId}"/>.png?${random}" class="singleMemberImage" onerror="this.src='/resources/img/profile_img/basicProfile.png'"/>
								  </c:when> 
							      <c:otherwise> 
							    		<img src="/upload/<c:out value="${chatRoomDTO.chatReadVoList[0].chat_memberId}"/>.png?${random}" class="singleMemberImage" onerror="this.src='/ROOT/resources/img/profile_img/basicProfile.png'" />
							      </c:otherwise>
							</c:choose>
						</c:if>
						<c:if test="${chatRoomDTO.chatRoomVo.chat_type == 1 }">
							<c:choose>
							   	  <c:when test="${pageContext.request.serverName == 'localhost'}"> 
									 	<c:forEach items="${chatRoomDTO.chatReadVoList}" var="chatReadVO" begin="0" end="3"> 
											<img src="/resources/img/profile_img/<c:out value="${chatReadVO.chat_memberId}"/>.png?${random}" class="multiMemberImage" onerror="this.src='/resources/img/profile_img/basicProfile.png'"/>
										</c:forEach>
								  </c:when> 
							      <c:otherwise> 
							      		<c:forEach items="${chatRoomDTO.chatReadVoList}" var="chatReadVO" begin="0" end="3">
									 		<img src="/upload/<c:out value="${chatReadVO.chat_memberId}"/>.png?${random}" class="multiMemberImage" onerror="this.src='/ROOT/resources/img/profile_img/basicProfile.png'" />
										</c:forEach>
							      </c:otherwise> 
							</c:choose>
						</c:if>
					</div>
					<div class="secondWrap"> 
						<div class="chatNick">
							<c:if test="${chatRoomDTO.chatRoomVo.chat_type == 0 }">
								${chatRoomDTO.chatReadVoList[0].chat_memberNick}
							</c:if>
							<c:if test="${chatRoomDTO.chatRoomVo.chat_type == 1 }">
								<c:if test="${chatRoomDTO.chatRoomVo.chat_title != null}">
		        						${chatRoomDTO.chatRoomVo.chat_title}
		        				</c:if>
		        				<c:if test="${chatRoomDTO.chatRoomVo.chat_title == null}">
			        				<c:forEach items="${chatRoomDTO.chatReadVoList}" var="chatReadVO" varStatus="status">
										<c:if test="${!status.last}">
											${chatReadVO.chat_memberNick}, 
										</c:if> 
										<c:if test="${status.last}">
											${chatReadVO.chat_memberNick}
										</c:if>  
								 	</c:forEach>
			        			</c:if>
							</c:if>
						</div>
						<div class="memberCount">
							<c:if test="${chatRoomDTO.chatRoomVo.chat_type == 1 }">
								(${chatRoomDTO.chatRoomVo.headCount}) 
							</c:if>
						</div>
						<div class="chatContent">
							        ${chatRoomDTO.chatContentVo.chat_content}
						</div>
					</div>
					<div class="thirdWrap">
						<div class="chatDate">
							<fmt:formatDate var="nowDate" value="${today}" pattern="yyyy-MM-dd" />
							<fmt:formatDate var="regDate" value="${chatRoomDTO.chatContentVo.regDate}" pattern="yyyy-MM-dd" />
							<c:choose>
						        <c:when test="${nowDate == regDate}">
						        	<fmt:formatDate value="${chatRoomDTO.chatContentVo.regDate}" pattern="a HH:mm"/>
						        </c:when>
						        <c:otherwise>
						        	<fmt:formatDate value="${chatRoomDTO.chatContentVo.regDate}" pattern="yyyy-MM-dd"/>
						        </c:otherwise>
							</c:choose>
						</div>
						<c:if test="${chatRoomDTO.notReadCnt != 0 }">
						 	<div class="chatCnt">
						 		${chatRoomDTO.notReadCnt}+
						 	</div>
						</c:if>
					</div>
				</div>
			</c:forEach>
		</div>
	</div>
	
	<div id="backGround"></div> 
	<div id="userListWrap">
			<div id="title">
				채팅할 회원을 선택해주세요 
			</div>
			<div id="chosenMembers">
			</div>
			<div id="searchWrap">
				<input id="search" type='text' value='' oninput="search(this,30)" placeholder=" 회원검색" autofocus/>
			</div>
			<div id="userList">
				<!-- 회원리스트 -->
			</div>
			<div id="buttonWrap">
				<div id="chatInviteWrap">
					<input type="button" class="newChatBtn" id="chatInvite" value="초대" disabled='disabled'/>	
				</div>
				<div id="chatCancelWrap">
					<input type="button" class="newChatBtn" id="chatCancel" value="취소" />				
				</div>
			</div>
	</div>
</body>
<script>
		var csrfHeaderName ="${_csrf.headerName}"; 
		var csrfTokenValue="${_csrf.token}";
		var serverName = '${pageContext.request.serverName}';
		var random = Math.random();
		var backGround = $("#backGround");
		var userListWrap = $("#userListWrap");
		
		//myId = '${userInfo.username}';  
		   
		$(document).ajaxSend(function(e, xhr, options){
			
		     xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
	    });
		
		$("#newChatBtn").on("click",function(event){
			
			if(isLimited()){
		    	  openAlert("채팅방 생성 권한이 제한되어 있습니다");
		    	  return;
		    }
			
			openUserList();
   		}); 
		
		$("#chatCancel").on("click", function(event){
			
			closeUserList();	
		});
		
		$("#chatInvite").on("click", function(event){
			
			var chosenUser = $(".chosenUser").get();
			
			createMultiChat(chosenUser);
		});
		
		
		function createMultiChat(chosenUser){
			
				<sec:authorize access="isAuthenticated()">   
					var myId = '${userInfo.username}';  
					var myNickName = '${userInfo.member.nickName}';
				</sec:authorize>
				
				if(myId == null){ 
					
					openAlert("로그인 해주세요"); 
					
					return;
				}
				
				if(isLimited()){
			    	 
					openAlert("채팅방 생성 기능이 제한되어 있습니다");
			    	
					return;
			    }
				
				var chatRoomData = {   
										roomOwnerId : myId,
										roomOwnerNick : myNickName,
										chat_type : 1,
										headCount : chosenUser.length + 1
								   };
				
				var chatMemberVoArray = new Array(chosenUser.length); 
				
			    for ( var i = 0; i < chosenUser.length; i++) {
		        	
					 var chatMemberData = {
							
											chat_memberId : $(chosenUser[i]).data("user_id"),
											chat_memberNick : $(chosenUser[i]).data("nick_name")
									  	};
					
					 chatMemberVoArray[i] = chatMemberData;
		        }
									
				var commonData = { 
									chatRoomVO : chatRoomData,
									chatMemberVoArray : chatMemberVoArray
					 			 };
				
				commonService.createMultiChat(commonData,  
						
				   		function(result, status){
							
							if(status == "success"){ 
								
								closeUserList();
								
								var popupX = (window.screen.width / 2) - (400 / 2);
		
								var popupY= (window.screen.height /2) - (500 / 2);
								
								window.open('/chatRoom/'+result+'?userId='+myId+'&chat_type=1', "title"+result, 'height=500, width=400, screenX='+ popupX + ', screenY= '+ popupY);
							}
				    	},
					    
				    	function(status){
				    	
							if(status == "error"){ 
								
								openAlert("Server Error(관리자에게 문의해주세요)");
							}
				    	}
			   	);
		}
		
		$(document).on("click",".multiChat", function(event){ 
			
			<sec:authorize access="isAuthenticated()">   
				var myId = '${userInfo.username}';  
			</sec:authorize>
			
			if(myId == null){ 
				
				openAlert("로그인 해주세요"); 
				
				return;
			}
			
			var chatroom_num = $(this).data("chatroom_num");
			
			var popupX = (window.screen.width / 2) - (400 / 2);
			
			var popupY= (window.screen.height /2) - (500 / 2);
			
			window.open('/chatRoom/'+chatroom_num+'?userId='+myId+'&chat_type=1', "title"+chatroom_num, 'height=500, width=400, screenX='+ popupX + ', screenY= '+ popupY);
		});
		
		function openUserList(){
			
			backGround.css("display","block");
			userListWrap.css("display","block");
			
			getChatUserList( showChatUserList, showError );
		} 
		
		function closeUserList(){
			
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
		
		function getChatUserList(callback, error, keyword ) {
			
			$.ajax({
				type : 'get', 
				url : '/getChatUserList?keyword='+keyword, 
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
		
		function search(obj, maxByte){
			
			checkInputVal(obj,30);
			getChatUserList( showChatUserList, showError, obj.value );
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
		
		function showError(status){
	    	
			if(status == "error"){ 
				
				openAlert("Server Error(관리자에게 문의해주세요)");
			}
    	}
		
		function showChatUserList(chatUserList, status){
			
			if(status == "success"){
				
				var length = chatUserList.length;
				var userList = $("#userList");
				var str = "";
				var nickName; 
				var userId; 
				
				for (var i = 0; i < length || 0; i++){
					
				       nickName = chatUserList[i].nickName; 
				       userId = chatUserList[i].userId;
				      
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
		
		function getChatRoomList(userId, callback, error){
			
			$.ajax({
				type : 'get', 
				url : '/getChatRoomList?userId='+userId,
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
		
		function reChatRoomList(){
			
				getChatRoomList('${userInfo.username}', function(result, status){
					
					if(status == "success"){
						
						var str =""; 
						
						for (var i = 0; i < result.length; i++) {
							
							var chat_type = result[i].chatRoomVo.chat_type;
							var chatRoomNum = result[i].chatRoomVo.chatRoomNum;
							
							if(chat_type == 0){
								
								var chat_nickname = result[i].chatReadVoList[0].chat_memberNick;
								var chat_memberId = result[i].chatReadVoList[0].chat_memberId;
								var chat_type_name = 'singleChat';
								
								str += "<div class='listContent "+ chat_type_name+"' id='"+chatRoomNum+"' data-chat_nickname='"+chat_nickname+"' data-chat_userid='"+chat_memberId+"'>";
								
							}else if(chat_type == 1){
								
								var chat_type_name = 'multiChat';
								
								str += "<div class='listContent "+ chat_type_name+"' id='"+chatRoomNum+"' data-chatroom_num='"+chatRoomNum+"'>";
							}
							
							str +=  "<div class='firstWrap'>";
							
							if(result[i].chatRoomVo.chat_type == 0){
									
									var userId = result[i].chatReadVoList[0].chat_memberId;
								
									if(serverName == 'localhost'){ 
										
			 							   str += "<img src='/resources/img/profile_img/"+userId+".png?"+random+"' class='singleMemberImage' onerror='this.src=\"/resources/img/profile_img/basicProfile.png\"'/>"
												   
								    }else{
								    	
										   str += "<img src='/upload/"+userId+".png?"+random+"' class='singleMemberImage' onerror='this.src=\"/resources/img/profile_img/basicProfile.png\"'/>"
								    }
									
							}else if(result[i].chatRoomVo.chat_type == 1){
									
									var length = result[i].chatReadVoList.length;
								
									if(serverName == 'localhost'){ 
										
											if(length > 3){
												
												for (var j = 0; j < 4; j++){
													
													 var userId = result[i].chatReadVoList[j].chat_memberId;
													
													 str += " <img src='/resources/img/profile_img/"+userId+".png?"+random+"' class='multiMemberImage' onerror='this.src=\"/resources/img/profile_img/basicProfile.png\"'/>"		
													
												}
												
											}else{
												
												for (var j = 0; j < result[i].chatReadVoList.length; j++){
													
													 var userId = result[i].chatReadVoList[j].chat_memberId;
													
													 str += " <img src='/resources/img/profile_img/"+userId+".png?"+random+"' class='multiMemberImage' onerror='this.src=\"/resources/img/profile_img/basicProfile.png\"'/>"		
													
												}
											}
												   
								    }else{
								    	
											if(length > 3){
												
												for (var j = 0; j < 4; j++){
													
										    		var userId = result[i].chatReadVoList[j].chat_memberId;
													
													str += " <img src='/upload/"+userId+".png?"+random+"' class='multiMemberImage' onerror='this.src=\"/resources/img/profile_img/basicProfile.png\"'/>"
												}
												
											}else{
												
												for (var j = 0; j < result[i].chatReadVoList.length; j++){
													
													 var userId = result[i].chatReadVoList[j].chat_memberId;
													
													 str += " <img src='/upload/"+userId+".png?"+random+"' class='multiMemberImage' onerror='this.src=\"/resources/img/profile_img/basicProfile.png\"'/>"		
												}
											}
								    }
							}
							
							str += "</div>";//firstWrap
							
							str += " <div class='secondWrap'>";
							
								str += "<div class='chatNick'>";
								
								if(result[i].chatRoomVo.chat_type == 0){
									
									str += result[i].chatReadVoList[0].chat_memberNick;
									
								}else if(result[i].chatRoomVo.chat_type == 1){
									
									if(result[i].chatRoomVo.chat_title != null){
										
										str += result[i].chatRoomVo.chat_title;
										
									}else{
										
										for (var j = 0; j < result[i].chatReadVoList.length; j++){
											
											if(j == result[i].chatReadVoList.length-1){
												
												str += result[i].chatReadVoList[j].chat_memberNick;
												
											}else{
												
												str += result[i].chatReadVoList[j].chat_memberNick+", ";	
											}
										}
									}
								}
								
								str += "</div>";//chatNick
								
								str += " <div class='memberCount'>";
									
									if(result[i].chatRoomVo.chat_type == 1){
										
										str += "(" + result[i].chatRoomVo.headCount + ")";
									}
	
								str += "</div>";//memberCount
										
								str += "<div class='chatContent'>";
										str += result[i].chatContentVo.chat_content;
								str += "</div>";//chatContent
								
							str += "</div>";//secondWrap
							 
							str += "<div class='thirdWrap'>";
								
								str += "<div class='chatDate'>";
								
								var nowTime = new Date();
								var lastChatTime = new Date(result[i].chatContentVo.regDate); 
								var chatDate;
								
								if(nowTime.getDate() == lastChatTime.getDate()){
								
									chatDate = commonService.displayDayTime(result[i].chatContentVo.regDate);
								
								}else{
									
									chatDate = commonService.displayYearMonthTime(result[i].chatContentVo.regDate);	
								}
								
								str += chatDate;
								
								str += "</div>";//chatDate
								
								if(result[i].notReadCnt != 0){
									
									str += "<div class='chatCnt'>";
										
										str +=  result[i].notReadCnt;
											
									str += "+</div>";//chatCnt
								}
								
							str += "</div></div>";//thirdWrap
						}
						
						$(".chatList").html(str);
					}
		    	},
		    
		    	function(status){
		    	
					if(status == "error"){ 
						
						openAlert("Server Error(관리자에게 문의해주세요)");
					}
		    	}
			);
		}
		
</script>
</html>