<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %> 

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>Dokky - 계정관리</title>
<c:choose>
  	  <c:when test="${pageContext.request.serverName == 'localhost'}">
			<link href="/resources/css/userList.css" rel="stylesheet" type="text/css"/>
  	 </c:when>
     <c:otherwise>
   			<link href="/ROOT/resources/css/userList.css" rel="stylesheet" type="text/css"/>
     </c:otherwise>
</c:choose>
</head> 
<%@include file="../includes/left.jsp"%>
<body> 
	<div class="memberListWrap">	 
	 
		 <div id="menuWrap"> 
				<div class="tab">      
					<button class="active" onclick="location.href='/admin/userList'">계정관리</button>
					<button onclick="location.href='/admin/cashRequest'">결제관리</button> 
					<button onclick="location.href='/admin/userReportList'">신고관리</button>
			    </div>
		 </div>    
		  
		 <div class="searchWrapper">  
			<form id='searchForm' action="/admin/userList" method='get'>
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
			<c:forEach items="${userList}" var="user">
				<div class="memberInfoWrap" onclick="location.href='userForm?userId=<c:out value="${user.userId}" />'" >
					<div class="memberProfile">
						<c:choose>
						  	  <c:when test="${pageContext.request.serverName == 'localhost'}">
									<img src="/upload/<c:out value="${user.userId}"/>.png?${random}" id="memberProfile" onerror="this.src='/resources/img/profile_img/basicProfile.png'" />
						  	 </c:when>
						     <c:otherwise>
						   			<img src="/upload/<c:out value="${user.userId}"/>.png?${random}" id="memberProfile" onerror="this.src='/ROOT/resources/img/profile_img/basicProfile.png'" />
						     </c:otherwise>
						</c:choose>
					</div>		 		 												 									
					<div class="memberInfo">
						<span class="nickName"><c:out value="${user.nickName}" /></span><br/>
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
		 
		 <form id='actionForm' action="/admin/userList" method='get'>  
			<input type='hidden' name='pageNum' value='${pageMaker.cri.pageNum}'>
			<input type='hidden' name='amount' value='${pageMaker.cri.amount}'>
			<input type='hidden' name='type' value='<c:out value="${ pageMaker.cri.type }"/>'> 
			<input type='hidden' name='keyword' value='<c:out value="${ pageMaker.cri.keyword }"/>'>
		 </form>  
		 
	</div> 
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script> 
	<script>
		   		
	   		var actionForm = $("#actionForm");

			$(".paginate_button a").on("click", function(e) {//페이징관련
		
						e.preventDefault();
		
						actionForm.find("input[name='pageNum']").val($(this).attr("href"));
						
						actionForm.submit();
					});

	</script>
</body>
</html>