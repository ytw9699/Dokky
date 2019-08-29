<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>계정관리 검색</title>
<style>
.searchWrapper {
	width: 12%;
    margin-top: 20px;
    margin-left: 1%;
    display: inline-block;
}
</style>
</head>
	<body>
		<div class="searchWrapper"> 
			<form id='searchForm' action="/dokky/admin/userList" method='get'>
				<select name='type'>
					<option value="I"
						<c:out value="${pageMaker.cri.type eq 'I'?'selected':''}"/>>아이디</option>
					<option value="N"
						<c:out value="${pageMaker.cri.type eq 'N'?'selected':''}"/>>닉네임</option>
					<option value="IN"
						<c:out value="${pageMaker.cri.type eq 'IN'?'selected':''}"/>>아이디+닉네임</option>
				</select> 
							
				<input type='text'   name='keyword' value='<c:out value="${pageMaker.cri.keyword}"/>' /> 
				<input type='hidden' name='pageNum' value='<c:out value="${pageMaker.cri.pageNum}"/>' /> 
				<input type='hidden' name='amount'  value='<c:out value="${pageMaker.cri.amount}"/>' />
						
				<button class='btn btn-default'>검색</button>
			</form>
		</div>
	</body>
</html>


		
