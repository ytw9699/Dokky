<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %> 

<!DOCTYPE html>
<html>
<head> 
<meta charset="UTF-8">
	<title>Dokky - 유저 등록 댓글</title>   
	<link href="/dokky/resources/css/userReplylist.css" rel="stylesheet" type="text/css"/>
</head>
<%@include file="../includes/left.jsp"%> 
<body>
<sec:authentication property="principal" var="userInfo"/>
<div class="userReplyWrap">	
	<div class="ContentWrap">
		<div id="menuWrap">
			<div class="tab">  
				<button onclick="location.href='/dokky/admin/userForm?userId=${pageMaker.cri.userId}'">유저 개인정보</button> 
		        <button onclick="location.href='/dokky/admin/userCashHistory?userId=${pageMaker.cri.userId}'">유저 캐시내역</button>
		        <button onclick="location.href='/dokky/userBoardList?userId=${pageMaker.cri.userId}&pageLocation=admin'">유저 활동</button>
			   <h1>${pageMaker.cri.userId} 유저 </h1>    
		    </div>
		</div>
		<div id="menuWrap">
			<div class="tab"> 
		        <button onclick="location.href='/dokky/userBoardList?userId=${pageMaker.cri.userId}&pageLocation=admin'">등록 게시글 ${boardTotal}개</button>
			    <button onclick="location.href='/dokky/userReplylist?userId=${pageMaker.cri.userId}&pageLocation=admin'">등록 댓글  ${replyTotal}개 </button>  
		    </div>  
		</div>
	<div class="listWrapper">
		<div class="">
			<table class=""> 
				<c:forEach items="${userReply}" var="Reply">
					<tr>
						<td class="replyTitle"><a class='move' href='<c:out value="${Reply.board_num}"/>'> 
							<c:out value="${Reply.reply_content}" /></a></td> 
					   <td> 
							<fmt:formatDate value="${Reply.replyDate}" pattern="yyyy-MM-dd HH:mm" />
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
	<form id='actionForm' action="/dokky/userReplylist" method='get'>  
		<input type='hidden' name='pageNum' value='${pageMaker.cri.pageNum}'>
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