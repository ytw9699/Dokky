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
		@media screen and (max-width:500px){ 
	     .userBoardWrap {
			    width: 80%; 
			    display: inline-block;
			    margin-left: 15%;
			    margin-top: 1%;
			    min-height: 500px; 
			    border-color: #e6e6e6;
				border-style: solid;
				background-color: #323639; 
				color: #e6e6e6;
				display: inline-block;
			}
        }
        @media screen and (min-width: 501px) and (max-width:1500px){
          .userBoardWrap {
			    width: 80%; 
			    display: inline-block;
			    margin-left: 15%;
			    margin-top: 1%;
			    min-height: 500px; 
			    border-color: #e6e6e6;
				border-style: solid;
				background-color: #323639; 
				color: #e6e6e6;
				display: inline-block;
			}
        }
        @media screen and (min-width: 1501px){    
          .userBoardWrap {
			    width: 51%; 
			    display: inline-block;
			    margin-left: 29%;
			    margin-top: 1%;
			    min-height: 500px; 
			    border-color: #e6e6e6;
				border-style: solid;
				background-color: #323639; 
				color: #e6e6e6;
				display: inline-block;
			}
        }
        
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
	.boardTitle a {   
    	color: white;
    	text-decoration:none;
	}
	.boardTitle a:hover {   
   		 color: #7151fc;
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
<div class="userBoardWrap">	
	<div class="ContentWrap">
		<div id="menuWrap">
			<div class="tab"> 
		       ${pageMaker.cri.userId} 유저
		    </div>
		    <span class="tab"> 
		   		    총 게시글  ${boardTotal}개,
		    </span> 
		    <span class="tab"> 
		      	  총 댓글 ${replyTotal}개 
		    </span>  
		</div>
		<div id="menuWrap">
			<div class="tab"> 
		        <button onclick="location.href='userBoardList?userId=${pageMaker.cri.userId}'">등록한 게시글</button> 
		        <button onclick="location.href='userReplylist?userId=${pageMaker.cri.userId}'">등록한 댓글</button>  
		    </div> 
		</div>
	<div class="listWrapper">
		<div class="">
			<table class=""> 
				<c:forEach items="${userBoard}" var="board">
					<tr>
						<td class="boardTitle">  
							<a class='move' href='<c:out value="${board.num}"/>'> 
								<c:out value="${board.title}" /> 
								<span class="replyCnt">[<c:out value="${board.replyCnt}" />]</span>
							</a>
						</td> 
						<td>
							<img width="20px" src="/dokky/resources/img/read.png"/>
							<c:out value="${board.hitCnt}" />
						</td>
						<td>
							<fmt:formatDate value="${board.regDate}" pattern="yyyy년 MM월 dd일 HH:mm" />
						</td>
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
	<form id='actionForm' action="/dokky/userBoardList" method='get'>  
		<input type='hidden' name='pageNum' value='${pageMaker.cri.pageNum}'>
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