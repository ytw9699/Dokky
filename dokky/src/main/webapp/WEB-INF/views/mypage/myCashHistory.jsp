<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %> 

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
		margin-left: 1%;
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
		.bodyWrap {
	    width: 80%; 
	    display: inline-block;
	    margin-left: 2%;
	    margin-top: 1%;
	    min-height: 500px; 
	    border-color: #e6e6e6;
		border-style: solid;
		background-color: #323639; 
		color: #e6e6e6;
	}
	.ContentWrap{box-sizing: border-box;
	    padding-top: 48px;
	    padding-left: 20px;
	    padding-right: 20px;
	    width: 95%;
		min-height: 750px;
	    margin: 0 auto; 
 	} 
	#menuWrap .tab button {
		background-color: inherit;
		border: none;
		outline:none;
		cursor: pointer;
		padding: 14px 16px;
		transition: 0.3s;
		font-size: 20px;  
		color: #e6e6e6;
	}
	#menuWrap .tab button:hover {
	background-color: #7b7676;
	}
</style> 
</head>
<%@include file="../includes/left.jsp"%>
<body>
<sec:authentication property="principal" var="userInfo"/>
<div class="bodyWrap">	
	<div class="ContentWrap">
		<div id="menuWrap">
			<div class="tab"> 
				<button onclick="location.href='myInfoForm?userId=${userInfo.username}'">개인정보 변경</button>
		        <button onclick="location.href='rePasswordForm?userId=${userInfo.username}'">비밀번호 변경</button> 
		        <button onclick="location.href='myBoardList?userId=${userInfo.username}'">나의 게시글</button> 
		        <button onclick="location.href='myReplylist?userId=${userInfo.username}'">나의 댓글</button> 
		        <button onclick="location.href='myScraplist?userId=${userInfo.username}'">스크랩</button>
		        <button onclick="location.href='myCashInfo?userId=${userInfo.username}'">캐시</button>  
		    </div> 
		</div>
	<div class="listWrapper">
		<div class="">나의 캐시 내역</div> 
		<div class="">
			<table class=""> 
			<tr>
				<td>종류</td>
				<td>금액</td>
				<td>상세내역</td>
				<td>내용</td>
				<td>날짜</td>
			</tr>
				<c:forEach items="${myCashHistory}" var="History">
					<tr>
						<td><c:out value="${History.cashKind}" /></td>
						<td><c:out value="${History.cashAmount}" />원</td>
						
					<c:choose>
					       <c:when test="${History.cashKind == '충전' || History.cashKind == '환전'}">
					          	<td><c:out value="${History.specification}" /></td>
					          	<td></td>  
					       </c:when>
					       <c:when test="${History.cashKind == '기부하기' || History.cashKind == '기부받기'}">
				       			  <c:if test="${History.specification == '게시판'}">
				       			  		<td><c:out value="${History.specification}" /></td>
				       			  		<td><a href="/dokky/board/get?num=${History.board_num}"><c:out value="${History.title}" /></a></td>
				       			  </c:if>
				       			  <c:if test="${History.specification == '댓글'}">
				       			  		<td><c:out value="${History.specification}" /></td>
				       					<td><a href="/dokky/board/get?num=${History.board_num}"><c:out value="${History.reply_content}" /></a></td>
				       			  </c:if>
					       </c:when>
			       </c:choose>
						<td><fmt:formatDate pattern="yyyy-MM-dd-HH:mm" value="${History.regDate}" /></td>
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
	<form id='actionForm' action="/dokky/mypage/myBoardList" method='get'>  
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
			actionForm.append("<input type='hidden' name='num' value='"+ $(this).attr("href")+ "'>");
			actionForm.attr("action","/dokky/board/get");
			actionForm.submit();   
		});
	 
</script>
	
</body>
</html>