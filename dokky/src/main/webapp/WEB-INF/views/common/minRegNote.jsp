<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="//code.jquery.com/jquery-1.11.3.min.js"></script>
	<title>Dokky - 쪽지쓰기</title>  
	<link href="/dokky/resources/css/minRegNote.css" rel="stylesheet" type="text/css">
	<sec:authentication property="principal" var="userInfo"/>
</head>
<body> 
        <div class="formWrapper">
	          <div class="row">
	          	<span>
	          		받는사람 -
	          	</span>
	          	<span>
	          		<img src="/dokky/resources/img/profile_img/<c:out value="${to_id}" />.png" class="memberImage" onerror="this.src='/dokky/resources/img/basicProfile.png'" />
	          		${to_nickname} 
	          	</span>
	          	(<span id="to_id">
	          		 ${to_id}
	          	</span>)
	          </div>
	          
	          <div class="row">
	          	<textarea id="content" placeholder="내용을 입력해 주세요." oninput="checkLength(this,1300);"></textarea>
	          </div>
	         
	          <div class="submitBtnWrap">  
		          	<button type="submit" id="submitBtn">보내기</button>    
		          	<button type="button" id="cancel" onclick="window.close()">취소</button>
	          </div>
	    </div> 
<script> 

	var csrfHeaderName ="${_csrf.headerName}"; 
	var csrfTokenValue="${_csrf.token}"; 
	   
	$(document).ajaxSend(function(e, xhr, options) {
		
	     xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
	});
	
	var myId = '${userInfo.username}';  
	var myNickName = '${userInfo.member.nickName}';

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
	
	$("#submitBtn").on("click", function(e){//쪽지 보내기 버튼
    
		    e.preventDefault();
				
			var to_id = $("#to_id").html();
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
		    					checking 	    : 'NO' 		  //쪽지 읽음 체크
				 		  };
		    
		    insertNote(noteData, function(result){
					alert(result); 
					window.close();
	   	    });
    });
	
</script>
</body>
</html>