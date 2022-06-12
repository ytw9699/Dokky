<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %> 

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>Dokky - 신고관리</title> 
	<c:choose>
	  	  <c:when test="${pageContext.request.serverName == 'localhost'}">
				<link href="/resources/css/userReportList.css" rel="stylesheet" type="text/css"/>
	  	 </c:when>
	     <c:otherwise>
	   			<link href="/ROOT/resources/css/userReportList.css" rel="stylesheet" type="text/css"/>
	     </c:otherwise>
	 </c:choose>
</head> 

<%@include file="../includes/common.jsp"%>
<body> 
	<div class="userReporWrap">	 
	 
		 <div id="menuWrap"> 
			<div class="tab">   
		        <button onclick="location.href='userList'">계정관리</button> 
		        <button onclick="location.href='cashRequestList'">캐시관리</button> 
		        <button class="active" onclick="location.href='userReportList'">신고관리</button> 
		    </div> 
		 </div> 
		 
		 <div class="listWrapper">
			<table id="inforTable">
					<tr>
						<td class="topTd kind">종류</td> 
						<td class="topTd">신고 한 회원</td>
						<td class="topTd">신고받은 회원</td>
						<td class="topTd reason">사유</td>
						<td class="topTd gap"></td>  
						<td class="topTd">신고날짜</td>
					</tr>
						<c:forEach items="${userReportList}" var="report">
					<tr>  
						<td class="td">
							<c:out value="${report.reportKind}" />
						</td>   
						<td class="td">
							<a href='userForm?userId=<c:out value="${report.reportingId}"/>'> 
							  <c:choose>
							  	  <c:when test="${pageContext.request.serverName == 'localhost'}">
										<img src="/resources/img/profile_img/<c:out value="${report.reportingId}"  />.png?${random}"  class="memberImage" onerror="this.src='/resources/img/profile_img/basicProfile.png'" />
							  	 </c:when>
							     <c:otherwise>
							   			<img src="/upload/<c:out value="${report.reportingId}" />.png?${random}"  class="memberImage" onerror="this.src='/ROOT/resources/img/profile_img/basicProfile.png'" />
							     </c:otherwise>
							  </c:choose>
							  <c:out value="${report.reportingNick}" /> 
							  <%-- (<c:out value="${report.reportingId}" />) --%>
							</a> 
						</td>
						<td class="td">
							<a href='userForm?userId=<c:out value="${report.reportedId}"/>'> 
							  <c:choose>
							  	  <c:when test="${pageContext.request.serverName == 'localhost'}">
										<img  src="/resources/img/profile_img/<c:out value="${report.reportingId}"  />.png?${random}"  class="memberImage" onerror="this.src='/resources/img/profile_img/basicProfile.png'" />
							  	 </c:when>
							     <c:otherwise>
							   			<img src="/upload/<c:out value="${report.reportedId}" />.png?${random}"  class="memberImage" onerror="this.src='/ROOT/resources/img/profile_img/basicProfile.png'" />
							     </c:otherwise>
							  </c:choose>
							  <c:out value="${report.reportedNick}" />
							  <%-- (<c:out value="${report.reportedId}" />) --%>
							</a> 
						</td> 
						<td class="td" id="reasonData">
							<a href='/board/get?board_num=<c:out value="${report.board_num}"/>'> 
							  <c:out value="${report.reason}" />
							</a>  
						</td> 
						<td class="td gap"></td>
						<td class="td">
							<fmt:formatDate value="${report.regDate}" pattern="yyyy-MM-dd HH:mm" />
						</td>  
					</tr>
				</c:forEach>
			</table>
		 </div>
		
		<form id='actionForm' action="/admin/userReportList" method='get'>  
			<input type='hidden' name='pageNum' value='${pageMaker.cri.pageNum}'>
			<input type='hidden' name='amount' value='${pageMaker.cri.amount}'>
		</form> 
			
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
		 
	</div>  
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script> 
	<script>
		   		
	   		var actionForm = $("#actionForm");

			$(".paginate_button a").on("click", function(e) {
		
						e.preventDefault();
		
						actionForm.find("input[name='pageNum']").val($(this).attr("href"));
						
						actionForm.submit();
					});

	</script>
</body>
</html>