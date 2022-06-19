<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ include file="../includes/common.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>Dokky - 회원가입</title> 
<c:choose>
   	  <c:when test="${pageContext.request.serverName == 'localhost'}">
			<link href="/resources/css/common/memberForm.css" rel="stylesheet" type="text/css"/>
	  </c:when>
      <c:otherwise>
    		<link href="/ROOT/resources/css/common/memberForm.css" rel="stylesheet" type="text/css"/>
      </c:otherwise>
</c:choose>
</head>
<body>
	<div class="memberFormWrap">	
	
		  <div class="title">
			회원가입
		  </div>	 
		  
		  <div class="tabcontent">
			 <form method='post' action="/members">	
			  	<table>
					<tr>
						<td class="tableText">
							닉네임 
						</td>
						<td class="tableValue">
							<div class="memberProfile">
								<input type="text" name="nickName" id="nickName" value="${nickName}" class="inputInfo" oninput="checkLength(this,21);"/>
							</div> 
						</td> 	
					</tr>
			  	</table> 
				
				<div class="nextWrap">
					<input type="button" class="submitInfo" id="join" value="가입완료"/>
				</div>
				
				<input type="hidden" name="userId" value="${id}" />
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
			 </form> 
		  </div>
	</div>
	
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script>
  	
 		 var csrfHeaderName ="${_csrf.headerName}"; 
		 var csrfTokenValue="${_csrf.token}";
		    
		 $(document).ajaxSend(function(e, xhr, options) { 
	       xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
	   	 });
		 
		 
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
		 				 
		 function checkDuplicatedNickname(nickname, callback, error) {
			 
			 	var checkReturn; 
			 
				$.ajax({
					type : 'get',
					url : '/nickCheckedVal?inputNickname='+nickname,
					async: false,  
					success : function(result, status, xhr) {
						if (callback) {
							if(callback(result, xhr)){
								checkReturn = true; 
							}
						}
					},
					error : function(xhr, status, er) {
						if(status == "error"){
							openAlert("ServerErorr입니다.");
							checkReturn = true; 
						}
					}
				});
				
			 return checkReturn;  
		 }
		 
		 function memberCheck(){
			
			var nickName = $('#nickName');
			var nickNameVal = nickName.val();
			nickNameVal = $.trim(nickNameVal);
	     
				if(nickNameVal == ""){ 
					nickName.focus();  
					openAlert("닉네임을 입력하세요"); 
					  return true;
				}
					      
			    if(checkDuplicatedNickname(nickNameVal, function(result){ //닉네임 중복체크
						if(result == 'duplicated'){ 
					 		openAlert("닉네임이 중복됩니다"); 
					 		nickName.focus(); 
					 		return true; 
						}
		   	    	}))
			    {  
		   			 return true;
				}
			    
		   return false;
	     }//END memberCheck
	 
		$("#join").on("click", function(e){
			   e.preventDefault();
			   
			   if(memberCheck()){ 
			   	return; 
			   } 
			   
			   
			   $("form").submit();
		});
	  
</script>
</body>
</html>

