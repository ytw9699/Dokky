<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ include file="../includes/left.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Dokky 새 글쓰기</title>
</head>
<style> 
	body{
		background-color: #323639; 
	}
	.registerWrapper { 
	    border-color: #e6e6e6;
		border-style: solid;
		background-color: #323639; 
		color: white;
		margin-left: 15%;
		margin-top: 1%; 
	}
</style>
<body>
<div class="registerWrapper">
<div class="row">
  <div class="col-lg-12">
    <h1 class="page-header">새 글쓰기</h1>  
  </div>
</div>
<div class="row">
  <div class="col-lg-12">
    <div class="panel panel-default">

      <div class="panel-body">
	        <form role="form" action="/dokky/board/register" method="post">
	        <div>
				<select name="kind" class="form-control"> <!-- kind드를 category로 -->
					<option value="" selected="selected">게시판을 선택해 주세요.</option>
                       <option value=1>공지사항</option>
                       <option value=2>자유게시판</option>
                       <option value=3>묻고답하기</option>
                       <option value=4>칼럼/Tech</option>
                       <option value=5>정기모임/스터디</option>
			     </select>
			</div>
		          <div class="form-group">
		            <input class="form-control" placeholder="제목을 입력해 주세요" name='title'>
		          </div>
		
		          <div class="form-group">
		            <textarea class="form-control" rows="3" name='content'></textarea>
		          </div>
		          
		          <input type='hidden' name='nickName' value='test' /> 
		        <%--   <input type='hidden' name='amount' value='<c:out value="${pageMaker.cri.amount}"/>' /> --%>
								
		          <button type="submit" class="btn btn-default">등록</button>
		          
		          <button type="reset" class="btn btn-default">다시쓰기</button>
	        </form>
      </div>
    </div>
  </div>
</div>
</div>
</body>
</html>