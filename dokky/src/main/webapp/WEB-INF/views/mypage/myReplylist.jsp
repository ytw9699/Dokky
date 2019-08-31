<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %> 

<!DOCTYPE html>
<html>
<head>	
<meta charset="UTF-8">
<title>Dokky - 나의 댓글</title> 
<link href="/dokky/resources/css/myReplylist.css" rel="stylesheet" type="text/css"/>
</head>
<%@include file="../includes/left.jsp"%>
<body>
<sec:authentication property="principal" var="userInfo"/>
<div class="myreplyWrap">	
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
		
		
		<div class="">
			<table class=""> 
				<c:forEach items="${myReply}" var="Reply">
					<tr>
					<td>
						<input type="checkbox" name="checkRow" value="${Reply.reply_num}" />
                    </td>
						<td class="replyTitle"><a class='move' href='<c:out value="${Reply.num}"/>'> 
							<c:out value="${Reply.reply_content}" /></a></td> 
					   <td> 
							<fmt:formatDate value="${Reply.replyDate}" pattern="yyyy년 MM월 dd일 HH:mm" />
						</td>
 					</tr>
				</c:forEach>
					<tr>
				        <td><input type="checkbox" name="checkAll" id="checkAll" onclick="checkAll();"/>전체선택</td>
				        <td><button id='deleteBtn' type="button" class="">삭제</button></td>
				        <td>총 댓글 ${total}개 </td>  
				    </tr>
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
	 <form id='actionForm' action="/dokky/mypage/myReplylist" method='get'>  
		<input type='hidden' name='pageNum' value='${pageMaker.cri.pageNum}'><!--  $(this).attr("href") -->
		<input type='hidden' name='amount' value='${pageMaker.cri.amount}'>
		<input type='hidden' name='userId' value='${pageMaker.cri.userId}'> 
	</form>
		</div>
	</div>
</div>
	
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script>
	   
		$("#deleteBtn").on("click", function() { 
			deleteAction(); 
		});  
	
	var actionForm = $("#actionForm");

		$(".paginate_button a").on("click", function(e) {//결국pageNum값만 바꿔주기 위해
	
					e.preventDefault();
	
					actionForm.find("input[name='pageNum']").val($(this).attr("href"));//pageNum값을 바꿔주는것//this는 a태그의 href값을 가져오는것
					
					actionForm.submit();
				});
	
		$(".move").on("click",function(e) {
			 
			e.preventDefault(); 
			actionForm.append("<input type='hidden' name='num' value='"+ $(this).attr("href")+ "'>");
			actionForm.find("input[name='pageNum']").remove();
			actionForm.find("input[name='amount']").remove();
			actionForm.find("input[name='userId']").remove(); 
			 
			actionForm.attr("action","/dokky/board/get");
			actionForm.submit();   
		});
	 
		function checkAll(){
		      if( $("#checkAll").is(':checked') ){ 
		        $("input[name=checkRow]").prop("checked", true);
		      }else{
		        $("input[name=checkRow]").prop("checked", false);
		      }
		}
		
		function deleteAction(){
			
			  var checkRow = "";
			  
			  $( "input[name='checkRow']:checked" ).each (function (){
			    	checkRow = checkRow + $(this).val()+"," ;
			  });
			  
			  checkRow = checkRow.substring(0,checkRow.lastIndexOf( ","));
			 
			  if(checkRow == ''){
			   	 alert("삭제할 댓글을 선택하세요.");
			    return false;
			  }
			   
			  if(confirm("정말 삭제 하시겠습니까?")){
				  actionForm.attr("action","/dokky/replies/removeAll").attr("method","post");
				  actionForm.append("<input type='hidden' name='checkRow' value='"+checkRow+"'>");
				  actionForm.append("<input type='hidden' id='csrf' name='${_csrf.parameterName}' value='${_csrf.token}'/>");
				  actionForm.submit();
			  }
		}
		
</script>
	
</body>
</html>