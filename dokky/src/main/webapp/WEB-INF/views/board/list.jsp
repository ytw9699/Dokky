<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Dokky</title>
<style>
 		@media screen and (max-width:500px){ 
	           .listWrapper {
			    border-color: #e6e6e6;
			    border-style: solid;
			    background-color: #323639;
			    color: #e6e6e6;
			    margin-left: 15%;
			    margin-top: 1%;
			    width: 80%;
			    display: inline-block;
			}
        }
        @media screen and (min-width: 501px) and (max-width:1500px){
          .listWrapper {
			    border-color: #e6e6e6;
			    border-style: solid;
			    background-color: #323639;
			    color: #e6e6e6;
			    margin-left: 15%;
			    margin-top: 1%;
			    width: 80%;
			    display: inline-block;
			}
        }
        @media screen and (min-width: 1501px){    
          .listWrapper {
			    border-color: #e6e6e6;
			    border-style: solid;
			    background-color: #323639;
			    color: #e6e6e6;
			    margin-left: 29%;
			    margin-top: 1%;
			    width: 51%;
			    display: inline-block; 
			}
        }
        
	a  {   
		color:#e6e6e6; text-decoration: none;
	}
	a:hover {   
	    color: #7151fc;
	    text-decoration: underline;
	}
	body{
		background-color: #323639; 
	}
	.mypage a { 
    color: white;
	}
	.pagination { 
	    display: inline-block;
	    padding-left: 0;
	    margin: 20px 0;
	    border-radius: 4px;
	}  
	.pagination li {
   		display: inline;
	}
	.pagination li a{
   		color: #e6e6e6;  
	}
	.pull-right{
		width: 80%;
		border-color: #e6e6e6;/* 흰색 */
		border-style: solid;
	}
	.replyCnt{  
	  color: #ff2f3b;  
	} 
	
	.userMenubar{
	    display: none;
	    border-style: solid;
	    border-color: #e6e6e6;
	    width: 6%;
	    height: 55px;
	    position: fixed;
	    background-color: #323639;
	    margin-left: 1.3%;
	}
	.userMenubar li {
	    list-style: none;
	    border-style: solid;
	    border-color: #e6e6e6;
	    width: 155%;  
	    margin-left: -60%;
	}
	.userMenubar ul { 
	    border-style : solid;
	    border-color: #e6e6e6;
	    margin: auto;
	}
	 
</style>
</head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<%@include file="../includes/left.jsp"%>
<body>
	<div class="listWrapper">
		<%@include file="../includes/search.jsp"%> 
		
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
		</div>
		<div class="">
			   <c:choose>
			   	   <c:when test="${pageMaker.cri.category == 0 }">
			          	<div class="mypage"><a href="/dokky/board/allList?category=0">전체글보기</a></div>
			       </c:when>
			       <c:when test="${pageMaker.cri.category == 1 }">
			          	<div class="mypage"><a href="/dokky/board/list?category=1">공지사항</a></div>
			       </c:when>
			       <c:when test="${pageMaker.cri.category == 2 }">
			       		<div class="mypage"><a href="/dokky/board/list?category=2">자유게시판</a></div>
			       </c:when>
			        <c:when test="${pageMaker.cri.category == 3 }">
			     		<div class="mypage"><a href="/dokky/board/list?category=3">묻고답하기</a></div>
			       </c:when>
			        <c:when test="${pageMaker.cri.category == 4 }">
			   		   	<div class="mypage"><a href="/dokky/board/list?category=4">칼럼/Tech</a></div>
			       </c:when>
			       <c:when test="${pageMaker.cri.category == 5 }">
			   		   	<div class="mypage"><a href="/dokky/board/list?category=5">정기모임/스터디</a></div>
			       </c:when> 
			       <c:otherwise>
			       </c:otherwise>
		       </c:choose>
  	    </div>

		<div><button id='regBtn' type="button" class="">새 글쓰기</button></div> 
		
		<div class="">
			<table class=""> 
				<c:forEach items="${list}" var="board">
					<tr>
						<td>   
							<a class='move' href='<c:out value="${board.num}"/>'> 
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
							<a href="#" class="userMenu" data-board_num="${board.num}">
								<img width="25px" src="/dokky/resources/img/profile_img/<c:out value="${board.userId}" />" class="memberImage hideUsermenu" onerror="this.src='/dokky/resources/img/basicProfile.png'" />
								<c:out value="${board.nickName}" /> 
							</a> 
							 <div id="userMenubar_${board.num}" class="userMenubar">
								<ul class="hideUsermenu"> 
									<li class="hideUsermenu"><a href="/dokky/userBoardList?userId=${board.userId}" class="hideUsermenu"><span class="hideUsermenu">게시글보기</span></a></li>
									<li class="hideUsermenu"><a href="#" class="hideUsermenu"><span class="hideUsermenu">쪽지보내기</span></a></li>
								</ul>    
						     </div> 
						</td>
						<td>
							<fmt:formatDate value="${board.regDate}" pattern="yyyy년 MM월 dd일 HH:mm" />
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
			actionForm.append("<input type='hidden' name='num' value='"+ $(this).attr("href")+ "'>");
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