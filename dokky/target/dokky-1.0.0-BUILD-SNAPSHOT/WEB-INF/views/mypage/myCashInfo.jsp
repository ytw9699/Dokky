<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %> 
<%@include file="../includes/left.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"> 
	<title>Dokky - 캐시</title>
	<link href="/resources/css/myCashInfo.css" rel="stylesheet" type="text/css"/> 
</head>
<body>
	<sec:authentication property="principal" var="userInfo"/>
	
	<div id="profileGray"></div> 
	<div id="chargeCash">
			<span class="chargeText">충전금액</span>
			<input type="text" id="chargeWon" class="chargeWon" placeholder="0" value="" onkeyup="numberWithComma(this)">
			<span class="chargeText">원</span> 
			 
			<input type="button" id="chargeSubmit" class="Submit" value="확인" /> 
			<input type="button" id="chargeCancel" class="Cancel" value="취소" />
	</div>
	
	<input type="text" id="realCommonWon"> 
	
	<div id="reChargeCash">
			<span class="chargeText">환전금액</span>
			<input type="text" id="reChargeWon" class="chargeWon" placeholder="0" value="" onkeyup="numberWithComma(this)">
			<span class="chargeText">원</span>
			
			<input type="button" id="reChargeSubmit" class="Submit" value="확인" /> 
			<input type="button" id="reChargeCancel" class="Cancel" value="취소" />
	</div>
	
<div class="mycashInfoWrap">	
		<div id="menuWrap">
			<div class="tab"> 
				<button onclick="location.href='myInfoForm?userId=${userInfo.username}'">개인정보 변경</button>
		        <button onclick="location.href='myBoardList?userId=${userInfo.username}'">나의 게시글</button> 
		        <button onclick="location.href='myReplylist?userId=${userInfo.username}'">나의 댓글</button> 
		        <button onclick="location.href='myScraplist?userId=${userInfo.username}'">나의 스크랩</button>
		        <button class="active" onclick="location.href='myCashInfo?userId=${userInfo.username}'">나의 캐시</button>
		    </div>  
		</div>
		
		<div class="tabcontent">
    		<div class="dotContentWrap">   
	     		<span id="dotText">My Cash </span> <span id="dotValue"><fmt:formatNumber type="number" maxFractionDigits="3" value="${userCash}"/>원</span> 
	     	</div> 
	     	<div class="dotContentWrap">  
	     		<span id="account">입금 계좌 </span> <span id="accountVal">신한 110-237-583410</span>  
	     	</div> 
	     	<div class="dotButtonWrap"> 
		     	<input type="button" id="charging" class="dotButtons" value="충전하기"/>
		     	<input type="button" id="recharging" class="dotButtons" value="환전하기" />
		     	<input type="button" class="dotButtons" value="내역보기" onclick="location.href='myCashHistory?userId=${userInfo.username}'">
	     	</div>
    	</div>
</div> 

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script>
		
   	    function numberWithComma(This) {       
   	    	  This.value = This.value.replace(/[^0-9]/g,'');//입력값에 숫자가 아닌곳은 모두 공백처리 
			  $("#realCommonWon").val(This.value);//실제 넘겨줄 값  
			  This.value = (This.value.replace(/\B(?=(\d{3})+(?!\d))/g, ","));//정규식을 이용해서 3자리 마다 ,추가 */  
		}
		 
		var csrfHeaderName ="${_csrf.headerName}"; 
		var csrfTokenValue="${_csrf.token}";
	
		$(document).ajaxSend(function(e, xhr, options) { 
		    xhr.setRequestHeader(csrfHeaderName, csrfTokenValue); //모든 AJAX전송시 CSRF토큰을 같이 전송하도록 셋팅
		  });
		
		function chargeCash(chargeData, callback, error) {//충전 요청
			$.ajax({
				type : 'post',
				url : '/mypage/chargeData',
				data : JSON.stringify(chargeData),
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
		
		function reChargeCash(reChargeData, callback, error) {//환전 요청
			$.ajax({
				type : 'post',
				url : '/mypage/reChargeData',
				data : JSON.stringify(reChargeData),
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
		
		var profileBack = $("#profileGray");
		var chargeDiv = $("#chargeCash");
		var rechargeDiv = $("#reChargeCash");
		var chargeInput = $("#chargeWon");
		var realCommonWon = $("#realCommonWon");
		var rechargeInput = $("#reChargeWon");
		
		function openCharge(){
			profileBack.css("display","block");
			chargeDiv.css("display","block");
			chargeInput.focus(); 
		}
		
		function closeCharge(){
			profileBack.css("display","none");
			chargeDiv.css("display","none");
			chargeInput.val("");
			realCommonWon.val(""); 
		}
		
		function openRecharge(){
   			profileBack.css("display","block");
   			rechargeDiv.css("display","block");
   			rechargeInput.focus();
   		}
		
   		function closeRecharge(){
			profileBack.css("display","none");
			rechargeDiv.css("display","none");
			rechargeInput.val("");
		}
		
		$("#charging").on("click",function(event){//1.충전 폼 열기 이벤트
			
			openCharge();
				
   		});//1.충전 폼 열기 이벤트
		
		$("#chargeCancel").on("click",function(event){//2.충전 폼 취소 이벤트
			
			closeCharge();
				
   		});//2.충전 폼 취소 이벤트
   		
		$("#chargeSubmit").on("click",function(event){//3.충전 확인버튼 이벤트
			var cash = $("#realCommonWon").val();
			
			if(cash === 0 || cash === ""){   
				alert("금액을 1원이상 입력해주세요."); 
				return;
			}
			
			var chargeData = {
					cashAmount:cash,  
					cashKind: '충전',
					userId:'${userInfo.username}',
					nickName : '${userInfo.member.nickName}',
					specification:'미승인'
		          };
		
			chargeCash(chargeData, function(result){
			        if(result == "success"){
			        	alert("계좌 입금이 확인되면 캐시가 충전됩니다.");
			        }
			        else if(result == "fail"){
			        	alert("잠시후 재시도 해주세요");
			        }
		     }); 
			
			closeCharge();
				
   		});//3.충전 확인버튼 이벤트
   		
	  
		$("#recharging").on("click",function(event){//4.환전 폼 열기 이벤트
			
			openRecharge(); 
				
   		});//3.환전 폼 열기 이벤트
   		 
		$("#reChargeCancel").on("click",function(event){//5.환전 폼 취소 이벤트
			
			closeRecharge();
				
   		});//4.환전 폼 취소 이벤트
   		
		$("#reChargeSubmit").on("click",function(event){//6.충전 확인버튼 이벤트
			
			var cash = $("#realCommonWon").val();
						
			if(cash === 0 || cash === ""){   
				alert("금액을 1원이상 입력해주세요"); 
				return;
			}
			
			var reChargeData = {
					cashAmount:cash,
					cashKind: '환전',
					userId:'${userInfo.username}',
					nickName : '${userInfo.member.nickName}',
					specification:'미승인'
		          };
			
			if(reChargeData.cashAmount > parseInt('${userCash}') ){
				alert("보유 캐시가 부족합니다.");
				closeRecharge();
				return;
			}
			
			reChargeCash(reChargeData, function(result){
			        if(result == "success"){
			        	alert("관리자 승인후 환전됩니다.");
			        }
			        else if(result == "fail"){
			        	alert("잠시후 재시도 해주세요");
			        }
		     }); 
			
			closeRecharge();
				
   		});//6.충전 확인버튼 이벤트
   		
</script>

</body>
</html>