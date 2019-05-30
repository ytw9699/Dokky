<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Dokky-게시판</title>
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
</style>
</head>
<%@include file="../includes/search.jsp"%>
<%@include file="../includes/left.jsp"%>
<body>
	<div class="listWrapper">
		<div class="">Dokky-게시판
			<button id='regBtn' type="button" class="">새 글쓰기</button>
		</div> 
		
		<div class="">
			<table class=""> 
				<c:forEach items="${list}" var="board">
					<tr>
						<td class="mypage"><a href='/dokky/board/get?num=<c:out value="${board.num}"/>'> 
							<c:out value="${board.title}" /></a></td> 
						<td>[<c:out value="${board.replyCnt}" />]</td>
						<td><c:out value="${board.nickName}" /></td>
						
						<td><fmt:formatDate pattern="yyyy-MM-dd-HH:mm"
								value="${board.regDate}" /></td>
					</tr>
				</c:forEach>
			</table>
		</div>
	</div>
	
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script>
	   
	$("#regBtn").on("click", function() {
	
		self.location = "/dokky/board/register?kind="+${kind};
	});
    
</script>
	
</body>
</html>