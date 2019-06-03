<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ include file="../includes/left.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Dokky</title>
</head>
<style>
	body{
		background-color: #323639; 
	}
	.modifyWrapper { 
	    border-color: #e6e6e6;
		border-style: solid;
		background-color: #323639; 
		color: white;
		margin-left: 15%;
		margin-top: 1%; 
	}
</style>
<body>
<div class="modifyWrapper">
	<div class="col-lg-12">
	    <h1 class="page-header">${board.category}게시판</h1>
	  </div>
	<form role="form" action="/dokky/board/modify" method="post"> 
				
			<div class="form-group">
			  <label>제목</label> 
			  <input class="form-control" name='title' 
			    value='<c:out value="${board.title }"/>' >
			</div>
			<div class="form-group">
			  <label>내용</label>
			  <textarea class="form-control" rows="3" name='content' ><c:out value="${board.content}"/></textarea>
			</div>
			
		   <input type='hidden' name='num' value='<c:out value="${board.num }"/>'>
		   <input type='hidden' name='category' value='<c:out value="${cri.category}"/>'>
		   <input type='hidden' name='pageNum' value='<c:out value="${cri.pageNum}"/>'>
		   <input type='hidden' name='amount' value='<c:out value="${cri.amount}"/>'>
		   <input type='hidden' name='type' value='<c:out value="${cri.type }"/>'>
		   <input type='hidden' name='keyword' value='<c:out value="${cri.keyword }"/>'>
     
     	   <button type="submit">수정완료</button>
        
     	   <button type="reset" class="btn btn-default">다시쓰기</button>
	</form>
</div>
</body>
</html>