<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %> 
<%@include file="../includes/left.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>마이페이지</title>
<style>
		@media screen and (max-width:500px){ 
    		.repasswordWrap {
				    width: 80%; 
				    display: inline-block;
				    margin-left: 15%;
				    margin-top: 1%;
				    min-height: 500px; 
				    border-color: #e6e6e6;
					border-style: solid;
					background-color: #323639; 
					color: #e6e6e6;
					display: inline-block;
				}     
        }
        @media screen and (min-width: 501px) and (max-width:1500px){
	        .repasswordWrap {
				    width: 80%; 
				    display: inline-block;
				    margin-left: 15%;
				    margin-top: 1%;
				    min-height: 500px; 
				    border-color: #e6e6e6;
					border-style: solid;
					background-color: #323639; 
					color: #e6e6e6;
					display: inline-block;
				}
        }
        @media screen and (min-width: 1501px){    
          .repasswordWrap {
			    width: 51%; 
			    display: inline-block;
			    margin-left: 29%;
			    margin-top: 1%;
			    min-height: 500px; 
			    border-color: #e6e6e6;
				border-style: solid;
				background-color: #323639; 
				color: #e6e6e6;
				display: inline-block;
			}
        }
	body{
		background-color: #323639;  
		}
	 
	.ContentWrap{box-sizing: border-box;
	    padding-top: 48px;
	    padding-left: 20px;
	    padding-right: 20px;
	    width: 95%;
		min-height: 750px;
	    margin: 0 auto; 
 	}
	#menuWrap .tab button {
		background-color: inherit;
		border: none;
		outline:none;
		cursor: pointer;
		padding: 14px 16px;
		transition: 0.3s;
		font-size: 20px;  
		color: #e6e6e6;
	}
	#menuWrap .tab button:hover {
	background-color: #7b7676;
	}
	/* #menuWrap .tabcontent {  
		display: none; 
		padding: 6px 12px;
		border: 1px;
	}  */
	.tableText{
		width: 20%;
		font-size: 20px;  
		color: #e6e6e6;
    }
	.tableValue{    
		height: 50px;
	    /* font-size: 18px;
	    color: #555; */
	 }
	 .inputInfo{
	 	margin-top: 3px;
	    font-size: 20px;
	    color: #555;
	    padding: 8px;
	    width: 30%;
	    border-radius: 8px;
	    border: 1px solid #b5b5b5;
	    height: 30px;
	 }
	 .submitInfo{  
	 	font-size: 20px;
	    background-color: #555;
	    border: 1px solid #555;
	    color: #e6e6e6;
	    padding: 8px;
	    border-radius: 8px;
	    width: 11%;
    }
	
</style>  
</head>
<body>
	<sec:authentication property="principal" var="userInfo"/>
		
<div class="repasswordWrap">	
	<div class="ContentWrap">
		<div id="menuWrap">
			<div class="tab"> 
				<button onclick="location.href='myInfoForm?userId=${userInfo.username}'">개인정보 변경</button>
		        <button onclick="location.href='rePasswordForm?userId=${userInfo.username}'">비밀번호 변경</button> 
		        <button onclick="location.href='myBoardList?userId=${userInfo.username}'">나의 게시글</button> 
		        <button onclick="location.href='myReplylist?userId=${userInfo.username}'">나의 댓글</button> 
		        <button onclick="location.href='myScraplist?userId=${userInfo.username}'">스크랩</button>
		        <button onclick="location.href='myCashInfo?userId=${userInfo.username}'">캐시</button>
		    </div> 
		</div>
		<div id="infomation" class="tabcontent">
	       <form method='post' action="/dokky/mypage/MyPassword" id="operForm">	
	     	  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
	     	  <input type="hidden" name="userId" value="${userInfo.username}" />
	     	<table width="100%" style="margin-bottom: 30px;">
	     		<tr>
	     			<td class="tableText"> 
	     			현재 비밀번호
	     			</td>
	     			<td class="tableValue">
	     				<input type="password" name="userPw" value="" class="inputInfo" oninput="checkLength(this,20)">
	     			</td> 
	     		</tr>
	     		<tr>
	     			<td class="tableText">
	     			새 비밀번호
	     			</td>
	     			<td class="tableValue">
	     				<input type="password" name="newPw" value="" class="inputInfo" oninput="checkLength(this,20)">
	     			</td>
	     		</tr>
	     		<tr>
	     			<td class="tableText"> 
	     			새 비밀번호 확인  
	     			</td>
	     			<td class="tableValue">
	     				<input type="password" name="checkPw" value="" class="inputInfo" oninput="checkLength(this,20)">
	     			</td>
	     		</tr>
	     	</table>  
	     		<input type="button" id="SumbitMyInfo" value="변경하기" class="submitInfo" /> 
	      </form>
     	</div>
	</div> 
</div> 
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script>

	function checkLength(obj, maxlength) {  
		
		if(obj.tagName === "INPUT"){ 
			var str = obj.value; 
		}else if(obj.tagName === "DIV"){
			var str = obj.innerHTML; 
		}
		// 이벤트가 일어난 컨트롤의 value 값    
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
				alert(max_length + "자 이상 입력할 수 없습니다.");              
				reStr = str.substr(0, max_length);         
				obj.value = reStr;      
		}     
		
		obj.focus();  
	}

	var csrfHeaderName ="${_csrf.headerName}"; 
	var csrfTokenValue="${_csrf.token}";

	$(document).ajaxSend(function(e, xhr, options) { 
	    xhr.setRequestHeader(csrfHeaderName, csrfTokenValue); //모든 AJAX전송시 CSRF토큰을 같이 전송하도록 셋팅
	  });
		
		function checkPassword(checkData, callback, error) {
			$.ajax({
				type : 'post',
				url : '/dokky/mypage/checkPassword',
				data : JSON.stringify(checkData),
				contentType : "application/json; charset=utf-8",
				success : function(result, status, xhr) {
					if (callback) {
						callback(result,xhr);
					}
				},
				error : function(xhr, status, er) {
					if (error) {
						error(xhr,er);
					}
				}
			});
		}

	$("#SumbitMyInfo").on("click",function(event){
		var operForm = $("#operForm");
		var userPw = operForm.find("input[name='userPw']").val();
	    var userId = operForm.find("input[name='userId']").val();
	    var newPw   = operForm.find("input[name='newPw']").val();
		var checkPw = operForm.find("input[name='checkPw']").val();
		
	    if(userPw == ""){
	    	alert("현재 비밀번호를 입력해주세요.");
	    	return;
	    }
	    if(newPw == ""){
	    	alert("새 비밀번호를 입력해주세요.");
	    	return;
	    }
	    if(checkPw == ""){
	    	alert("새 비밀번호를 다시 입력해주세요."); 
	    	return;
	    }
	    
		var checkData = {	userPw : userPw,
							userId : userId
						};
		
		checkPassword(checkData, function(result,xhr){
			 if(xhr.status == '200'){
				
				if(newPw !== checkPw){
					alert("새 비밀번호가 서로 일치 하지 않습니다.");
				}else{
					operForm.submit();
				}
	    	}
		    }
		,function(xhr,er){
			if(xhr.status == '404'){
			 alert("현재 비밀번호가 맞지 않습니다.");
			}
		}
		);
		});
</script>
 		<c:choose>
		       <c:when test="${update eq 'complete'}">
		          		<script>
					      $(document).ready(function(){
					      	alert("비밀번호가 변경되었습니다.");
					      });
				      	</script>
		       </c:when>
		       <c:when test="${update eq 'notComplete'}">
		       			<script>
					      $(document).ready(function(){
					      	alert("재시도해주세요.");
					      });
				    	</script>
		       </c:when>
		</c:choose>
</body>
</html>