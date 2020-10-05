<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %> 
<sec:authentication property="principal" var="userInfo"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Dokky - 글 리스트</title>
<c:choose>
   	  <c:when test="${pageContext.request.serverName == 'localhost'}">
			<link href="/resources/css/list.css" rel="stylesheet" type="text/css">
	  </c:when>
      <c:otherwise>
    		<link href="/ROOT/resources/css/list.css" rel="stylesheet" type="text/css">
      </c:otherwise>
</c:choose>
</head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<%@include file="../includes/common.jsp"%>
<body>
	<div class="listWrapper">
		<div class="boardKind">
			 <span class="category">
				   <c:choose>
				   	   <c:when test="${pageMaker.cri.category == 0 }">
				          	<a href="/board/allList?category=0" >전체글보기</a>
				       </c:when>
				       <c:when test="${pageMaker.cri.category == 1 }">
				          	<a href="/board/list?category=1">공지사항</a>
				       </c:when>
				       <c:when test="${pageMaker.cri.category == 2 }">
				       		<a href="/board/list?category=2">자유게시판</a>
				       </c:when>
				        <c:when test="${pageMaker.cri.category == 3 }">
				     		<a href="/board/list?category=3">묻고답하기</a>
				       </c:when>
				        <c:when test="${pageMaker.cri.category == 4 }">
				   		   <a href="/board/list?category=4">칼럼/Tech</a>
				       </c:when>
				       <c:when test="${pageMaker.cri.category == 5 }">
				   		   	<a href="/board/list?category=5">정기모임/스터디</a>
				       </c:when> 
				       <c:otherwise>
				       </c:otherwise>
			       </c:choose>
		     </span>   
		     
		     <c:if test="${pageMaker.cri.category == 1 }">
		     		<span class="regBtn"> 
		     			<sec:authorize access="hasAnyRole('ROLE_ADMIN','ROLE_SUPER')">
	   		 				<button id='regBtn' type="button">새 글쓰기</button>
	   		 			</sec:authorize>
		     		</span>
		      </c:if>
		      
		     <c:if test="${pageMaker.cri.category != 1 }">
		     		<span class="regBtn"> 
		      			<button id='regBtn' type="button">새 글쓰기</button>
		     		</span>
		     </c:if>
	    </div> 
	     
		<div class="orderMethodWrap">
		
			<div id="menuWrap"> 
				<div class="tab">   
					<button class="<c:if test="${pageMaker.cri.order == 0 }">active</c:if>"  
					onclick="location.href='${requestScope['javax.servlet.forward.request_uri']}?category=${pageMaker.cri.category}&order=0&type=${pageMaker.cri.type}&keyword=${pageMaker.cri.keyword}&pageNum=${pageMaker.cri.pageNum}&amount=${pageMaker.cri.amount}'">최신순</button>
					<button class="<c:if test="${pageMaker.cri.order == 1 }">active</c:if>"  
					onclick="location.href='${requestScope['javax.servlet.forward.request_uri']}?category=${pageMaker.cri.category}&order=1&type=${pageMaker.cri.type}&keyword=${pageMaker.cri.keyword}&pageNum=${pageMaker.cri.pageNum}&amount=${pageMaker.cri.amount}'">조회순</button>
					<button class="<c:if test="${pageMaker.cri.order == 2 }">active</c:if>"  
					onclick="location.href='${requestScope['javax.servlet.forward.request_uri']}?category=${pageMaker.cri.category}&order=2&type=${pageMaker.cri.type}&keyword=${pageMaker.cri.keyword}&pageNum=${pageMaker.cri.pageNum}&amount=${pageMaker.cri.amount}'">댓글순</button>
					<button class="<c:if test="${pageMaker.cri.order == 3 }">active</c:if>"  
					onclick="location.href='${requestScope['javax.servlet.forward.request_uri']}?category=${pageMaker.cri.category}&order=3&type=${pageMaker.cri.type}&keyword=${pageMaker.cri.keyword}&pageNum=${pageMaker.cri.pageNum}&amount=${pageMaker.cri.amount}'">좋아요순</button>
					<button class="<c:if test="${pageMaker.cri.order == 4 }">active</c:if>"  
					onclick="location.href='${requestScope['javax.servlet.forward.request_uri']}?category=${pageMaker.cri.category}&order=4&type=${pageMaker.cri.type}&keyword=${pageMaker.cri.keyword}&pageNum=${pageMaker.cri.pageNum}&amount=${pageMaker.cri.amount}'">기부순</button>
			    </div>
		 	</div>
			
			<div class="searchWrapper">
				<form id='searchForm' action="/board/list" method='get'>
					<select id="option" name='type'>
						<option value="TC"
							<c:out value="${pageMaker.cri.type == null || pageMaker.cri.type eq 'TC'?'selected':''}"/>>제목+내용</option>
						<%-- <option value="TC"
							<c:out value="${pageMaker.cri.type eq 'TC'?'selected':''}"/>>제목+내용</option> --%>
						<option value="T"
							<c:out value="${pageMaker.cri.type eq 'T'?'selected':''}"/>>제목</option>
						<option value="C"
							<c:out value="${pageMaker.cri.type eq 'C'?'selected':''}"/>>내용</option>
						<option value="N"
							<c:out value="${pageMaker.cri.type eq 'N'?'selected':''}"/>>닉네임</option>
						<option value="TN"
							<c:out value="${pageMaker.cri.type eq 'TN'?'selected':''}"/>>제목+닉네임</option>
						<option value="TNC"
							<c:out value="${pageMaker.cri.type eq 'TNC'?'selected':''}"/>>제목+내용+닉네임</option>
					</select> 
					
					<input id="keyword" name='keyword' type='text' value='<c:out value="${pageMaker.cri.keyword}"/>' oninput="checkLength(this,30)" autofocus/> 
					<input type='hidden' name='pageNum' value='<c:out value="${pageMaker.cri.pageNum}"/>' /> 
					<input type='hidden' name='amount' value='<c:out value="${pageMaker.cri.amount}"/>' />
					<input type='hidden' name='category' value='${pageMaker.cri.category}'>
					
					<button id='search'></button> 
				</form> 
			</div> 
			
	    </div>
	    
		<div class="">
			<table class="table"> 
				<c:forEach items="${list}" var="board">
					<tr>
						<td class="title">  
							<a class='move' href='<c:out value="${board.board_num}"/>'> 
								<c:out value="${board.title}" />
								<span class="replyCnt">
									<c:if test="${board.replyCnt > 0}">
										[<c:out value="${board.replyCnt}" />]
							        </c:if>
								</span>
							</a> 
						</td> 
						<td class="td">
							<div class="tdData">  
								조회수
							</div>
							<c:out value="${board.hitCnt}" />
						</td>
						<td class="td">
							<div class="tdData">  
								좋아요
							</div>
							<c:out value="${board.likeCnt}"/>
						</td> 
						<td class="td">
							<div class="tdData">  
							</div>
							    \<fmt:formatNumber type="number" maxFractionDigits="3" value="${board.money}"/>
						</td>
						<td class="td"> 
							<a href="#" class="userMenu" data-board_num="${board.board_num}"> 
								<c:choose>
								   	  <c:when test="${pageContext.request.serverName == 'localhost'}"> 
										 	<img src="/resources/img/profile_img/<c:out value="${board.userId}"  />.png?${random}"  class="memberImage hideUsermenu" onerror="this.src='/resources/img/profile_img/basicProfile.png'" />
									  </c:when> 
								      <c:otherwise> 
								    		<img src="/upload/<c:out value="${board.userId}"  />.png?${random}"  class="memberImage hideUsermenu" onerror="this.src='/ROOT/resources/img/profile_img/basicProfile.png'" />
								      </c:otherwise>
								</c:choose>	 
								<c:out value="${board.nickName}" /> 
							</a> 
							 <div id="userMenubar_${board.board_num}" class="userMenubar">
								<ul class="hideUsermenu"> 
									<li class="hideUsermenu">
										<a href="/userBoardList?userId=${board.userId}" class="hideUsermenu">
											<span class="hideUsermenu">게시글보기</span>
										</a>
									</li>
									<li class="hideUsermenu">
										<a href="#" class="hideUsermenu" onclick="noteOpen('${board.userId}','${board.nickName}')">
											<span class="hideUsermenu">쪽지보내기</span> 
										</a>
									</li>
									<li class="hideUsermenu singleChat" data-board_nickname="${board.nickName}" data-board_userid="${board.userId}">
										<a href="#" class="hideUsermenu">
											<span class="hideUsermenu">1:1채팅</span>
										</a>
									</li>
								</ul>     
						     </div> 
						</td>
						<td id="dateTd" class="regdate${board.board_num}" data-regdate_val='<fmt:formatDate value="${board.regDate}" pattern="yyyy/MM/dd/HH:mm:ss" />'>
								<script>
									$(document).ready(function(){
										var	board_num = '${board.board_num}'; 
										var	regdateTd = $(".regdate"+board_num);
										var regdate_val = regdateTd.data("regdate_val");
										regdateTd.html(timeBefore(regdate_val));
			            			});
			    				</script> 
						</td> 
					</tr>
				</c:forEach>
			</table>
		</div>
		
			<div class='pull-right'>
				<ul class="pagination">
					<c:if test="${pageMaker.prev}">
						<li class="paginate_button previous">
							<a href="${pageMaker.startPage -1}">Previous</a>
						</li>
					</c:if>

					<c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
						<li class="paginate_button  ${pageMaker.cri.pageNum == num ? "page_active":""} ">
							<a href="${num}">${num}</a>
						</li>
					</c:forEach> 

					<c:if test="${pageMaker.next}">
						<li class="paginate_button next"><a
							href="${pageMaker.endPage +1 }">Next</a>
						</li>
					</c:if>
				</ul>
			</div>
	</div>
	
<form id='actionForm' action="/board/list" method='get'> 
	<input type='hidden' name='pageNum' value='${pageMaker.cri.pageNum}'><!--  $(this).attr("href") -->
	<input type='hidden' name='amount' value='${pageMaker.cri.amount}'>
	<input type='hidden' name='category' value='${pageMaker.cri.category}'>
	<input type='hidden' name='type' value='<c:out value="${ pageMaker.cri.type }"/>'> 
	<input type='hidden' name='keyword' value='<c:out value="${ pageMaker.cri.keyword }"/>'>
</form> 
	
<script> 
	
	var myId;
	var myNickName;
	var csrfHeaderName ="${_csrf.headerName}"; 
	var csrfTokenValue="${_csrf.token}";
	
	<sec:authorize access="isAuthenticated()">   
		myId = '${userInfo.username}';  
		myNickName = '${userInfo.member.nickName}';
	</sec:authorize>
	
	$(document).ajaxSend(function(e, xhr, options) {  //모든 AJAX전송시 CSRF토큰을 같이 전송하도록 셋팅
		
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

	function timeBefore(time){  
        
        var now = new Date();//현재시간
        var writeDay = new Date(time);//글쓴 시간 
     	var minus;//현재 년도랑 글쓴시간의 년도 비교 
     	var prev;
        
        if(now.getFullYear() > writeDay.getFullYear()){
        	
            minus= now.getFullYear()-writeDay.getFullYear();//두개의 차이를 구해서 표시
            
			if(minus == 1){
        		
        		var monthVal = now.getMonth()+12-writeDay.getMonth();
        		
        		if(monthVal < 12){
        			
    	            return monthVal+"달 전";
        		}
        	}
            
            return minus+"년 전";
            
        }else if(now.getMonth() > writeDay.getMonth()){//년도가 같을 경우 달을 비교해서 출력
        	
        	minus= now.getMonth()-writeDay.getMonth();
        
        	if(minus == 1){
        		
        		prev = new Date(writeDay.getYear(), writeDay.getMonth(), 0);//작성달의 말일
        	        
        		var dayVal = prev.getDate()+now.getDate()-writeDay.getDate();//작성달의 전체일수+현재 이번달의 일수 - 작성일
        		
    			if(dayVal < 7){
    				
    				return dayVal+"일 전";
    				
    			}else if(dayVal < 11){//7~10일
    				
    				return "1주 전";
    				
    			}else if(dayVal < 18){//11일 ~17일
    				
    				return "2주 전";
    				
    			}else if(dayVal < 25){//18~24일
    				
    				return "3주 전";
    				
    			}else if(dayVal < 31){
    				
    				return "1달 전";
    			}
        	}
            
            return minus+"달 전";
            
        }else if(now.getDate() > writeDay.getDate()){//같은 달일 경우 일을 계산
        	
            minus= now.getDate()-writeDay.getDate();	
            return minus+"일 전";
            
        }else if(now.getDate() == writeDay.getDate()){//당일인 경우에는 
        	
            var nowTime = now.getTime();
            var writeTime = writeDay.getTime();
            
            if(nowTime > writeTime){//시간을 비교
                sec =parseInt(nowTime - writeTime) / 1000;
                day  = parseInt(sec/60/60/24);
                sec = (sec - (day * 60 * 60 * 24));
                hour = parseInt(sec/60/60);
                sec = (sec - (hour*60*60));
                min = parseInt(sec/60);
                sec = parseInt(sec-(min*60));
                
                if(hour > 0){
                
                    return hour+"시간 전";
                }else if(min > 0){
                	
                    return min+"분 전";
                }else if(sec > 0){
                	
                    return sec+"초 전";
                }
            }
        }
	}
	
	$(".userMenu").on("click",function(event){//해당 메뉴바 보이기 이벤트
		
		var	board_num = $(this).data("board_num");
		var userMenubar = $("#userMenubar_"+board_num);
				
		if($(".addBlockClass").length > 0){
			$(".addBlockClass").css("display","none");  
			$(".addBlockClass").removeClass('addBlockClass');
		}
		userMenubar.css("display","block"); 
		userMenubar.addClass('addBlockClass'); 
	 });
	 
	$('html').click(function(e) { //html안 Usermenu, hideUsermenu클래스를 가지고있는 곳 제외하고 클릭하면 숨김 이벤트발생
		if( !$(e.target).is('.userMenu, .hideUsermenu') ) {  //("Usermenu") || $(e.target).hasClass("perid-layer")) { 	
		    var userMenu = $(".userMenubar");     
			userMenu.css("display","none"); 
		} 
	});

	$("#regBtn").on("click", function() { 
		
		if(isLimited){
	    	  openAlert("쓰기 기능이 제한되어있습니다.");
	    	  return;
	    }
		
		self.location = "/board/registerForm?category="+${pageMaker.cri.category};
	}); 
    
	
	var actionForm = $("#actionForm");

	$(".paginate_button a").on("click", function(e) {//결국pageNum값만 바꿔주기 위해

				e.preventDefault();//a태그 클릭해도 이동안되게 처리

				//console.log('click');

				actionForm.find("input[name='pageNum']").val($(this).attr("href"));//pageNum값을 바꿔주는것//this는 a태그의 href값을 가져오는것
				
				var category = '${pageMaker.cri.category}';//전체보기
				
				if(category == 0){ //전체보기	
					actionForm.attr("action","/board/allList");//전체보기
				}
				actionForm.submit(); 
			});
	
		$(".move").on("click",function(e) {
			
			e.preventDefault();
			actionForm.append("<input type='hidden' name='board_num' value='"+ $(this).attr("href")+ "'>");
			actionForm.attr("action","/board/get");
			actionForm.submit();   
		});
	
		var searchForm = $("#searchForm");
 
		$("#searchForm button").on("click", function(e) {
					
					e.preventDefault();

					/* if (!searchForm.find("option:selected")
							.val()) {
						alert("검색종류를 선택하세요");
						return false;
					} */

					if (!searchForm.find(
							"input[name='keyword']").val()) {
						openAlert("키워드를 입력해주세요");
						return false;
					}

					searchForm.find("input[name='pageNum']").val("1");
					
					var category = '${pageMaker.cri.category}';//전체보기
					
					if(category == 0){ //전체보기	
						searchForm.attr("action","/board/allList");//전체보기
					}

					searchForm.submit();
		});
		
		$(".singleChat").on("click",function(event){//1:1 채팅 
				
				if(isLimited){ 
			    	  openAlert("쓰기 기능이 제한되어있습니다.");
			    	  return;
			    }
				
				if(username == null){ 
					
					openAlert("로그인 해주세요"); 
					
					return;
				}
				
				if(username == $(this).data("board_userid")){ 
					
					openAlert("본인과는 채팅 할 수 없습니다");
					
					return;
				}
			
				var chatRoomData = {   
										roomOwnerId : myId,
										roomOwnerNick : myNickName,
										chat_type : 0
								   };
			
				var chatMemberData = {
						
										chat_memberId : $(this).data("board_userid"),
										chat_memberNick : $(this).data("board_nickname")
								  	 };
									
				var commonData = { 
									chatRoomVO : chatRoomData,
									chatMemberVO : chatMemberData
					 			 };
				
				commonService.makeSingleChat(commonData, 
			   			
				   		function(result, status){
						
							if(status == "success"){ 
								
								var popupX = (window.screen.width / 2) - (400 / 2);
	
								var popupY= (window.screen.height /2) - (500 / 2);
								
								window.open('/chatRoom/'+result+'?userId='+myId, 'ot', 'height=500, width=400, screenX='+ popupX + ', screenY= '+ popupY);
							}
				    	},
					    
				    	function(status){
				    	
							if(status == "error"){ 
								
								openAlert("Server Error(관리자에게 문의해주세요)");
							}
				    	}
			   	); 
		});
		
</script>
	
</body>
</html>