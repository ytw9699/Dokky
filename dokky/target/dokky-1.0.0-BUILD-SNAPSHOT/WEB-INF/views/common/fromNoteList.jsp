<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"> 
<title>Dokky - 받은쪽지함</title>
<c:choose>
   	  <c:when test="${pageContext.request.serverName == 'localhost'}">
			<link href="/resources/css/common/noteList.css" rel="stylesheet" type="text/css"/>
	  </c:when>
      <c:otherwise>
    		<link href="/ROOT/resources/css/common/noteList.css" rel="stylesheet" type="text/css"/>
      </c:otherwise>
</c:choose>
</head>
<%@include file="../includes/common.jsp"%>
<body>
<sec:authentication property="principal" var="userInfo"/>

<div class="noteWrap">	

		<div id="menuWrap">
			<div class="tab">  
				<button class="active" onclick="location.href='/fromNoteList?userId=${userInfo.username}'">받은쪽지함 - ${fromNotetotal}</button>
				<button onclick="location.href='/toNoteList?userId=${userInfo.username}'">보낸쪽지함  - ${toNotetotal}</button>
				<button onclick="location.href='/myNoteList?userId=${userInfo.username}'">내게쓴쪽지함  - ${myNotetotal}</button>
				<button onclick="location.href='/myNoteForm?userId=${userInfo.username}'">내게쓰기</button>
		    </div> 
		</div>
		
		<div class="listWrapper">
				<table id="inforTable">
						<tr>
							<td class="topTd"> 
								<input type="checkbox" name="checkAll" id="checkAll" onclick="checkAll();"/>전체선택
							</td>
							<td class="topTd">
								보낸이
							</td>
							<td class="topTd">
								내용
							</td>
						 	<td>
						 	</td>
							<td class="topTd">
								보낸날짜
							</td>
						</tr>
						
					<c:forEach items="${fromNoteList}" var="note">
						<tr>
							<td>
								<input type="checkbox" name="checkRow" value="${note.note_num}" />
		                    </td>
		                    
			     			<td class="td"> 
								<a href="#" class="userMenu" data-note_num="${note.note_num}">
									<c:choose>
									   	  <c:when test="${pageContext.request.serverName == 'localhost'}">
												<img src="/resources/img/profile_img/<c:out value="${note.from_id}" />.png?${random}"  class="memberImage hideUsermenu" onerror="this.src='/resources/img/profile_img/basicProfile.png'" />
										  </c:when>
									      <c:otherwise>
									    		<img src="/upload/<c:out value="${note.from_id}"/>.png?${random}"  class="memberImage hideUsermenu" onerror="this.src='/ROOT/resources/img/profile_img/basicProfile.png'" />
									      </c:otherwise>
									</c:choose>
									<c:out value="${note.from_nickname}" /> 
								</a>   
								<div id="userMenubar_${note.note_num}" class="userMenubar">
									<ul class="hideUsermenu">
										<li class="hideUsermenu">
											<a href="/userBoardList?userId=${note.from_id}" class="hideUsermenu">
												<span class="hideUsermenu">게시글보기</span>
											</a>
										</li>
										<li class="hideUsermenu">
											<a href="#" class="hideUsermenu" onclick="noteOpen('${note.from_id}','${note.from_nickname}')">
												<span class="hideUsermenu">쪽지보내기</span>
											</a>
										</li>
										<li class="hideUsermenu singleChat" data-chat_nickname="${note.from_nickname}" data-chat_userid="${note.from_id}">
											<a href="#" class="hideUsermenu">
												<span class="hideUsermenu">1:1채팅</span>
											</a>
										</li>
									</ul>      
							    </div> 
							</td>
							<td class="content" data-note_num="${note.note_num}"> 
									<div class="title">
									        	<c:out value="${note.content}" escapeXml="false"/>
				          			</div>
				          	</td>
				          	<td>
			          			<c:if test="${note.read_check == 'NO'}">
				          			<div class="readCheck checkNote${note.note_num}">
										1 
									</div>
								</c:if>
				          	</td>
							<td id="dateTd">
								<fmt:formatDate value="${note.regdate}" pattern="yyyy-MM-dd HH:mm" />
							</td>
							
						</tr>
					</c:forEach>
					    <tr>
					        <td><button id='deleteBtn' type="button" class="btn">삭제</button></td>
					    </tr>
				</table>
		
				<form id='actionForm' action="/fromNoteList" method='get'>  
					<input type='hidden' name='pageNum' value='${pageMaker.cri.pageNum}'>
					<input type='hidden' name='amount' value='${pageMaker.cri.amount}'>
					<input type='hidden' name='userId' value='${pageMaker.cri.userId}'>
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

		var actionForm = $("#actionForm");
		var userId = '${userInfo.username}';
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
		 
		/*  
		function noteOpen(userId,nickname){
			
			$(".userMenubar").css("display","none");
			
			var popupX = (window.screen.width / 2) - (400 / 2);

			var popupY= (window.screen.height /2) - (500 / 2);
		         
	        window.open('/noteForm?userId='+userId+'&nickname='+nickname, 'ot', 'height=500, width=400, left='+ popupX + ', top='+ popupY + ', screenX='+ popupX + ', screenY= '+ popupY);
	    }  
		*/ 
		
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
			   	 openAlert("삭제할 쪽지를 선택하세요");
			    return false;
			  }
			  
			  deleting('정말 삭제 하시겠습니까?', function() {
				  actionForm.attr("action","/deleteAllNote").attr("method","post");
				  actionForm.append("<input type='hidden' name='checkRow' value='"+checkRow+"'>");
				  actionForm.append("<input type='hidden' name='note_kind' value='fromNote'>");
				  actionForm.append("<input type='hidden' id='csrf' name='${_csrf.parameterName}' value='${_csrf.token}'/>");
				  actionForm.submit();
			  });
		}
		
		$("#deleteBtn").on("click", function() { 
			deleteAction(); 
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
		
		$(".paginate_button a").on("click", function(e) {
	
					e.preventDefault();
	
					actionForm.find("input[name='pageNum']").val($(this).attr("href"));
					
					actionForm.submit();
		});
		
		function updateNoteCheck(note_num, callback, error){
				$.ajax({
						type : 'put',
						url : '/noteCheck/'+ note_num,
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
		
		$(".content").on("click",function(e) {//쪽지 상세보기 + 쪽지 읽기 체크
			
				e.preventDefault();
	
				var note_num = $(this).data("note_num");  
				
				updateNoteCheck(note_num, 
						
						function(result, status){//쪽지 읽기 체크
						
							var checkNote = $("#checkNote+"+note_num);
							
							if(status == "success"){
								
								checkNote.html("");
								
								actionForm.attr("action", "/detailNotepage");
								actionForm.append("<input type='hidden' name='note_num' value='"+note_num+"'/>");
								actionForm.append("<input type='hidden' name='note_kind' value='fromNote'/>");
								actionForm.submit();
							}
						},
						    
				    	function(status){
				    	
							if(status == "error"){ 
								
								openAlert("Server Error(관리자에게 문의해주세요)");
							}
				    	}
	   	  		);
		});
    	
</script>
	
</body>
</html>