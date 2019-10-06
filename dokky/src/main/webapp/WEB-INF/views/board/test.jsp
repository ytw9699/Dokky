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