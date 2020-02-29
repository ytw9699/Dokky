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
	<title>Dokky - 쪽지쓰기</title>  
	<link href="/resources/css/registerNote.css" rel="stylesheet" type="text/css">
</head>
<body> 

<div class="noteWrap">	

		  <div id="menuWrap">
				<div class="tab">  
					<button onclick="location.href='/fromNoteList?userId=${userInfo.username}'">받은쪽지함 - ${fromNotetotal}</button>
					<button onclick="location.href='/toNoteList?userId=${userInfo.username}'">보낸쪽지함  - ${toNotetotal}</button>
					<button onclick="location.href='/myNoteList?userId=${userInfo.username}'">내게쓴쪽지함  - ${myNotetotal}</button>
					<button class="active" onclick="location.href='/registerNote?userId=${userInfo.username}'">내게쓰기</button>
			    </div> 
		  </div>
		  
          <div class="formWrapper">
		          <!-- <div class="row">
			          	<div class="topbody">
			          		<input id="to_id" class="" placeholder="받는사람 아이디를 입력하세요." oninput="checkLength(this,20);" autofocus/>
			          	</div> 
			          	<div class="topbody">
			          		<input id="checkbox" type="checkbox" value="" />내게쓰기
			          	</div>
		          </div> -->
		          <div class="row">
		          		<textarea id="content" placeholder="내용을 입력해 주세요." oninput="checkLength(this,1300);"></textarea>
		          </div>
		         
		          <div class="submitBtnWrap">  
			          	<button type="submit" id="submitBtn">보내기</button> 
		          </div>
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

	function checkLength(obj, maxByte) { 
		 
		if(obj.tagName === "INPUT" || obj.tagName === "TEXTAREA"){ 
			var str = obj.value; 
		}else if(obj.tagName === "DIV" ){
			var str = obj.innerHTML; 
		} 
			
		var stringByteLength = 0;
		var reStr;
			
		stringByteLength = (function(s,b,i,c){
			
		    for(b=i=0; c=s.charCodeAt(i++);){
		    
			    b+=c>>11?3:c>>7?2:1;
			    //3은 한글인 경우 한글자당 3바이트를 의미,영어는 1바이트 의미 3을2로바꾸면 한글은 2바이트 영어는 1바이트 의미
			    //현재 나의 오라클 셋팅 같은경우 한글을 한자당 3바이트로 처리
			    if (b > maxByte) { 
			    	break;
			    }
			    
			    reStr = str.substring(0,i);
		    }
		    
		    return b //b는 바이트수 의미
		    
		})(str);
		
		if(obj.tagName === "INPUT" || obj.tagName === "TEXTAREA"){ 
			if (stringByteLength > maxByte) {// 전체길이를 초과하면          
				alert(maxByte + " Byte 이상 입력할 수 없습니다.");         
				obj.value = reStr;       
			}   
		}else if(obj.tagName === "DIV"){
			if (stringByteLength > maxByte) {// 전체길이를 초과하면          
				alert(maxByte + " Byte 이상 입력할 수 없습니다.");         
				obj.innerHTML = reStr;    
			}   
		} 
		
		obj.focus();  
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
	
	/* $("#checkbox").on("change", function(e){
			
			if($("#checkbox").is(":checked")){
				
				$("#to_id").val(myId);
	        }else{
	        	
	        	$("#to_id").val("");
	        }
	}); */
	  
	$("#submitBtn").on("click", function(e){//쪽지 보내기 버튼
    
		    e.preventDefault();
				
			/* var to_id = $("#to_id").val();
	   			to_id = $.trim(to_id);
			
			if(to_id == ""){ 
				
				alert("받는사람 아이디를 입력하세요."); 
				return false;
			} */
			
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
		    					to_id 	    	: myId,	  //쪽지 받는 아이디
		    					//to_id 	    	: to_id,	  //쪽지 받는 아이디
		    					to_nickname		: myNickName,
		    					read_check 	    : 'NO' 		  //쪽지 읽음 체크
				 		  };
		    
		    insertNote(noteData, function(result){
				
			    	$("#content").val("");
			    	//$("#to_id").val(""); 
					//$("#checkbox").prop("checked", false);
					
					alert(result); 
	   	    });
    });
	
</script>
</body>
</html>