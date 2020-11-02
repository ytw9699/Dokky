<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ include file="../includes/common.jsp"%>
<c:set var="random"><%= java.lang.Math.round(java.lang.Math.random() * 123456) %></c:set>

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
		<c:forEach items="${chatRoomList}" var="chatRoomDTO">
			<div>
				${chatRoomDTO.chatRoomVo.chatRoomNum}번방 
				<c:if test="${chatRoomDTO.chatRoomVo.chat_type == 0 }"> <!-- 1:1채팅방 이라면 -->
					<c:choose>
						   	  <c:when test="${pageContext.request.serverName == 'localhost'}"> 
								 	<img src="/resources/img/profile_img/<c:out value="${chatRoomDTO.chatReadVoList[0].chat_memberId}"/>.png?${random}" class="memberImage" onerror="this.src='/resources/img/profile_img/basicProfile.png'"/>
							  </c:when> 
						      <c:otherwise> 
						    		<img src="/upload/<c:out value="${chatRoomDTO.chatReadVoList[0].chat_memberId}"/>.png?${random}" class="memberImage" onerror="this.src='/ROOT/resources/img/profile_img/basicProfile.png'" />
						      </c:otherwise>
					</c:choose>
					${chatRoomDTO.chatReadVoList[0].chat_memberNick}
				</c:if>
					 ${chatRoomDTO.chatContentVo.chat_content}
					 <fmt:formatDate value="${chatRoomDTO.chatContentVo.regDate}" pattern="yyyy/MM/dd/HH:mm:ss"/>
				<c:if test="${chatRoomDTO.notReadCnt != 0 }">
				 	${chatRoomDTO.notReadCnt}읽지않음
				</c:if>
			</div>
		</c:forEach>
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