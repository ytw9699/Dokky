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
	<link href="/dokky/resources/css/register.css" rel="stylesheet" type="text/css"> 
</head>
<body> 

<a href="https://picksell-bucket.s3.ap-northeast-2.amazonaws.com/upload/2019/10/08/0a38de9a-5d3a-463b-8319-377c821de9d9_dokky.png" download="newFileName.png">다운로드</a>
  
  <a href="/dokky/download2?fileName=dokky.png">s3다운로드</a>  
  <img src="/dokky/display2?folder_name=upload/2019/10/15&fileName=dokky.png" />
  
<div class='bigPictureWrapper'>
  <div class='bigPicture'>
  </div>
</div>

<div class="registerWrapper"> 
	              <div class="row">
			     	 	<span id="category">새 글쓰기</span>   
			      </div> 
			  
	          <form role="form" action="/dokky/board/register" method="post">
			      <div class="row">
					<select id="selectId" name="category" class="">
						   <option value=0>게시판을 선택해 주세요.</option>
	                       <option value=1>공지사항</option>
	                       <option value=2>자유게시판</option>
	                       <option value=3>묻고답하기</option> 
	                       <option value=4>칼럼/Tech</option>
	                       <option value=5>정기모임/스터디</option>
				     </select>
				  </div>
				 
		          <div class="row">
		            <input id="title" placeholder="제목을 입력해 주세요." name='title' oninput="checkLength(this,50);" autofocus/>   
		          </div>
		          
		          <div>
		          	<textarea id="areaContent" name='content'></textarea>
		          </div>
		               
				  <div class="row" id="divContent" contenteditable="true" placeholder="내용을 입력해 주세요." oninput="checkLength(this,3500);"></div>    
				  
		          <div class='photoUploadResult row'> 
			          <ul>
			          </ul>
			      </div>  
			      
			      <div class='fileUploadResult row'> <!-- 첨부파일 --> 
			          <ul id="fileUploadResultUl">
			          </ul>
			      </div>
			      
		          <div class="bottomMenuWrap row">  
			          <ul class="bottomMenu">
				          <li class="photo"> 
				          	  <label for="inputPhoto" class="inputButton">사진</label>  
				          	  <input type="file" id="inputPhoto" name='uploadPhoto' multiple> 
				          </li>
				          <li class="file">  
				         	  <label for="inputFile" class="inputButton">파일</label>    
					          <input type="file" id="inputFile" name='uploadFile' multiple>
					      </li> 
				          <li class="submit"> 
				          	<button type="submit" class="submitButton">등록</button>    
				          </li>
			          </ul> 
		          </div>
		          
		          <input type='hidden' name='nickName' value='<sec:authentication property="principal.member.nickName"/>' /> 
		          <input type='hidden' name='userId' value='<sec:authentication property="principal.username"/>' /> 
				  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
	        </form>
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
	        	  	showUploadResult(result, inputName); 
		      }
	    });
	});  
	
	
	function showUploadResult(uploadResultArr, inputName){
	    if(!uploadResultArr || uploadResultArr.length == 0){ 
	    	return; 
	    }
	    
	    var str ="";
	    var divContent = $("#divContent");//본문 내용
	    
	    var contentVal ="";
	  		contentVal = divContent.html(); 
	    
	    $(uploadResultArr).each(function(i, obj){  
				 
				str += "<a href='"+obj.downUrl+"' download='newfilename'><li><img src='/dokky/display2?folder_name="+obj.uploadPath+"&fileName="+obj.uuid+"_"+obj.fileName+"' width='50' height='50'>";
				str +"</li></a>";                    
									 
				contentVal += "<img src='/dokky/display2?folder_name="+obj.uploadPath+"&fileName="+obj.uuid+"_"+obj.fileName+"' width='50' height='50'>";
				divContent.html(contentVal);//본문 삽입     
	    }); 
	    
	    if(inputName === "uploadPhoto" ){
	    	
	    	var uploadUL = $(".photoUploadResult ul");
		    	uploadUL.append(str); 
		    	
		    $(".photoUploadResult").css("display","block");//업로드결과 div보이기
		    
	    }else if(inputName === "uploadFile" ){
	    	
	    	var uploadUL = $(".fileUploadResult ul"); 
			    uploadUL.append(str);
			    
		    $(".fileUploadResult").css("display","block");
	    }
	}
	
   function showImage(fileCallPath){//원본 이미지 파일 보기
	    
	    $(".bigPictureWrapper").css("display","flex").show();
	    
	    $(".bigPicture").html("<img src='"+fileCallPath+"'>");
   }

  $(".photoUploadResult").on("click","img", function(e){//아래 포토리스트에서 사진을 클릭한다면
	      
	    var liObj = $(this);    
	    
	    var path = encodeURIComponent(liObj.data("path")+"/" + liObj.data("uuid")+"_" + liObj.data("filename"));
	    
	    if(liObj.data("type")){      
	      showImage(path);//원본 이미지 파일 보기
	    } 
	  });
  
  $("#divContent").on("click","img", function(e){//본문에서 사진을 클릭한다면
  	
	  var imgObj = $(this);
  
	  var path = imgObj.data("filecallpath"); 
	  
	  showImage(path);  
  });
  
  
  $(".bigPictureWrapper").on("click", function(e){//원본 이미지 파일 숨기기 
	  
		$('.bigPictureWrapper').hide();
  });


</script>
</body>
</html>