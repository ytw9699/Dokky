<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %> 

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>계정관리</title>
	
<style>
		@media screen and (max-width:500px){ 
	     .memberListWrap {
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
          .memberListWrap {
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
          .memberListWrap {
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
	
	.memberInfoWrap {  
	    display: inline-block;
	    background-color: #eeeeee;
	    width: 23%;
	    margin-top: 20px;
	    margin-right: 16px;
	    cursor: pointer;
	    box-sizing: border-box;
	    transition: 0.3s;
	}
	.memberInfoWrap:hover {
	    border: 1px solid #12b9ff;
	}
	
	.memberInfo {
	    display: inline-block;
	    float: left;
	    width: 70px;
	    /* margin: 20px; */
	    margin-top: 30px;
	    margin-left: 0;
	}
	
	.memberProfile {
	    display: inline-block;
	    float: left;
	    width: 60px;
	    margin: 20px;
	    /* border: 1px solid black; */
	    border-radius: 50px;
	}
	 #memberProfile {
	    width: 100%;
	    border-radius: 80px;
	    height: 60px; 
	}  
	
	.infoWrap {
	    width: 100%;
	    margin: 0 auto;
	}
	
	span.userId {
    color: #868686;
    display: block;
    margin-top: 5px;
    /* font-weight: 600; */ 
	}
	
	span.nickName {
	    color: #131313;
	    font-size: 15px;
	    /* font-weight: 600; */
	}

</style>
</head> 

<%@include file="../includes/left.jsp"%>


<body> 
	<div class="memberListWrap">	 
	 <div class="ContentWrap">  
	 
		 <div id="menuWrap"> 
			<div class="tab">   
		        <button onclick="location.href='memberList'">계정관리</button> 
		        <button onclick="location.href='cashRequest'">결제관리</button> 
		        <button onclick="location.href='userReportList'">신고관리</button>
		    </div> 
		 </div> 
		  
	<%@include file="../includes/adminSearch.jsp"%> 
		 
	<div class="infoWrap"> 
		<c:forEach items="${userList}" var="user">
			<div class="memberInfoWrap" onclick="location.href='userForm?userId=<c:out value="${user.userId}" />'" >
				<div class="memberProfile">
					<img src="/dokky/resources/img/profile_img/<c:out value="${user.userId}"/>.png" id="memberProfile" onerror="this.src='/dokky/resources/img/basicProfile.png'" />
				</div>		 		 												 									
				<div class="memberInfo">
					<span class="nickName"><c:out value="${user.nickName}" /></span><br/>
					<span class="userId"><c:out value="${user.userId}" /></span>
				</div>
			</div>
		</c:forEach>
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
			<form id='actionForm' action="/dokky/admin/memberList" method='get'>  
				<input type='hidden' name='pageNum' value='${pageMaker.cri.pageNum}'>
				<input type='hidden' name='amount' value='${pageMaker.cri.amount}'>
				<input type='hidden' name='type' value='<c:out value="${ pageMaker.cri.type }"/>'> 
				<input type='hidden' name='keyword' value='<c:out value="${ pageMaker.cri.keyword }"/>'>
			</form>  
	 </div>
	</div> 
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script> 
	<script>
		   		
	   		var actionForm = $("#actionForm");

			$(".paginate_button a").on("click", function(e) {//페이징관련
		
						e.preventDefault();
		
						actionForm.find("input[name='pageNum']").val($(this).attr("href"));
						
						actionForm.submit();
					});

	</script>
</body>
</html>