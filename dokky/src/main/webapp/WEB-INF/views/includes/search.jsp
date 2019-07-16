<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Dokky-검색</title>
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
			<form id='searchForm' action="/dokky/board/list" method='get'>
				<select name='type'>
					<option value="TC"
						<c:out value="${pageMaker.cri.type == null || pageMaker.cri.type eq 'TC'?'selected':''}"/>>제목+내용</option>
					<option value="T"
						<c:out value="${pageMaker.cri.type eq 'T'?'selected':''}"/>>제목</option>
					<option value="C"
						<c:out value="${pageMaker.cri.type eq 'C'?'selected':''}"/>>내용</option>
					<%-- <option value="TC"
						<c:out value="${pageMaker.cri.type eq 'TC'?'selected':''}"/>>제목+내용</option> --%>
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
						
				<button class='btn btn-default'>검색</button>
			</form>
		</div>
		<script>
			var searchForm = $("#searchForm");   
		
			$(".btn-default").on("click", function(e) { 
			
							e.preventDefault();
							
							var category = '${pageMaker.cri.category}';//전체보기
							
							if(category == 0){ //전체보기	
								searchForm.attr("action","/dokky/board/allList");//전체보기
							}
							searchForm.submit(); 
						});
		</script>	
	</body>
</html>


		
