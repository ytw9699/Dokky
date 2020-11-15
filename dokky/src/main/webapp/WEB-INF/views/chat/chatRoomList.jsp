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
				<div class="listContent singleChat" id="${chatRoomDTO.chatRoomVo.chatRoomNum}" data-chatroom_num="${chatRoomDTO.chatRoomVo.chatRoomNum}" data-chat_nickname="${chatRoomDTO.chatReadVoList[0].chat_memberNick}" data-chat_userid="${chatRoomDTO.chatReadVoList[0].chat_memberId}">
					<div class="firstWrap">
						<c:if test="${chatRoomDTO.chatRoomVo.chat_type == 0 }"> <!-- 1:1채팅방 이라면 -->
							<c:choose>
								   	  <c:when test="${pageContext.request.serverName == 'localhost'}"> 
										 	<img src="/resources/img/profile_img/<c:out value="${chatRoomDTO.chatReadVoList[0].chat_memberId}"/>.png?${random}" class="listMemberImage" onerror="this.src='/resources/img/profile_img/basicProfile.png'"/>
									  </c:when> 
								      <c:otherwise> 
								    		<img src="/upload/<c:out value="${chatRoomDTO.chatReadVoList[0].chat_memberId}"/>.png?${random}" class="listMemberImage" onerror="this.src='/ROOT/resources/img/profile_img/basicProfile.png'" />
								      </c:otherwise>
							</c:choose>
						</c:if>
					</div>
					<div class="secondWrap"> 
						<div class="chatNick">
							${chatRoomDTO.chatReadVoList[0].chat_memberNick}
						</div>
						<div class="chatContent">
					        <c:choose>
							        <c:when test="${fn:length(chatRoomDTO.chatContentVo.chat_content) gt 40}">
							        	<c:out value="${fn:substring(chatRoomDTO.chatContentVo.chat_content, 0, 39)}"/>...
							        </c:when>
							        <c:otherwise>
								        ${chatRoomDTO.chatContentVo.chat_content}
							        </c:otherwise>
							</c:choose>
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
				<input id="search" type='text' oninput="checkLength(this,30)" placeholder="회원검색" autofocus/> 
			</div>
			<div id="userList">
				<!-- 회원리스트 -->
			</div>
			<div id="buttonWrap">
				<div id="chatInviteWrap">
					<input type="button" id="chatInvite" value="초대" />	
				</div>
				<div id="chatCancelWrap">
					<input type="button" id="chatCancel" value="취소" />				
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
			openUserList();
   		}); 
		
		$("#chatCancel").on("click", function(event){
			
			closeUserList();	
		});
		
		$("#chatInvite").on("click", function(event){
			
			var chosenUser = $(".chosenUser").get();
	   		
	        for ( var i = 0; i < chosenUser.length; i++) {
				var user_id = $(chosenUser[i]).data("user_id");
				var nick_name = $(chosenUser[i]).data("nick_name");
				
				console.log(user_id);
				console.log(nick_name);
	        }
		});
		
		
		function openUserList(){
			
			backGround.css("display","block");
			userListWrap.css("display","block");
			
			getChatUserList( 
					
					function(chatUserList, status){
						
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
										
										str += "<span id='user"+user_id+"' class='chosenUser' data-user_id='"+user_id+"' data-nick_name='"+nick_name+"'>"+nick_name;
										
									}else{
										
										str += "<span id='user"+user_id+"' class='chosenUser' data-user_id='"+user_id+"' data-nick_name='"+nick_name+"'>, "+nick_name;
									}
							   	    	str +=  "</span>";
									
							   		chosenMembers.html(str);
							   	
							});
						}
			    	},
			 
			    	function(status){
			    	
						if(status == "error"){ 
							
							openAlert("Server Error(관리자에게 문의해주세요)");
						}
			    	}
			);
		} 
		
		function closeUserList(){
			
			backGround.css("display","none");
			userListWrap.css("display","none");
			
			var chosenMembers = $("#chosenMembers");
			
			chosenMembers.html("");//선택한 멤버 초기화
		}
		
		function getChatUserList(callback, error) {
			
			$.ajax({
				type : 'get', 
				url : '/getChatUserList', 
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