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
          <button onclick="">좋아요,ajax구현</button> 
        </div>
        
        <div class="form-group">
          <label>싫어요</label>-<c:out value="${board.down }"/>
          <button onclick="">싫어요,ajax구현</button> 
        </div>
        
        <div class="form-group">
          <label>기부금</label>-<c:out value="${board.money }"/>
          <button onclick="">기부금,ajax구현</button> 
        </div>
        <div class="form-group">
          <label>조회수</label>-<c:out value="${board.hitCnt }"/>
        </div>
        <div class="form-group">
          <label>댓글</label>-<c:out value="${board.replyCnt }"/>
        </div>
		<div>
			<button id="modify_button">수정 </button> 
	        <button id="list_button">목록보기 </button> 
	        <button id="remove_button">삭제 </button>
	        
			<form id='operForm' action="/dokky/board/modify" method="get">
			  <input type='hidden' id='num' name='num' value='<c:out value="${board.num}"/>'>
			  <input type='hidden' name='category' value='<c:out value="${cri.category}"/>'>
			  <input type='hidden' name='pageNum' value='<c:out value="${cri.pageNum}"/>'>
			  <input type='hidden' name='amount' value='<c:out value="${cri.amount}"/>'>
			</form>

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
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script>
     function func_confirm(content){//확인여부
         if(confirm(content)){//true
         	return true;
         } else {//false
         	return false;
         }
     }

	var operForm = $("#operForm");  

	$("#list_button").on("click", function(e){
	    operForm.find("#num").remove();
	    operForm.attr("action","/dokky/board/list")
	    operForm.submit();
 	 }); 
	
	$("#modify_button").on("click", function(e){
	    operForm.submit(); 
 	 }); 
	   
	$("#remove_button").on("click", function(e){
		if(func_confirm('정말 삭제 하시겠습니까?')){
			operForm.attr("action","/dokky/board/remove")
		    operForm.submit();
		}
 	 }); 
	
	
</script>
</body>
</html>


 
