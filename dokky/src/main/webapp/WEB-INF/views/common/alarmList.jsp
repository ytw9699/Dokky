<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"> 
<title>Dokky - 알림</title>
<link href="/dokky/resources/css/alarmList.css" rel="stylesheet" type="text/css"/>
</head>
<%@include file="../includes/left.jsp"%>
<body>
<sec:authentication property="principal" var="userInfo"/>
<div class="alarmWrap">	
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
									<a href="#" class="userMenu" data-alarm_num="${alarm.alarmNum}">
										<img src="/dokky/resources/img/profile_img/<c:out value="${alarm.writerId}" />.png"  class="memberImage hideUsermenu" onerror="this.src='/dokky/resources/img/basicProfile.png'" />
										<c:out value="${alarm.writerNick}" /> 
									</a>   
									 <div id="userMenubar_${alarm.alarmNum}" class="userMenubar">
										<ul class="hideUsermenu"> 
											<li class="hideUsermenu"><a href="/dokky/userBoardList?userId=${alarm.writerId}" class="hideUsermenu"><span class="hideUsermenu">게시글보기</span></a></li>
											<li class="hideUsermenu"><a href="#" class="hideUsermenu"><span class="hideUsermenu">쪽지보내기</span></a></li>
										</ul>      
								     </div> 
								</td> 
					
				          		<td> 
				          			<a href="#" class="getBoard" data-alarm_num="${alarm.alarmNum}" data-board_num="${alarm.commonVar2}">댓글이 달렸습니다. "${alarm.commonVar1}"</a>
					          	</td>
					          	
				          		 <td class="checkAlarm${alarm.alarmNum}"> 
					          		 <c:if test="${alarm.checking == 'NO'}">
											<span class="readCheck">1</span> 				          		 	
					          		 </c:if> 
				          		 </td>
					       </c:when>
					      <c:when test="${alarm.kind == 1 }">
				     			<td> 
									<a href="#" class="userMenu" data-alarm_num="${alarm.alarmNum}">
										<img src="/dokky/resources/img/profile_img/<c:out value="${alarm.writerId}"  />.png"  class="memberImage hideUsermenu" onerror="this.src='/dokky/resources/img/basicProfile.png'" />
										<c:out value="${alarm.writerNick}" /> 
									</a>   
									 <div id="userMenubar_${alarm.alarmNum}" class="userMenubar">
										<ul class="hideUsermenu"> 
											<li class="hideUsermenu"><a href="/dokky/userBoardList?userId=${alarm.writerId}" class="hideUsermenu"><span class="hideUsermenu">게시글보기</span></a></li>
											<li class="hideUsermenu"><a href="#" class="hideUsermenu"><span class="hideUsermenu">쪽지보내기</span></a></li>
										</ul>      
								     </div> 
								</td>
								
								<td>
				          			<a href="#" class="getBoard" data-alarm_num="${alarm.alarmNum}" data-board_num="${alarm.commonVar2}">다음 글에 좋아요 하셨습니다. "${alarm.commonVar1}"</a>
					          	</td>
				          		
				          		 <td class="checkAlarm${alarm.alarmNum}"> 
					          		 <c:if test="${alarm.checking == 'NO'}"> 
											<span class="readCheck">1</span> 				          		 	
					          		 </c:if> 
				          		 </td>
					       </c:when> 
					        <c:when test="${alarm.kind == 2 }">
				      			<td> 
									<a href="#" class="userMenu" data-alarm_num="${alarm.alarmNum}">
										<img src="/dokky/resources/img/profile_img/<c:out value="${alarm.writerId}"  />.png"  class="memberImage hideUsermenu" onerror="this.src='/dokky/resources/img/basicProfile.png'" />
										<c:out value="${alarm.writerNick}" /> 
									</a>   
									 <div id="userMenubar_${alarm.alarmNum}" class="userMenubar">
										<ul class="hideUsermenu"> 
											<li class="hideUsermenu"><a href="/dokky/userBoardList?userId=${alarm.writerId}" class="hideUsermenu"><span class="hideUsermenu">게시글보기</span></a></li>
											<li class="hideUsermenu"><a href="#" class="hideUsermenu"><span class="hideUsermenu">쪽지보내기</span></a></li>
										</ul>      
								     </div> 
								</td>
								
								<td>
				          			<a href="#" class="getBoard" data-alarm_num="${alarm.alarmNum}" data-board_num="${alarm.commonVar2}">다음 글에 싫어요 하셨습니다. "${alarm.commonVar1}"</a>
					          	</td>
					          	
				          		  <td class="checkAlarm${alarm.alarmNum}"> 
					          		 <c:if test="${alarm.checking == 'NO'}">
											<span class="readCheck">1</span> 				          		 	
					          		 </c:if> 
				          		 </td>
					       </c:when> 
					        <c:when test="${alarm.kind == 3 }">
				        		 <td> 
									<a href="#" class="userMenu" data-alarm_num="${alarm.alarmNum}">
										<img src="/dokky/resources/img/profile_img/<c:out value="${alarm.writerId}"  />.png"  class="memberImage hideUsermenu" onerror="this.src='/dokky/resources/img/basicProfile.png'" />
										<c:out value="${alarm.writerNick}" /> 
									</a>   
									 <div id="userMenubar_${alarm.alarmNum}" class="userMenubar">
										<ul class="hideUsermenu"> 
											<li class="hideUsermenu"><a href="/dokky/userBoardList?userId=${alarm.writerId}" class="hideUsermenu"><span class="hideUsermenu">게시글보기</span></a></li>
											<li class="hideUsermenu"><a href="#" class="hideUsermenu"><span class="hideUsermenu">쪽지보내기</span></a></li>
										</ul>      
								     </div> 
								</td>
								
								<td>
				          			<a href="#" class="getBoard" data-alarm_num="${alarm.alarmNum}" data-board_num="${alarm.commonVar2}">다음 글에 기부하셨습니다. "${alarm.commonVar1}"</a>
					          	</td>
					          	
				          		  <td class="checkAlarm${alarm.alarmNum}"> 
					          		 <c:if test="${alarm.checking == 'NO'}">
											<span class="readCheck">1</span> 				          		 	
					          		 </c:if> 
				          		 </td>
					       </c:when> 
					       <c:when test="${alarm.kind == 4 }">
				 			    <td> 
									<a href="#" class="userMenu" data-alarm_num="${alarm.alarmNum}">
										<img src="/dokky/resources/img/profile_img/<c:out value="${alarm.writerId}"  />.png"  class="memberImage hideUsermenu" onerror="this.src='/dokky/resources/img/basicProfile.png'" />
										<c:out value="${alarm.writerNick}" /> 
									</a>   
									 <div id="userMenubar_${alarm.alarmNum}" class="userMenubar">
										<ul class="hideUsermenu"> 
											<li class="hideUsermenu"><a href="/dokky/userBoardList?userId=${alarm.writerId}" class="hideUsermenu"><span class="hideUsermenu">게시글보기</span></a></li>
											<li class="hideUsermenu"><a href="#" class="hideUsermenu"><span class="hideUsermenu">쪽지보내기</span></a></li>
										</ul>      
								     </div> 
								</td>
								
								<td>
				          			<a href="#" class="getBoard" data-alarm_num="${alarm.alarmNum}" data-board_num="${alarm.commonVar2}">다음 댓글에 기부하셨습니다. "${alarm.commonVar1}"</a>
					          	</td>
					          	
				          		 <td class="checkAlarm${alarm.alarmNum}"> 
					          		 <c:if test="${alarm.checking == 'NO'}">
											<span class="readCheck">1</span> 					          		 	
					          		 </c:if> 
				          		 </td>
					       </c:when>
					       <c:when test="${alarm.kind == 5 }">
				      		  	<td> 
									<a href="#" class="userMenu" data-alarm_num="${alarm.alarmNum}">
										<img src="/dokky/resources/img/profile_img/<c:out value="${alarm.writerId}"  />.png"  class="memberImage hideUsermenu" onerror="this.src='/dokky/resources/img/basicProfile.png'" />
										<c:out value="${alarm.writerNick}" /> 
									</a>   
									 <div id="userMenubar_${alarm.alarmNum}" class="userMenubar">
										<ul class="hideUsermenu"> 
											<li class="hideUsermenu"><a href="/dokky/userBoardList?userId=${alarm.writerId}" class="hideUsermenu"><span class="hideUsermenu">게시글보기</span></a></li>
											<li class="hideUsermenu"><a href="#" class="hideUsermenu"><span class="hideUsermenu">쪽지보내기</span></a></li>
										</ul>      
								     </div> 
								</td>
								
								<td>
				          			<a href="#" class="getBoard" data-alarm_num="${alarm.alarmNum}" data-board_num="${alarm.commonVar2}">다음 댓글에 좋아요 하셨습니다. "${alarm.commonVar1}"</a>
					          	</td>
					          	
				          		 <td class="checkAlarm${alarm.alarmNum}"> 
					          		 <c:if test="${alarm.checking == 'NO'}">
											<span class="readCheck">1</span> 				          		 	
					          		 </c:if> 
				          		 </td>
					       </c:when>
					       <c:when test="${alarm.kind == 6 }">
				   				<td> 
									<a href="#" class="userMenu" data-alarm_num="${alarm.alarmNum}">
										<img src="/dokky/resources/img/profile_img/<c:out value="${alarm.writerId}" />.png"  class="memberImage hideUsermenu" onerror="this.src='/dokky/resources/img/basicProfile.png'" />
										<c:out value="${alarm.writerNick}" /> 
									</a>   
									 <div id="userMenubar_${alarm.alarmNum}" class="userMenubar">
										<ul class="hideUsermenu"> 
											<li class="hideUsermenu"><a href="/dokky/userBoardList?userId=${alarm.writerId}" class="hideUsermenu"><span class="hideUsermenu">게시글보기</span></a></li>
											<li class="hideUsermenu"><a href="#" class="hideUsermenu"><span class="hideUsermenu">쪽지보내기</span></a></li>
										</ul>      
								     </div> 
								</td>
				          		<td>
				          			<a href="#" class="getBoard" data-alarm_num="${alarm.alarmNum}" data-board_num="${alarm.commonVar2}">다음 댓글에 싫어요 하셨습니다. "${alarm.commonVar1}"</a>
					          	</td>
				          		 <td class="checkAlarm${alarm.alarmNum}"> 
					          		 <c:if test="${alarm.checking == 'NO'}">
											<span class="readCheck">1</span> 				          		 	
					          		 </c:if> 
				          		 </td>
					       </c:when>
					       <c:when test="${alarm.kind == 7 }">
					       			<td>  
					       				<a href="#" class="userMenu" data-alarm_num="${alarm.alarmNum}">
						       				<img src="/dokky/resources/img/profile_img/admin.png" class="memberImage hideUsermenu" onerror="this.src='/dokky/resources/img/basicProfile.png'">
						       				<c:out value="${alarm.writerNick}" /> 
					       				</a> 
					       				<div id="userMenubar_${alarm.alarmNum}" class="userMenubar">
											<ul class="hideUsermenu">  
												<li class="hideUsermenu"><a href="/dokky/userBoardList?userId=admin" class="hideUsermenu"><span class="hideUsermenu">게시글보기</span></a></li>
												<li class="hideUsermenu"><a href="#" class="hideUsermenu"><span class="hideUsermenu">쪽지보내기</span></a></li>
											</ul>      
								     	</div> 
					       			</td> 
					       			<td>
					          			<a href="#" class="getMyCashHistory" data-alarm_num="${alarm.alarmNum}"> 캐시충전이 완료되었습니다.</a>
						           </td>
				          		   <td class="checkAlarm${alarm.alarmNum}"> 
					          		 <c:if test="${alarm.checking == 'NO'}">
										<span class="readCheck">1</span>  					          		 	
					          		 </c:if> 
				          		   </td>
					       </c:when>
					       <c:when test="${alarm.kind == 8 }">  
				   			    <td>  
				       				<a href="#" class="userMenu" data-alarm_num="${alarm.alarmNum}">
					       				<img src="/dokky/resources/img/profile_img/admin.png" class="memberImage hideUsermenu" onerror="this.src='/dokky/resources/img/basicProfile.png'">
					       				<c:out value="${alarm.writerNick}" />    
				       				</a> 
				       				<div id="userMenubar_${alarm.alarmNum}" class="userMenubar">
										<ul class="hideUsermenu">  
											<li class="hideUsermenu"><a href="/dokky/userBoardList?userId=admin" class="hideUsermenu"><span class="hideUsermenu">게시글보기</span></a></li>
											<li class="hideUsermenu"><a href="#" class="hideUsermenu"><span class="hideUsermenu">쪽지보내기</span></a></li>
										</ul>        
							     	</div> 
				       			</td>  
				   			    <td>
					          		<a href="#" class="getMyCashHistory" data-alarm_num="${alarm.alarmNum}"> 캐시환전이 완료되었습니다.</a>
						        </td>
			          		    <td class="checkAlarm${alarm.alarmNum}"> 
					          		 <c:if test="${alarm.checking == 'NO'}">
										<span class="readCheck">1</span> 					          		 	
					          		 </c:if>  
			          		    </td>
					       </c:when> 
					       
					          <c:when test="${alarm.kind == 9 }">
				   				<td> 
									<a href="#" class="userMenu" data-alarm_num="${alarm.alarmNum}">
										<img src="/dokky/resources/img/profile_img/<c:out value="${alarm.writerId}" />.png"  class="memberImage hideUsermenu" onerror="this.src='/dokky/resources/img/basicProfile.png'" />
										<c:out value="${alarm.writerNick}" /> 
									</a>   
									 <div id="userMenubar_${alarm.alarmNum}" class="userMenubar">
										<ul class="hideUsermenu"> 
											<li class="hideUsermenu"><a href="/dokky/userBoardList?userId=${alarm.writerId}" class="hideUsermenu"><span class="hideUsermenu">게시글보기</span></a></li>
											<li class="hideUsermenu"><a href="#" class="hideUsermenu"><span class="hideUsermenu">쪽지보내기</span></a></li>
										</ul>      
								     </div> 
								</td> 
				          		<td> 
				          			<a href="#" class="getUserReportList" data-alarm_num="${alarm.alarmNum}">다음 사유로 신고가 접수되었습니다. "${alarm.commonVar1}"</a>  
					          	</td> 
				          		 <td class="checkAlarm${alarm.alarmNum}"> 
					          		 <c:if test="${alarm.checking == 'NO'}">
											<span class="readCheck">1</span> 				          		 	
					          		 </c:if> 
				          		 </td>
					       </c:when>
					       
			       </c:choose> 
						<td> 
							<fmt:formatDate value="${alarm.regdate}" pattern="yyyy-MM-dd HH:mm" />
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
		    xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
		  });
  
		$(".userMenu").on("click",function(event){//해당 메뉴바 보이기 이벤트
			
			var	alarm_num = $(this).data("alarm_num");
			var userMenubar = $("#userMenubar_"+alarm_num);
					
			if($(".addBlockClass").length > 0){
				$(".addBlockClass").css("display","none");  
				$(".addBlockClass").removeClass('addBlockClass');
			}
			userMenubar.css("display","block"); 
			userMenubar.addClass('addBlockClass'); 
		 });
		 
		$('html').click(function(e) { //html안 Usermenu, hideUsermenu클래스를 가지고있는 곳 제외하고 클릭하면 숨김 이벤트발생
			if( !$(e.target).is('.userMenu, .hideUsermenu') ) { 	
			    var userMenu = $(".userMenubar");     
				userMenu.css("display","none");  
			} 
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
		
		/* $(".move").on("click",function(e) {
			
			e.preventDefault(); 
			actionForm.append("<input type='hidden' name='board_num' value='"+ $(this).attr("href")+ "'>");
			actionForm.attr("action","/dokky/board/get");
			
			actionForm.submit();   
		}); */
		
		
		$("#deleteBtn").on("click", function() { 
			deleteAction(); 
		}); 
		
		var commonForm = $("#commonForm");
		
		$(".getBoard").on("click",function(e) {//글 상세보기+알람 읽기 체크
					e.preventDefault();
					var board_num = $(this).data("board_num");  
					var alarmNum = $(this).data("alarm_num");  
					
					updateAlarmCheck(alarmNum, function(result){//알람 읽기 체크
						var checkAlarm = $("#checkAlarm+"+alarmNum);
							if(result == "success"){
								
								checkAlarm.html("");//알림 숫자 1 없애주기
								
								commonForm.append("<input type='hidden' name='board_num' value='"+board_num+"'/>");
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
		
		$(".getUserReportList").on("click",function(e) {//알람 읽기 체크+신고리스트 가져오기
			var alarmNum = $(this).data("alarm_num");  
			
			updateAlarmCheck(alarmNum, function(result){//알람 읽기 체크
				var checkAlarm = $(".checkAlarm"+alarmNum);
				
					if(result == "success"){
						checkAlarm.html(""); 
						commonForm.attr("action", "/dokky/admin/userReportList");
						commonForm.submit(); 
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