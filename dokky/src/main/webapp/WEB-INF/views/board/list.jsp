<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Dokky-게시판</title>
</head>
<%@include file="../includes/search.jsp"%>
<%@include file="../includes/left.jsp"%>
<body>
	<div class="">
		<div class="">Dokky-게시판
			<button id='regBtn' type="button" class="">새 글쓰기</button>
		</div> 
		
		<div class="">
			<table class=""> 
				<c:forEach items="${list}" var="board">
					<tr>
						<td><c:out value="${board.TITLE}" /></td>
						<td>[<c:out value="${board.REPLYCNT}" />]</td>
						<td><c:out value="${board.NICKNAME}" /></td>
						
						<td><fmt:formatDate pattern="yyyy-MM-dd-HH:mm"
								value="${board.REGDATE}" /></td>
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