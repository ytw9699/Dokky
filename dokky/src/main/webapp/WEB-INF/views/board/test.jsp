<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ include file="../includes/left.jsp"%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="//code.jquery.com/jquery-1.11.3.min.js"></script>
	<title>Dokky - test</title>  
</head>
<body> 

<div class="registerWrapper"> 
		  <input type="file" id="inputPhoto" name='uploadPhoto' multiple> 
		  <input type="file" id="inputPhoto" name='uploadFile' multiple>
		  <a href="https://s3.ap-northeast-2.amazonaws.com/picksell-bucket/upload/2019/10/06/dokky.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20191006T143655Z&X-Amz-SignedHeaders=host&X-Amz-Expires=900&X-Amz-Credential=AKIA47S6HNIPMDWY3OGR%2F20191006%2Fap-northeast-2%2Fs3%2Faws4_request&X-Amz-Signature=c56c14ff384418b217659f9d1a50417cc5567c409c27dcf6c2edc89ae1257073">
		  dddcdddddddddddddddddddddddddd</a>
		  <img src="https://s3.ap-northeast-2.amazonaws.com/picksell-bucket/upload/2019/10/06/dokky.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20191006T143655Z&X-Amz-SignedHeaders=host&X-Amz-Expires=900&X-Amz-Credential=AKIA47S6HNIPMDWY3OGR%2F20191006%2Fap-northeast-2%2Fs3%2Faws4_request&X-Amz-Signature=c56c14ff384418b217659f9d1a50417cc5567c409c27dcf6c2edc89ae1257073"
 alt="카카오 라이언" width="100" height="50" align="center" border="0">
</div>
 
<script> 
		
var csrfHeaderName ="${_csrf.headerName}"; 
var csrfTokenValue="${_csrf.token}"; 

$("input[type='file']").change(function(e){//업로드하기 
	  
	  var formData = new FormData();
	  
	  var inputName = $(this).attr("name");
	  
		  if(inputName === "uploadPhoto"){//사진업로드라면
			  
			  var inputFile = $("input[name='uploadPhoto']");
			  
			  var files = inputFile[0].files;
			  
			  for(var i = 0; i < files.length; i++){
			    	
		      	  formData.append("uploadFile", files[i]);
		      }
		   		  formData.append("uploadKind", "photo");
		   		  
		  }else if(inputName === "uploadFile"){//파일업로드라면
			  
			  var inputFile = $("input[name='uploadFile']");
			  
			  var files = inputFile[0].files;
			  
			  for(var i = 0; i < files.length; i++){
		     	  formData.append("uploadFile", files[i]);
		      }
		     	  formData.append("uploadKind", "file");
		  }  
		  		  
		  inputFile.val("");  
		  
		  $.ajax({
		      url: '/dokky/s3uploadFile',
		      type: 'POST',
		      processData: false, 
		      contentType: false,
		      beforeSend: function(xhr) {
		          xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
		      },
		      data: formData,
		      dataType:'json',
	          success: function(result){ 
				  	   alert(result);  
		      }
	    });
	});  
	
</script>
</body>
</html>