<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"> 
<title>Dokky - 쪽지</title>
<link href="/dokky/resources/css/fromNoteList.css" rel="stylesheet" type="text/css"/>
</head>
<%@include file="../includes/left.jsp"%>
<body>
<sec:authentication property="principal" var="userInfo"/>

<div class="noteWrap">	
	<div class="ContentWrap">
		<div id="menuWrap">
			<div class="tab"> 
				<button onclick="location.href='registerNote'">쪽지쓰기</button> 
				<button onclick="location.href='fromNoteList?userId=${userInfo.username}'">받은쪽지함</button>
				<button onclick="location.href='alarmList?userId=${userInfo.username}'">보낸쪽지함</button>
				<button onclick="location.href='alarmList?userId=${userInfo.username}'">내게쓴쪽지함</button>
		    </div> 
		</div>
		
		<div class="listWrapper">
			<div class="">
				<table class=""> 
					<c:forEach items="${fromNoteList}" var="note">
						<tr>
							<td>
								<input type="checkbox" name="checkRow" value="${note.note_num}" />
		                    </td>
		                    
			     			<td> 
								<a href="#" class="userMenu" data-note_num="${note.note_num}">
									<img src="/dokky/resources/img/profile_img/<c:out value="${note.from_id}"/>.png"  class="memberImage hideUsermenu" onerror="this.src='/dokky/resources/img/basicProfile.png'" />
									<c:out value="${note.from_nickname}" /> 
								</a>   
								 <div id="userMenubar_${note.note_num}" class="userMenubar">
									<ul class="hideUsermenu">
										<li class="hideUsermenu"><a href="/dokky/userBoardList?userId=${note.from_id}" class="hideUsermenu"><span class="hideUsermenu">게시글보기</span></a></li>
										<li class="hideUsermenu"><a href="#" class="hideUsermenu"><span class="hideUsermenu">쪽지보내기</span></a></li>
									</ul>      
							     </div> 
							</td>
							
							<td>
			          			<a href="#" class="getNote" data-note_num="${note.note_num}">"${note.content}"</a>
				          	</td>
			          		
			          		<td class="checkNote${note.note_num}"> 
				          		 <c:if test="${note.checking == 'NO'}"> 
										<span class="readCheck">1</span> 				          		 	
				          		 </c:if> 
			          		</td>
			          		 
							<td>
								<fmt:formatDate value="${note.regdate}" pattern="yyyy-MM-dd HH:mm" />
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
			
			<form id='actionForm' action="/dokky/fromNoteList" method='get'>  
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
			   	 alert("삭제할 쪽지를 선택하세요.");
			    return false;
			  }
			  
			  if(confirm("정말 삭제 하시겠습니까?")){
				  actionForm.attr("action","/dokky/removeAllNote").attr("method","post");
				  actionForm.append("<input type='hidden' name='checkRow' value='"+checkRow+"'>");
				  actionForm.append("<input type='hidden' id='csrf' name='${_csrf.parameterName}' value='${_csrf.token}'/>");
				  actionForm.submit();
			  }
		}
		
		var commonForm = $("#commonForm");
		
		$(".getNote").on("click",function(e) {//쪽지 상세보기+ 쪽지 읽기 체크
			
					e.preventDefault();
					var note_num = $(this).data("note_num");  
					
					updateNoteCheck(alarmNum, function(result){//알람 읽기 체크
						var checkNote = $("#checkNote+"+alarmNum);
							if(result == "success"){
								
								checkNote.html("");//알림 숫자 1 없애주기
								
								commonForm.append("<input type='hidden' name='note_num' value='"+note_num+"'/>");
								commonForm.submit();//글 상세보기 
								}
				   	  });
				});
		
		
		$(".userMenu").on("click",function(event){//해당 메뉴바 보이기 이벤트
					
					var	note_num = $(this).data("note_num");
					var userMenubar = $("#userMenubar_"+note_num);
							
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
		
		var actionForm = $("#actionForm");

		$(".paginate_button a").on("click", function(e) {//결국pageNum값만 바꿔주기 위해
	
					e.preventDefault();
	
					actionForm.find("input[name='pageNum']").val($(this).attr("href"));//pageNum값을 바꿔주는것//this는 a태그의 href값을 가져오는것
					
					actionForm.submit();
		});
	
		$("#deleteBtn").on("click", function() { 
			deleteAction(); 
		}); 
		
		var commonForm = $("#commonForm");
		
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
		
</script>
	
</body>
</html>