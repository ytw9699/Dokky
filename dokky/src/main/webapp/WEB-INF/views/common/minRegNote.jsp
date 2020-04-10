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
	<link href="/resources/css/minRegNote.css" rel="stylesheet" type="text/css">
	<sec:authentication property="principal" var="userInfo"/>
</head>
<body> 
        <div class="formWrapper">
	          <div class="row top">
		          	<span>
		          		받는사람 -
		          	</span>
		          	<span>
		          		<img src="/resources/img/profile_img/<c:out value="${to_id}" />.png" class="memberImage" onerror="this.src='/resources/img/profile_img/basicProfile.png'" />
		          		${to_nickname} 
		          	</span>
		          	<%-- (<span id="to_id">
		          		 ${to_id}
		          	</span>) --%>
	          </div>
	          
	          <div class="row">
	          		<textarea id="content" placeholder="내용을 입력해 주세요." oninput="checkLength(this,1300);" autofocus></textarea> 
	          </div>
	         
	          <div class="submitBtnWrap">  
		          	<button type="submit" class="btn" id="submitBtn">보내기</button>    
		          	<button type="button" class="btn" id="cancel" onclick="window.close()">취소</button>
	          </div>
	    </div> 
	    
 	<div id="alertFakeDiv"></div> 
	<div id="alertDiv">
			<div id="alertContent"></div>  
			<input type="button" id="alertConfirm" value="확인" onclick="closeAlert();" /> 
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
				openAlert(maxByte + " Byte 이상 입력할 수 없습니다");         
				obj.value = reStr;       
			}   
		}else if(obj.tagName === "DIV"){
			if (stringByteLength > maxByte) {// 전체길이를 초과하면          
				openAlert(maxByte + " Byte 이상 입력할 수 없습니다");         
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
	
	$("#submitBtn").on("click", function(e){//쪽지 보내기 버튼
    		
		    e.preventDefault();
				 
			/* var to_id = $("#to_id").html();
	   			to_id = $.trim(to_id);
			
			if(to_id == ""){ 
				
				alert("받는사람 아이디를 입력하세요."); 
				return false;
			} */
			
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
		    					to_id 	    	: "${to_id}", //쪽지 받는 아이디
		    					to_nickname		: "${to_nickname}",//쪽지 받는 닉네임
		    					read_check 	    : 'NO' 		  //쪽지 읽음 체크
				 		  };
		    
		    insertNote(noteData, function(result){
					openAlert(result);  
					window.close(); 
					opener.openAlert("쪽지를 보냈습니다"); 
	   	    });
    });
	
	function openAlert(content){ 
		
		var alertFakeDiv = $("#alertFakeDiv");
		var alertDiv = $("#alertDiv"); 
		var alertContent = $("#alertContent");
		
		alertContent.html(content); 
		 
		alertFakeDiv.css("display","block");
		alertDiv.css("display","block"); 
	}
	  
	function closeAlert(content){ 
		
		var alertFakeDiv = $("#alertFakeDiv"); 
		var alertDiv = $("#alertDiv");
		
		alertFakeDiv.css("display","none");
		alertDiv.css("display","none"); 
	}
	
</script>
</body>
</html>