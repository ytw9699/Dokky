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
	<c:choose>
	   	  <c:when test="${pageContext.request.serverName == 'localhost'}">
				<link href="/resources/css/common/noteForm.css" rel="stylesheet" type="text/css">
				<script type="text/javascript" src="/resources/js/common.js"></script>
		  </c:when>
	      <c:otherwise>
	    		<link href="/ROOT/resources/css/common/noteForm.css" rel="stylesheet" type="text/css">
	    		<script type="text/javascript" src="/ROOT/resources/js/common.js"></script>
	      </c:otherwise>
	</c:choose>
	<sec:authentication property="principal" var="userInfo"/>
</head>
<body> 
        <div class="formWrapper">
	          <div class="row top">
		          	<span>
		          		받는사람 -
		          	</span>
		          	<span>
		          		<c:choose>
						   	  <c:when test="${pageContext.request.serverName == 'localhost'}">
									<img src="/resources/img/profile_img/<c:out value="${to_id}" />.png?${random}" class="memberImage" onerror="this.src='/resources/img/profile_img/basicProfile.png'" />
							  </c:when>
						      <c:otherwise>
						    		<img src="/upload/<c:out value="${to_id}" />.png?${random}" class="memberImage" onerror="this.src='/ROOT/resources/img/profile_img/basicProfile.png'" />
						      </c:otherwise>
						</c:choose>
						<c:choose>
						   	  <c:when test="${enabled == 1}">
									${to_nickname} 
							  </c:when>
						      <c:otherwise>
						    		탈퇴회원
						      </c:otherwise>
						</c:choose>
		          	</span>
		          	<%-- (<span id="to_id">
		          		 ${to_id}
		          	</span>) --%>
	          </div>
	          
	          <div class="row">
	          			<c:choose>
						   	  <c:when test="${enabled == 1}">
									<textarea id="content" placeholder="내용을 입력해 주세요." oninput="checkLength(this,1300);" autofocus></textarea> 
							  </c:when>
						      <c:otherwise>
						    		<textarea id="content" placeholder="탈퇴회원에게는 쪽지를 보낼 수 없습니다." oninput="checkLength(this,1300);" autofocus></textarea>
						      </c:otherwise>
						</c:choose>
	          </div>
	         
	          <div class="submitBtnWrap">
				   	  <c:if test="${enabled == 1}">
							<button type="submit" class="btn" id="submitBtn">보내기</button> 
					  </c:if> 
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
	
	 function parseUrl(orgnTxt) {
	    	
	        var rplcdTxt, rplcdPttrn1, rplcdPttrn2, rplcdPttrn3;

	        //  http://, https://로 url이 시작한다면.
	        rplcdPttrn1 = /(\b(https?):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/gim;
	        rplcdTxt = orgnTxt.replace(rplcdPttrn1, '<a href="$1" target="_blank">$1</a>');

	        //  http?없이 www로 시작한다면.
	        rplcdPttrn2 = /(^|[^\/])(www\.[\S]+(\b|$))/gim;
	        rplcdTxt = rplcdTxt.replace(rplcdPttrn2, '$1<a href="http://$2" target="_blank">$2</a>');

	        //  메일 주소일 경우
	        rplcdPttrn3 = /(([a-zA-Z0-9\-\_\.])+@[a-zA-Z\_]+?(\.[a-zA-Z]{2,6})+)/gim;
	        rplcdTxt = rplcdTxt.replace(rplcdPttrn3, '<a href="mailto:$1">$1</a>');

	        return rplcdTxt;
	}
	
	//////////////////////////////////////////////////////////////////////////////
	
	$("#submitBtn").on("click", function(e){//쪽지 보내기 버튼
    		
		    e.preventDefault();
			
			var content = $("#content").val();
			
				content = $.trim(content);
			
			if(content == ""){ 
				
			   openAlert("내용을 입력하세요"); 
			   return false;
			}
			
		    var noteData = {	  	
		    					content    		: parseUrl(content), 	  //쪽지 내용
		    					from_nickname   : myNickName, //쪽지 보내는 닉네임
		    					from_id      	: myId, 	  //쪽지 보내는 아이디
		    					to_id 	    	: "${to_id}", //쪽지 받는 아이디
		    					to_nickname		: "${to_nickname}",//쪽지 받는 닉네임
		    					read_check 	    : 'NO' 		  //쪽지 읽음 체크
				 		  };
		    
		    commonService.insertNote(noteData, function(result, status){
		    	
			    	if(status == "success"){
			    			
			    		window.close(); 
			    		
			    		if(opener.webSocket != null){
							opener.webSocket.send("noteAlarm,"+noteData.to_id);
					   	}
			    		
						opener.openAlert("쪽지를 보냈습니다");
			    	}
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