<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %> 

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>Dokky - 캐시관리</title>  
<c:choose>
   	  <c:when test="${pageContext.request.serverName == 'localhost'}">
			<link href="/resources/css/admin/cashRequestList.css" rel="stylesheet" type="text/css"/>
	  </c:when>
      <c:otherwise>
    		<link href="/ROOT/resources/css/admin/cashRequestList.css" rel="stylesheet" type="text/css"/>
      </c:otherwise>
</c:choose>
</head> 
<%@include file="../includes/common.jsp"%>
<body> 
<sec:authentication property="principal" var="userInfo"/>

 <div class="cashRequestWrap">	 
	 
	 <div id="menuWrap"> 
		<div class="tab">
			<button onclick="location.href='/admin/userList'">계정관리</button>
			<button class="active" onclick="location.href='/admin/cashRequestList'">캐시관리</button> 
			<button onclick="location.href='/admin/userReportList'">신고관리</button>
	    </div>
	 </div> 
	 
  	 <div class="listWrapper">
		 <table id="inforTable">
			 <tr>
				<td class="topTd">요청닉네임</td>
				<td class="topTd">종류</td>
				<td class="topTd">금액</td>
				<td class="topTd">요청날짜</td>
				<td class="topTd">상태</td> 
				<td class="topTd">승인하기</td>
			</tr>
				<c:forEach items="${cashRequestList}" var="cash">
			<tr>  
			
				<td class="td">
					<a href='userForm?userId=<c:out value="${cash.userId}"/>'> 
					  <c:choose>
					   	  <c:when test="${pageContext.request.serverName == 'localhost'}">
								<img src="/resources/img/profile_img/<c:out value="${cash.userId}"  />.png?${random}"  class="memberImage" onerror="this.src='/resources/img/profile_img/basicProfile.png'" />
						  </c:when>
					      <c:otherwise>
					    		<img src="/upload/<c:out value="${cash.userId}"/>.png?${random}"  class="memberImage" onerror="this.src='/ROOT/resources/img/profile_img/basicProfile.png'" />
					      </c:otherwise>
					  </c:choose>
					  <c:out value="${cash.nickName}" />
					</a> 
				</td> 
				<td class="td">
					<c:out value="${cash.cashKind}" />
				</td> 
				<td class="td">
					<fmt:formatNumber type="number" maxFractionDigits="3" value="${cash.cashAmount}"/>원
				</td>
				<td class="td"> 
					<fmt:formatDate value="${cash.regDate}" pattern="yyyy-MM-dd HH:mm" />
				</td>
				<td class="td" id="specification${cash.cash_num}">
					<c:out value="${cash.specification}" />
				</td>   
				<td class="td">
				 	<button class="btn approveButton" data-cash_kind="${cash.cashKind}" data-user_id="${cash.userId}" data-cash_amount="${cash.cashAmount}" data-cash_num="${cash.cash_num}">
				 	승인
				 	</button>
				</td>
			</tr>
		       </c:forEach>
		 </table>
	 </div>
		
	<form id='actionForm' action="/admin/cashRequestList" method='get'> 
		<input type='hidden' name='pageNum' value='${pageMaker.cri.pageNum}'><!--  $(this).attr("href") -->
		<input type='hidden' name='amount' value='${pageMaker.cri.amount}'>
	</form>  
	
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
						<li class="paginate_button next">
							<a href="${pageMaker.endPage +1 }">Next</a>
						</li>
					</c:if>
				</ul>
		</div>
			
	</div> 
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script> 
	<script>
	
			var csrfHeaderName ="${_csrf.headerName}"; 
			var csrfTokenValue="${_csrf.token}";
			var myId = '${userInfo.username}'; 
			var myNickName = '${userInfo.member.nickName}';
			
			 $(document).ajaxSend(function(e, xhr, options) { 
		       xhr.setRequestHeader(csrfHeaderName, csrfTokenValue); //모든 AJAX전송시 CSRF토큰을 같이 전송하도록 셋팅
		     });
	 
			 function approve(commonData, callback, error) {
				 
					$.ajax({
						type : 'put',
						url : '/admin/approveCash/',
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
			 
			 $(".approveButton").on("click",function(event){// 이벤트  
				 
				 	var cash_num = $(this).data("cash_num");
				 	var userId = $(this).data("user_id");
				 	var cashAmount = $(this).data("cash_amount");
				 	var cashKind = $(this).data("cash_kind");
				 	var specification = $("#specification"+cash_num); 
				 	var kind;
					
				 	if($.trim(specification.html()) === "승인완료"){
				 		
				 		openAlert("이미 승인완료가 되었습니다");
				 		return;
				 	} 
				 	 
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
	   						writerNick:myNickName,
							writerId:myId
								  
  			        };
					
					var commonData ={
							
							cashVO:approveData,
							alarmVO:alarmData
				 	}
				 	
				    approve(commonData, function(result){
				 		
						if(result == 'success'){ 
							
					 		specification.html("승인완료"); 
					 		
					 		openAlert("승인완료 되었습니다");
					 		
					 		if(webSocket != null && alarmData != null ){
						   		webSocket.send("sendAlarmMsg,"+alarmData.target);
						   	}	
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