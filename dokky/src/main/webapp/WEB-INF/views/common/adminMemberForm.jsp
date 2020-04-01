<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ include file="../includes/left.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>Dokky - 회원가입</title> 
<link href="/resources/css/memberForm.css" rel="stylesheet" type="text/css"/>
</head>
<body>
	<div class="memberFormWrap">	
	
		  <div class="title">
			회원가입
		  </div>	 
		  
		  <div class="tabcontent">
			 <form method='post' action="/adminMembers">	
			  	<table>
					<tr>
						<td class="tableText">
							아이디  
						</td>
						<td class="tableValue">
							<div class="memberProfile">
								<input type="text" name="userId" id="userId"  class="inputInfo" oninput="checkLength(this,20);" autofocus/> 
							</div> 
						</td> 	
					</tr>
					<tr>
						<td class="tableText">
							비밀번호 
						</td>
						<td class="tableValue">
							<div class="memberProfile">
								<input type="password" name="userPw" id="userpw" class="inputInfo" oninput="checkLength(this,20);"/>
							</div> 
						</td> 	
					</tr>
					<tr>
						<td class="tableText">
							비밀번호 재입력 
						</td>
						<td class="tableValue">
							<div class="memberProfile">
								<input type="password" name="userpwCheck" id="userpwCheck" class="inputInfo" oninput="checkLength(this,20);"/>
							</div> 
						</td> 	
					</tr>
					<tr>
						<td class="tableText">
							닉네임 
						</td>
						<td class="tableValue">
							<div class="memberProfile">
								<input type="text" name="nickName" id="nickName" class="inputInfo" oninput="checkLength(this,21);"/>
							</div> 
						</td> 	
					</tr>
					<!-- <tr>
						<td class="tableText">
							이메일 
						</td>
						<td class="tableValue">
							<div class="memberProfile">
								<input type="email" name="email" id="email" class="inputInfo" oninput="checkLength(this,21);"/>
							</div> 
						</td> 	
					</tr>
					<tr>
						<td class="tableText">
							연락처(선택) 
						</td>
						<td class="tableValue">
							<div class="memberProfile">
								<input type="text" name="phoneNum" class="inputInfo" oninput="checkLength(this,21);"/>
							</div> 
						</td> 	
					</tr> -->
					<tr>
						<td class="tableText">
							은행명(선택) 
						</td>
						<td class="tableValue">
							<div class="memberProfile">
								<input type="text" name="bankName" class="inputInfo" oninput="checkLength(this,21);"/>
							</div> 
						</td> 	
					</tr>
					<tr>
						<td class="tableText">
							계좌번호(선택)
						</td>
						<td class="tableValue">
							<div class="memberProfile">
								<input type="text" name="account" class="inputInfo" oninput="checkLength(this,21);"/>
							</div> 
						</td> 	
					</tr>
			  	</table> 
				
				<div class="nextWrap">
					<input type="button" class="submitInfo" id="join" value="가입완료"/>
				</div>
				
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
						openAlert(maxByte + " Byte 이상 입력할 수 없습니다.");         
						obj.value = reStr;       
					}   
				}else if(obj.tagName === "DIV"){
					if (stringByteLength > maxByte) {// 전체길이를 초과하면          
						openAlert(maxByte + " Byte 이상 입력할 수 없습니다.");         
						obj.innerHTML = reStr;    
					}   
				} 
				
				obj.focus();  
			}
		 
		 function checkDuplicatedId(id, callback, error) {
			 	var checkReturn; 
			 
				$.ajax({
					type : 'get',
					url : '/idCheckedVal?inputId='+id,
					async: false, //동기로 처리  
					success : function(result, status, xhr) {
						if (callback) {
							if(callback(result,xhr)){
								checkReturn = true; 
							}
						}
					},
					error : function(xhr, status, er) {
						if (error) {
							error(xhr,er);  
						}
					}
				});
				
			return checkReturn;  
		 }
		 
		 function checkDuplicatedNickname(nickname, callback, error) {
			 	var checkReturn; 
			 
				$.ajax({
					type : 'get',
					url : '/nickCheckedVal?inputNickname='+nickname,
					async: false,  
					success : function(result, status, xhr) {
						if (callback) {
							if(callback(result,xhr)){
								checkReturn = true; 
							}
						}
					},
					error : function(xhr, status, er) {
						if (error) {
							error(xhr,er);  
						}
					}
				});
				
			 return checkReturn;  
		 }
		 
		 /* function checkDuplicatedEmail(email, callback, error) {
			 	var checkReturn; 
			 
				$.ajax({
					type : 'get',
					url : '/emailCheckedVal?inputEmail='+email,
					async: false, //동기로 처리  
					success : function(result, status, xhr) {
						if (callback) {
							if(callback(result,xhr)){
								checkReturn = true; 
							}
						}
					},
					error : function(xhr, status, er) {
						if (error) {
							error(xhr,er);  
						}
					}
				});
				
			return checkReturn;  
		 } */
  
		 function memberCheck(){
			 var userId = $('#userId');
		     var userIdVal = userId.val();
		    	 userIdVal = $.trim(userIdVal);
		     
				if(userIdVal == ""){ 
					openAlert("아이디를 입력하세요.");
					userId.focus();  
					   return true;
				}
		    	
			var userpw = $('#userpw');
			var userpwVal = userpw.val();
				userpwVal = $.trim(userpwVal);
		     
				if(userpwVal == ""){ 
					openAlert("비밀번호를 입력하세요.");
					userpw.focus();  
					  return true;
				}
				
			var userpwCheck = $('#userpwCheck');
			var userpwCheckVal = userpwCheck.val();
				userpwCheckVal = $.trim(userpwCheckVal);
		     
				if(userpwCheckVal == ""){ 
					openAlert("비밀번호를 재입력하세요."); 
					userpwCheck.focus();  
					  return true;
				}
				if(userpwVal != userpwCheckVal ){ 
					openAlert('비밀번호가 일치하지 않습니다');
					userpwCheck.focus();
					return true;
				}
			
			var nickName = $('#nickName');
			var nickNameVal = nickName.val();
			nickNameVal = $.trim(nickNameVal);
	     
				if(nickNameVal == ""){ 
					nickName.focus();  
					openAlert("닉네임을 입력하세요."); 
					  return true;
				}
			
			/* var email = $('#email');
			var emailVal = email.val(); 
			emailVal = $.trim(emailVal);
	       
				if(emailVal == ""){ 
					email.focus(); 
					alert("이메일을 입력하세요.");  
					  return true;
				} */
			
			    if(checkDuplicatedId(userIdVal, function(result){ //아이디 중복체크
						if(result == 'success'){ 
					 		openAlert("아이디가 중복됩니다."); 
					 		userId.focus(); 
					 		return true; 
						}
			   	    }))
			    {  
			   		 return true;
			   	}
	      
			    if(checkDuplicatedNickname(nickNameVal, function(result){ //닉네임 중복체크
						if(result == 'success'){ 
					 		openAlert("닉네임이 중복됩니다."); 
					 		nickName.focus(); 
					 		return true; 
						}
		   	    	}))
			    {  
		   			 return true;
				}
	    
			    /* if(checkDuplicatedEmail(emailVal, function(result){ //이메일 중복체크
						if(result == 'success'){ 
					 		alert("이메일이 중복됩니다."); 
					 		email.focus(); 
					 		return true; 
						}
					}))
			    {  
				 	return true;
				} */
	    
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

