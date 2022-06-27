<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %> 

<!DOCTYPE html>
<html>
<head> 
<meta charset="UTF-8">
	<title>Dokky - 회원 등록 댓글</title>   
	<c:choose>
	  	  <c:when test="${pageContext.request.serverName == 'localhost'}">
				<link href="/resources/css/admin/userReplylist.css" rel="stylesheet" type="text/css"/>
	  	 </c:when>
	     <c:otherwise>
	   			<link href="/ROOT/resources/css/admin/userReplylist.css" rel="stylesheet" type="text/css"/>
	     </c:otherwise>
	 </c:choose>
</head>
<%@include file="../includes/common.jsp"%> 
<body>
<sec:authentication property="principal" var="userInfo"/>

<div class="userReplyWrap">	

		<div id="menuWrap">
			<div class="tab">  
				<button onclick="location.href='/admin/userForm?userId=${pageMaker.cri.userId}'">회원 개인정보</button> 
		        <button onclick="location.href='/admin/userCashHistory?userId=${pageMaker.cri.userId}'">회원 캐시내역</button>
		        <button class="active" onclick="location.href='/userBoardList?userId=${pageMaker.cri.userId}&pageLocation=admin'">회원 활동</button>
		    </div>
		</div> 
		
		<div class="listWrapper">
			<div id="secondMenuWrap">
				<div class="tab"> 
			        <button onclick="location.href='/userBoardList?userId=${pageMaker.cri.userId}&pageLocation=admin'">등록 게시글 ${boardTotal}개</button>
				    <button class="active" onclick="location.href='/userReplylist?userId=${pageMaker.cri.userId}&pageLocation=admin'">등록 댓글  ${replyTotal}개 </button>  
			    </div>  
			</div>
			
			<table id="inforTable"> 
				<c:forEach items="${userReplylist}" var="Reply">
					<tr>
						<td class="replyTitle">
					         <c:choose>
							         <c:when test="${fn:length(Reply.reply_content) gt 40}">
								        <a class='move' href='<c:out value="${Reply.board_num}"/>'> 
											<c:out value="${fn:substring(Reply.reply_content, 0, 40)}"/>.....
										</a> 
							         </c:when>
							        <c:otherwise>
								        <a class='move' href='<c:out value="${Reply.board_num}"/>'> 
								        	<c:out value="${Reply.reply_content}"/>
							        	</a> 
							        </c:otherwise>
							</c:choose>
						</td> 
					    <td id="dateTd"> 
							<fmt:formatDate value="${Reply.replyDate}" pattern="yyyy-MM-dd HH:mm" />
						</td>
					</tr> 
				</c:forEach>
			</table>
		</div>
				
		<form id='actionForm' action="/userReplylist" method='get'>  
			<input type='hidden' name='pageNum' value='${pageMaker.cri.pageNum}'>
			<input type='hidden' name='amount' value='${pageMaker.cri.amount}'>
			<input type='hidden' name='userId' value='${pageMaker.cri.userId}'>
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
					actionForm.append("<input type='hidden' name='pageLocation' value='admin'>");
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