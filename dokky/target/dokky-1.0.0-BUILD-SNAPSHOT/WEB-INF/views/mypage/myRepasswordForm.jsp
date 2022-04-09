<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %> 
<%@include file="../includes/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>슈퍼관리자 비밀번호 변경</title>
	<c:choose>
	   	  <c:when test="${pageContext.request.serverName == 'localhost'}">
				<link href="/resources/css/myRepasswordForm.css" rel="stylesheet" type="text/css">
		  </c:when>
	      <c:otherwise>
	    		<link href="/ROOT/resources/css/myRepasswordForm.css" rel="stylesheet" type="text/css">
	      </c:otherwise>
	</c:choose> 
</head>
<body>
	<sec:authentication property="principal" var="userInfo"/>
		
<div class="repasswordWrap">	
		<div id="infomation" class="tabcontent">
			     	<table id="inforTable">
			     		<tr>
			     			<td class="tableText"> 
			     			현재 비밀번호
			     			</td>
			     			<td class="tableValue">
			     				<input type="password" id="userPw" value="" class="inputInfo" oninput="checkLength(this,20)" autofocus>
			     			</td> 
			     		</tr>
			     		<tr>
			     			<td class="tableText">
			     			새 비밀번호
			     			</td>
			     			<td class="tableValue">
			     				<input type="password" id="newPw" value="" class="inputInfo" oninput="checkLength(this,20)">
			     			</td>
			     		</tr>
			     		<tr>
			     			<td class="tableText"> 
			     			새 비밀번호 확인  
			     			</td>
			     			<td class="tableValue">
			     				<input type="password" id="checkPw" value="" class="inputInfo" oninput="checkLength(this,20)">
			     			</td>
			     		</tr>
			     	</table>  
	     		<input type="button" id="changeBtn" value="변경하기"/> 
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
			    if (b > maxByte) { 
			    	break;
			    }
			    
			    reStr = str.substring(0,i);
		    }
		    
		    return b
		    
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

	function checkPassword(checkData, callback, error) {
		$.ajax({
			type : 'post',
			url : '/mypage/checkPassword',
			data : JSON.stringify(checkData),
			contentType : "application/json; charset=utf-8",
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
	
	function changeMyPassword(changeData, callback, error) {
		$.ajax({
			type : 'post',
			url : '/mypage/changeMyPassword',
			data : JSON.stringify(changeData),
			contentType : "application/json; charset=utf-8",
			success : function(result, status, xhr) {
				if (callback) {
					callback(status);
				}
			},
			error : function(xhr, status, er) {
				if (error) {
					error(status);
				}
			}
		});
	}
	
	$("#changeBtn").on("click",function(event){
		
		var userPw =  $("#userPw").val();
			userPw = $.trim(userPw);
	    var newPw   =  $("#newPw").val();
	   		newPw = $.trim(newPw);
		var checkPw =  $("#checkPw").val();
			checkPw = $.trim(checkPw);
		
	    if(userPw == ""){
	    	openAlert("현재 비밀번호를 입력해주세요");
	    	return;
	    }
	    
	    if(newPw == ""){
	    	openAlert("새 비밀번호를 입력해주세요");
	    	return;
	    }
	    
	    if(checkPw == ""){
	    	openAlert("새 비밀번호를 다시 입력해주세요"); 
	    	return;
	    }
	    
	    if(newPw !== checkPw){
			openAlert("새 비밀번호가 서로 일치 하지 않습니다");
			return;
		}
	    
		var checkData = {	userPw : userPw,
							userId : '${userInfo.username}'
						};
		
		
		checkPassword(checkData, 
				
						function(result, status){
			
							if(result == "success"){
								
								var changeData = {	userPw : newPw,
													userId :  '${userInfo.username}'
												 };
								
								changeMyPassword(changeData, 
												
												function(status){
									
													if(status == "success"){
														
														openAlert("비밀번호가 변경되었습니다");
														
														$("#userPw").val("");
													    $("#newPw").val("");
														$("#checkPw").val("");
													}
												},
												
												function showError(status){
											    	
													if(status == "error"){ 
														
														openAlert("Server Error");
													}
										    	}
								);
								 
							}else if(result == "fail"){
								
								openAlert("현재 비밀번호가 맞지 않습니다");
							}
						}	
						
						, function showError(status){
					    	
							if(status == "error"){ 
								
								openAlert("Server Error");
							}
				    	}
		);
	});
	
</script>
</body>
</html>