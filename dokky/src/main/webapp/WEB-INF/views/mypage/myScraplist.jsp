<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %> 

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Dokky - 스크랩</title>     
<c:choose>
   	  <c:when test="${pageContext.request.serverName == 'localhost'}">
			<link href="/resources/css/myScraplist.css" rel="stylesheet" type="text/css">
	  </c:when>
      <c:otherwise>
    		<link href="/ROOT/resources/css/myScraplist.css" rel="stylesheet" type="text/css">
      </c:otherwise>
</c:choose> 
</head>
<%@include file="../includes/left.jsp"%>
<body>
<sec:authentication property="principal" var="userInfo"/>
<div class="myscrapWrap">	

		<div id="menuWrap">
			<div class="tab"> 
				<button onclick="location.href='myInfoForm?userId=${userInfo.username}'">개인정보 변경</button>
		        <button onclick="location.href='myBoardList?userId=${userInfo.username}'">나의 게시글</button> 
		        <button onclick="location.href='myReplylist?userId=${userInfo.username}'">나의 댓글</button> 
		        <button class="active" onclick="location.href='myScraplist?userId=${userInfo.username}'">나의 스크랩</button>
		        <button onclick="location.href='myCashInfo?userId=${userInfo.username}'">나의 캐시</button>
		        <button onclick="location.href='myWithdrawalForm?userId=${userInfo.username}'">탈퇴 하기</button>
		    </div> 
		</div>
		
		<div class="listWrapper">
				<table id="inforTable">  
					<c:forEach items="${myScraplist}" var="scrap"> 
						<tr>
							<td class="td">
								<input type="checkbox" name="checkRow" value="${scrap.scrap_num}" />
	                    	</td>
	                    	
							<td class="boardTitle">
								<c:choose>
								        <c:when test="${fn:length(scrap.title) gt 9}">
									        <a class='move' href='<c:out value="${scrap.board_num}"/>'>  
												<c:out value="${fn:substring(scrap.title, 0, 9)}"/>... 
												<span class="replyCnt">
													<c:if test="${scrap.replyCnt > 0}">
														[<c:out value="${scrap.replyCnt}" />]
											        </c:if>
												</span> 
											</a>
								        </c:when>
								        <c:otherwise>
									        <a class='move' href='<c:out value="${scrap.board_num}"/>'>  
												<c:out value="${scrap.title}" />
												<span class="replyCnt">
													<c:if test="${scrap.replyCnt > 0}">
														[<c:out value="${scrap.replyCnt}" />]
											        </c:if>
												</span>   
											</a>
								        </c:otherwise>
								</c:choose> 
							</td>  
							
							<td class="td">
								<div class="tdData">  
									조회수
								</div>
								<c:out value="${scrap.hitCnt}" />
							</td>
							<td class="td" >
								<div class="tdData">  
									좋아요
								</div>
								<c:out value="${scrap.likeCnt}"/>
							</td> 
							<td class="td">
								<div class="tdData">  
									기부금
								</div>
								    \<fmt:formatNumber type="number" maxFractionDigits="3" value="${scrap.money}"/>
							</td>
						 
							<td class="td">
								<a href="#" class="userMenu" data-scrap_num="${scrap.scrap_num}"> 
									<c:choose>
									   	  <c:when test="${pageContext.request.serverName == 'localhost'}">
												<img src="/upload/<c:out value="${scrap.userId}"  />.png?${random}"  class="memberImage hideUsermenu" onerror="this.src='/resources/img/profile_img/basicProfile.png'" />
										  </c:when>
									      <c:otherwise>
									    		<img src="/upload/<c:out value="${scrap.userId}"  />.png?${random}"  class="memberImage hideUsermenu" onerror="this.src='/ROOT/resources/img/profile_img/basicProfile.png'" />
									      </c:otherwise>
									</c:choose> 
									<c:out value="${scrap.nickName}" /> 
								</a>   
								<div id="userMenubar_${scrap.scrap_num}" class="userMenubar">
									<ul class="hideUsermenu"> 
										<li class="hideUsermenu">
											<a href="/userBoardList?userId=${scrap.userId}" class="hideUsermenu">
												<span class="hideUsermenu">게시글보기</span>
											</a>
										</li> 
										<li class="hideUsermenu">
											<a href="#" class="hideUsermenu" onclick="noteOpen('${scrap.userId}','${scrap.nickName}')">
												<span class="hideUsermenu">쪽지보내기</span> 
											</a>
										</li>
									</ul>      
							    </div>
							</td>
							
							<td id="dateTd">
								<fmt:formatDate value="${scrap.regDate}" pattern="yyyy-MM-dd HH:mm" />
							</td>
						</tr>
					</c:forEach>
						<tr>
					        <td class="bottomTd"><input type="checkbox" name="checkAll" id="checkAll" onclick="checkAll();"/>전체선택</td>
					        <td class="bottomTd"><button id='deleteBtn' type="button" class="btn">삭제</button></td>
					        <td class="bottomTd"></td>  
					        <td class="bottomTd"></td>
					        <td class="bottomTd"></td>
					        <td class="bottomTd"></td> 
					        <td class="bottomTd">총 스크랩수 ${total}개 </td>  
					    </tr>
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
		
		<form id='actionForm' action="/mypage/myScraplist" method='get'>  
			<input type='hidden' name='pageNum' value='${pageMaker.cri.pageNum}'><!--  $(this).attr("href") -->
			<input type='hidden' name='amount' value='${pageMaker.cri.amount}'>
			<input type='hidden' name='userId' value='${pageMaker.cri.userId}'>
		</form> 
</div> 
	
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script> 
<script> 

		$(".userMenu").on("click",function(event){//해당 메뉴바 보이기 이벤트
			
			var	scrap_num = $(this).data("scrap_num");
			var userMenubar = $("#userMenubar_"+scrap_num);
					
			if($(".addBlockClass").length > 0){
				$(".addBlockClass").css("display","none");  
				$(".addBlockClass").removeClass('addBlockClass');
			}
			userMenubar.css("display","block"); 
			userMenubar.addClass('addBlockClass'); 
		 });
		 
		$('html').click(function(e) { //html안 Usermenu, hideUsermenu클래스를 가지고있는 곳 제외하고 클릭하면 숨김 이벤트발생
			if( !$(e.target).is('.userMenu, .hideUsermenu') ) {  	
			    var userMenu = $(".userMenubar");     
				userMenu.css("display","none");  
			} 
		});
	   
		$("#deleteBtn").on("click", function() { 
			deleteAction(); 
		}); 
    
	var actionForm = $("#actionForm");

		$(".paginate_button a").on("click", function(e) {
	
					e.preventDefault();
	 
					actionForm.find("input[name='pageNum']").val($(this).attr("href"));
					
					actionForm.submit();
				});
	
		$(".move").on("click",function(e) {//게시판 조회
			
			e.preventDefault(); 
		
			actionForm.append("<input type='hidden' name='board_num' value='"+ $(this).attr("href")+ "'>");
			actionForm.attr("action","/board/get");
			actionForm.submit();   
		});
		
		function checkAll(){
		      if( $("#checkAll").is(':checked') ){ 
		        $("input[name=checkRow]").prop("checked", true);
		      }else{
		        $("input[name=checkRow]").prop("checked", false);
		      }
		}
		
		function deleteAction(){
			
			  var checkRow = "";
			  
			  $( "input[name='checkRow']:checked" ).each (function (){
			    	checkRow = checkRow + $(this).val()+"," ;
			  });
			  
			  checkRow = checkRow.substring(0,checkRow.lastIndexOf( ","));
			 
			  if(checkRow == ''){
			   	 openAlert("삭제할 스크랩을 선택하세요");
			    return false;
			  }
			    
			  deleting('정말 삭제 하시겠습니까?', function() {
				  actionForm.attr("action","/mypage/removeAllScrap").attr("method","post");
				  actionForm.append("<input type='hidden' name='checkRow' value='"+checkRow+"'>");
				  actionForm.append("<input type='hidden' id='csrf' name='${_csrf.parameterName}' value='${_csrf.token}'/>");
				  actionForm.submit();
			  });
		}
		
	 
</script>
	
</body>
</html>