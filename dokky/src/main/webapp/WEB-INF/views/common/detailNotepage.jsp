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
	<link href="/dokky/resources/css/detailNotepage.css" rel="stylesheet" type="text/css">
</head>
<body> 

<div class="noteWrap">	
	<div class="ContentWrap">
		  <div id="menuWrap">
				<div class="tab"> 
					<button onclick="location.href='/dokky/registerNote'">쪽지쓰기</button>
					<button onclick="location.href='/dokky/fromNoteList?userId=${userInfo.username}'">받은쪽지함 - ${fromNotetotal}</button>
					<button onclick="location.href='/dokky/toNoteList?userId=${userInfo.username}'">보낸쪽지함  - ${toNotetotal}</button>
					<button onclick="location.href='/dokky/myNoteList?userId=${userInfo.username}'">내게쓴쪽지함  - ${myNotetotal}</button>
		    	</div>  
		  </div> 
		  
          <div class="formWrapper">
		          <div class="row">
				          	<div>
				          		<span><button id="deleteBtn">삭제</button></span>
				          		<c:if test="${note_kind == 'fromNote'}">
				          			<span><button onclick="noteOpen('${note.from_id}','${note.from_nickname}')">답장</button></span>
				          		</c:if>
				          	</div> 
		          	<c:choose>
				        <c:when test="${note_kind == 'fromNote' || note_kind == 'myNote'}">
	     					<div>보낸사람 -
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
				          	</div>
				          	<div>
				          		보낸시각 <fmt:formatDate value="${note.regdate}" pattern="yyyy-MM-dd HH:mm" />
				          	</div>
						</c:when>
						<c:when test="${note_kind == 'toNote'}">
							<div>받는사람 -
		          				<a href="#" class="userMenu" data-note_num="${note.note_num}">
									<img src="/dokky/resources/img/profile_img/<c:out value="${note.to_id}"/>.png"  class="memberImage hideUsermenu" onerror="this.src='/dokky/resources/img/basicProfile.png'" />
									<c:out value="${note.to_nickname}" /> 
								</a>   
								<div id="userMenubar_${note.note_num}" class="userMenubar">
									<ul class="hideUsermenu">
										<li class="hideUsermenu"><a href="/dokky/userBoardList?userId=${note.to_id}" class="hideUsermenu"><span class="hideUsermenu">게시글보기</span></a></li>
										<li class="hideUsermenu"><a href="#" class="hideUsermenu"><span class="hideUsermenu">쪽지보내기</span></a></li>
									</ul>      
							    </div> 
				          	</div>
				          	<div>
				          		보낸시각 <fmt:formatDate value="${note.regdate}" pattern="yyyy-MM-dd HH:mm" />
				          	</div>
						</c:when>
	     			</c:choose> 
		          	
		          </div>
		          
	              <div id="content"> 
	          			${note.content}
	              </div>
		  </div>
	</div>
</div>
<form id='actionForm' action="/dokky/deleteNote" method='post'>  
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
        window.open('/dokky/minRegNote?userId='+userId+'&nickname='+nickname, 'ot', 'width=500px, height=500px'); 
    } 

	function checkLength(obj, maxlength) {   
			var str = obj.value; // 이벤트가 일어난 컨트롤의 value 값    
			var str_length = str.length; // 전체길이       // 변수초기화     
			var max_length = maxlength; // 제한할 글자수 크기     
			var i = 0; // for문에 사용     
			var ko_byte = 0; // 한글일경우는, 2그밗에는 1을 더함     
			var li_len = 0; // substring하기 위해서 사용     
			var one_char = ""; // 한글자씩 검사한다     
			var reStr = ""; // 글자수를 초과하면 제한할수 글자전까지만 보여준다.  
			
			for (i = 0; i < str_length; i++) { // 한글자추출         
				one_char = str.charAt(i);            
				ko_byte++;        
			}     
			
			if (ko_byte <= max_length) {// 전체 크기가 max_length를 넘지않으면                
				li_len = i + 1;         
			}  
			
			if (ko_byte > max_length) {// 전체길이를 초과하면          
					alert(max_length + " 글자 이상 입력할 수 없습니다.");         
					reStr = str.substr(0, max_length);         
					obj.value = reStr;      
			}     
			obj.focus();  
	}
	
	//////////////////////////////////////////////////////////////////////////////
	
	function insertNote(noteData, callback, error) {
			$.ajax({
				type : 'post',
				url : '/dokky/Note',
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
				
				alert("받는사람 아이디를 입력하세요."); 
				return false;
			}
			
			var content = $("#content").val();
			
				content = $.trim(content);
			
			if(content == ""){ 
				
			   alert("내용을 입력하세요."); 
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
					
					alert(result); 
	   	    });
    });
	
	
	$("#deleteBtn").on("click", function() {
		if(confirm("정말 삭제 하시겠습니까?")){
			$("#actionForm").submit();
		  }
	}); 
	
</script>
</body>
</html>