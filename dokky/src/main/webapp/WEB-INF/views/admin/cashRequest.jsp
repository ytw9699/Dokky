<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %> 

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>메인</title>
	
<style>
	body{
		background-color: #323639;  
		}
	.bodyWrap {
	    width: 80%; 
	    display: inline-block;
	    margin-left: 2%;
	    margin-top: 1%;
	    min-height: 500px; 
	    border-color: #e6e6e6;
		border-style: solid;
		background-color: #323639; 
		color: #e6e6e6;
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
</style>
</head> 

<%@include file="../includes/left.jsp"%>

<body> 
 <div class="bodyWrap">	 
  <div class="ContentWrap">  
	 <div id="menuWrap"> 
		<div class="tab">   
	        <button onclick="location.href='memberList'">계정관리</button> 
	        <button onclick="location.href='cashRequest'">결제관리</button> 
	        <button onclick="location.href='userReportList'">신고관리</button> 
	    </div> 
	 </div> 
	 
  <div class="listWrapper">
	<div class="">
	 <table class=""> 
		 <tr>
			<td>요청아이디</td><td>종류</td><td>요청날짜</td><td>금액</td><td>상태</td><td>승인하기</td>
		</tr>
			<c:forEach items="${cashRequest}" var="cash">
		<tr>  
			<td onclick="location.href='userForm?userId=<c:out value="${cash.userId}" />'"><c:out value="${cash.userId}" /></td> 
			<td><c:out value="${cash.cashKind}" /></td> 
			<td> 
				<fmt:formatDate value="${cash.regDate}" pattern="yyyy년 MM월 dd일 HH:mm" />
			</td>
			<td><c:out value="${cash.cashAmount}" />원</td>
			<td id="specification${cash.cash_num}"><c:out value="${cash.specification}" /></td>   
			<td>
			 	<button class="approveButton" data-cash_kind="${cash.cashKind}" data-user_id="${cash.userId}" data-cash_amount="${cash.cashAmount}" data-cash_num="${cash.cash_num}">승인</button>
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
			<form id='actionForm' action="/dokky/admin/cashRequest" method='get'>  
				<input type='hidden' name='pageNum' value='${pageMaker.cri.pageNum}'><!--  $(this).attr("href") -->
				<input type='hidden' name='amount' value='${pageMaker.cri.amount}'>
			</form>  
			
	 </div>
	</div> 
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script> 
	<script>
	
			var csrfHeaderName ="${_csrf.headerName}"; 
			var csrfTokenValue="${_csrf.token}";
			    
			 $(document).ajaxSend(function(e, xhr, options) { 
		       xhr.setRequestHeader(csrfHeaderName, csrfTokenValue); //모든 AJAX전송시 CSRF토큰을 같이 전송하도록 셋팅
		     });
	 
			 function approve(commonData, callback, error) {
				 console.log(commonData); 
				 
					$.ajax({
						type : 'put',
						url : '/dokky/admin/approve/',
						data : JSON.stringify(commonData),
						contentType : "application/json; charset=utf-8",
						success : function(result, status, xhr) {
							if (callback) {
								callback(result,xhr);
							}
						},
						error : function(xhr, status, er) {
							if (error) {
								error(xhr,er);
							}
						}
					});
				}
			 
			 function postAlarm(approveData, callback, error) {//알림등록
					console.log("postAlarm...............");  
					
					$.ajax({
						type : 'post',
						url : '/dokky/alarm',
						//data : JSON.stringify(alarmData1),
						data : JSON.stringify(approveData),
						/* data : {
							  alarmData : JSON.stringify(alarmData1),
							  approveData : JSON.stringify(approveData)
							}, */
						contentType : "application/json; charset=utf-8",
						success : function(result, status, xhr) {
							if (callback) { 
								callback(result);
							}
						},
						error : function(xhr, status, er) {
							if (error) {
								error(er);
							}
						}
					})
				}
			 
			 
			 $(".approveButton").on("click",function(event){// 이벤트  
				 	var cash_num = $(this).data("cash_num");
				 	var userId = $(this).data("user_id");
				 	var cashAmount = $(this).data("cash_amount");
				 	var cashKind = $(this).data("cash_kind");
				 	var kind;
				 	
				 	 if(cashKind == '충전'){
				 		kind = 7;
				 	 }else if(cashKind == '환전'){
				 		 kind = 8;
				 	 } 
					  
				 	var approveData = { //승인 데이타
				 			cash_num: cash_num,
				 			userId:userId,
				 			cashAmount:cashAmount,
				 			cashKind:cashKind  
				          };
				 	
					var alarmData = { //알람 데이타
	   						target:userId,
	   						kind:kind,
	   						writerNick:'관리자',
	   						writerId:'admin'
	   			          };
					
					var commonData ={
							cashVO:approveData,
							alarmVO:alarmData
				 	}
				 	
				 	approve(commonData, function(result){
						if(result == 'success'){ 
							
							var specification = $("#specification"+cash_num); 
							
					 		specification.html("승인완료"); 
					 		
					 		alert("승인완료 되었습니다");
						}
			   	    });
		   		});//이벤트 끝
		   		
		   		
	   		var actionForm = $("#actionForm");

			$(".paginate_button a").on("click", function(e) {//페이징관련
		
						e.preventDefault();
		
						actionForm.find("input[name='pageNum']").val($(this).attr("href"));
						
						actionForm.submit();
					});

	</script>
</body>
</html>