<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %> 

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Dokky</title>
<style>
		@media screen and (max-width:500px){ 
			.myscrapWrap { 
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
	        .myscrapWrap {
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
          .myscrapWrap { 
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
	.listWrapper { 
	    border-color: #e6e6e6;/* 흰색 */
		border-style: solid;   
		background-color: #323639; 
		color: #e6e6e6;
		margin-left: 1%;
		margin-top: 1%; 
	}
	.boardTitle a { 
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
	a:hover {   
	    color: #7151fc;
	    text-decoration: underline;
	}  
	a  {    
			color:#e6e6e6; text-decoration: none;
		} 
	.replyCnt{   
	  color: #ff2f3b;  
	}
</style> 
</head>
<%@include file="../includes/left.jsp"%>
<body>
<sec:authentication property="principal" var="userInfo"/>
<div class="myscrapWrap">	
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
	<div class="listWrapper">
		<div class="">
			<table class="">  
				<c:forEach items="${myScraplist}" var="scrap"> 
					<tr>
						<td>
						<input type="checkbox" name="checkRow" value="${scrap.scrap_num}" />
                    </td>
						<td class="boardTitle">
							<a class='move' href='<c:out value="${scrap.num}"/>'>  
								<c:out value="${scrap.title}" />
								<span class="replyCnt">[<c:out value="${scrap.replyCnt}" />]</span>
							</a>
						</td>  
						<td>
							<img width="20px" src="/dokky/resources/img/read.png"/>
							<c:out value="${scrap.hitCnt}" />
						</td>
						<td> 
							<a href="#" class="userMenu" data-scrap_num="${scrap.scrap_num}">
								<img width="25px" src="/dokky/resources/img/profile_img/<c:out value="${scrap.userId}" />" class="memberImage hideUsermenu" onerror="this.src='/dokky/resources/img/basicProfile.png'" />
								<c:out value="${scrap.nickName}" /> 
							</a>   
							 <div id="userMenubar_${scrap.scrap_num}" class="userMenubar">
								<ul class="hideUsermenu"> 
									<li class="hideUsermenu"><a href="/dokky/userBoardList?userId=${scrap.userId}" class="hideUsermenu"><span class="hideUsermenu">게시글보기</span></a></li>
									<li class="hideUsermenu"><a href="#" class="hideUsermenu"><span class="hideUsermenu">쪽지보내기</span></a></li>
								</ul>      
						     </div> 
						</td>
						<td>
							<fmt:formatDate value="${scrap.regDate}" pattern="yyyy년 MM월 dd일 HH:mm" />
						</td>
					</tr>
				</c:forEach>
					<tr>
				        <td><input type="checkbox" name="checkAll" id="checkAll" onclick="checkAll();"/>전체선택</td>
				        <td><button id='deleteBtn' type="button" class="">삭제</button></td>
				         <td>총 스크랩수 ${total}개 </td> 
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
	<form id='actionForm' action="/dokky/mypage/myScraplist" method='get'>  
		<input type='hidden' name='pageNum' value='${pageMaker.cri.pageNum}'><!--  $(this).attr("href") -->
		<input type='hidden' name='amount' value='${pageMaker.cri.amount}'>
		<input type='hidden' name='userId' value='${pageMaker.cri.userId}'>
	</form> 
		</div>
	</div>
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
		
			actionForm.append("<input type='hidden' name='num' value='"+ $(this).attr("href")+ "'>");
			actionForm.attr("action","/dokky/board/get");
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
			   	 alert("삭제할 스크랩을 선택하세요.");
			    return false;
			  }
			   
			  if(confirm("정말 삭제 하시겠습니까?")){
				  actionForm.attr("action","/dokky/mypage/removeAllScrap").attr("method","post");
				  actionForm.append("<input type='hidden' name='checkRow' value='"+checkRow+"'>");
				  actionForm.append("<input type='hidden' id='csrf' name='${_csrf.parameterName}' value='${_csrf.token}'/>");
				  actionForm.submit();
			  }
		}
		
	 
</script>
	
</body>
</html>