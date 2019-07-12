<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %> 
<!DOCTYPE html>
<html>
<head>
<title>dokky로그아웃</title>  
	<meta charset="utf-8">
</head> 
<body>  
	<div class="container"> 
		<form role="form" method='post' action="/dokky/customLogout">
				<a href="" class="btn-success">Logout</a>
			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
		</form>
	</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	<script>
		$(".btn-success").on("click", function(e){
			e.preventDefault();
			$("form").submit();
		});
	</script>   
</body>

</html>