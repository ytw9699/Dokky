<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %> 

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>메인</title>
<style>
	    @media screen and (max-width:500px){ 
	           .bodyWrap {
				    width: 50%;
				    display: inline-block; 
				    margin-left: 29%;
				    margin-top: 1%;
				    min-height: 500px;
				    border-color: #e6e6e6;
				    border-style: solid;
				    background-color: #323639;
				    color: #e6e6e6;
				}
        }
        @media screen and (min-width: 501px) and (max-width:1500px){
          	.bodyWrap {
			    width: 80%;
			    display: inline-block;
			    margin-left: 15%;
			    margin-top: 1%;
			    min-height: 500px;
			    border-color: #e6e6e6;
			    border-style: solid;
			    background-color: #323639;
			    color: #e6e6e6;
			}
        }
        @media screen and (min-width: 1501px){    
            .bodyWrap {
			    width: 51%;
			    display: inline-block; 
			    margin-left: 29%;
			    margin-top: 1%;
			    min-height: 500px;
			    border-color: #e6e6e6;
			    border-style: solid;
			    background-color: #323639;
			    color: #e6e6e6;
			}
        }
            
	a  {    
			color:#e6e6e6;
			text-decoration: none;
		}
	a:hover {   
	     color: #7151fc;
	    text-decoration: underline;
	}
	body{
		background-color: #323639;   
		}
	
	.mainLists {
	    border-color: #e6e6e6;
	    border-style: solid;
	    margin-left: 1%;
	    margin-top: 1%;
	    width: 98%;
	}
	.replyCnt{  
	  color: #ff2f3b;  
	}
	
</style>
</head>

<%@include file="includes/left.jsp"%>

<body>
	<div class="bodyWrap">	 
		<div class="mainLists"> 
			실시간 게시글
			<table class=""> 
				<c:forEach items="${realtimeList}" var="board">
					<tr>
						<td>  
							<a class='move' href='/dokky/board/get?num=<c:out value="${board.num}"/>'> 
							<c:out value="${board.title}" /></a>
							<a class="replyCnt">[<c:out value="${board.replyCnt}" />]</a>
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
							<a href="/dokky/userBoardList?userId=${board.userId}"> 
								<img width="25px" src="/dokky/resources/img/profile_img/<c:out value="${board.userId}" />" class="memberImage" onerror="this.src='/dokky/resources/img/basicProfile.png'" />
								<c:out value="${board.nickName}" />
							</a> 
						</td>
						<td>
							<fmt:formatDate value="${board.regDate}" pattern="yyyy년 MM월 dd일 HH:mm" />
						</td> 
					</tr>
				</c:forEach>
			</table>
		</div>
		 
		<div class="mainLists">  
			monthly 인기글
			<table class=""> 
				<c:forEach items="${monthlyList}" var="board">
					<tr>
						<td>  
							<a class='move' href='/dokky/board/get?num=<c:out value="${board.num}"/>'> 
							<c:out value="${board.title}" /></a>
							<a class="replyCnt">[<c:out value="${board.replyCnt}" />]</a>
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
							<a href="/dokky/userBoardList?userId=${board.userId}"> 
								<img width="25px" src="/dokky/resources/img/profile_img/<c:out value="${board.userId}" />" class="memberImage" onerror="this.src='/dokky/resources/img/basicProfile.png'" />
								<c:out value="${board.nickName}" />
							</a> 
						</td>
						<td>
							<fmt:formatDate value="${board.regDate}" pattern="yyyy년 MM월 dd일 HH:mm" />
						</td> 
					</tr>
				</c:forEach>
			</table>
		</div>
		
		<div class="mainLists"> 
			monthly 최다 기부글
			<table class="">
				<c:forEach items="${donationList}" var="board">
					<tr>
						<td>  
							<a class='move' href='/dokky/board/get?num=<c:out value="${board.num}"/>'> 
							<c:out value="${board.title}" /></a>
							<a class="replyCnt">[<c:out value="${board.replyCnt}" />]</a>
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
							<a href="/dokky/userBoardList?userId=${board.userId}"> 
								<img width="25px" src="/dokky/resources/img/profile_img/<c:out value="${board.userId}" />" class="memberImage" onerror="this.src='/dokky/resources/img/basicProfile.png'" />
								<c:out value="${board.nickName}" />
							</a> 
						</td>
						<td>
							<fmt:formatDate value="${board.regDate}" pattern="yyyy년 MM월 dd일 HH:mm" />
						</td> 
					</tr>
				</c:forEach>
			</table>
		</div>
		
		
	</div>
	
</body>

</html>