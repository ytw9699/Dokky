<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %> 

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>Dokky - 권한부여관리</title>
<link href="/ROOT/resources/css/authorizationList.css" rel="stylesheet" type="text/css"/>
</head> 
<%@include file="../includes/left.jsp"%>
<c:set var="random"><%= java.lang.Math.round(java.lang.Math.random() * 123456) %></c:set>
<body> 
	<div class="memberListWrap">	 
	 
		 <div id="menuWrap"> 
				<div class="tab">      
					<button class="active" onclick="location.href='/admin/authorizationList'">관리자 권한관리</button> 
			    </div>
		 </div>    
		  
		 <div class="searchWrapper">  
			<form id='searchForm' action="/admin/authorizationList" method='get'>
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
						<img src="/upload/<c:out value="${user.userId}"/>.png?${random}" id="memberProfile" onerror="this.src='/ROOT/resources/img/profile_img/basicProfile.png'" />
					</div>		 		 												 									
					<div class="memberInfo">
						<span class="nickName"><c:out value="${user.nickName}" /></span>
						<c:choose>
		     				<c:when test="${user.authList[0].auth == 'ROLE_USER'}"> 
								<button class="authorization" data-user_id="${user.userId}">회원</button>
							</c:when>
							<c:when test="${user.authList[0].auth == 'ROLE_ADMIN'}">
								<button class="authorization admin" data-user_id="${user.userId}">관리자</button>
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
		 
		 <form id='actionForm' action="/admin/authorizationList" method='get'>  
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
			
			$(document).ajaxSend(function(e, xhr, options) { 
			    xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
			  });
	
			function updateRoleUser(userId, callback, error) {//권한 ROLE_USER로 변경
	   			$.ajax({
	   				type : 'put',
	   				url : '/admin/roleUser/'+ userId,
	   				success : function(result, status, xhr) {
	   					if (callback) {
	   						callback(result,xhr);
	   					}
	   				},
	   				error : function(xhr, status, er) {
	   					if (error) {
	   						error(xhr,er);
	   					}
	   				}
	   			});
	   		}
			
			function updateRoleAdmin(userId, callback, error) {//권한 ROLE_ADMIN로 변경
	   			$.ajax({
	   				type : 'put',
	   				url : '/admin/roleAdmin/'+ userId,
	   				success : function(result, status, xhr) {
	   					if (callback) {
	   						callback(result,xhr);
	   					}
	   				},
	   				error : function(xhr, status, er) {
	   					if (error) {
	   						error(xhr,er);
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
					
					updateRoleUser(userId, function(result){
						
						authButton.html("사용자");
						
						authButton.attr('class','authorization'); 

						openAlert("사용자 계정으로 변경 완료");
						
				   	  }); 
					
				}else if((auth == '사용자')){
					
					updateRoleAdmin(userId, function(result){ 
						
						authButton.html("관리자");
						
						authButton.attr('class','authorization admin'); 
						
						openAlert("관리자 계정으로 변경 완료");				   	
			   	  	})
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