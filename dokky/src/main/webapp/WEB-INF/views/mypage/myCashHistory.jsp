<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %> 

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>Dokky - 캐시내역보기</title> 
	<c:choose>
	   	  <c:when test="${pageContext.request.serverName == 'localhost'}">
				<link href="/resources/css/myCashHistory.css" rel="stylesheet" type="text/css"/>
		  </c:when>
	      <c:otherwise>
	    		<link href="/ROOT/resources/css/myCashHistory.css" rel="stylesheet" type="text/css"/>
	      </c:otherwise>
	</c:choose>
</head>
<%@include file="../includes/common.jsp"%>
<body>
<sec:authentication property="principal" var="userInfo"/>
<div class="mycashHisWrap">	

	<div id="menuWrap">
		<div class="tab"> 
			<button onclick="location.href='myInfoForm?userId=${userInfo.username}'">개인정보 변경</button>
	        <button onclick="location.href='myBoardList?userId=${userInfo.username}'">나의 게시글</button> 
	        <button onclick="location.href='myReplylist?userId=${userInfo.username}'">나의 댓글</button> 
	        <button onclick="location.href='myScraplist?userId=${userInfo.username}'">나의 스크랩</button>
	        <button class="active" onclick="location.href='myCashInfo?userId=${userInfo.username}'">나의 캐시</button>
	        <button onclick="location.href='myWithdrawalForm?userId=${userInfo.username}'">탈퇴 하기</button>
	    </div> 
	</div>
	
	<div class="listWrapper">
			<table id="inforTable"> 
					<tr>
						<td class="topTd">종류</td>
						<td class="topTd">금액</td>
						<td class="topTd">내역</td>
						<td class="topTd content">상세내용</td>
						<td class="topTd">날짜</td>
					</tr>
				<c:forEach items="${myCashHistory}" var="History">
					<tr>
						<td class="td">
							<div class="tdData">  
										<c:out value="${History.cashKind}" />
							</div>
						</td>
				    <c:if test="${History.cashKind == '기부하기' || History.cashKind == '환전'}">
						<td class="td">
							<div class="tdData">  
										-<c:out value="${History.cashAmount}" />원
							</div>
						</td>
					</c:if>  
					<c:if test="${History.cashKind == '기부받기' || History.cashKind == '충전'}">
						<td class="td">
							<div class="tdData">  
										+<c:out value="${History.cashAmount}" />원
							</div>
						</td>
					</c:if>
						
					<c:choose>
					       <c:when test="${History.cashKind == '충전' || History.cashKind == '환전'}">
					          	<td class="td">
						          	<div class="tdData">  
										<c:out value="${History.specification}" />
									</div>
					          	</td>
					          	<td class="td">
					          	</td>
					       </c:when>
					       <c:when test="${History.cashKind == '기부하기' || History.cashKind == '기부받기'}">
				       			  <c:if test="${History.specification == '게시판'}">
				       			  		<td class="td">
					       			  		<div class="tdData">  
												<c:out value="${History.specification}" />
											</div>
				       			  		</td>
				       			  		<td class="td">
				       			  			<div class="tdData">  
												<a href="/board/get?board_num=${History.board_num}"><c:out value="${History.title}" /></a>
											</div>
				       			  		</td>
				       			  </c:if>
				       			  <c:if test="${History.specification == '댓글'}">
				       			  		<td class="td">
				       			  			<div class="tdData">  
												<c:out value="${History.specification}" />
											</div>
				       			  		</td>
				       					<<td class="td">
				       						<div class="tdData">  
												<a href="/board/get?board_num=${History.board_num}"><c:out value="${History.reply_content}" /></a>
											</div>
				       					</td>
				       			  </c:if>
					       </c:when>
			       </c:choose>
			     		<td class="td"> 
			     			<div class="tdData">  
								<fmt:formatDate value="${History.regDate}" pattern="yyyy-MM-dd HH:mm" />
							</div>
						</td>
				   </tr> 
				</c:forEach>
			</table>
		
			<form id='actionForm' action="/mypage/myCashHistory" method='get'>  
				<input type='hidden' name='pageNum' value='${pageMaker.cri.pageNum}'><!--  $(this).attr("href") -->
				<input type='hidden' name='amount' value='${pageMaker.cri.amount}'>
				<input type='hidden' name='userId' value='${pageMaker.cri.userId}'>
			</form> 
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
				<li class="paginate_button next"><a
					href="${pageMaker.endPage +1 }">Next</a>
				</li>
			</c:if>
		</ul>
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
			actionForm.attr("action","/board/get");
			actionForm.submit();   
		});
	 
</script>
	
</body>
</html>