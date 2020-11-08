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
      			<button id="chatBtn" type="button">새로운 채팅</button>
     		 </span>
	    </div>
		<div class="chatList">
			<c:forEach items="${chatRoomList}" var="chatRoomDTO">
				<div class="listContent" id="${chatRoomDTO.chatRoomVo.chatRoomNum}" data-chatroom_num="${chatRoomDTO.chatRoomVo.chatRoomNum}">
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
</body>

<script>

		var webSocketChat;
		var chatRoomId;
		var csrfHeaderName ="${_csrf.headerName}"; 
		var csrfTokenValue="${_csrf.token}";
		
		<sec:authorize access="isAuthenticated()">   
		  myId = '${userInfo.username}';  
		  myNickName = '${userInfo.member.nickName}';
		</sec:authorize>
		   
		$(document).ajaxSend(function(e, xhr, options){
			
		     xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
	    });
		
</script>

</html>