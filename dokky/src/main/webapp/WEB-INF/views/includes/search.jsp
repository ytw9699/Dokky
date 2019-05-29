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
			<form action="/dokky/mainSearchList" name="memberSearchForm" method="GET" onsubmit="">
				<input type="text" name="searchKey" placeholder="검색어 입력" class="searchINPUT" />
				<input type="submit" value="검색" class="searchSUBMIT" />
			</form>
		</div>
	</body>
</html>
