<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %> 

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>Dokky - 권한부여관리</title>
<c:choose>
   	  <c:when test="${pageContext.request.serverName == 'localhost'}">
			<link href="/resources/css/authorizationList.css" rel="stylesheet" type="text/css"/>
	  </c:when>
      <c:otherwise>
    		<link href="/ROOT/resources/css/authorizationList.css" rel="stylesheet" type="text/css"/>
      </c:otherwise>
</c:choose>
</head> 
<%@include file="../includes/common.jsp"%>
<body> 
<sec:authentication property="principal" var="userInfo"/>

	<div class="memberListWrap">	 
	 
		 <div id="menuWrap"> 
				<div class="tab">      
					<button class="active" onclick="location.href='/superAdmin/authorizationList'">관리자 권한관리</button> 
			    </div>
		 </div>    
		  
		 <div class="searchWrapper">  
			<form id='searchForm' action="/superAdmin/authorizationList" method='get'>
				<select id="option" name='type'>
					<option value="N"
						<c:out value="${pageMaker.cri.type eq 'N'?'selected':''}"/>>닉네임</option>
					<option value="I" 
						<c:out value="${pageMaker.cri.type eq 'I'?'selected':''}"/>>아이디</option>
					<option value="IN"
						<c:out value="${pageMaker.cri.type eq 'IN'?'selected':''}"/>>아이디+닉네임</option>
				</select> 
							
				<input id="keyword" type='text' name='keyword' value='<c:out value="${pageMaker.cri.keyword}"/>' autofocus/> 
				<input type='hidden' name='pageNum' value='<c:out value="${pageMaker.cri.pageNum}"/>' /> 
				<input type='hidden' name='amount'  value='<c:out value="${pageMaker.cri.amount}"/>' />
						 
				<button id='search' class='btn btn-default'></button> 
			</form>
		 </div>
		 
		 <div class="infoWrap"> 
			<c:forEach items="${authorizationList}" var="user">
				<%-- <div class="memberInfoWrap" onclick="location.href='userForm?userId=<c:out value="${user.userId}" />'" > --%>
				<div class="memberInfoWrap">
					<div class="memberProfile">
						<%-- <img src="/resources/img/profile_img/<c:out value="${user.userId}"/>.png" id="memberProfile" onerror="this.src='/resources/img/profile_img/basicProfile.png'" /> --%>
						<c:choose>
						   	  <c:when test="${pageContext.request.serverName == 'localhost'}">
									<img src="/resources/img/profile_img/<c:out value="${user.userId}"  />.png?${random}" id="memberProfile" onerror="this.src='/resources/img/profile_img/basicProfile.png'" />
							  </c:when>
						      <c:otherwise>
						    		<img src="/upload/<c:out value="${user.userId}"/>.png?${random}" id="memberProfile" onerror="this.src='/ROOT/resources/img/profile_img/basicProfile.png'" />
						      </c:otherwise>
						</c:choose>
					</div>		 		 												 									
					<div class="memberInfo">
						<span class="nickName"><c:out value="${user.nickName}" /></span>
						<c:choose>
		     				<c:when test="${user.authList[0].auth == 'ROLE_USER'}"> 
								<button class="authorization" data-user_id="${user.userId}">사용자</button>
							</c:when>
							<c:when test="${user.authList[0].auth == 'ROLE_ADMIN'}">
								<button class="authorization admin" data-user_id="${user.userId}">관리자</button>
							</c:when>
							<c:when test="${user.authList[0].auth == 'ROLE_LIMIT'}"> 
								<button class="authorization admin" data-user_id="${user.userId}">제한계정</button> 
							</c:when>  
							<c:when test="${user.authList[0].auth == 'ROLE_STOP'}"> 
								<button class="authorization admin" data-user_id="${user.userId}">정지계정</button>
							</c:when>
							<c:when test="${user.authList[0].auth == 'ROLE_SUPER'}"> 
								<button class="authorization admin" data-user_id="${user.userId}">슈퍼관리자</button>
							</c:when>  
		     			</c:choose>
						<br/>  
						<span class="userId"><c:out value="${user.userId}" /></span>
					</div>
				</div>
			</c:forEach>
		 </div>
		 
		 <div class='pull-right'>
				<ul class="pagination">
					<c:if test="${pageMaker.prev}">
						<li class="paginate_button previous">
							<a href="${pageMaker.startPage -1}">Previous</a>
						</li>
					</c:if>

					<c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
						<li class="paginate_button  ${pageMaker.cri.pageNum == num ? "page_active":""} ">
							<a href="${num}">${num}</a>
						</li> 
					</c:forEach>

					<c:if test="${pageMaker.next}">
						<li class="paginate_button next"> 
							<a href="${pageMaker.endPage +1 }">Next</a>
						</li>
					</c:if> 
				</ul>
		 </div>
		 
		 <form id='actionForm' action="/superAdmin/authorizationList" method='get'>  
			<input type='hidden' name='pageNum' value='${pageMaker.cri.pageNum}'>
			<input type='hidden' name='amount' value='${pageMaker.cri.amount}'>
			<input type='hidden' name='type' value='<c:out value="${ pageMaker.cri.type }"/>'> 
			<input type='hidden' name='keyword' value='<c:out value="${ pageMaker.cri.keyword }"/>'>
		 </form>  
		 
	</div> 
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script> 
	<script>
			
			var csrfHeaderName ="${_csrf.headerName}"; 
			var csrfTokenValue="${_csrf.token}";
			var myId = '${userInfo.username}';  
			var myNickName = '${userInfo.member.nickName}';
			
			$(document).ajaxSend(function(e, xhr, options) { 
			    xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
			  });
	
			function updateRoleUser(userId, alarmData, callback, error) {//권한 ROLE_USER로 변경
	   			
				$.ajax({
	   				type : 'put',
	   				url : '/admin/roleUser/'+ userId,
	   				data : JSON.stringify(alarmData), 
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
			
			function updateRoleAdmin(userId, alarmData, callback, error) {//권한 ROLE_ADMIN로 변경
	   			
				$.ajax({
	   				type : 'put',
	   				url : '/admin/roleAdmin/'+ userId,
	   				data : JSON.stringify(alarmData), 
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
			
			$(".authorization").on("click",function(e){ 
				
				e.preventDefault();
			
				var authButton = $(this);
				
				var userId = authButton.data("user_id");
				
				var auth = authButton.html();
				
				if(auth == '관리자'){
					
						var alarmData = { 
												target:userId,  
												  kind:13, 
											writerNick:myNickName,
											  writerId:myId
								 		};
						 
						updateRoleUser(userId, alarmData,
								
								function(result, status){
								
									if(status == "success"){ 
										
										authButton.html("사용자");
										
										authButton.attr('class','authorization'); 
				
										openAlert("사용자 계정으로 변경 완료");
										
										if(webSocket != null && alarmData != null ){
									   		webSocket.send("sendAlarmMsg,"+alarmData.target);
									   	}
									}
					   	    	},
					   	    
					   	    	function(status){
					   	    	
									if(status == "error"){ 
										
										openAlert("Server Error(관리자에게 문의해주세요)");
									}
					   	    	}
						 ); 
					
				}else if((auth == '사용자')){
					
						var alarmData = { 
												target:userId,  
												  kind:14, 
											writerNick:myNickName,
											  writerId:myId
								 		};
						
				   		updateRoleAdmin(userId, alarmData,
								
								function(result, status){
								
									if(status == "success"){ 
										
										authButton.html("관리자");
										
										authButton.attr('class','authorization admin'); 
										
										openAlert("관리자 계정으로 변경 완료");		
										
										if(webSocket != null && alarmData != null ){
									   		webSocket.send("sendAlarmMsg,"+alarmData.target);
									   	}
									}
					   	    	},
					   	    
					   	    	function(status){
					   	    	
									if(status == "error"){ 
										
										openAlert("Server Error(관리자에게 문의해주세요)");
									}
					   	    	}
						 ); 
				   	  	
				}else{
					
					openAlert("이 계정은 변경 할 수 없습니다");
				}
		   	});
			
			var actionForm = $("#actionForm");  
	   		
			$(".paginate_button a").on("click", function(e) {//페이징관련
		
					e.preventDefault();
	
					actionForm.find("input[name='pageNum']").val($(this).attr("href"));
					
					actionForm.submit();
			});
	   		

	</script>
</body>
</html>