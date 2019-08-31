<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %> 

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>신고관리</title>
	
<style>
@media screen and (max-width:500px){ 
	     .userReporWrap {
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
          .userReporWrap {
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
          .userReporWrap {
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
	a:hover {    
	    color: #7151fc;
	    text-decoration: underline;
	}  
	a  {    
			color:#e6e6e6; text-decoration: none;
		}  
	.memberImage{ 
		border-radius: 50px;
		width: 25px; 
		height: 25px;
	}
	
	 
	
</style>
</head> 

<%@include file="../includes/left.jsp"%>

<body> 
	<div class="userReporWrap">	 
	 <div class="ContentWrap">  
	 
		 <div id="menuWrap"> 
			<div class="tab">   
		        <button onclick="location.href='userList'">계정관리</button> 
		        <button onclick="location.href='cashRequest'">결제관리</button> 
		        <button onclick="location.href='userReportList'">신고관리</button> 
		    </div> 
		 </div> 
	 
	 <div class="listWrapper">
		<div class="">
			<table class=""> 
					<tr>
						<td>종류</td><td>신고 한 회원</td><td>신고받은 회원</td><td>사유</td><td>신고날짜</td>
					</tr>
						<c:forEach items="${userReportList}" var="report">
					<tr>  
						<td><c:out value="${report.reportKind}" /></td>   
						<td>
							<a href='userForm?userId=<c:out value="${report.reportingId}"/>'> 
							  <img src="/dokky/resources/img/profile_img/<c:out value="${report.reportingId}" />.png"  class="memberImage" onerror="this.src='/dokky/resources/img/basicProfile.png'" />
							  <c:out value="${report.reportingNick}" />(<c:out value="${report.reportingId}" />)
							</a> 
						</td>
						<td>
							<a href='userForm?userId=<c:out value="${report.reportedId}"/>'> 
							  <img src="/dokky/resources/img/profile_img/<c:out value="${report.reportedId}" />.png"  class="memberImage" onerror="this.src='/dokky/resources/img/basicProfile.png'" />
							  <c:out value="${report.reportedNick}" />(<c:out value="${report.reportedId}" />)
							</a> 
						</td> 
						<td>
							<a href='/dokky/board/get?num=<c:out value="${report.board_num}"/>'> 
							  <c:out value="${report.reason}" />
							</a> 
						</td>  
						 <td> 
							<fmt:formatDate value="${report.regDate}" pattern="yyyy년 MM월 dd일 HH:mm" />
						</td>  
					</tr>
				</c:forEach>
			</table>
		</div>
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
						<li class="paginate_button next">
							<a href="${pageMaker.endPage +1 }">Next</a>
						</li>
					</c:if>
				</ul>
		</div>
			<form id='actionForm' action="/dokky/admin/userReportList" method='get'>  
				<input type='hidden' name='pageNum' value='${pageMaker.cri.pageNum}'>
				<input type='hidden' name='amount' value='${pageMaker.cri.amount}'>
			</form>  
	 </div>
	</div>  
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script> 
	<script>
		   		
	   		var actionForm = $("#actionForm");

			$(".paginate_button a").on("click", function(e) {
		
						e.preventDefault();
		
						actionForm.find("input[name='pageNum']").val($(this).attr("href"));
						
						actionForm.submit();
					});

	</script>
</body>
</html>