<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ include file="../includes/left.jsp"%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="//code.jquery.com/jquery-1.11.3.min.js"></script>
	<title>Dokky - 쪽지 상세페이지</title>  
	<link href="/ROOT/resources/css/detailNotepage.css" rel="stylesheet" type="text/css">
</head>
<body> 

<div class="noteWrap">	

		  <div id="menuWrap">
				<div class="tab"> 
						<button id="deleteBtn">삭제</button>
		          		<c:if test="${note_kind == 'fromNote'}">
		          			<button onclick="noteOpen('${note.from_id}','${note.from_nickname}')">답장</button>
		          		</c:if>
		    	</div>  
		  </div> 
		  
          <div class="formWrapper">
		          <div class="row">
		          		<c:choose>
					        <c:when test="${note_kind == 'fromNote' || note_kind == 'myNote'}">
		     					<div class="topData">보낸사람 -
			          				<a href="#" class="userMenu" data-note_num="${note.note_num}">
										<img src="/upload/<c:out value="${note.from_id}"/>.png"  class="memberImage hideUsermenu" onerror="this.src='/ROOT/resources/img/profile_img/basicProfile.png'" />
										<c:out value="${note.from_nickname}" />
									</a>   
									<div id="userMenubar_${note.note_num}" class="userMenubar">
										<ul class="hideUsermenu">
											<li class="hideUsermenu"><a href="/userBoardList?userId=${note.from_id}" class="hideUsermenu"><span class="hideUsermenu">게시글보기</span></a></li>
											<li class="hideUsermenu">
												<a href="#" class="hideUsermenu" onclick="noteOpen('${note.from_id}','${note.from_nickname}')">
													<span class="hideUsermenu">쪽지보내기</span>
												</a>
											</li>
										</ul>   
								    </div> 
					          	</div>
					          	<div class="topData"> 
					          		보낸시각 -<span class="date"><fmt:formatDate value="${note.regdate}" pattern="yyyy-MM-dd HH:mm" /></span>
					          	</div>
							</c:when>
							
							<c:when test="${note_kind == 'toNote'}">
								<div class="topData">받는사람 -
			          				<a href="#" class="userMenu" data-note_num="${note.note_num}">
										<img src="/upload/<c:out value="${note.to_id}"/>.png"  class="memberImage hideUsermenu" onerror="this.src='/ROOT/resources/img/profile_img/basicProfile.png'" />
										<c:out value="${note.to_nickname}" /> 
									</a>   
									<div id="userMenubar_${note.note_num}" class="userMenubar">
										<ul class="hideUsermenu">
											<li class="hideUsermenu"><a href="/userBoardList?userId=${note.to_id}" class="hideUsermenu"><span class="hideUsermenu">게시글보기</span></a></li>
											<li class="hideUsermenu"><a href="#" class="hideUsermenu"><span class="hideUsermenu">쪽지보내기</span></a></li>
										</ul>      
								    </div> 
					          	</div>
					         	<div class="topData"> 
					          		보낸시각 -<span class="date"><fmt:formatDate value="${note.regdate}" pattern="yyyy-MM-dd HH:mm" /></span>
					          	</div>
							</c:when>
							
		     			</c:choose> 
		          </div>
		          
	              <div id="content"> 
	          			${note.content}
	              </div>
		  </div>
</div>

<form id='actionForm' action="/deleteNote" method='post'>  
		<input type='hidden' name='pageNum' value='${cri.pageNum}'>
		<input type='hidden' name='amount' value='${cri.amount}'>
		<input type='hidden' name='userId' value='${cri.userId}'>
		<input type='hidden' name='note_num' value='${note.note_num}'>
		<input type='hidden' name='note_kind' value='${note_kind}'>
		<input type="hidden" id='csrf' name="${_csrf.parameterName}" value="${_csrf.token}"/>
</form>

<script> 

	var csrfHeaderName ="${_csrf.headerName}"; 
	var csrfTokenValue="${_csrf.token}";
	   
	$(document).ajaxSend(function(e, xhr, options) {
		
	     xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
	});
	
	var myId = '${userInfo.username}';  
	var myNickName = '${userInfo.member.nickName}';
	
	function noteOpen(userId,nickname){
		
		var popupX = (window.screen.width / 2) - (400 / 2);

		var popupY= (window.screen.height /2) - (500 / 2);
	         
        window.open('/minRegNote?userId='+userId+'&nickname='+nickname, 'ot', 'height=500, width=400, left='+ popupX + ', top='+ popupY + ', screenX='+ popupX + ', screenY= '+ popupY);
    } 

	
	//////////////////////////////////////////////////////////////////////////////
	
	function insertNote(noteData, callback, error) {
			$.ajax({
				type : 'post',
				url : '/Note',
				data : JSON.stringify(noteData),
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
	
	$("#checkbox").on("change", function(e){
			
			if($("#checkbox").is(":checked")){
				
				$("#to_id").val(myId);
	        }else{
	        	
	        	$("#to_id").val("");
	        }
	});
	  
	$("#submitBtn").on("click", function(e){//쪽지 보내기 버튼
    
		    e.preventDefault();
				
			var to_id = $("#to_id").val();
	   			to_id = $.trim(to_id);
			
			if(to_id == ""){ 
				
				openAlert("받는사람 아이디를 입력하세요"); 
				return false;
			}
			
			var content = $("#content").val();
			
				content = $.trim(content);
			
			if(content == ""){ 
				
			   openAlert("내용을 입력하세요"); 
			   return false;
			}
	
		    var noteData = {	  	
		    					content    		: content, 	  //쪽지 내용
		    					from_nickname   : myNickName, //쪽지 보내는 닉네임
		    					from_id      	: myId, 	  //쪽지 보내는 아이디
		    					to_id 	    	: to_id,	  //쪽지 받는 아이디
		    					read_check 	    : 'NO' 		  //쪽지 읽음 체크
				 		  };
		    
		    insertNote(noteData, function(result){
				
			    	$("#content").val("");
			    	$("#to_id").val(""); 
					$("#checkbox").prop("checked", false);
					
					openAlert(result); 
	   	    });
    });
	
	
	$("#deleteBtn").on("click", function() {
		if(confirm("정말 삭제 하시겠습니까?")){
			$("#actionForm").submit();
		  }
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
	
</script>
</body>
</html>