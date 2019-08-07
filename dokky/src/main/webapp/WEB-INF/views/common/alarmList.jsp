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
	a  {    
			color:#e6e6e6; text-decoration: none;
		}
	a:hover {   
	    color: #7151fc;
	    text-decoration: underline;
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
	.mypage a { 
    color: white;
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
</style> 
</head>
<%@include file="../includes/left.jsp"%>
<body>
<sec:authentication property="principal" var="userInfo"/>
<div class="bodyWrap">	
	<div class="ContentWrap">
		<div id="menuWrap">
			<div class="tab"> 
				<button onclick="location.href='alarmList?userId=${userInfo.username}'">총 알림 ${total}개</button> 
		    </div> 
		</div>
	<div class="listWrapper">
		<div class="">
			<table class=""> 
				<c:forEach items="${alarmList}" var="alarm">
					<tr>
					<td>
						<input type="checkbox" name="checkRow" value="${alarm.alarmNum}" />
                    </td>
                    <c:choose>
					       <c:when test="${alarm.kind == 0 }">
					      			 <td>  
						          		<a href="userBoardList?userId=${alarm.writerId}">
						          	<img width="30" src="/dokky/resources/img/profile_img/<c:out value="${alarm.writerId}" />" class="memberImage" onerror="this.src='/dokky/resources/img/basicProfile.png'" />
						          		${alarm.writerNick}
						          		</a>
						          		님께서 
					          		</td>
					          		<td data-alarm_num="${alarm.alarmNum}" data-board_num="${alarm.commonVar2}" class="getBoard">
						          		${alarm.commonVar1} 글에 댓글을 다셨습니다. 
						          	</td>
					          		 <td class="checkAlarm${alarm.alarmNum}"> 
						          		 <c:if test="${alarm.checking == 'NO'}">
												1					          		 	
						          		 </c:if> 
					          		 </td>
					       </c:when>
					      <c:when test="${alarm.kind == 1 }">
					     			 <td>  
						          		<a href="userBoardList?userId=${alarm.writerId}">
						          	<img width="30" src="/dokky/resources/img/profile_img/<c:out value="${alarm.writerId}" />" class="memberImage" onerror="this.src='/dokky/resources/img/basicProfile.png'" />
						          		${alarm.writerNick}
						          		</a>
						          		님께서 
					          		</td>
					          		<td data-alarm_num="${alarm.alarmNum}" data-board_num="${alarm.commonVar2}" class="getBoard">
						          		${alarm.commonVar1} 글에 좋아요 표시를 했습니다. 
						          	</td>
					          		 <td class="checkAlarm${alarm.alarmNum}"> 
						          		 <c:if test="${alarm.checking == 'NO'}">
												1					          		 	
						          		 </c:if> 
					          		 </td>
					       </c:when> 
					        <c:when test="${alarm.kind == 2 }">
					      			<td>  
						          		<a href="userBoardList?userId=${alarm.writerId}">
						          	<img width="30" src="/dokky/resources/img/profile_img/<c:out value="${alarm.writerId}" />" class="memberImage" onerror="this.src='/dokky/resources/img/basicProfile.png'" />
						          		${alarm.writerNick}
						          		</a>
					          		</td>
					          		<td data-alarm_num="${alarm.alarmNum}" data-board_num="${alarm.commonVar2}" class="getBoard">
						          		${alarm.commonVar1}글에 싫어요 표시를 했습니다.  
						          	</td>
					          		  <td class="checkAlarm${alarm.alarmNum}"> 
						          		 <c:if test="${alarm.checking == 'NO'}">
												1					          		 	
						          		 </c:if> 
					          		 </td>
					       </c:when> 
					        <c:when test="${alarm.kind == 3 }">
					        		 <td>  
						          		<a href="userBoardList?userId=${alarm.writerId}">
						          	<img width="30" src="/dokky/resources/img/profile_img/<c:out value="${alarm.writerId}" />" class="memberImage" onerror="this.src='/dokky/resources/img/basicProfile.png'" />
						          		${alarm.writerNick}
						          		</a>
					          		</td>
					          		<td data-alarm_num="${alarm.alarmNum}" data-board_num="${alarm.commonVar2}" class="getBoard">
						          		${alarm.commonVar1}글에 기부하셨습니다.  
						          	</td>
					          		  <td class="checkAlarm${alarm.alarmNum}"> 
						          		 <c:if test="${alarm.checking == 'NO'}">
												1					          		 	
						          		 </c:if> 
					          		 </td>
					       </c:when> 
					       <c:when test="${alarm.kind == 4 }">
					 			     <td>  
						          		<a href="userBoardList?userId=${alarm.writerId}">
						          	<img width="30" src="/dokky/resources/img/profile_img/<c:out value="${alarm.writerId}" />" class="memberImage" onerror="this.src='/dokky/resources/img/basicProfile.png'" />
						          		${alarm.writerNick}
						          		</a>
					          		</td>
					          		<td data-alarm_num="${alarm.alarmNum}" data-board_num="${alarm.commonVar2}" class="getBoard">
						          		${alarm.commonVar1}댓글에 기부하셨습니다.  
						          	</td>
					          		 <td class="checkAlarm${alarm.alarmNum}"> 
						          		 <c:if test="${alarm.checking == 'NO'}">
												1					          		 	
						          		 </c:if> 
					          		 </td>
					       </c:when>
					       <c:when test="${alarm.kind == 5 }">
					      		  	<td>  
						          		<a href="userBoardList?userId=${alarm.writerId}">
						          	<img width="30" src="/dokky/resources/img/profile_img/<c:out value="${alarm.writerId}" />" class="memberImage" onerror="this.src='/dokky/resources/img/basicProfile.png'" />
						          		${alarm.writerNick}
						          		</a>
					          		</td>
					          		<td data-alarm_num="${alarm.alarmNum}" data-board_num="${alarm.commonVar2}" class="getBoard">
						          		${alarm.commonVar1}댓글에 좋아요 표시를 했습니다. 
						          	</td>
					          		 <td class="checkAlarm${alarm.alarmNum}"> 
						          		 <c:if test="${alarm.checking == 'NO'}">
												1					          		 	
						          		 </c:if> 
					          		 </td>
					       </c:when>
					       <c:when test="${alarm.kind == 6 }">
					   				 <td>  
						          		<a href="userBoardList?userId=${alarm.writerId}">
						          	<img width="30" src="/dokky/resources/img/profile_img/<c:out value="${alarm.writerId}" />" class="memberImage" onerror="this.src='/dokky/resources/img/basicProfile.png'" />
						          		${alarm.writerNick}
						          		</a>
					          		</td>
					          		<td data-alarm_num="${alarm.alarmNum}" data-board_num="${alarm.commonVar2}" class="getBoard">
						          		${alarm.commonVar1} 댓글에 싫어요 표시를 했습니다. 
						          	</td> 
					          		 <td class="checkAlarm${alarm.alarmNum}"> 
						          		 <c:if test="${alarm.checking == 'NO'}">
												1					          		 	
						          		 </c:if> 
					          		 </td>
					       </c:when>
					       <c:when test="${alarm.kind == 7 }">
					       			<td>관리자에 의해</td> 
					       			<td data-alarm_num="${alarm.alarmNum}" class="getMyCashHistory">
						          		캐시충전이 완료되었습니다.
						          	</td> 
					          		   <td class="checkAlarm${alarm.alarmNum}"> 
						          		 <c:if test="${alarm.checking == 'NO'}">
												1					          		 	
						          		 </c:if> 
					          		 </td>
					       </c:when>
					       <c:when test="${alarm.kind == 8 }">
					   			    <td>관리자에 의해</td> 
					       			<td data-alarm_num="${alarm.alarmNum}" class="getMyCashHistory">
						          		캐시환전이 완료되었습니다.
						          	</td> 
					          		   <td class="checkAlarm${alarm.alarmNum}"> 
						          		 <c:if test="${alarm.checking == 'NO'}">
												1					          		 	
						          		 </c:if> 
					          		 </td>
					       </c:when>
			       </c:choose> 
						<td>
							<fmt:formatDate value="${alarm.regdate}" pattern="yyyy년 MM월 dd일 HH:mm" />
						</td>
					</tr>
				</c:forEach>
				    <tr>
				        <td><input type="checkbox" name="checkAll" id="checkAll" onclick="checkAll();"/>전체선택</td>
				        <td><button id='deleteBtn' type="button" class="">삭제</button></td>
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
	<form id='actionForm' action="/dokky/alarmList" method='get'>  
		<input type='hidden' name='pageNum' value='${pageMaker.cri.pageNum}'>
		<input type='hidden' name='amount' value='${pageMaker.cri.amount}'>
		<input type='hidden' name='userId' value='${pageMaker.cri.userId}'>
	</form> 
	
	<form id='commonForm' action="/dokky/board/get" method='get'>  
	</form>
	
		</div>
	</div>
</div> 
	
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script> 
<script> 
		var csrfHeaderName ="${_csrf.headerName}"; 
		var csrfTokenValue="${_csrf.token}";
		
		$(document).ajaxSend(function(e, xhr, options) { 
		    xhr.setRequestHeader(csrfHeaderName, csrfTokenValue); //모든 AJAX전송시 CSRF토큰을 같이 전송하도록 셋팅
		  });
  
		function updateAlarmCheck(alarmNum, callback, error) {
			$.ajax({
				type : 'put',
				url : '/dokky/updateAlarmCheck/'+ alarmNum,
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
		
		
		$("#deleteBtn").on("click", function() { 
			deleteAction(); 
		}); 
		
		var commonForm = $("#commonForm");
		
		$(".getBoard").on("click",function(e) {//글 상세보기+알람 읽기 체크
					var num = $(this).data("board_num");  
					var alarmNum = $(this).data("alarm_num");  
					
					updateAlarmCheck(alarmNum, function(result){//알람 읽기 체크
						var checkAlarm = $("#checkAlarm+"+alarmNum);
							if(result == "success"){
								
								checkAlarm.html("");//알림 숫자 1 없애주기
								
								commonForm.append("<input type='hidden' name='num' value='"+num+"'/>");
								commonForm.submit();//글 상세보기 
								}
				   	  });
				});
		
		$(".getMyCashHistory").on("click",function(e) {//알람 읽기 체크+캐시 히스토리 가져오기
			var alarmNum = $(this).data("alarm_num");  
			
			updateAlarmCheck(alarmNum, function(result){//알람 읽기 체크
				var checkAlarm = $("#checkAlarm+"+alarmNum);
				var userId = '${userInfo.username}';
				
					if(result == "success"){
						checkAlarm.html("");//알림 숫자 1 없애주기 
						commonForm.attr("action", "/dokky/mypage/myCashHistory");
						commonForm.append("<input type='hidden' name='userId' value='"+userId+"'/>");
						commonForm.submit();//글 상세보기 
						}
		   	  });
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
		  
		  $( "input[name='checkRow']:checked" ).each (function (){
		    	checkRow = checkRow + $(this).val()+"," ;
		  });
		  
		  checkRow = checkRow.substring(0,checkRow.lastIndexOf( ","));
		 
		  if(checkRow == ''){
		   	 alert("삭제할 알림을 선택하세요.");
		    return false;
		  }
		  
		  //console.log(checkRow);
		  
		  if(confirm("정말 삭제 하시겠습니까?")){
			  actionForm.attr("action","/dokky/removeAllAlarm").attr("method","post");
			  actionForm.append("<input type='hidden' name='checkRow' value='"+checkRow+"'>");
			  actionForm.append("<input type='hidden' id='csrf' name='${_csrf.parameterName}' value='${_csrf.token}'/>");
			  actionForm.submit();
		  }
		}
	
</script>
	
</body>
</html>