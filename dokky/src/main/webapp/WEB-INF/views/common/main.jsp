<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %> 

<!DOCTYPE html>
<html>
<!-- <head>
<meta charset="UTF-8">
	<title>Dokky - Developer community</title> 
	<link href="/ROOT/resources/css/main.css" rel="stylesheet" type="text/css"/>
</head> -->
<head> 
<meta charset="UTF-8">
	<title>Dokky - Developer community</title> 
	   <c:choose>
		   	  <c:when test="${pageContext.request.serverName == 'localhost'}">
				 <link href="/resources/css/main.css" rel="stylesheet" type="text/css"/>
			  </c:when>
	          <c:otherwise>
	        	<link href="/ROOT/resources/css/main.css" rel="stylesheet" type="text/css"/>
	          </c:otherwise>
       </c:choose>
</head>

<%@include file="../includes/common.jsp"%>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<c:set var="random"><%= java.lang.Math.round(java.lang.Math.random() * 123456) %></c:set>
<body>
	<div class="bodyWrap">	 
		<div class="mainLists">
	      <div class="category"> 
			실시간 게시글
		  </div>
			<table class="table"> 
				<c:forEach items="${realtimeBoardList}" var="board">
					<tr>
						<td class="title">   
							<a class='move' href='/board/get?board_num=<c:out value="${board.board_num}"/>'> 
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
								기부금
							</div>
							    \<fmt:formatNumber type="number" maxFractionDigits="3" value="${board.money}"/>
						</td>
						<td class="td"> 
							<a href="" class="userMenu" data-board_num="${board.board_num}" data-menu_kind="realtime">
								<c:choose>
								   	  <c:when test="${pageContext.request.serverName == 'localhost'}">
											<img src="/resources/img/profile_img/<c:out value="${board.userId}"  />.png?${random}"  class="memberImage hideUsermenu" onerror="this.src='/resources/img/profile_img/basicProfile.png'" />
									  </c:when>
							          <c:otherwise>
							        		<img src="/upload/<c:out value="${board.userId}" />.png?${random}"  class="memberImage hideUsermenu" onerror="this.src='/ROOT/resources/img/profile_img/basicProfile.png'" />
							          </c:otherwise>
						        </c:choose>
								<c:out value="${board.nickName}" /> 
							</a> 
							 <div id="userMenubar_realtime_${board.board_num}" class="userMenubar">
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
								</ul>  
						     </div>
						</td>
						<td id="dateTd" class="td regdate${board.board_num}" data-regdate_val='<fmt:formatDate value="${board.regDate}" pattern="yyyy/MM/dd/HH:mm:ss" />'>
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
		 
		<div class="mainLists"> 
		  <div class="category"> 
			한달간 인기글
		  </div> 
			<table class="table"> 
				<c:forEach items="${monthlyBoardList}" var="board">
					<tr>
						<td class="title">  
							<a class='move' href='/board/get?board_num=<c:out value="${board.board_num}"/>'> 
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
								기부금
							</div>
							    \<fmt:formatNumber type="number" maxFractionDigits="3" value="${board.money}"/>
						</td>
						<td class="td">
							<a href="" class="userMenu" data-board_num="${board.board_num}" data-menu_kind="like">
								<c:choose>
								   	  <c:when test="${pageContext.request.serverName == 'localhost'}">
											<img src="/resources/img/profile_img/<c:out value="${board.userId}"  />.png?${random}"  class="memberImage hideUsermenu" onerror="this.src='/resources/img/profile_img/basicProfile.png'" />
									  </c:when>
							          <c:otherwise>
							        		<img src="/upload/<c:out value="${board.userId}" />.png?${random}"  class="memberImage hideUsermenu" onerror="this.src='/ROOT/resources/img/profile_img/basicProfile.png'" />
							          </c:otherwise>
						        </c:choose>
								<c:out value="${board.nickName}" />
							</a> 
							 <div id="userMenubar_like_${board.board_num}" class="userMenubar">
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
								</ul>   
						     </div>
						</td>
						<td id="dateTd" class="td regdate${board.board_num}" data-regdate_val='<fmt:formatDate value="${board.regDate}" pattern="yyyy/MM/dd/HH:mm:ss" />'>
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
		
		<div class="mainLists"> 
		  <span class="category"> 
			한달간 기부글
		  </span>
			<table class="table">
				<c:forEach items="${donationBoardList}" var="board">
					<tr>
						<td class="title">  
							<a class='move' href='/board/get?board_num=<c:out value="${board.board_num}"/>'> 
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
								기부금
							</div> 
							    \<fmt:formatNumber type="number" maxFractionDigits="3" value="${board.money}"/>
						</td>
						<td class="td">
							<a href="" class="userMenu" data-board_num="${board.board_num}" data-menu_kind="donate"> 
								<c:choose>
								   	  <c:when test="${pageContext.request.serverName == 'localhost'}">
											<img src="/resources/img/profile_img/<c:out value="${board.userId}"  />.png?${random}"  class="memberImage hideUsermenu" onerror="this.src='/resources/img/profile_img/basicProfile.png'" />
									  </c:when>
							          <c:otherwise>
							        		<img src="/upload/<c:out value="${board.userId}" />.png?${random}"  class="memberImage hideUsermenu" onerror="this.src='/ROOT/resources/img/profile_img/basicProfile.png'" />
							          </c:otherwise>
						        </c:choose>
								<c:out value="${board.nickName}" />
							</a> 
							 <div id="userMenubar_donate_${board.board_num}" class="userMenubar">
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
								</ul> 
						     </div>
						</td>
						<td id="dateTd" class="td regdate${board.board_num}" data-regdate_val='<fmt:formatDate value="${board.regDate}" pattern="yyyy/MM/dd/HH:mm:ss" />'>
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
		
	</div>
	
	<div class="footer"> 
		<div class="info"> 
			이용약관 | 개인정보처리방침 | 책임의 한계와 법적고지 | 회원정보 고객센터 
		</div>
	</div>
	<script>
	 
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
		
		event.preventDefault();//화면움직임 막기
			
		var	board_num = $(this).data("board_num");
		var	menu_kind = $(this).data("menu_kind");
		
		if(menu_kind == 'like'){
				var userMenu = $("#userMenubar_like_"+board_num);
		}else if(menu_kind == 'realtime'){
				var userMenu = $("#userMenubar_realtime_"+board_num);
		}else if(menu_kind == 'donate'){
				var userMenu = $("#userMenubar_donate_"+board_num);
		}
		if($(".addBlockClass").length > 0){
			$(".addBlockClass").css("display","none"); 
			$(".addBlockClass").removeClass('addBlockClass');
		}    
		userMenu.css("display","block"); 
		userMenu.addClass('addBlockClass'); 
		
	 });
	 
	$('html').click(function(e) { //html안 Usermenu, hideUsermenu클래스를 가지고있는 곳 제외하고 클릭하면 숨김 이벤트발생
		if( !$(e.target).is('.userMenu, .hideUsermenu') ) {  //("Usermenu") || $(e.target).hasClass("perid-layer")) { 	
		    var userMenu = $(".userMenubar");    
			userMenu.css("display","none"); 
		} 
	});
	 
	</script>
	<c:if test="${check != null}"> 
	      <script>
		      $(document).ready(function(){
		      	openAlert('${check}'); 
		      });
	      </script>
	</c:if>  
</body>
</html>