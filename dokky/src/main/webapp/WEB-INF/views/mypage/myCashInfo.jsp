<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %> 
<%@include file="../includes/left.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>나의 캐시</title>
<style>
	@media screen and (max-width:500px){ 
		.mycashInfoWrap { 
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
	        .mycashInfoWrap {
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
          .mycashInfoWrap { 
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
		width: 10%;
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
	    width: 7%;
    }
    #profileGray{position: fixed; width: 100%; height: 100%; top: 0; left: 0; background-color: #000; opacity: 0.6; display: none;}
	
	#chargeCash{display: none;   width: 250px;
    border-radius: 8px;
    position: fixed;
    top: 25%;
    left: 35%;
    padding: 50px;
    background-color: white;}
    
    #reChargeCash{display: none;   width: 250px;
    border-radius: 8px;
    position: fixed;
    top: 25%;
    left: 35%;
    padding: 50px;
    background-color: white;}
    
    .chargeWon{
	    font-size: 40px;
	     color: #ff7e00;
	     width: 53%; 
     }
    
    .Submit{  font-size: 20px;
	    border: none;
	    padding: 8px;
	    width: 80%;
	    margin: 0 auto;
	    margin-top: 10px;
	    display: block;
	    border-radius: 8px;
	    color: white;
	    background-color: #12b9ff;
	 }
    
    .Cancel{    font-size: 20px;
    border: none;
    padding: 8px;
    width: 80%;
    margin: 0 auto;
    margin-top: 10px;
    display: block;
    border-radius: 8px;
    color: white;
    background-color: #bd081c;}
     
    .chargeText{font-size: 20px;
    color: #555;
    font-weight: 600;}
    
    .dotButtonWrap{width: 27%;} 
    
    .dotButtons{font-size: 20px;
    display: block;
    padding: 8px;
    border-radius: 8px;
    border: none;
    margin-top: 18px;
    background-color: #555;
    color: white;
    width: 200px;}
    
    .dotText{ font-size: 30px;
    font-weight: 600;}
    
    .dotValue{color: #ff7e00;
    font-size: 26px;}
    
    .dotContentWrap{ width: 80%;
    }
     
    .tabcontent {padding: 6px 12px; border: 1px solid #e6e6e6; width: 70%;}
	
</style>  
</head>
<body>
	<sec:authentication property="principal" var="userInfo"/>
	
	<div id="profileGray"></div>
	<div id="chargeCash">
		 <form action="/dokky/mypage/myCashInfo" id="operForm" method='post'>	
	     	
			<span class="chargeText">충전금액</span>
			<input type="text" id="chargeWon" class="chargeWon" value="" /> <span class="chargeText">원</span>
			
			<input type="button" id="chargeSubmit" class="Submit" value="확인" /> 
			<input type="button" id="chargeCancel" class="Cancel" value="취소" />
		</form>
	</div>
	
	<div id="reChargeCash">
		 <form action="/dokky/mypage/myCashInfo" id="operForm" method='post'>	
	     	
			<span class="chargeText">환전금액</span>
			<input type="text" id="reChargeWon" class="chargeWon" value="" /> <span class="chargeText">원</span>
			
			<input type="button" id="reChargeSubmit" class="Submit" value="확인" /> 
			<input type="button" id="reChargeCancel" class="Cancel" value="취소" />
		</form>
	</div>
	
<div class="mycashInfoWrap">	
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
		
		<div class="tabcontent">
    		<div class="dotContentWrap">  
	     		<span class="dotText">Cash</span> <span class="dotValue">${userCash}원</span> 
	     	</div>
	     	<div class="dotContentWrap">  
	     		<span class="dotText">입금 가상계좌</span> <span class="dotValue">신한 110-237-583410</span>  
	     	</div> 
	     	<div class="dotButtonWrap"> 
		     	<input type="button" id="charging" class="dotButtons" value="충전하기"/>
		     	<input type="button" id="recharging" class="dotButtons" value="환전하기" />
		     	<input type="button" class="dotButtons" value="내역보기" onclick="location.href='myCashHistory?userId=${userInfo.username}'">
	     	</div>
    	</div>
	</div> 
</div> 

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script>

		var csrfHeaderName ="${_csrf.headerName}"; 
		var csrfTokenValue="${_csrf.token}";
	
		$(document).ajaxSend(function(e, xhr, options) { 
		    xhr.setRequestHeader(csrfHeaderName, csrfTokenValue); //모든 AJAX전송시 CSRF토큰을 같이 전송하도록 셋팅
		  });
		
		function chargeCash(chargeData, callback, error) {//충전 요청
			$.ajax({
				type : 'post',
				url : '/dokky/mypage/chargeData',
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
				url : '/dokky/mypage/reChargeData',
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
			
			var chargeData = {
					cashAmount:chargeInput.val(),
					cashKind: '충전',
					userId:'${userInfo.username}',
					specification:'승인중'
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
			
			var reChargeData = {
					cashAmount:rechargeInput.val(),
					cashKind: '환전',
					userId:'${userInfo.username}',
					specification:'승인중'
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