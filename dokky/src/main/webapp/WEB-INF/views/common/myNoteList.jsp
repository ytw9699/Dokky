<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">  
<title>Dokky - 내게쓴쪽지함</title>
<link href="/dokky/resources/css/noteList.css" rel="stylesheet" type="text/css"/>
</head>
<%@include file="../includes/left.jsp"%>
<body>
<sec:authentication property="principal" var="userInfo"/>

<div class="noteWrap">	

		<div id="menuWrap">
			<div class="tab"> 
				<button class="<c:if test="${pageMaker.cri.order == 0 }">active</c:if>" onclick="location.href='/dokky/registerNote?userId=${userInfo.username}&order=0'">쪽지쓰기</button>
				<button class="<c:if test="${pageMaker.cri.order == 1 }">active</c:if>" onclick="location.href='/dokky/fromNoteList?userId=${userInfo.username}&order=1'">받은쪽지함 - ${fromNotetotal}</button>
				<button class="<c:if test="${pageMaker.cri.order == 2 }">active</c:if>" onclick="location.href='/dokky/toNoteList?userId=${userInfo.username}&order=2'">보낸쪽지함  - ${toNotetotal}</button>
				<button class="<c:if test="${pageMaker.cri.order == 3 }">active</c:if>" onclick="location.href='/dokky/myNoteList?userId=${userInfo.username}&order=3'">내게쓴쪽지함  - ${myNotetotal}</button>
		    </div> 
		</div>
		
		<div class="listWrapper">
			<table id="inforTable"> 
					<tr>
						<td class="topTd">
							<input type="checkbox" name="checkAll" id="checkAll" onclick="checkAll();"/>전체선택
						</td>
						<td class="topTd">
							보낸사람
						</td>
						<td class="topTd">
							내용
						</td>
						<td class="topTd">
							보낸날짜
						</td>
					</tr>
				<c:forEach items="${myNoteList}" var="note">
					<tr>
						<td class="td"> 
							<input type="checkbox" name="checkRow" value="${note.note_num}" />
	                    </td>
	                    
		     			<td class="td"> 
							<a href="#" class="userMenu" data-note_num="${note.note_num}">
								<img src="/dokky/resources/img/profile_img/<c:out value="${note.from_id}"/>.png"  class="memberImage hideUsermenu" onerror="this.src='/dokky/resources/img/basicProfile.png'" />
								<c:out value="${note.from_nickname}" /> 
							</a>   
							 <div id="userMenubar_${note.note_num}" class="userMenubar">
								<ul class="hideUsermenu">
									<li class="hideUsermenu">
										<a href="/dokky/userBoardList?userId=${note.from_id}" class="hideUsermenu">
											<span class="hideUsermenu">게시글보기</span>
										</a>
									</li>
									<li class="hideUsermenu">
										<a href="#" class="hideUsermenu" onclick="noteOpen('${note.from_id}','${note.from_nickname}')">
											<span class="hideUsermenu">쪽지보내기</span>
										</a>
									</li>
								</ul>      
						     </div> 
						</td>
						
						<td class="content">
		          			<a href="#" class="getNote" data-note_num="${note.note_num}">
	          					<c:choose>
							        <c:when test="${fn:length(note.content) > 20}">
							        	<c:out value="${fn:substring(note.content, 0, 20)}"/>.....
							        </c:when>
							        <c:otherwise>
							        	<c:out value="${note.content}"/> 
							        </c:otherwise>
								</c:choose>
		          			</a>
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
		
			<form id='actionForm' action="/dokky/myNoteList" method='get'>  
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
		
		var csrfHeaderName ="${_csrf.headerName}"; 
		var csrfTokenValue="${_csrf.token}";
		
		$(document).ajaxSend(function(e, xhr, options) { 
		    xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
	    });
		
		function noteOpen(userId,nickname){
			
			var popupX = (window.screen.width / 2) - (400 / 2);

			var popupY= (window.screen.height /2) - (500 / 2);
		         
	        window.open('/dokky/minRegNote?userId='+userId+'&nickname='+nickname, 'ot', 'height=500, width=400, left='+ popupX + ', top='+ popupY + ', screenX='+ popupX + ', screenY= '+ popupY);
	    } 
		
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
				  actionForm.attr("action","/dokky/deleteAllNote").attr("method","post");
				  actionForm.append("<input type='hidden' name='checkRow' value='"+checkRow+"'>");
				  actionForm.append("<input type='hidden' name='note_kind' value='myNote'>");
				  actionForm.append("<input type='hidden' id='csrf' name='${_csrf.parameterName}' value='${_csrf.token}'/>");
				  actionForm.submit();
			  }
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
		
		$(".getNote").on("click",function(e) {//쪽지 상세보기 
			
			e.preventDefault();

			var note_num = $(this).data("note_num");  
			
			actionForm.attr("action", "/dokky/detailNotepage");
			actionForm.append("<input type='hidden' name='note_num' value='"+note_num+"'/>");
			actionForm.append("<input type='hidden' name='note_kind' value='myNote'/>");
			actionForm.submit();
			
		});
		
</script>
	
</body>
</html>