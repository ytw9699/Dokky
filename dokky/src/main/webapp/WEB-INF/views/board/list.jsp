<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Dokky</title>
<style>
	body{
		background-color: #323639; 
	}
	.listWrapper { 
	    border-color: #e6e6e6;/* 흰색 */
		border-style: solid;
		background-color: #323639; 
		color: #e6e6e6;
		margin-left: 15%;
		margin-top: 1%; 
	}
	.mypage a { 
    color: white;
}
.pagination { 
	    display: inline-block;
	    padding-left: 0;
	    margin: 20px 0;
	    border-radius: 4px;
	}  
	.pagination li {
   		display: inline;
	}
	.pagination li a{
   		color: #e6e6e6;  
	}
	.pull-right{
		width: 80%;
		border-color: #e6e6e6;/* 흰색 */
		border-style: solid;
	}
</style>
</head>
<%@include file="../includes/search.jsp"%>
<%@include file="../includes/left.jsp"%>
<body>
	<div class="listWrapper">
		<div class="">
			   <c:choose>
			       <c:when test="${pageMaker.cri.category == 1 }">
			          		 공지사항 
			       </c:when>
			       <c:when test="${pageMaker.cri.category == 2 }">
			       			  자유게시판
			       </c:when>
			        <c:when test="${pageMaker.cri.category == 3 }">
			     		 	  묻고답하기
			       </c:when>
			        <c:when test="${pageMaker.cri.category == 4 }">
			   		   	  	  칼럼/Tech
			       </c:when>
			       <c:when test="${pageMaker.cri.category == 5 }">
			   		   		  정기모임/스터디 
			       </c:when>
			        <c:when test="${pageMaker.cri.category == 6 }"> 
			   		   		    마이페이지
			       </c:when>
			       <%-- <c:otherwise>
			       </c:otherwise> --%>
		       </c:choose>
  	    </div>

		<div><button id='regBtn' type="button" class="">새 글쓰기</button></div> 
		
		<div class="">
			<table class=""> 
				<c:forEach items="${list}" var="board">
					<tr>
						<td class="mypage"><a class='move' href='<c:out value="${board.num}"/>'> 
							<c:out value="${board.title}" /></a></td> 
						<td>댓글수[<c:out value="${board.replyCnt}" />]</td>
						<td>조회수<c:out value="${board.hitCnt}" /></td>
						<td><c:out value="${board.nickName}" /></td>
			                  
						<td><fmt:formatDate pattern="yyyy-MM-dd-HH:mm"
								value="${board.regDate}" /></td>
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
	</div>
	
<form id='actionForm' action="/dokky/board/list" method='get'> 
	<input type='hidden' name='pageNum' value='${pageMaker.cri.pageNum}'><!--  $(this).attr("href") -->
	<input type='hidden' name='amount' value='${pageMaker.cri.amount}'>
	<input type='hidden' name='category' value='${pageMaker.cri.category}'>
	<input type='hidden' name='type' value='<c:out value="${ pageMaker.cri.type }"/>'> 
	<input type='hidden' name='keyword' value='<c:out value="${ pageMaker.cri.keyword }"/>'>
</form> 
	
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script>
	   
	$("#regBtn").on("click", function() { 
	
		self.location = "/dokky/board/register?category="+${pageMaker.cri.category};
	}); 
    
	
	var actionForm = $("#actionForm");

	$(".paginate_button a").on("click", function(e) {//결국pageNum값만 바꿔주기 위해

				e.preventDefault();//a태그 클릭해도 이동안되게 처리

				//console.log('click');

				actionForm.find("input[name='pageNum']").val($(this).attr("href"));//pageNum값을 바꿔주는것//this는 a태그의 href값을 가져오는것
				
				actionForm.submit();
			});
	
		$(".move").on("click",function(e) {
			
			e.preventDefault();
			actionForm.append("<input type='hidden' name='num' value='"+ $(this).attr("href")+ "'>");
			actionForm.attr("action","/dokky/board/get");
			actionForm.submit();   
		});
	 
		var searchForm = $("#searchForm");

		$("#searchForm button").on("click", function(e) {

					if (!searchForm.find("option:selected")
							.val()) {
						alert("검색종류를 선택하세요");
						return false;
					}

					if (!searchForm.find(
							"input[name='keyword']").val()) {
						alert("키워드를 입력하세요");
						return false;
					}

					searchForm.find("input[name='pageNum']")
							.val("1");
					
					e.preventDefault();

					searchForm.submit();
				});
</script>
	
</body>
</html>