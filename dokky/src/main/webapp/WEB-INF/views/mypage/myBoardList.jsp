<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Dokky - 나의 게시글</title> 
<link href="/resources/css/myBoardList.css" rel="stylesheet" type="text/css"/>
</head>
<%@include file="../includes/left.jsp"%> 
<body>
<sec:authentication property="principal" var="userInfo"/>
<div class="myboardWrap">	
	<div id="menuWrap">
		<div class="tab"> 
			<button onclick="location.href='myInfoForm?userId=${userInfo.username}'">개인정보 변경</button>
	        <button class="active" onclick="location.href='myBoardList?userId=${userInfo.username}'">나의 게시글</button> 
	        <button onclick="location.href='myReplylist?userId=${userInfo.username}'">나의 댓글</button> 
	        <button onclick="location.href='myScraplist?userId=${userInfo.username}'">나의 스크랩</button>
	        <button onclick="location.href='myCashInfo?userId=${userInfo.username}'">나의 캐시</button>
	    </div> 
	</div>
	<div class="listWrapper">
			<table id="inforTable">
				<c:forEach items="${MyBoard}" var="board">
					<tr>
						<td>
							<input type="checkbox" name="checkRow" value="${board.board_num}" />
	                    </td>
						<td class="title">
							<c:choose>
							        <c:when test="${fn:length(board.title) gt 12}">
								        <a class='move' href='<c:out value="${board.board_num}"/>'>  
											<c:out value="${fn:substring(board.title, 0, 12)}"/>... 
											<span class="replyCnt">
												<c:if test="${board.replyCnt > 0}">
													[<c:out value="${board.replyCnt}" />]
										        </c:if>
											</span> 
										</a>
							        </c:when>
							        <c:otherwise>
								        <a class='move' href='<c:out value="${board.board_num}"/>'>  
											<c:out value="${board.title}" />
											<span class="replyCnt">
												<c:if test="${board.replyCnt > 0}">
													[<c:out value="${board.replyCnt}" />]
										        </c:if>
											</span>  
										</a>
							        </c:otherwise>
							</c:choose>  
						</td> 
						<td class="td">
							<div class="tdData">  
								조회수
							</div>
							<c:out value="${board.hitCnt}" />
						</td>
						<td class="td" >
							<div class="tdData">  
								좋아요
							</div>
							<c:out value="${board.likeCnt}"/>
						</td> 
						<td class="td">
							<div class="tdData">  
								기부금
							</div>
							    \<fmt:formatNumber type="number" maxFractionDigits="3" value="${board.money}"/>
						</td>
						
						<td id="dateTd">
							<fmt:formatDate value="${board.regDate}" pattern="yyyy-MM-dd HH:mm" />
						</td>
						
					</tr> 
				</c:forEach>
				    <tr>
				        <td class="bottomTd"><input type="checkbox" name="checkAll" id="checkAll" onclick="checkAll();"/>전체선택</td>
				        <td class="bottomTd"><button id='deleteBtn' type="button" class="btn">삭제</button></td>
				       	<td class="bottomTd"></td>
				       	<td class="bottomTd"></td>
				        <td class="bottomTd"><span>총 게시글 ${total}개</span></td>  
						<td class="bottomTd"><button id='regBtn' type="button" class="btn">새 글쓰기</button></td> 
				    </tr>
			</table>
		
			<div class='pull-right'>
				<ul class="pagination">
					<c:if test="${pageMaker.prev}">
						<li class="paginate_button previous">
							<a href="${pageMaker.startPage -1}">Previous</a>
						</li>
					</c:if>

					<c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
						<li class="paginate_button  ${pageMaker.cri.pageNum == num ? "page_active":""} ">
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
			
		<form id='actionForm' action="/mypage/myBoardList" method='get'>  
			<input type='hidden' name='pageNum' value='${pageMaker.cri.pageNum}'>
			<input type='hidden' name='amount' value='${pageMaker.cri.amount}'>
			<input type='hidden' name='userId' value='${pageMaker.cri.userId}'>
		</form> 
		
	</div>
</div> 
	
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script> 
<script> 
	   
	$("#regBtn").on("click", function() { 
	
		self.location = "/board/register?category="+${pageMaker.cri.category};
	}); 
	
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
			actionForm.append("<input type='hidden' name='board_num' value='"+ $(this).attr("href")+ "'>");
			actionForm.attr("action","/board/get");
			
			actionForm.submit();   
		});
		
		
	/* 체크박스 전체선택, 전체해제 */
	function checkAll(){
	      if( $("#checkAll").is(':checked') ){ 
	        $("input[name=checkRow]").prop("checked", true);
	      }else{
	        $("input[name=checkRow]").prop("checked", false);
	      }
	}
	
	function deleteAction(){
		
		  var checkRow = "";
		  console.log(checkRow);
		  
		  $( "input[name='checkRow']:checked" ).each (function (){ 
		    	checkRow = checkRow + $(this).val()+"," ;
		  });
		  
		  checkRow = checkRow.substring(0,checkRow.lastIndexOf( ","));
		 
		  if(checkRow == ""){
		   	 openAlert("삭제할 글을 선택하세요.");
		    return false;
		  }
		  
		  //console.log(checkRow);
		  
		  if(confirm("정말 삭제 하시겠습니까?")){
			  actionForm.attr("action","/board/removeAll").attr("method","post");
			  actionForm.append("<input type='hidden' name='checkRow' value='"+checkRow+"'>");
			  actionForm.append("<input type='hidden' id='csrf' name='${_csrf.parameterName}' value='${_csrf.token}'/>");
			  actionForm.submit();
		  }
		}
	
</script>
	
</body>
</html>