<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Dokky</title>
<%@include file="../includes/left.jsp"%>
<style>
	body{
		background-color: #323639; 
	}
	.getWrapper { 
	    border-color: #e6e6e6; 
		border-style: solid; 
		background-color: #323639; 
		color: #e6e6e6;
		margin-left: 15%;
		margin-top: 1%; 
	}
</style>
</head>
<body>
<div class="getWrapper"> 
<div class="col-lg-12">
    <h1 class="page-header">${board.category}게시판</h1>
  </div>

		<div class="form-group">
          <label>날짜</label>-<fmt:formatDate pattern="yyyy-MM-dd-HH:mm"
								value="${board.regDate}" />
        </div>
        <div class="form-group">
          <label>수정됨</label>-<fmt:formatDate pattern="yyyy-MM-dd-HH:mm"
								value="${board.updateDate}" />
        </div>						
		<div class="form-group">
          <label>닉네임</label>-<c:out value="${board.nickName }"/>  
        </div>
         <div class="form-group">
          <label>번호</label>-<c:out value="${board.num }"/>
        </div>

        <div class="form-group">
          <label>제목</label>-<c:out value="${board.title }"/>
        </div>

        <div class="form-group">
          <label>내용</label>-<c:out value="${board.content }"/>
        </div>
        
        <div class="form-group">
          <label>좋아요</label>-<c:out value="${board.up }"/>
        </div>
        
        <div class="form-group">
          <label>싫어요</label>-<c:out value="${board.down }"/>
        </div>
        
        <div class="form-group">
          <label>기부금</label>-<c:out value="${board.money }"/>
        </div>
        <div class="form-group">
          <label>조회수</label>-<c:out value="${board.hitCnt }"/>
        </div>
        <div class="form-group">
          <label>댓글</label>-<c:out value="${board.replyCnt }"/>
        </div>
		<div>
			<button>
				<a href="/dokky/board/modify?num=<c:out value="${board.num}"/>">수정</a>
			</button>
	        <button>
	        	<a href="/dokky/board/list?category=<c:out value="${board.category}"/>">목록보기</a>
	        </button> 
	
			<button id='modalRemoveBtn' type="button" class="btn btn-danger">
				<a href="/dokky/board/remove?num=<c:out value="${board.num}"/>&category=<c:out value="${board.category}"/>">삭제</a>
			</button>
		</div>
	<div>
	 댓글쓰기
		<form action="" method="post">
			       
		         <div class="form-group">
		           <textarea class="form-control" rows="3" name='content'></textarea>
		         </div>
		         <button type="submit" class="btn btn-default">등록</button>
		         <button type="reset" class="btn btn-default">다시쓰기</button>
		</form>
	</div> 
</div>
</body>
</html>

