<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %> 

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Dokky - 상세페이지</title> 
		<link href="/dokky/resources/css/get.css" rel="stylesheet" type="text/css">
		<%@include file="../includes/left.jsp"%> 
	</head>
<body> 

<sec:authentication property="principal" var="userInfo"/>
<!-- 다시보기 : 위 코드 없어도 left.jsp에있기 때문에 userInfo가 동작함 -->

<div class="getWrapper"> 
	<div class="getKind">
		 <c:choose>
		       <c:when test="${board.category == 1 }">
		          		  공지사항 
		       </c:when>
		       <c:when test="${board.category == 2 }">
		       			  자유게시판
		       </c:when>
		        <c:when test="${board.category == 3 }">
		     		 	  묻고답하기
		       </c:when>
		        <c:when test="${board.category == 4 }">
		   		   	  	  칼럼/Tech
		       </c:when>
		       <c:when test="${board.category == 5 }">
		   		   		  정기모임/스터디 
		       </c:when>
          </c:choose> 
	</div>
     
	<div class="topInfoWrap">
			
			<div class="nickName">
				<a href="#" id="board_userMenu" class="userMenu">
					<img src="/dokky/resources/img/profile_img/<c:out value="${board.userId}" />.png"  class="memberImage hideUsermenu" onerror="this.src='/dokky/resources/img/basicProfile.png'" />
					<c:out value="${board.nickName}" /> 
				</a>
			</div>
			
			<div>
				<span id="regdate">  
						  <fmt:formatDate value="${board.regDate}" pattern="yyyy-MM-dd HH:mm" /><label> 작성</label>
					<c:if test="${board.regDate != board.updateDate}">
					      , <fmt:formatDate value="${board.updateDate}" pattern="yyyy-MM-dd HH:mm" /><label> 수정됨</label>
					</c:if>  
				</span>
				<span class="rightInfo">
					<span class="tdData">   
						조회수
					</span>
					<span id="hitCnt">
						<c:out value="${board.hitCnt }"/>
					</span>
				</span>
		    </div>  
			
			<div id="UserMenubar_board" class="userMenubar">
				<ul class="hideUsermenu">  
					<li class="hideUsermenu">
						<a href="/dokky/userBoardList?userId=${board.userId}" class="hideUsermenu">
							<span class="hideUsermenu">게시글보기</span>
						</a>
					</li>
					
					<li class="hideUsermenu">
						<a href="#" class="hideUsermenu" onclick="noteOpen('${board.userId}','${board.nickName}')">
							<span class="hideUsermenu">쪽지보내기</span>
						</a>
					</li>
				</ul>    
		    </div> 
	</div>
         
	<div class="titleWrapper">
   		<div id="titleNum"> 
   			#<c:out value="${board.board_num}"/>
   		</div>
   		
   		<div class="fileUploadWrap userMenu"> 
	   		<a href="#" id="fileUploadLink" class="userMenu"> 
				첨부파일
			</a> 
		</div>
   		
   		<div id="title">
   		 	<c:out value="${board.title}"/>
   		</div>
		
		<div class='fileUploadResult userMenu'>
           <ul class="userMenu">
           </ul>
	    </div>
	</div> 
            
    <div class="content"> 
      		${board.content } 
    </div>
    
    <div class="contentInformation">
	    <ul id="contentInformation">
	    	<li class="contentMenu">
	    		<button class="getButton" id="like">좋아요</button>
	    	</li>
	    	<li class="contentMenu" id="likeCount"> 
				<span><c:out value="${board.likeCnt}"/></span>
	    	</li>
	    	<li class="contentMenu">
	    		<button class="getButton" id="dislike">싫어요</button>
	    	</li>
	    	<li class="contentMenu" id="dislikeCount"> 
				<span><c:out value="${board.dislikeCnt}"/></span>
	    	</li>
	    	<li class="contentMenu">
	    		 <button class="getButton" id="donateMoney">기부</button> 
	    	</li>
	    	<li class="contentMenu" id="boardMoney">
				\<c:out value="${board.money}"/>
	    	</li>
	   		<sec:authorize access="isAuthenticated()">
		        <c:if test="${userInfo.username eq board.userId}">
			    	<li class="contentMenu">
			   		    <button class="getButton" id="modify_button">수정 </button>
			    	</li>
			    	<li class="contentMenu">
			    		<button class="getButton" id="remove_button">삭제 </button>
			    	</li>
		    	</c:if>
	    	<li class="contentMenu">
				<button class="getButton" id="scrap">스크랩 </button>
	    	</li>
	    	<c:if test="${userInfo.username != board.userId}">
		         <li class="contentMenu">
		       		 <button class="getButton" id="openReport">신고</button> 
	       	     </li>
	        </c:if>
	        </sec:authorize>  
	    	<li class="contentMenu">
				<button class="getButton" id="list_button">글목록 </button>  
	    	</li>
	    </ul>
    </div> 
    
    <div class="replyCntVal">
    	<!-- 댓글수 -->
    </div> 
	 
	<div class="replyListWrapper">
        <ul class="replyList">
        <!-- 댓글 목록 -->
        </ul>
	</div>  
    
    <div class="replyPage">
    	<!-- 댓글페이지 -->
    </div>
    
	<sec:authorize access="isAuthenticated()">
		<div class="replyWriteForm"><!--  기본 댓글쓰기 폼 -->
			<div class="replytextareaWrapper">
					<textarea id="reply_contents" rows="3" placeholder="댓글을 입력하세요."
						name='reply_content' oninput="checkLength(this,3000);"></textarea>
					<button id='replyRegisterBtn' type="button">작성</button>
			</div>
		</div>  
	</sec:authorize>
	
</div><!--  end getWrapper -->

<!-- START 숨겨진 DIV들 -->

<div class="reReplyWriteForm"><!--  대댓글 쓰기 폼 --> 
		<div class="textareaWrapper">  
			<textarea id="reReply_contents" rows="3" placeholder="답글을 입력하세요." name='reReply_content' oninput="checkLength(this,3000);"></textarea>
			<button id='reReplyRegisterBtn' class="reReplyBtn" type="button">작성</button>
			<button id='reReplyCancelBtn' class="reReplyBtn" type="button">취소</button>
		</div> 
</div> 

<div id="replyModForm" ><!-- 댓글의 수정 폼+값 불러오기 --> 
	  	<div class="modifyTextareaWrapper">  
			<textarea name='reply_content' rows="3" class="reply_contents" value='' oninput="checkLength(this,3000);"></textarea>
		</div> 
		
		<div class="replyModFormBtnWrapper"> 
			<button id='replyModFormModBtn' class="replyModFormBtn" type="button" >수정</button> 
			<button id='replyModFormCloseBtn' class="replyModFormBtn" type="button" >취소</button>
		</div> 
</div>  

<div class='bigPictureWrapper'><!-- 사진클릭시 -->
	 <div class='bigPicture'>
	 </div>
</div>

<div> 
	<form id='operForm' action="/dokky/board/modify" method="get">
		  <input type="hidden" id='csrf' name="${_csrf.parameterName}" value="${_csrf.token}"/>
		  <input type='hidden' id='userId' name='userId' value='<c:out value="${board.userId}"/>'>    
		  <input type='hidden' id='board_num' name='board_num' value='<c:out value="${board.board_num}"/>'>
		  <input type='hidden' name='category' value='<c:out value="${board.category}"/>'>
		  <input type='hidden' name='pageNum' value='<c:out value="${cri.pageNum}"/>'>
		  <input type='hidden' name='amount' value='<c:out value="${cri.amount}"/>'>
		  <input type='hidden' name='keyword' value='<c:out value="${cri.keyword}"/>'>
		  <input type='hidden' name='type' value='<c:out value="${cri.type}"/>'>  
	</form>
</div>
	
<div id="donateBackGround">
</div>

<div id="donateModal"> <!-- 기부폼 -->
         <div class="">
			<span class="mydonaText">남은금액</span>
				<input type="text" class="donaSelect" name='myCash' value='' readonly="readonly">
			<span class="mydonaText">원</span>
		 </div>
		 
		 <div class="">
			<span class="mydonaText">기부금액</span>  
				<input type="text" class="donaSelect" name='giveCash' placeholder="0" onkeyup="numberWithComma(this)">
				<input type="text" class="donaSelect" id="realGiveCash" value="0" name='realGiveCash'>
			<span class="mydonaText">원</span>
         </div>
            
         <div class="">
	         <span> 
	         	 <button id='modalSubmitBtn' type="button" class="donateSubmit">기부</button>
	         </span>
	         <span>  
	         	 <button id='modalCloseBtn' type="button" class="donateSubmit">취소</button>
	         </span>
         </div>
</div>

<div id="reportBackGround">
</div>

<div id="reportForm"> <!-- 신고폼 -->
         <div class="reportText">
			신고사유를 입력해주세요.
		 </div>
		 <div class="reportText">	 
		 	<textarea id="reportInput" rows="3" oninput="checkLength(this,40);"></textarea>
		 </div>  
	 
         <div class="">
	         <span>  
	         	 <button id='submitReport' type="button" class="reportBtn">확인</button>
	         </span>
	         <span>  
	         	 <button id='closeReport' type="button" class="reportBtn">취소</button>
	         </span>
         </div>
</div>
<!-- END 숨겨진 DIV들  -->

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script type="text/javascript" src="/dokky/resources/js/reply.js"></script> <!--댓글 AJAX통신 -->
<script>
	//공통 변수 모음 
	var board_num = '${board.board_num}'; 
	var board_id = '${board.userId}';
	var board_nickName = '${board.nickName}';
	var board_title = '${board.title}';
	var myId;
	var myNickName;
	var pageNum = 1;//댓글의 페이지 번호
	
	<sec:authorize access="isAuthenticated()">   
				  myId = '${userInfo.username}';  
		    myNickName = '${userInfo.member.nickName}';
	</sec:authorize>
	
	var csrfHeaderName ="${_csrf.headerName}"; 
	var csrfTokenValue="${_csrf.token}";
	   
	$(document).ajaxSend(function(e, xhr, options) {  //모든 AJAX전송시 CSRF토큰을 같이 전송하도록 셋팅
		
	     xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
    });
	 
	///////////////////////////////////////////////////////함수모음
	
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
	
	function substr(str){//글자수 자르기 함수
		
		var str_length = str.length;  
		var max_length = 15;
		     
		if (str_length > max_length) {   
			str = str.substr(0, max_length);
			str = str+"......"
		}
		return str;
	}
	
	
	function checkUser(input_id, loginCheck, idCheck, commonCheck){
 		
 		if(!myId){//로그인 여부 확인
 			 
	  		  alert(loginCheck);
	  		  return true; 
	  	 } 
		
		/* if(idCheck){
			
			if(input_id  != myId){
		 		  alert(idCheck);
		 		  return true; 
		 	 }
		} */
		
		if(commonCheck){//좋아요,싫어요,기부금 체크
			
			if(input_id == myId){
				
		 		  alert(commonCheck);
		 		  return true; 
		 	 }
		}
 	}
	
	function numberWithComma(This) {//기부금 숫자입력시 콤마처리함수          
		
	 	    This.value = This.value.replace(/[^0-9]/g,'');//입력값에 숫자가 아닌곳은 모두 공백처리 
		    $("#realGiveCash").val(This.value);//실제 넘겨줄 값  
		    This.value = (This.value.replace(/\B(?=(\d{3})+(?!\d))/g, ","));//정규식을 이용해서 3자리 마다 ,추가 */  
	}
		
	function func_confirm(content){//단순 확인 여부 함수
		
		    if(confirm(content)){//true
		    	return true;
		    } else {//false
		    	return false;
		    }
	}
	
	/////////////////////////////////////////////////////// 댓글 리스트 관련 시작
	
	function showReplyList(page){//댓글 리스트 가져오기
		
	    replyService.getList({board_num:board_num, page: page || 1 }, function(data) {
	    	
	    	var replyList = $(".replyList");//댓글리스트 ul  
	    	var replyCntVal = $(".replyCntVal");//댓글 갯수 div
			var str ="";
			var len = data.list.length;//현재 페이지의 댓글 갯수
			var replyCnt = data.replyCnt;//해당 게시글의 총 댓글 갯수
			var nickName;//댓글 작성자의 닉네임 
			var userId; //댓글 작성자의 아이디
			var toNickName; //답글 보낼 사람의 닉네임
			var toUserId; //답글 보낼 사람의 아이디
			var reply_nums; //댓글 번호
			var reply_content; //댓글 내용
			var replyDate; //댓글 작성 날짜
			var likeCnt; //댓글 좋아요 카운트
			var dislikeCnt; //댓글 싫어요 카운트
			var money; //댓글 기부금
			var depth; 
			var group_num; 
			var order_step; 
			
			
			if(page == -1){
			
			    pageNum = Math.ceil(replyCnt/10.0);
			    showReplyList(pageNum);//댓글이 가장 마지막에 달린 페이지 찾아서 다시 호출
		      	return;
			}
	        
			if(data.list == null || len == 0){//댓글이 하나도 없다면
		    	 
			    	 replyList.html(str);//댓글 목록안에 공백 채우기
			    	 
			    	 showReplyPage(0);//페이지 번호 없애기
			    	 
			    	 replyCntVal.html("");//댓글수 없애기
			    	 
			    	 replyCntVal.css("display","none");
			    	 
		    	 	 return;  
		    	 	 
			}else{//댓글이 있다면
					 showReplyPage(replyCnt);//댓글 페이지 번호 보여주기 
			     
			         replyCntVal.css("display","block"); 
			       
			         replyCntVal.html("<span id='replyCntVal'>댓글 </span>"+replyCnt); //댓글 갯수 보여주기  
			}
		     
	        for (var i = 0; i < len || 0; i++) {
	        	
		       nickName 	 = data.list[i].nickName; 
		       userId 		 = data.list[i].userId;  
		       reply_nums 	 = data.list[i].reply_num;    
		       toNickName	 = data.list[i].toNickName;    
			   toUserId		 = data.list[i].toUserId;   
			   reply_content = data.list[i].reply_content; 
			   replyDate 	 = data.list[i].replyDate;
			   likeCnt 	     = data.list[i].likeCnt;
			   dislikeCnt 	 = data.list[i].dislikeCnt;
			   depth   		 = data.list[i].depth;
			   group_num     = data.list[i].group_num;
			   order_step    = data.list[i].order_step;
			   money         = data.list[i].money;
			   
		   	   str +=  "<div id='replyModForm"+reply_nums+"' class='replyModForm'>"
			       		   + "<div class='modifyTextareaWrapper'>"  
				    	   +	"<textarea name='reply_content' rows='3' class='reply_contents' value='' oninput='checkLength(this,3000);'></textarea>"
				    	   + "</div>"
				    	   + "<div class='replyModFormBtnWrapper'>" 
					    	   + "<button id='replyModFormModBtn"+reply_nums+"' class='replyModFormBtn' type='button' >수정</button>" 
					    	   + "<button id='replyModFormCloseBtn"+reply_nums+"' class='replyModFormBtn' type='button' >취소</button>"	 
				    	   + "</div>" 	
		    	     + "</div>";  
    	       
		       str += "<li id='replyLi"+reply_nums+"' class='replyLi'>"
		    
		       if(depth == 0){    
			    	    
		    	  str += "<div class='reply' data-reply_num='"+reply_nums+"'>" 
			    	  		   + "<span>"
								   + "<a href='#' class='userMenu' data-reply_num='"+reply_nums+"' data-menu_kind='from'>"   
									   + "<img src='/dokky/resources/img/profile_img/"+userId+".png' class='memberImage hideUsermenu' onerror='this.src=\"/dokky/resources/img/basicProfile.png\"'/>&nbsp"
									   + nickName
								   + "</a>"
							   + "</span>" 
							   
							   + "<div id='userMenubar_reply_from_"+reply_nums+"' class='userMenubar'>" 
								   + "<ul class='hideUsermenu'>" 
									   + "<li class='hideUsermenu'>"
								   		   + "<a href='/dokky/userBoardList?userId="+userId+"' class='hideUsermenu'>"
								   				+ "<span class='hideUsermenu'>게시글보기</span>"
								   		   + "</a>"
								   	   + "</li>"
								   	   
									   + "<li class='hideUsermenu'>"  
									   	  + "<a href='#' class='hideUsermenu' onclick=\"noteOpen('"+userId+"','"+nickName+"')\">"
										   	+ "<span class='hideUsermenu'>쪽지보내기</span>"
									   	  + "</a>"
									   + "</li>"
								   + "</ul>"
							   + "</div>"
							   
							   + "<span class='reply_date'>"
							   		+ replyService.displayTime(replyDate) 
							   + "</span>";
				  
					  if(myId){ 
						  str += "<span class='replyMenu'>" 
							   		+ "<button class='replyButton' data-oper='reReplyForm' type='button' data-reply_num='"+reply_nums+"' data-reply_id='"+userId+"' data-nick_name='"+nickName+"' data-group_num='"+ group_num+"' data-order_step='"+order_step+"' data-depth='"+depth+"'>답글</button>" 
						       + "</span>"; 
					  }
		    	  
		    	  	  	  str += "<span class='replyInformation'>" 
				    	  	   		+ "<span class='replyMenu'>"
				    	  	   				+ "<button class='replyButton' data-oper='like' type='button' data-reply_content='"+reply_content+"' data-reply_id='"+userId+"' data-reply_num='"+reply_nums+"'>좋아요</button>"
				    	  	   		+ "</span>"
				    	  	   		+ "<span class='replyMenu' id='replyLikeCount"+reply_nums+"'>"
				    	  	   				+ likeCnt
				    	  			+ "</span>" 
				    	  			
				    	  			+ "<span class='replyMenu'>"
				    	  					+"<button class='replyButton' data-oper='dislike' type='button' data-reply_content='"+reply_content+"' data-reply_id='"+userId+"' data-reply_num='"+reply_nums+"'>싫어요</button>"
		    	  	   				+ "</span>"
					       			+ "<span class='replyMenu' id='replyDisLikeCount"+reply_nums+"'>"
					       					+dislikeCnt
				       				+ "</span>"
				       				
				       				+ "<span class='replyMenu'>"
				       						+"<button class='replyButton' data-oper='donateMoney' type='button' data-reply_content='"+reply_content+"' data-reply_id='"+userId+"' data-reply_num='"+reply_nums+"'>기부</button>"
				  	   				+ "</span>" 	
					       			+ "<span class='replyMenu' id='replyMoney"+reply_nums+"'>\\"
					       				+ money
					       			+"</span>"  
		      
	          	     if(myId == userId){   
		        	  
		        	     str += "<span class='replyMenu'>"
			        	  		    + "<button class='replyButton' data-oper='modify' type='button' data-reply_id='"+userId+"' data-reply_num='"+reply_nums+"'>수정</button>"
	   					      + "</span>"
	   					   
	   					      + "<span class='replyMenu'>"
	   							    +"<button class='replyButton' data-oper='delete' type='button' data-reply_id='"+userId+"' data-reply_num='"+reply_nums+"'>삭제</button>"
	  	   				      + "</span>"
		             }    
		        
		          	 if(myId != userId){   
		          		 
		        	     str += "<span class='replyMenu'>" 
			        		 	  	+ "<button class='replyButton' data-oper='report' type='button' data-reply_id='"+userId+"' data-reply_nickname='"+nickName+"'>신고</button>"
				  	          + "</span>"
		          	 } 
		    	  
		       }else if(depth == 1){    
		    	   
		    	   str += "<div class='reply' data-reply_num='"+reply_nums+"'><span class='first'>"  
		    	  
		       }else if(depth == 2){
		    	   
		    	   str += "<div class='reply' data-reply_num='"+reply_nums+"'><span class='second'>"  
		    	  
		       }else if(depth == 3){ 
		    	   
	    	       str += "<div class='reply' data-reply_num='"+reply_nums+"'><span class='third'>"  
	    	      
		       }else{  
		    	   
		    	   str += "<div class='reply' data-reply_num='"+reply_nums+"'><span class='other'>"  
		    	   
			   }//end if   
			     
			   
		       if(depth != 0){   
		    	   
    	   			     str += "<span class='depthLine'>└ </span>"
	    	   			  	   +"<span>"
							       + "<a href='#' class='userMenu' data-reply_num='"+reply_nums+"' data-menu_kind='from'>"   
									   + "<img src='/dokky/resources/img/profile_img/"+userId+".png' class='memberImage hideUsermenu' onerror='this.src=\"/dokky/resources/img/basicProfile.png\"'/>&nbsp"
									   + nickName
							       + "</a>"
						   	   + "</span>"
						   	   
						   	   + "<div id='userMenubar_reply_from_"+reply_nums+"' class='userMenubar'>" 
								   + "<ul class='hideUsermenu'>" 
									   + "<li class='hideUsermenu'>"
								   		   + "<a href='/dokky/userBoardList?userId="+userId+"' class='hideUsermenu'>"
								   				+ "<span class='hideUsermenu'>게시글보기</span>"
								   		   + "</a>"
								   	   + "</li>"
								   	   
									   + "<li class='hideUsermenu'>"
									   	  + "<a href='#' class='hideUsermenu' onclick=\"noteOpen('"+userId+"','"+nickName+"')\">"
										   	+ "<span class='hideUsermenu'>쪽지보내기</span>"
									   	  + "</a>"
									   + "</li>"
								   + "</ul>"
							   + "</div>"
							   
							   + "<span class='toLine'>➜</span>"  
							   
							   + "<span>"
							       + "<a href='#' class='userMenu' data-reply_num='"+reply_nums+"' data-menu_kind='to'>"
									   + "<img src='/dokky/resources/img/profile_img/"+toUserId+".png' class='memberImage hideUsermenu' onerror='this.src=\"/dokky/resources/img/basicProfile.png\"'/>&nbsp"
									   + toNickName
							       + "</a>"
				   	   		   + "</span>"
				   	   		   
				   	   		   + "<div id='userMenubar_reply_to_"+reply_nums+"' class='userMenubar to'>" 
								   + "<ul class='hideUsermenu'>" 
									   + "<li class='hideUsermenu'>"
								   		   + "<a href='/dokky/userBoardList?userId="+toUserId+"' class='hideUsermenu'>"
								   				+ "<span class='hideUsermenu'>게시글보기</span>"
								   		   + "</a>"
								   	   + "</li>"
								   	   
									   + "<li class='hideUsermenu'>"
									   	  + "<a href='#' class='hideUsermenu' onclick=\"noteOpen('"+toUserId+"','"+toNickName+"')\">"
										   	+ "<span class='hideUsermenu'>쪽지보내기</span>"
									   	  + "</a>"
									   + "</li>"
								   + "</ul>"
							   + "</div>"
					   
							   + "<span class='reply_date'>"
						   			+ replyService.displayTime(replyDate) 
						  	   + "</span>"; 
				
				  	  if(myId){ 
						  str += "<span class='replyMenu'>" 
							   		+ "<button class='replyButton' data-oper='reReplyForm' type='button' data-reply_num='"+reply_nums+"' data-reply_id='"+userId+"' data-nick_name='"+nickName+"' data-group_num='"+ group_num+"' data-order_step='"+order_step+"' data-depth='"+depth+"'>답글</button>" 
						       + "</span>"
				          +"</span>"; 
				  	  }
					      
				   	      str += "<span class='replyInformation'>" 
					   	  	   		+ "<span class='replyMenu'>"
					   	  	   				+ "<button class='replyButton' data-oper='like' type='button' data-reply_content='"+reply_content+"' data-reply_id='"+userId+"' data-reply_num='"+reply_nums+"'>좋아요</button>"
					   	  	   		+ "</span>"
					   	  	   		+ "<span class='replyMenu' id='replyLikeCount"+reply_nums+"'>"
					   	  	   				+ likeCnt
					   	  			+ "</span>" 
				   	  			
				   	  				+ "<span class='replyMenu'>"
				   	  					+"<button class='replyButton' data-oper='dislike' type='button' data-reply_content='"+reply_content+"' data-reply_id='"+userId+"' data-reply_num='"+reply_nums+"'>싫어요</button>"
				 	   				+ "</span>"
					       			+ "<span class='replyMenu' id='replyDisLikeCount"+reply_nums+"'>"
					       					+dislikeCnt
				      				+ "</span>"
				      				
				      				+ "<span class='replyMenu'>"
				      						+"<button class='replyButton' data-oper='donateMoney' type='button' data-reply_content='"+reply_content+"' data-reply_id='"+userId+"' data-reply_num='"+reply_nums+"'>기부</button>"
				 	   				+ "</span>" 	
				 	   				+ "<span class='replyMenu' id='replyMoney"+reply_nums+"'>\\"
					       				+ money 
					       			+ "</span>" 
				   
					  if(myId == userId){   
					        	  
					   	       str += "<span class='replyMenu'>"
				    	  		    	+ "<button class='replyButton' data-oper='modify' type='button' data-reply_id='"+userId+"' data-reply_num='"+reply_nums+"'>수정</button>"
						      	    + "</span>"
							   
						     	    + "<span class='replyMenu'>"
								   		+ "<button class='replyButton' data-oper='delete' type='button' data-reply_id='"+userId+"' data-reply_num='"+reply_nums+"'>삭제</button>"
							        + "</span>"
					  }  
					    
					  if(myId != userId){  
					       	  
				   	   	       str += "<span class='replyMenu'>"
					   		 	 		  + "<button class='replyButton' data-oper='report' type='button' data-reply_id='"+userId+"' data-reply_nickname='"+nickName+"'>신고</button>"
						  	        + "</span>" 
					  } 
			   }//end if
	   	    			  str +="</span>"
			   				   +"<div class='reply_contentWrapper'>"; 
			   				   
   	    			   if(depth == 0){    
   			    	      str += "<div class='reply_content'>";
	   			    	  
	   			       }else if(depth == 1){
   			    		  str += "<div class='reply_content first'>" ; 
	   			    	 
	   			       }else if(depth == 2){ 
   			    		  str += "<div class='reply_content second'>" ;
	   		    	      
	   			       }else if(depth == 3){ 
   			    		  str += "<div class='reply_content third'>" ; 
	   		    	      
	   			       }else{  
	   			    	  str += "<div class='reply_content other'>" ;
	   				   }//end if .
	   				   
           				   str += reply_content; 
           				   str += "</div>"    
			           	       +"</div>"
		          	  +"</div>" 
		          +"</li>";         
			}//end for
	        
	        replyList.html(str);//댓글목록안에 채워주기
		     
	    });//end function
	     
	}//end showReplyList
	
	showReplyList(1);//댓글리스트 1페이지 보여주기  

	/////////////////////////////////////////////////////////
	
	var replyPage = $(".replyPage");
	    
    function showReplyPage(replyCnt){//댓글 페이지 함수
    	
    	  if(replyCnt == 0){//댓글삭제후 댓글이 하나도없다면
    		  
	    		replyPage.html(""); 
	    		replyPage.css("display","none");
	    		return;
    	  }
    		  
	      var endNum = Math.ceil(pageNum / 10.0) * 10; 
	      var startNum = endNum - 9;
	      var prev = startNum != 1; 
	      var next = false; 
      
	      if(endNum * 10 >= replyCnt){
	    	  
	        	endNum = Math.ceil(replyCnt/10.0);
	       					 /* 10.0은 보여줄 댓글의 갯수 */
	      }
	      
	      if(endNum * 10 < replyCnt){
	    	  
	        	next = true;
	      }
	      
	  	  var str = "<ul class='pagination'>";  
	      	
	      if(prev){ 
	    	  
	        	str+= "<li class='paginate_button previous'><a class='page-link' href='"+(startNum -1)+"'>Previous</a></li>";
	      }
	      
	      for(var i = startNum ; i <= endNum; i++){
	        
		        var active = pageNum == i? "page_active":""; 
		          
		        str+= "<li class='paginate_button "+active+" '><a class='page-link' href='"+i+"'> " +i+ " </a></li>"; 
	      }
	      
	      if(next){
	        str+= "<li class='paginate_button next'><a class='page-link' href='"+(endNum + 1)+"'>Next</a></li>";
	      }
	      
      	  str += "</ul>";    
	      
	      replyPage.html(str);
	      replyPage.css("display","block");
    }
    
	/////////////////////////////////////////////////////////
	     
    replyPage.on("click","li a", function(e){//댓글의 페이지 번호 클릭시
    	
	       e.preventDefault();
	       
	       var targetPageNum = $(this).attr("href");
	       
	       pageNum = targetPageNum;
	        
	       showReplyList(pageNum);
    });   
	    
	/////////////////////////////////////////////////////////
	
	var operForm = $("#operForm"); 
	
	$("#list_button").on("click", function(e){//목록보기
		
	    operForm.find("#board_num").remove();
	    operForm.find("#userId").remove();
	    operForm.find("#csrf").remove();
	    operForm.attr("action","/dokky/board/list")
	    operForm.submit();
	}); 
	
	$("#modify_button").on("click", function(e){//게시글 수정
		
	    operForm.submit();//다시보기 post아닌데 csrf보냄   
	}); 
	   
	$("#remove_button").on("click", function(e){//게시글 삭제
		
		if(func_confirm('정말 삭제 하시겠습니까?')){
			operForm.attr("action","/dokky/board/remove").attr("method","post");
		    operForm.submit();
		}
	}); 
	
	/////////////////////////////////////////////////////////

	$("#scrap").on("click",function(event){//게시글 스크랩
		
			var scrapData = { 
								board_num : board_num,
								userId    : myId
					 		}; 
			 	 
			replyService.ScrapBoard(scrapData, function(result){
				
					 if(result == 'success'){
						 alert("스크랩 하였습니다."); 
			 	 
					 }else if(result == 'cancel'){
						 alert("스크랩을 취소하였습니다.");
						 
					 }else if(result == 'fail'){
						 alert("스크랩에 실패하였습니다. 관리자에게 문의주세요.");
					 }
			});
	});  
	
	/////////////////////////////////////////////////////////

	$("#like").on("click",function(event){//게시글 좋아요
		
		var loginCheck = "로그인후 좋아요를 눌러주세요.";
		var likeCheck = "자신의 글에는 좋아요를 할 수 없습니다.";
		 
		if(checkUser(board_id, loginCheck, null, likeCheck)){ 
			return;
		} 
		
		var likeData = {
							board_num:board_num,
							userId:myId
					   };
		
		var alarmData = {
								target:board_id,
							commonVar1:board_title,
							commonVar2:board_num,
								  kind:1,
							writerNick:myNickName,
							  writerId:myId
			            };
		  
	    var commonData = {
						 	boardLikeVO : likeData,
						 	alarmVO     : alarmData
	 					 };
		 
	   	replyService.updateLike(commonData, function(result){
	   	
			   	var likeCount = $("#likeCount");
			  	likeCount.html(result);
        }); 
	   	//다시보기 추후 좋아요를 눌르면 이미지변경까지, 취소하면 이미지변경 추가해보자
   	}); 
   	
	/////////////////////////////////////////////////////////

	$("#dislike").on("click",function(event){//게시글 싫어요
		  
		var loginCheck = "로그인후 싫어요를 눌러주세요.";
		var dislikeCheck = "자신의 글에는 싫어요를 할 수 없습니다.";
		 
		if(checkUser(board_id, loginCheck, null, dislikeCheck)){ 
			return;
		} 
		
		var dislikeData = {   
							 board_num:board_num,
							    userId:myId
						  };
		
		var alarmData = { 
								target:board_id,
							commonVar1:board_title,
							commonVar2:board_num,
								  kind:2,
							writerNick:myNickName,
							  writerId:myId
	          			};
		
		var commonData = { 
						    boardDisLikeVO : dislikeData,
						 	alarmVO        : alarmData
			 			 }
		
		replyService.updateDisLike(commonData, function(result){
		   	 
			   	var dislikeCount = $("#dislikeCount");
			   	dislikeCount.html(result);
		   	
   	    });
	});
	
	///////////////////////////////////////////////////////
	
	$(".replyList").on("click",'button[data-oper="like"]', function(event){//댓글 좋아요
			
			var reply_id = $(this).data("reply_id");
			var reply_num = $(this).data("reply_num");
			var reply_content = $(this).data("reply_content");
			var loginCheck = "로그인후 좋아요를 눌러주세요.";
			var likeCheck = "자신의 댓글에는 좋아요를 할 수 없습니다.";
			 
			if(checkUser(reply_id, loginCheck, null, likeCheck)){ 
				return;
			}
			
			var likeData = {
							 reply_num:reply_num,
							    userId:myId 
						   };
	
			var alarmData = { 
									target:reply_id,  
								commonVar1:reply_content,
								commonVar2:board_num,
									  kind:5, 
								writerNick:myNickName,
								  writerId:myId
				          	};
			
			var commonData = {
								replyLikeVO : likeData,
							 	alarmVO     : alarmData
		 					 };
	
			replyService.updateReplyLike(commonData, function(result){
			 
				var replyLikeCount = $("#replyLikeCount"+reply_num);
					replyLikeCount.html(result);
		    });
	});
	
	///////////////////////////////////////////////////////
	
	$(".replyList").on("click",'button[data-oper="dislike"]', function(event){//댓글 싫어요
		
			var reply_id = $(this).data("reply_id");
			var reply_num = $(this).data("reply_num");
			var reply_content = $(this).data("reply_content");
			var loginCheck = "로그인후 싫어요를 눌러주세요.";
			var dislikeCheck = "자신의 댓글에는 싫어요를 할 수 없습니다.";
			 
			if(checkUser(reply_id, loginCheck, null, dislikeCheck)){ 
				return;
			} 
			
			var dislikeData = {
								 reply_num:reply_num,
								    userId:myId 
							  };
		
			var alarmData = { 
									target:reply_id,  
								commonVar1:reply_content,
								commonVar2:board_num,
									  kind:6, 
								writerNick:myNickName,
								  writerId:myId
				          	};

			
			var commonData = { 
								replyDisLikeVO : dislikeData,
							 	   alarmVO     : alarmData
		 					 };
			
			replyService.updateReplyDisLike(commonData, function(result){
			 
				var replyDisLikeCount = $("#replyDisLikeCount"+reply_num);
					replyDisLikeCount.html(result);
					
	 	 	});
	});
	
	///////////////////////////////////////////////////////이하 게시판,댓글 - 기부 관련
 
   	var donateBackGround = $("#donateBackGround");
	var donateModal = $("#donateModal");//기부 모달창
	var option;//게시글 기부 or 댓글 기부 선택 
	var inputMoney = 0;//기부 할 금액
	var myCash;//내 캐시
	var donate_reply_id;//해당 댓글의 아이디
	var donate_reply_num;//해당 댓글 번호
	var donate_reply_content;//해당 댓글 내용
	 	
	function closeDonateModal(){//모달창 닫기 함수  
			
			inputMoney = 0;
			donateModal.find("input[name='realGiveCash']").val(0); 
			donateModal.find("input[name='giveCash']").val(""); 
			donateBackGround.css("display","none");
			donateModal.css("display","none"); 
	}
	
	function openDonateModal(){//모달창 열기 함수 
		
			donateBackGround.css("display","block");
			donateModal.css("display","block");
	}
	
    	
	$("#modalCloseBtn, #donateBackGround").on("click",function(event){//모달창 닫기
		closeDonateModal();
	});
	
	$("#donateMoney").on("click",function(event){//게시글 기부 모달폼 열기
		
		var loginCheck = "로그인후 기부를 해주세요.";
		var giveCheck = "자신의 글에는 기부를 할 수 없습니다.";
	
		if(checkUser(board_id, loginCheck, null, giveCheck)){ 
			return;  
		}
		
		replyService.getUserCash(myId, function(result){//나의 잔여 캐시 가져오기
				
				option = 'board';
				myCash = parseInt(result);
				 
				result = result.replace(/[^0-9]/g,''); 
				result = (result.replace(/\B(?=(\d{3})+(?!\d))/g, ","));  
			  
				donateModal.find("input[name='myCash']").val(result);
				
				openDonateModal();
   	    });
   	
	});
	
	$(".replyList").on("click",'button[data-oper="donateMoney"]', function(event){//댓글 기부 모달폼 열기
		
		donate_reply_id 	  =  $(this).data("reply_id"); 
		donate_reply_num 	  =  $(this).data("reply_num");
		donate_reply_content  =  $(this).data("reply_content");
		var loginCheck 		  =  "로그인후 기부를 해주세요.";
		var giveCheck 		  =  "자신의 댓글에는 기부를 할 수 없습니다.";
		 
		if(checkUser(donate_reply_id, loginCheck, null, giveCheck)){ 
			return;
		} 
		
		replyService.getUserCash(myId, function(result){
				
				option = 'reply'; 
				myCash = parseInt(result); 
				
				result = result.replace(/[^0-9]/g,''); 
				result = (result.replace(/\B(?=(\d{3})+(?!\d))/g, ","));  
			
				donateModal.find("input[name='myCash']").val(result);
				
				openDonateModal();
   	    });
   	
	});

	$("#modalSubmitBtn").on("click",function(event){ //게시글 or 댓글 기부 하기 완료 버튼    
		
		inputMoney = parseInt(donateModal.find("input[name='realGiveCash']").val());  
	
		if(myCash < inputMoney){
			alert("보유 캐시가 부족합니다.");
			closeDonateModal();
			return; 
		} 
		 
		if(inputMoney === 0 || inputMoney === ""){   
			alert("금액을 1원이상 입력해주세요."); 
			return;
		}
		
		if(option === 'board'){//게시글 기부시
			
			var donateData = {	 board_num 	: board_num, //글번호
							 	 userId     : myId, //기부하는 아이디
							  	 donatedId  : board_id, //기부받는 아이디
							  	 money      : inputMoney, //기부금액
							  	 cash 	    : myCash //기부자의 잔여 캐시
							 };
		
		
			var alarmData = { 
								target:board_id,
								commonVar1:board_title,
								commonVar2:board_num,
								kind:3,
								writerNick:myNickName,
								writerId:myId
				            };
			
			var commonData ={ 
							  donateVO    : donateData,
						 	  alarmVO     : alarmData
						 	}
	
			replyService.updateDonation(commonData, function(result){
			
				var boardMoney = $("#boardMoney"); 
			   	boardMoney.html(result+"\\");  
			   	
				closeDonateModal(); 
				
				alert("기부 하였습니다."); 
				
	   	    });
			
		}else if(option === 'reply'){//댓글 기부시
				
				var replyDonateData = {
										   board_num : board_num, //글번호
						   				   reply_num : donate_reply_num, //댓글번호
										   userId  	 : myId, //기부하는 아이디
										   donatedId : donate_reply_id, //기부받는 아이디
										   money     : inputMoney, //기부금액
										   cash 	 : myCash //기부자의 잔여 캐시
									  };
				
				var alarmData = { 
									target:donate_reply_id,
									commonVar1:donate_reply_content,
									commonVar2:board_num,
									kind:4,
									writerNick:myNickName,
									writerId:myId
					            };
							
				var commonData ={ 
									replyDonateVO    : replyDonateData,
								 	alarmVO          : alarmData
		 						}	
			
				replyService.updateReplyDonation(commonData, function(result){
				
					var replyMoney= $("#replyMoney"+donate_reply_num);
					replyMoney.html(result+"\\"); 
				   	
					closeDonateModal();
					
					alert("기부 하였습니다.");  
		   	    });
		}
	});
	
	///////////////////////////////////////////////////////신고 관련 시작,

	var reportKind;  //신고 종류
	var reportingId; //신고자 아이디
	var reportingNick; //신고자 닉네임
	var reportedId; //신고당한자 아이디 
	var reportedNick; //신고당한자 닉네임
	var reportForm = $("#reportForm"); //신고폼
	var reportBackGround = $("#reportBackGround");
	var reportInput = $("#reportInput"); //신고사유Input
		
	function openReportForm(){//신고폼 열기 함수
   		
   	 	 reportBackGround.css("display","block");			
   		 reportForm.css("display","block");
	} 

	function closeReportForm(){//신고폼 닫기 함수

		reportBackGround.css("display","none");
		reportForm.css("display","none");
		reportInput.val(""); 
	}  
  		
	$("#closeReport").on("click",function(event){//신고폼 닫기 공통
  			
 			closeReportForm(); 
 	});
  		
	$("#openReport").on("click",function(event){//게시글 신고폼 열기 버튼
	   			
			openReportForm();
	 		reportKind =  "게시글"; 
	 		reportedId = board_id;
	  		reportedNick = board_nickName;
	});	 
		 	
	$(".replyList").on("click",'button[data-oper="report"]', function(event){//댓글 신고폼 열기 버튼
		
		reportedId = $(this).data("reply_id");
		var loginCheck = "로그인후 신고를 해주세요.";
		var reportCheck = "자신의 댓글에는 신고를 할 수 없습니다.";
		 
		if(checkUser(reportedId, loginCheck, null, reportCheck)){ 
			return;
		} 
		
		openReportForm();
		reportKind = '댓글';
		reportedNick = $(this).data("reply_nickname");
		
	});
	
    $("#submitReport").on("click",function(event){//신고 확인 버튼 
    	  
    	 var reason = reportInput.val();
    	 
    	 reason = $.trim(reason);
    	 
    	 if(reason === "") {
    			alert("신고 사유 입력후 신고해주세요.");
    			reportInput.focus();
	 			return;
    	 } 
    
		 var reportData = {  
							reportKind    : reportKind,
			 			    reportingId   : myId, 
			 				reportingNick : myNickName, 
			 				reportedId    : reportedId, 
			 				reportedNick  : reportedNick, 
			 				board_num     : board_num, 
			 				reason        : reason
		 				  };
		 
		 var alarmData = { 
							target		: 'admin',  
							kind		: 9,
							commonVar1:reason, 
							writerNick	: myNickName,
							writerId	: myId
	            		 };
			
		 var commonData ={ 
			 				reportVO  : reportData,
			 				alarmVO   : alarmData
						 };	

		 replyService.report(commonData, function(result){
			 
				 if(result == 'success'){
					 alert("신고완료 되었습니다.");
					 
				 }else if(result == 'fail'){
					 alert("신고되지 않았습니다. 관리자에게 문의주세요.");
				 } 
				 
				 closeReportForm();  
		 });
    });
	 	
	///////////////////////////////////////////////////////// 
	$("#replyRegisterBtn").on("click",function(e){//댓글 등록 버튼 
		
			var alarmData;
			var commonData;
		 	var reply_contents = $("#reply_contents");//기본 댓글 textarea
		 
			var reply = {
				    		reply_content : reply_contents.val(), //댓글 내용
				    			   userId : myId,				  //댓글 작성자 아이디
				    			 nickName : myNickName, 	      //댓글 작성자 닉네임
				    			 board_num : board_num 			  //글번호 
			            };
		 	
		 	if(board_id !== myId){
		 		
		 		 alarmData = {
									target  :  board_id, 
								commonVar1  :  substr(reply_contents.val()),
								commonVar2  :  board_num,
									  kind  :  0,
								writerNick  :  myNickName,
								writerId    :  myId
				             };
 
				 commonData = { 
									replyVO:reply,
									alarmVO:alarmData
							  };
		 	}else{//나의 글에 댓글을 달시에 알람을 보내지 말자
		 		 commonData = { 
									replyVO:reply
							  };
		 	}
		 	
			replyService.add(commonData, function(result){
			        reply_contents.val("");
			        
			        showReplyList(-1);//다시 댓글 목록 마지막 페이지 보여주기
			}); 
    });
		 
	/////////////////////////////////////////////////////////대댓글
	
	var reReplyWriteForm = $(".reReplyWriteForm");
	
	var group_num;//댓글 묶음 번호  
	var order_step;//댓글 출력순서
    var depth;//댓글 깊이= 루트글인지,답변글인지,답변에 답변글인지
    var toUserId;//대댓글 알림 보낼 사람의 아이디
    var toNickName;//대댓글 알림 보낼 사람의 닉네임
    
	
	$(".replyList").on("click",'button[data-oper="reReplyForm"]', function(event){//대댓글 폼 열기
			   
			var reply_num = $(this).data("reply_num");
			 
			reReplyWriteForm.css("display","block");  
			
			$("#replyLi"+reply_num).after(reReplyWriteForm);//해당 댓글 li의 뒤에다가 대댓글폼 버튼 붙이기       
		  
			group_num = $(this).data("group_num");  
			order_step = $(this).data("order_step");  
			depth = $(this).data("depth");  
			toUserId = $(this).data("reply_id");  
			toNickName = $(this).data("nick_name");  
    });
	
	$("#reReplyRegisterBtn").on("click",function(e){//대댓글 등록 버튼
		
		      var reReply_contents = $("#reReply_contents");
		      var alarmData ;
		      var commonData;
		      
	          var reply = { 
				    		reply_content  :	reReply_contents.val(), //대댓글 내용
				    		userId		   :	myId,//댓글 작성자 아이디
				    		nickName	   :	myNickName, //댓글 작성자 닉네임
				            toUserId	   :	toUserId,
				            toNickName	   :	toNickName,
				            board_num	   :	board_num,
				            group_num	   :	group_num,
				            order_step	   :	order_step,
				            depth	   	   :	depth
			       	     };
				  
	          if(toUserId !== myId){
	        	  
				   alarmData = {
									 target		: toUserId,
									 commonVar1 : reReply_contents.val(),
									 commonVar2 : board_num,
									 kind		: 0,	
									 writerNick : myNickName,
									 writerId	: myId
								  };
			 
				   commonData =	{ 
										replyVO : reply, 
										alarmVO : alarmData
						 	  		}
	          }else{ 
	        	  
	        	   commonData =	{ 
									replyVO : reply 
					 	  		} 
	          }
			  
	     	  replyService.add(commonData, function(result){
	        	    
	     			reReplyWriteForm.css("display","none"); 
	     	 
	     			reReply_contents.val("");//대댓글 내용  비우기 
	     			
	     			$(".replyWriteForm").after(reReplyWriteForm);//댓글 리스트가 리셋되면 폼이 사라지니까 다시 붙여두기 
			         
			        showReplyList(-1);//댓글 목록 마지막 페이지 보여주기
		     }); 
    });
	
	
	$("#reReplyCancelBtn").on("click",function(e){ //대댓글 등록 취소 버튼
		
		reReplyWriteForm.css("display","none");
	
		$("#reReply_contents").val(""); 
    });
	
	var checkModify = false;
	var originReplyForm;//수정할려는 원래의 댓글폼
	var replyModForm ;//현재 수정폼 
	 
	$(".replyList").on("click",'button[data-oper="modify"]', function(event){//댓글 수정 폼 열기
		 
		var reply_id = $(this).data("reply_id");   
		var reply_num = $(this).data("reply_num"); 
		
		if(checkModify){//댓글 수정중이었다면   
			originReplyForm.css("display","block");
			replyModForm.css("display","none"); 
		}   
		 
		originReplyForm = $("#replyLi"+reply_num);
		originReplyForm.css("display","none");
		
	    replyService.get(reply_num, function(Result){//댓글 데이터 한줄 가져오기 
			  
	    	  replyModForm = $("#replyModForm"+reply_num);
	    
	    	  var InputReply_content = replyModForm.find("textarea[name='reply_content']");
	    	
			  InputReply_content.val(Result.reply_content);
			  
			  replyModForm.css("display","block");
			  
			  checkModify = true;
			  
			  $("#replyModFormModBtn"+reply_num).on("click", function(e){//댓글 수정 등록 완료 
				   
				   	 var reply = {  
									  reply_num		: reply_num,
									  reply_content	: InputReply_content.val(),
									  userId		: reply_id //접속자와 댓글작성자의 확인을 위해
							     };
				   	  
			   	     replyService.updateReply(reply, function(result){
				   	        
				   	    	showReplyList(pageNum);//수정후 댓글 페이지 유지하면서 리스트 다시불름
			   	     });
		   	  });   
			    
			  $("#replyModFormCloseBtn"+reply_num).on("click", function(e){//댓글 수정 취소 
				  	
				  	replyModForm.css("display","none"); 
				  	originReplyForm.css("display","block");
			  }); 
	    });
	});
	
	///////////////////////////////////////////////////////
	
	$(".replyList").on("click",'button[data-oper="delete"]', function(event){//댓글 삭제
		
		if(func_confirm('정말 삭제 하시겠습니까?')){
			
				replyService.remove( $(this).data("reply_num"), $(this).data("reply_id"), board_num, function(result){
					
				  	      showReplyList(pageNum);//삭제후 댓글 페이지 유지하면서 리스트 다시 호출 
				}); 
		}
	}); 
			
	///////////////////////////////////////////////////////

   $(document).ready(function(){//첨부파일 즉시 함수
    	  
	  	 (function(){//즉시실행함수 
	   	  
		   	    $.getJSON("/dokky/board/getAttachList", {board_num: board_num}, function(arr){
		   	        	
		    	       var fileStr = "";
		    	       var hasFile = false;
		    	       
		    	       $(arr).each(function(i, attach){
							if(!attach.fileType){ //파일이라면
			    	        	   fileStr += "<li class='hideUsermenu' data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"' >"
			    	        	    				+ attach.fileName        
				    	            		 +"</li>";
			    	        	   hasFile = true;
		    	            }
					   });
		    	       
		    	       if(hasFile){
		    	    	   $(".fileUploadWrap").css("display","inline-block");
			    	       $(".fileUploadResult ul").html(fileStr);
		    	       }
		   	     });
	   	 })(); 
   }); 
    	  
   ///////////////////////////////////////////////////////

   $(".fileUploadResult").on("click","li", function(e){
   	      
    	    var liObj = $(this); 
    	    
    	    var path = encodeURIComponent(liObj.data("path")+"/" + liObj.data("uuid")+"_" + liObj.data("filename"));
    	    
    	    if(!liObj.data("type")){//파일이라면  
    	    	self.location ="/dokky/download?fileName="+path 
    	    }
   });
   
   ///////////////////////////////////////////////////////
   	  
   function showImage(fileCallPath){
  	    
	  	    $(".bigPictureWrapper").css("display","flex").show();
	  	    
	  	    $(".bigPicture").html("<img src='/dokky/display?fileName="+fileCallPath+"' >");
   } 
   
   ///////////////////////////////////////////////////////

   $(".content").on("click","img", function(e){//본문에서 사진을 클릭한다면
	  	
			var imgObj = $(this);
		  
			var path = imgObj.data("filecallpath");
			  
			showImage(path);  
   });
	
   ///////////////////////////////////////////////////////
	    	  
   $(".bigPictureWrapper").on("click", function(e){
   		  
   			$('.bigPictureWrapper').hide();
   });  
	      
	///////////////////////////////////////////////////////
   
   $(".replyList").on("click",'.userMenu', function(event){//해당 댓글 메뉴바 보이기 이벤트
			
			event.preventDefault();
		
			if($(".addBlockClass").length > 0){//상세페이지 전체에서 찾음
				
				  $(".addBlockClass").css("display","none"); 
				  $(".addBlockClass").removeClass('addBlockClass'); 
			} 
		
			var	menu_kind = $(this).data("menu_kind"); 
			var	reply_num = $(this).data("reply_num");
			 
			if(menu_kind == 'from'){
			
					var userMenubar = $("#userMenubar_reply_from_"+reply_num);
					
			}else if(menu_kind == 'to'){
				
					var userMenubar = $("#userMenubar_reply_to_"+reply_num);
			}
			
			userMenubar.css("display","block").addClass('addBlockClass'); 
   }); 
	 
   ///////////////////////////////////////////////////////
		 
   $("#board_userMenu").on("click",function(event){//해당 게시판 메뉴바 보이기 이벤트
	
			event.preventDefault();
   
			if($(".addBlockClass").length > 0){
				
				  $(".addBlockClass").css("display","none");  
				  $(".addBlockClass").removeClass('addBlockClass'); 
			}  
			 
			$("#UserMenubar_board").css("display","block").addClass('addBlockClass');
   }); 
	  
   ///////////////////////////////////////////////////////
   
   $("#fileUploadLink").on("click",function(event){//첨부파일 리스트 보기
	
			event.preventDefault();
   
			if($(".addBlockClass").length > 0){
				
				  $(".addBlockClass").css("display","none");  
				  $(".addBlockClass").removeClass('addBlockClass'); 
			}  
			 
			$(".fileUploadResult").css("display","inline-block").addClass('addBlockClass'); 
   });
   
   
   $('html').click(function(e) { //html안 Usermenu, hideUsermenu클래스를 가지고있는 곳 제외하고 클릭하면 userMenubar숨김 이벤트발생
	    //console.log(e.target);
	   	//alert(!$(e.target).is('.userMenu, .hideUsermenu'));
	   		if( !$(e.target).is('.userMenu, .hideUsermenu') ) {
			  
	   			$(".userMenubar").css("display","none");
	   			$(".fileUploadResult").css("display","none"); 
			} 
   });  
	    
</script>
</body>
</html>
 
