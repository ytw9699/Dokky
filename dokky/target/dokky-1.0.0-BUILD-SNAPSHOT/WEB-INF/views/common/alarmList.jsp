<!--
마지막 업데이트 2022-05-24
알람 종류에 따라 보여줄 리스트
-->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"> 
<title>Dokky - 알림</title>
<c:choose>
   	  <c:when test="${pageContext.request.serverName == 'localhost'}">
			<link href="/resources/css/alarmList.css" rel="stylesheet" type="text/css"/>
	  </c:when>
      <c:otherwise>
    		<link href="/ROOT/resources/css/alarmList.css" rel="stylesheet" type="text/css"/>
      </c:otherwise>
</c:choose>
</head>
<%@include file="../includes/common.jsp"%>

<body>
<sec:authentication property="principal" var="userInfo"/>
<div class="alarmWrap">	

	<div id="menuWrap">
		<div class="tab">  
			<button class="<c:if test="${pageMaker.cri.order == 0 }">active</c:if>" onclick="location.href='alarmList?userId=${userInfo.username}&order=0'">모든 알림 ${allAlarmCount}개</button> 
			<button class="<c:if test="${pageMaker.cri.order == 1 }">active</c:if>" onclick="location.href='alarmList?userId=${userInfo.username}&order=1'">읽은 알림 ${alarmCountRead}개</button>
			<button class="<c:if test="${pageMaker.cri.order == 2 }">active</c:if>" onclick="location.href='alarmList?userId=${userInfo.username}&order=2'">읽지 않은 알림 ${alarmCountNotReaded}개</button> 
	    </div> 																								
	</div> 
	
	<div class="listWrapper">
			<table id="inforTable">
				<c:forEach items="${alarmList}" var="alarm">
					<tr>
						<td>
							<input type="checkbox" name="checkRow" value="${alarm.alarmNum}" />
	                    </td>
	                    
	                    <td class="td"> 
							<a href="#" class="userMenu" data-alarm_num="${alarm.alarmNum}">
								<c:choose>
								   	  <c:when test="${pageContext.request.serverName == 'localhost'}"> 
											<img src="/resources/img/profile_img/<c:out value="${alarm.writerId}" />.png?${random}"  class="memberImage hideUsermenu" onerror="this.src='/resources/img/profile_img/basicProfile.png'" />
									  </c:when>
								      <c:otherwise>
								    		<img src="/upload/<c:out value="${alarm.writerId}" />.png?${random}"  class="memberImage hideUsermenu" onerror="this.src='/ROOT/resources/img/profile_img/basicProfile.png'" />
								      </c:otherwise>
								</c:choose>
								<c:out value="${alarm.writerNick}" /> 
							</a>
							 
							<div id="userMenubar_${alarm.alarmNum}" class="userMenubar">
								<ul class="hideUsermenu"> 
									<li class="hideUsermenu">
										<a href="/userBoardList?userId=${alarm.writerId}" class="hideUsermenu">
											<span class="hideUsermenu">게시글보기</span>
										</a>  
									</li>   
									<li class="hideUsermenu">
										<a href="#" class="hideUsermenu" onclick="noteOpen('${alarm.writerId}','${alarm.writerNick}')">
											<span class="hideUsermenu">쪽지보내기</span> 
										</a>
									</li>
									<li class="hideUsermenu singleChat" data-chat_nickname="${alarm.writerNick}" data-chat_userid="${alarm.writerId}">
										<a href="#" class="hideUsermenu">
											<span class="hideUsermenu">1:1채팅</span>
										</a>
									</li>
								</ul>    
						    </div> 
						</td>
						<td class="title">
			                    <c:choose>
							       <c:when test="${alarm.kind == 0 }"> 
								        <c:choose>
										        <c:when test="${fn:length(alarm.commonVar1) gt 13}">
											        <a href="#" class="getBoard" data-alarm_num="${alarm.alarmNum}" data-board_num="${alarm.commonVar2}" data-reply_num="${alarm.commonVar3}">
											        	댓글이 달렸습니다. "<c:out value="${fn:substring(alarm.commonVar1, 0, 13)}"/>....."
										        	</a>
										        </c:when>
										        <c:otherwise>
											        <a href="#" class="getBoard" data-alarm_num="${alarm.alarmNum}" data-board_num="${alarm.commonVar2}" data-reply_num="${alarm.commonVar3}">
											        	댓글이 달렸습니다. "<c:out value="${alarm.commonVar1}"/>"
										        	</a> 
										        </c:otherwise>
										</c:choose>
							       </c:when>
							
							       <c:when test="${alarm.kind == 1 }">
						          			<c:choose>
										        <c:when test="${fn:length(alarm.commonVar1) gt 13}">
											        <a href="#" class="getBoard" data-alarm_num="${alarm.alarmNum}" data-board_num="${alarm.commonVar2}">
											        	다음 글에 좋아요 하셨습니다. "<c:out value="${fn:substring(alarm.commonVar1, 0, 13)}"/>....."
										        	</a>
										        </c:when>
										        <c:otherwise>
											        <a href="#" class="getBoard" data-alarm_num="${alarm.alarmNum}" data-board_num="${alarm.commonVar2}">
											        	다음 글에 좋아요 하셨습니다. "<c:out value="${alarm.commonVar1}"/>"
										        	</a>
										        </c:otherwise>
											</c:choose>
							       </c:when> 
							       
							       <c:when test="${alarm.kind == 2 }">
						          			<c:choose>
											        <c:when test="${fn:length(alarm.commonVar1) gt 13}">
												        <a href="#" class="getBoard" data-alarm_num="${alarm.alarmNum}" data-board_num="${alarm.commonVar2}">
												        	다음 글에 싫어요 하셨습니다. "<c:out value="${fn:substring(alarm.commonVar1, 0, 13)}"/>....."
											        	</a>
											        </c:when>
											        <c:otherwise>
												        <a href="#" class="getBoard" data-alarm_num="${alarm.alarmNum}" data-board_num="${alarm.commonVar2}">
												        	다음 글에 싫어요 하셨습니다. "<c:out value="${alarm.commonVar1}"/>"
											        	</a>  
											        </c:otherwise>
											</c:choose>
							       </c:when> 
							       
							       <c:when test="${alarm.kind == 3 }">
						          			<c:choose>
										        <c:when test="${fn:length(alarm.commonVar1) gt 15}">
											        <a href="#" class="getBoard" data-alarm_num="${alarm.alarmNum}" data-board_num="${alarm.commonVar2}">
											        	다음 글에 기부하셨습니다. "<c:out value="${fn:substring(alarm.commonVar1, 0, 15)}"/>....."
										        	</a>
										        </c:when>
										        <c:otherwise>
											        <a href="#" class="getBoard" data-alarm_num="${alarm.alarmNum}" data-board_num="${alarm.commonVar2}">
											        	다음 글에 기부하셨습니다. "<c:out value="${alarm.commonVar1}"/>"
										        	</a>
										        </c:otherwise>
											</c:choose>
							       </c:when> 
							       
							       <c:when test="${alarm.kind == 4 }"> 
						          			<c:choose>
										        <c:when test="${fn:length(alarm.commonVar1) gt 13}">
										        	<a href="#" class="getBoard" data-alarm_num="${alarm.alarmNum}" data-board_num="${alarm.commonVar2}" data-reply_num="${alarm.commonVar3}">
										        		다음 댓글에 기부하셨습니다. "<c:out value="${fn:substring(alarm.commonVar1, 0, 13)}"/>....."
										        	</a>
										        </c:when>
										        <c:otherwise>
										        	<a href="#" class="getBoard" data-alarm_num="${alarm.alarmNum}" data-board_num="${alarm.commonVar2}" data-reply_num="${alarm.commonVar3}">
										        		다음 댓글에 기부하셨습니다. "<c:out value="${alarm.commonVar1}"/>"
										        	</a> 
										        </c:otherwise>
											</c:choose>
							       </c:when>
							       
							       <c:when test="${alarm.kind == 5 }"> 
						          			<c:choose>
										        <c:when test="${fn:length(alarm.commonVar1) gt 13}">
										        	<a href="#" class="getBoard" data-alarm_num="${alarm.alarmNum}" data-board_num="${alarm.commonVar2}" data-reply_num="${alarm.commonVar3}">
										        		다음 댓글에 좋아요 하셨습니다. "<c:out value="${fn:substring(alarm.commonVar1, 0, 13)}"/>....."
								        			</a>
										        </c:when>
										        <c:otherwise>
										        	<a href="#" class="getBoard" data-alarm_num="${alarm.alarmNum}" data-board_num="${alarm.commonVar2}" data-reply_num="${alarm.commonVar3}">
										        		다음 댓글에 좋아요 하셨습니다. "<c:out value="${alarm.commonVar1}"/>"
									        		</a>
										        </c:otherwise>
											</c:choose>
							       </c:when>
							       
							       <c:when test="${alarm.kind == 6 }">
							       			<c:choose>
										        <c:when test="${fn:length(alarm.commonVar1) gt 13}">
										        	<a href="#" class="getBoard" data-alarm_num="${alarm.alarmNum}" data-board_num="${alarm.commonVar2}" data-reply_num="${alarm.commonVar3}">
										        		다음 댓글에 싫어요 하셨습니다. "<c:out value="${fn:substring(alarm.commonVar1, 0, 13)}"/>....."
										        	</a>
										        </c:when>
										        <c:otherwise>
									        		<a href="#" class="getBoard" data-alarm_num="${alarm.alarmNum}" data-board_num="${alarm.commonVar2}" data-reply_num="${alarm.commonVar3}">
										        		다음 댓글에 싫어요 하셨습니다. "<c:out value="${alarm.commonVar1}"/>"
										        	</a>
										        </c:otherwise>
											</c:choose>
							       </c:when>
							       
							       <c:when test="${alarm.kind == 7 }">
							       		<a href="#" class="getMyCashHistory" data-alarm_num="${alarm.alarmNum}">
						          			캐시충전이 완료되었습니다.
						          		</a>
							       </c:when>
							       
							       <c:when test="${alarm.kind == 8 }">  
						          		<a href="#" class="getMyCashHistory" data-alarm_num="${alarm.alarmNum}">
						          			캐시환전이 완료되었습니다.
						          		</a>
							       </c:when>  
							       
						           <%-- <c:when test="${alarm.kind == 9 }">
						          			<c:choose>
										        <c:when test="${fn:length(alarm.commonVar1) gt 15}">
										        	<a href="#" class="getUserReportList" data-alarm_num="${alarm.alarmNum}">
										        		신고 접수 : "<c:out value="${fn:substring(alarm.commonVar1, 0, 15)}"/>....."
										        	</a>
										        </c:when>
										        <c:otherwise>
										        	<a href="#" class="getUserReportList" data-alarm_num="${alarm.alarmNum}">
										        		신고 접수 : "<c:out value="${alarm.commonVar1}"/>"
										        	</a> 
										        </c:otherwise>
											</c:choose>
							       </c:when> --%>
							       
						          <c:when test="${alarm.kind == 11 }">  
						          		<a href="#" class="getMyPage" data-alarm_num="${alarm.alarmNum}">
						          			접속이 제한 되었습니다. 
						          		</a>
							       </c:when>  
							       
							       <c:when test="${alarm.kind == 12 }">  
						          		<a href="#" class="getMyPage" data-alarm_num="${alarm.alarmNum}">
						          			접속 제한이 풀렸습니다.
						          		</a>
							       </c:when>  
							       
							       <c:when test="${alarm.kind == 13 }">
						          		<a href="#" class="getMyPage" data-alarm_num="${alarm.alarmNum}">
						          			일반 유저 권한이 부여되었습니다.  
						          		</a>
							       </c:when>  
							       
							       <c:when test="${alarm.kind == 14 }">
						          		<a href="#" class="getMyPage" data-alarm_num="${alarm.alarmNum}">
						          			일반 유저 권한이 삭제되었습니다.
						          		</a>
							       </c:when> 
							       
							       <c:when test="${alarm.kind == 15 }">   
						          		<a href="#" class="getMyPage" data-alarm_num="${alarm.alarmNum}">
						          			일반 관리자 권한이 부여되었습니다.
						          		</a>
							       </c:when> 
							       
							       <c:when test="${alarm.kind == 16 }">   
						          		<a href="#" class="getMyPage" data-alarm_num="${alarm.alarmNum}">
						          			일반 관리자 권한이 삭제되었습니다.
						          		</a>
							       </c:when> 
							        
						        </c:choose>  
					        <c:if test="${alarm.checking == 'NO'}">
					        	<span class="readCheck checkAlarm${alarm.alarmNum}">1</span> 
					        </c:if>
			       		</td>
						<td id="dateTd"> 
							<fmt:formatDate value="${alarm.regdate}" pattern="yyyy-MM-dd HH:mm" />
						</td>
					</tr>
				</c:forEach>
				    <tr>
				        <td class="bottomTd"><input type="checkbox" name="checkAll" id="checkAll" onclick="checkAll();"/>전체선택</td>
				        <td class="bottomTd"><button id='deleteBtn' type="button" class="btn">삭제</button></td> 
				    </tr>
			</table>
			
			<form id='actionForm' action="/alarmList" method='get'>  
				<input type='hidden' name='pageNum' value='${pageMaker.cri.pageNum}'>
				<input type='hidden' name='order' value='${pageMaker.cri.order}'>
				<input type='hidden' name='amount' value='${pageMaker.cri.amount}'>
				<input type='hidden' name='userId' value='${pageMaker.cri.userId}'>
			</form> 
			
			<form id='commonForm' action="/board/get" method='get'>  
			</form>
	</div>
	
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
			
</div> 
	
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script> 
<script> 
		
		var myId;
		var myNickName;
		var csrfHeaderName ="${_csrf.headerName}"; 
		var csrfTokenValue="${_csrf.token}";
	
		<sec:authorize access="isAuthenticated()">   
			myId = '${userInfo.username}';  
			myNickName = '${userInfo.member.nickName}';
		</sec:authorize>
		
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
				url : '/updateAlarmCheck/'+ alarmNum,
				success : function(result, status, xhr) {
					if (callback) {
						callback(result, status);
					}
				},
				error : function(xhr, status, er) {
					if (error) {
						error(status);
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
			actionForm.attr("action","/board/get");
			
			actionForm.submit();   
		}); */
		
		
		$("#deleteBtn").on("click", function() { 
			deleteAction(); 
		}); 
		
		var commonForm = $("#commonForm");
		
		$(".getBoard").on("click", function(e){//글 상세보기+알람 읽기 체크
			
					e.preventDefault();
		
					var board_num = $(this).data("board_num");  
					var alarmNum  = $(this).data("alarm_num");
					var reply_num = $(this).data("reply_num");
					
					updateAlarmCheck(alarmNum, 
							
						function(result, status){//알람 읽기 체크
							
								var checkAlarm = $("#checkAlarm+"+alarmNum);
						
								if(status == "success"){
									
									checkAlarm.html("");//알림 숫자 1 없애주기
									
									//location.href='/board/get?board_num='+board_num+'#reply_contents';
	
									commonForm.append("<input type='hidden' name='board_num' value='"+board_num+"'/>");
									
									if(reply_num != null){
										commonForm.append("<input type='hidden' name='reply_num' value='"+reply_num+"'/>");	
									}
									
									commonForm.submit();
								}
					   	},
					   	
					   	function(status){
				   	    	
							if(status == "error"){ 
								
								openAlert("Server Error(관리자에게 문의해주세요)");
							}
			   	    	}
					);
		});
		
		$(".getMyCashHistory").on("click",function(e) {//알람 읽기 체크+캐시 히스토리 가져오기
			var alarmNum = $(this).data("alarm_num");   
			
			updateAlarmCheck(alarmNum, function(result){//알람 읽기 체크
				var checkAlarm = $("#checkAlarm+"+alarmNum);
				var userId = '${userInfo.username}';
				
					if(result == "success"){
						checkAlarm.html("");//알림 숫자 1 없애주기   
						commonForm.attr("action", "/mypage/myCashHistory");
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
						commonForm.attr("action", "/admin/userReportList");
						commonForm.submit(); 
						}
		   	  });
		});
		
		$(".getMyPage").on("click",function(e) {//마이페이지 이동+알람 읽기 체크
			
			e.preventDefault();
		
			var userId = '${userInfo.username}';
			var alarmNum = $(this).data("alarm_num");  
			
			updateAlarmCheck(alarmNum, function(result){
				
				var checkAlarm = $(".checkAlarm+"+alarmNum);
			
				if(result == "success"){
					
					checkAlarm.html("");
					commonForm.attr("action", "/mypage/myInfoForm");
					commonForm.append("<input type='hidden' name='userId' value='"+userId+"'/>");
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
		   	 openAlert("삭제할 알림을 선택하세요");
		    return false;
		  }
		  
		  //console.log(checkRow); 
		  
		  deleting('정말 삭제 하시겠습니까?', function() {
			  actionForm.attr("action","/deleteAllAlarm").attr("method","post");
			  actionForm.append("<input type='hidden' name='checkRow' value='"+checkRow+"'>");
			  actionForm.append("<input type='hidden' id='csrf' name='${_csrf.parameterName}' value='${_csrf.token}'/>");
			  actionForm.submit();
		  });
		  
		}
	
</script>
	
</body>
</html>