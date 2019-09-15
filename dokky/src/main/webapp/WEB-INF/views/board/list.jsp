<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Dokky - 리스트</title>
<link href="/dokky/resources/css/list.css" rel="stylesheet" type="text/css">
</head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<%@include file="../includes/left.jsp"%>
<body>
	<div class="listWrapper">
		<div class="boardKind">
			 <span>
			   <c:choose>
			   	   <c:when test="${pageMaker.cri.category == 0 }">
			          	<a href="/dokky/board/allList?category=0">전체글보기</a>
			       </c:when>
			       <c:when test="${pageMaker.cri.category == 1 }">
			          	<a href="/dokky/board/list?category=1">공지사항</a>
			       </c:when>
			       <c:when test="${pageMaker.cri.category == 2 }">
			       		<a href="/dokky/board/list?category=2">자유게시판</a>
			       </c:when>
			        <c:when test="${pageMaker.cri.category == 3 }">
			     		<a href="/dokky/board/list?category=3">묻고답하기</a>
			       </c:when>
			        <c:when test="${pageMaker.cri.category == 4 }">
			   		   <a href="/dokky/board/list?category=4">칼럼/Tech</a>
			       </c:when>
			       <c:when test="${pageMaker.cri.category == 5 }">
			   		   	<a href="/dokky/board/list?category=5">정기모임/스터디</a>
			       </c:when> 
			       <c:otherwise>
			       </c:otherwise>
		       </c:choose>
		      </span>   
		      <span class="regBtn"> 
		      	<button id='regBtn' type="button" class="">새 글쓰기</button>
		      </span>
	     </div> 
	     
		<div class="orderMethodWrap">
			<ul class="orderMethodUL">
				<li class="orderMethodLI active"> 
					<a href="${requestScope['javax.servlet.forward.request_uri']}?category=${pageMaker.cri.category}&order=0
					&type=${pageMaker.cri.type}&keyword=${pageMaker.cri.keyword}&pageNum=${pageMaker.cri.pageNum}&amount=${pageMaker.cri.amount}">최신순</a> 
				</li> 
				<li class="orderMethodLI ">
				<a href="${requestScope['javax.servlet.forward.request_uri']}?category=${pageMaker.cri.category}&order=1
				&type=${pageMaker.cri.type}&keyword=${pageMaker.cri.keyword}&pageNum=${pageMaker.cri.pageNum}&amount=${pageMaker.cri.amount}">조회순</a>
				</li>
				<li class="orderMethodLI ">
				<a href="${requestScope['javax.servlet.forward.request_uri']}?category=${pageMaker.cri.category}&order=2
				&type=${pageMaker.cri.type}&keyword=${pageMaker.cri.keyword}&pageNum=${pageMaker.cri.pageNum}&amount=${pageMaker.cri.amount}">댓글순</a>
				</li>
				<li class="orderMethodLI ">
				<a href="${requestScope['javax.servlet.forward.request_uri']}?category=${pageMaker.cri.category}&order=3
				&type=${pageMaker.cri.type}&keyword=${pageMaker.cri.keyword}&pageNum=${pageMaker.cri.pageNum}&amount=${pageMaker.cri.amount}">좋아요순</a>
				</li>
				<li class="orderMethodLI ">
				<a href="${requestScope['javax.servlet.forward.request_uri']}?category=${pageMaker.cri.category}&order=4
				&type=${pageMaker.cri.type}&keyword=${pageMaker.cri.keyword}&pageNum=${pageMaker.cri.pageNum}&amount=${pageMaker.cri.amount}">기부순</a>
				</li>
			</ul>
			
			<div class="searchWrapper">
				<form id='searchForm' action="/dokky/board/list" method='get'>
					<select name='type'>
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
								
					<input type='text' name='keyword' value='<c:out value="${pageMaker.cri.keyword}"/>' /> 
					<input type='hidden' name='pageNum' value='<c:out value="${pageMaker.cri.pageNum}"/>' /> 
					<input type='hidden' name='amount' value='<c:out value="${pageMaker.cri.amount}"/>' />
					<input type='hidden' name='category' value='${pageMaker.cri.category}'>
							
					<button class=''>검색</button> 
				</form>
			</div> 
	  </div>
		<div class="">
			<table class=""> 
				<c:forEach items="${list}" var="board">
					<tr>
						<td>   
							<a class='move' href='<c:out value="${board.board_num}"/>'> 
								<c:out value="${board.title}" />
								<span class="replyCnt">[<c:out value="${board.replyCnt}" />]</span>
							</a> 
						</td> 
						<td>
							<img width="20px" src="/dokky/resources/img/read.png"/>
							<c:out value="${board.hitCnt}" />
						</td>
						<td>   
							<img width="20px" src="/dokky/resources/img/like.png"/>
							<c:out value="${board.likeCnt}" />
						</td>
						<td> 
							\<fmt:formatNumber type="number" maxFractionDigits="3" value="${board.money}"/>
						</td>
						<td> 
							<a href="#" class="userMenu" data-board_num="${board.board_num}">
								<img src="/dokky/resources/img/profile_img/<c:out value="${board.userId}"  />.png"  class="memberImage hideUsermenu" onerror="this.src='/dokky/resources/img/basicProfile.png'" />
								<c:out value="${board.nickName}" /> 
							</a> 
							 <div id="userMenubar_${board.board_num}" class="userMenubar">
								<ul class="hideUsermenu"> 
									<li class="hideUsermenu"><a href="/dokky/userBoardList?userId=${board.userId}" class="hideUsermenu"><span class="hideUsermenu">게시글보기</span></a></li>
									<li class="hideUsermenu"><a href="#" class="hideUsermenu"><span class="hideUsermenu">쪽지보내기</span></a></li>
								</ul>    
						     </div> 
						</td>
						<td class="regdate${board.board_num}" data-regdate_val='<fmt:formatDate value="${board.regDate}" pattern="yyyy/MM/dd/HH:mm:ss" />'>
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
						<li class="paginate_button  ${pageMaker.cri.pageNum == num ? "active":""} ">
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
	
<form id='actionForm' action="/dokky/board/list" method='get'> 
	<input type='hidden' name='pageNum' value='${pageMaker.cri.pageNum}'><!--  $(this).attr("href") -->
	<input type='hidden' name='amount' value='${pageMaker.cri.amount}'>
	<input type='hidden' name='category' value='${pageMaker.cri.category}'>
	<input type='hidden' name='type' value='<c:out value="${ pageMaker.cri.type }"/>'> 
	<input type='hidden' name='keyword' value='<c:out value="${ pageMaker.cri.keyword }"/>'>
</form> 
	
<script> 
	function timeBefore(time){  
	    
	    var now = new Date();//현재시간
	    var writeDay = new Date(time);//글쓴 시간 
	 	var minus;//현재 년도랑 글쓴시간의 년도 비교 
	    
	    if(now.getFullYear() > writeDay.getFullYear()){
	    	
	        minus= now.getFullYear()-writeDay.getFullYear();//두개의 차이를 구해서 표시
	        return minus+"년 전";
	    }else if(now.getMonth() > writeDay.getMonth()){//년도가 같을 경우 달을 비교해서 출력
	    	
	        minus= now.getMonth()-writeDay.getMonth();
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
	
		self.location = "/dokky/board/register?category="+${pageMaker.cri.category};
	}); 
    
	
	var actionForm = $("#actionForm");

	$(".paginate_button a").on("click", function(e) {//결국pageNum값만 바꿔주기 위해

				e.preventDefault();//a태그 클릭해도 이동안되게 처리

				//console.log('click');

				actionForm.find("input[name='pageNum']").val($(this).attr("href"));//pageNum값을 바꿔주는것//this는 a태그의 href값을 가져오는것
				
				var category = '${pageMaker.cri.category}';//전체보기
				
				if(category == 0){ //전체보기	
					actionForm.attr("action","/dokky/board/allList");//전체보기
				}
				actionForm.submit(); 
			});
	
		$(".move").on("click",function(e) {
			
			e.preventDefault();
			actionForm.append("<input type='hidden' name='board_num' value='"+ $(this).attr("href")+ "'>");
			actionForm.attr("action","/dokky/board/get");
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
						alert("키워드를 입력해주세요.");
						return false;
					}

					searchForm.find("input[name='pageNum']").val("1");
					
					var category = '${pageMaker.cri.category}';//전체보기
					
					if(category == 0){ //전체보기	
						searchForm.attr("action","/dokky/board/allList");//전체보기
					}

					searchForm.submit();
				});
</script>
	
</body>
</html>