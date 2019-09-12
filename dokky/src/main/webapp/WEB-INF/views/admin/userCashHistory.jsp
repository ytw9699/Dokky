<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %> 

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Dokky - 유저 캐시내역</title>
<link href="/dokky/resources/css/userCashHistory.css" rel="stylesheet" type="text/css"/>
</head>
<%@include file="../includes/left.jsp"%>
<body>
<sec:authentication property="principal" var="userInfo"/> 
<div class="userCashWrap">	
	<div class="ContentWrap">
		<div id="menuWrap"> 
			<div class="tab">    
				<button onclick="location.href='/dokky/admin/userForm?userId=${pageMaker.cri.userId}'">유저 개인정보</button> 
		        <button onclick="location.href='/dokky/admin/userCashHistory?userId=${pageMaker.cri.userId}'">유저 캐시내역</button>
		        <button onclick="location.href='/dokky/userBoardList?userId=${pageMaker.cri.userId}&pageLocation=admin'">유저 활동</button>
		    </div>  	    
		 </div>    
		 
	<div class="listWrapper"> 
		<div class="">
			<table class=""> 
			<tr>
				<td>종류</td>
				<td>금액</td>
				<td>상세내역</td>
				<td>내용</td>
				<td>날짜</td>
			</tr>
				<c:forEach items="${userCashHistory}" var="History">
					<tr>
						<td><c:out value="${History.cashKind}" /></td>
						 <c:if test="${History.cashKind == '기부하기' || History.cashKind == '환전'}">
							<td>-<c:out value="${History.cashAmount}" />원</td>
						</c:if>  
						<c:if test="${History.cashKind == '기부받기' || History.cashKind == '충전'}">
							<td>+<c:out value="${History.cashAmount}" />원</td>
						</c:if>
						
					<c:choose>
					       <c:when test="${History.cashKind == '충전' || History.cashKind == '환전'}">
					          	<td><c:out value="${History.specification}" /></td>
					          	<td></td>
					       </c:when>
					       <c:when test="${History.cashKind == '기부하기' || History.cashKind == '기부받기'}">
				       			  <c:if test="${History.specification == '게시판'}">
				       			  		<td><c:out value="${History.specification}" /></td>
				       			  		<td><a href="/dokky/board/get?board_num=${History.board_num}" class="content"><c:out value="${History.title}" /></a></td>
				       			  </c:if>
				       			  <c:if test="${History.specification == '댓글'}">
				       			  		<td><c:out value="${History.specification}" /></td>
				       					<td><a href="/dokky/board/get?board_num=${History.board_num}" class="content"><c:out value="${History.reply_content}" /></a></td>
				       			  </c:if>
					       </c:when>
			       </c:choose>
				         <td> 
							<fmt:formatDate value="${History.regDate}" pattern="yyyy년 MM월 dd일 HH:mm" />
						</td> 
					</tr>
				</c:forEach>
			</table>
		</div>
		
			<div class='pull-right'>
				<ul class="pagination">
					<c:if test="${pageMaker.prev}">
						<li class="paginate_button previous">
							<a href="${pageMaker.startPage -1}">Previous</a>
						</li>
					</c:if>

					<c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
						<li class="paginate_button  ${pageMaker.cri.pageNum == num ? "active":""} ">
							<a href="${num}">${num}</a>
						</li> 
					</c:forEach>

					<c:if test="${pageMaker.next}">
						<li class="paginate_button next"><a
							href="${pageMaker.endPage +1 }">Next</a>
						</li>
					</c:if>
				</ul>
			</div>
	<form id='actionForm' action="/dokky/admin/userCashHistory" method='get'>  
		<input type='hidden' name='pageNum' value='${pageMaker.cri.pageNum}'><!--  $(this).attr("href") -->
		<input type='hidden' name='amount' value='${pageMaker.cri.amount}'>
		<input type='hidden' name='userId' value='${pageMaker.cri.userId}'>
	</form> 
		</div>
	</div>
</div> 
	
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script> 
<script> 
	   
	var actionForm = $("#actionForm");

		$(".paginate_button a").on("click", function(e) {//결국pageNum값만 바꿔주기 위해
	
					e.preventDefault();
	
					actionForm.find("input[name='pageNum']").val($(this).attr("href"));//pageNum값을 바꿔주는것//this는 a태그의 href값을 가져오는것
					
					actionForm.submit();
				});
	
		$(".move").on("click",function(e) {
			
			e.preventDefault(); 
			actionForm.append("<input type='hidden' name='board_num' value='"+ $(this).attr("href")+ "'>");
			actionForm.attr("action","/dokky/board/get");
			actionForm.submit();   
		});
	 
</script>
	
</body>
</html>