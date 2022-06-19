<%-- <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ include file="../includes/common.jsp"%>

<!DOCTYPE html> 
<html>
<head>
	<meta charset="UTF-8">
	<title>Dokky - 수정하기</title>    
	<link href="/resources/css/modify.css" rel="stylesheet" type="text/css">
</head>  
<body> 

<div class='bigPictureWrapper'> 
  <div class='bigPicture'>
  </div> 
</div>

<div class="modifyWrapper">
		<div class="row">
			<span id="category">
			 	<c:choose>
			       <c:when test="${board.category == 1 }">
			          		공지사항
			       </c:when>
			       <c:when test="${board.category == 2 }">
			       			자유게시판
			       </c:when>
			        <c:when test="${board.category == 3 }">
			     		 	묻고답하기
			       </c:when>
			        <c:when test="${board.category == 4 }">
			   		   	  	칼럼/Tech
			       </c:when>
			       <c:when test="${board.category == 5 }">
			   		   		정기모임/스터디 
			       </c:when>
	            </c:choose>
            </span>  
      	 </div> 
      
      <form role="form" action="/board/modify" method="post"> 
				
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
		  	 <input id="title" class="" placeholder="제목을 입력해 주세요" name='title' oninput="checkLength(this,50);" value='<c:out value="${board.title }"/>'>
		  </div>
		
		  <div class="">
         	 <textarea id="areaContent" name='content'></textarea>
          </div>
	      
		  <div class="row" id="divContent" contenteditable="true" placeholder="내용을 입력해 주세요." oninput="checkLength(this,3500);">${board.content}</div>
		  
		
		  <div class='photoUploadResult'> 
	           <ul>
	           </ul>
	      </div>
		      
	      <div class='fileUploadResult row'> 
	           <ul id="fileUploadResultUl">
	           </ul>
	      </div>
	      
	      <div class="bottomMenuWrap row">  
	          <ul class="bottomMenu">
		          <li class="photo"> 
		          	  <label for="inputPhoto" class="inputButton" >사진</label>  
		          	  <input type="file" id="inputPhoto" name='uploadPhoto' multiple> 
		          </li>
		          <li class="file">  
		         	  <label for="inputFile" class="inputButton" >파일</label>    
			          <input type="file" id="inputFile" name='uploadFile' multiple>
			      </li> 
			        <sec:authentication property="principal" var="userInfo"/>
				 
				 	<sec:authorize access="isAuthenticated()">
				        <c:if test="${userInfo.username eq board.userId}">
				       		 <button type="submit">수정완료</button>
				        </c:if>
			        </sec:authorize> 
		          <li class="submit">
		          	<button type="submit" class="submitButton">등록</button> 
		          </li>
	          </ul>
          </div> 
          
		   <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/> 
		   <input type='hidden' name='userId' value='<c:out value="${board.userId }"/>'>  
		   <input type='hidden' name='board_num' value='<c:out value="${board.board_num }"/>'>
		   <input type='hidden' name='pageNum' value='<c:out value="${cri.pageNum}"/>'>
		   <input type='hidden' name='amount' value='<c:out value="${cri.amount}"/>'>
		   <input type='hidden' name='type' value='<c:out value="${cri.type }"/>'>
		   <input type='hidden' name='keyword' value='<c:out value="${cri.keyword }"/>'>
     
	</form>
</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script> 

	$(document).ready(function(e){ 
		 $("#selectId option[value='${board.category}']").attr('selected','selected');
	});
	
	$(document).ready(function() {
		  (function(){
		    
		    var board_num = '<c:out value="${board.board_num}"/>';
		    
		    $.getJSON("/board/attachList", {board_num: board_num}, function(arr){
		    
			      var fileStr ="";
			      var photoStr ="";
			
			      $(arr).each(function(i, attach){
			          
				          if(attach.fileType){//이미지라면
				        	  
					            var fileCallPath =  encodeURIComponent( attach.uploadPath+ "/s_"+attach.uuid +"_"+attach.fileName);
						            photoStr += "<li id='"+attach.uuid+"' data-path='"+attach.uploadPath+"'";
						            photoStr +=" data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"'"
						            photoStr +" >";                
						            photoStr += "<br><img src='/display?fileName="+fileCallPath+"' data-type='"+attach.image+"' data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"'>";
						            photoStr += "<button type='button' data-uuid='"+attach.uuid+"' data-filecallpath=\'"+fileCallPath+"\' "
						            photoStr += "data-type='image' class='btn btn-warning btn-circle'><span class='css-cancel'></span></button>"; 
						            photoStr +"</li>";    
						            
				          }else{//일반파일이라면
				        	   
				        	    var fileCallPath =  encodeURIComponent( attach.uploadPath+"/"+ attach.uuid +"_"+attach.fileName);			      
				        	    	fileStr += "<li " 
				        	    	fileStr += "data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"' >";
				        	    	fileStr += attach.fileName;  
				        	    	fileStr += "<button type='button' data-uuid='"+attach.uuid+"' data-filecallpath=\'"+fileCallPath+"\' data-type='file' " 
				        	    	fileStr += "class='btn btn-warning btn-circle'><span class='css-cancel'></span></button>";  
				        	    	fileStr +"</li>";  
				          }
			      });
			 		
			      if(photoStr != "" ){
				    	var uploadUL = $(".photoUploadResult ul");
					    $(".photoUploadResult").css("display","block");
					    uploadUL.append(photoStr); 
			      } 
			      
			      if(fileStr != "" ){
				    	var uploadUL = $(".fileUploadResult ul"); 
					    $(".fileUploadResult").css("display","block");
					    uploadUL.append(fileStr);
			      }
			      
		     });//end getjson
	    })();//end function
    });//end document ready function
	

    function checkLength(obj, maxByte) { 
		 
		if(obj.tagName === "INPUT" || obj.tagName === "TEXTAREA"){ 
			var str = obj.value; 
		}else if(obj.tagName === "DIV" ){
			var str = obj.innerHTML; 
		} 
			
		var stringByteLength = 0;
		var reStr;
			
		stringByteLength = (function(s,b,i,c){
			
		    for(b=i=0; c=s.charCodeAt(i++);){
		    
			    b+=c>>11?3:c>>7?2:1;
			    //3은 한글인 경우 한글자당 3바이트를 의미,영어는 1바이트 의미 3을2로바꾸면 한글은 2바이트 영어는 1바이트 의미
			    //현재 나의 오라클 셋팅 같은경우 한글을 한자당 3바이트로 처리
			    if (b > maxByte) { 
			    	break;
			    }
			    
			    reStr = str.substring(0,i);
		    }
		    
		    return b //b는 바이트수 의미
		    
		})(str);
		
		if(obj.tagName === "INPUT" || obj.tagName === "TEXTAREA"){ 
			if (stringByteLength > maxByte) {// 전체길이를 초과하면          
				alert(maxByte + " Byte 이상 입력할 수 없습니다.");         
				obj.value = reStr;       
			}   
		}else if(obj.tagName === "DIV"){
			if (stringByteLength > maxByte) {// 전체길이를 초과하면          
				alert(maxByte + " Byte 이상 입력할 수 없습니다.");         
				obj.innerHTML = reStr;    
			}   
		} 
		
		obj.focus();  
	}
	
	//////////////////////////////////////////////////////////////////////////////
	
    function checkFile(fileName, fileSize){
		    var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
		    var maxSize = 5242880; //5MB
			  
		    if(fileSize >= maxSize){
		      alert("파일 사이즈가 5MB를 초과하였습니다.");
		      return false;
		    }
		    
		    if(regex.test(fileName)){
		      alert("해당 확장자 파일은 업로드할 수 없습니다.");
		      return false;
		    }
		    return true;
    }
	  
	//////////////////////////////////////////////////////////////////////////////

    function checkImage(fileName, fileSize) {
			var maxSize = 5242880; //5MB
			var type = fileName.substring(fileName.lastIndexOf('.')+1, fileName.length);
			
			if (fileSize >= maxSize) {
				alert("파일 사이즈가 5MB를 초과하였습니다.");
				return false; 
			}
			if(type.toUpperCase() == 'JPG' || type.toUpperCase() == 'GIF' || type.toUpperCase() == 'PNG' || type.toUpperCase() == 'BMP'){
				return true; 
			}else{
				alert("해당 확장자 파일은 업로드할 수 없습니다.");
				return false;
			}
			return true;
	 }
	
	//////////////////////////////////////////////////////////////////////////////
	
     function showUploadResult(uploadResultArr, inputName){
		    if(!uploadResultArr || uploadResultArr.length == 0){ 
		    	return; 
		    }
		    
		    var str ="";
		    var divContent = $("#divContent");
		    
		    var contentVal ="";
		  		contentVal = divContent.html();
		    
		    $(uploadResultArr).each(function(i, obj){ 
				if(obj.image){//이미지라면
					var fileCallPath =  encodeURIComponent( obj.uploadPath+ "/s_"+obj.uuid +"_"+obj.fileName);
					str += "<li id='"+obj.uuid+"' data-path='"+obj.uploadPath+"'";
					str +=" data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'"
					str +" >";                
					str += "<br><img src='/display?fileName="+fileCallPath+"' data-type='"+obj.image+"' data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"'>";
					str += "<button type='button' data-uuid='"+obj.uuid+"' data-filecallpath=\'"+fileCallPath+"\' "
					str += "data-type='image' class='btn btn-warning btn-circle'><span class='css-cancel'></span></button>"; 
					str +"</li>";   
					fileCallPath =  encodeURIComponent( obj.uploadPath+"/"+ obj.uuid +"_"+obj.fileName); 
					contentVal += "<img src='/display?fileName="+fileCallPath+"' data-uuid='"+obj.uuid+"' data-filecallpath='"+fileCallPath+"'>";
					divContent.html(contentVal);//본문 삽입  
					
					
				}else{//일반파일이라면
					var fileCallPath =  encodeURIComponent( obj.uploadPath+"/"+ obj.uuid +"_"+obj.fileName);			      
				    //var fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");
					str += "<li " 
					str += "data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"' >";
					str += obj.fileName;  
					str += "<button type='button' data-uuid='"+obj.uuid+"' data-filecallpath=\'"+fileCallPath+"\' data-type='file' " 
					str += "class='btn btn-warning btn-circle'><span class='css-cancel'></span></button>";  
					str +"</li>";   
				}
		    });
		    
		    if(inputName === "uploadPhoto" ){
		    	var uploadUL = $(".photoUploadResult ul");
			    $(".photoUploadResult").css("display","block");//업로드결과 div보이기
			    uploadUL.append(str);
			    
		    }else if(inputName === "uploadFile" ){
		    	var uploadUL = $(".fileUploadResult ul"); 
			    $(".fileUploadResult").css("display","block");
			    uploadUL.append(str);
	        }
	 }
	 
	
		//////////////////////////////////////////////////////////////////////////////

	var csrfHeaderName ="${_csrf.headerName}"; 
	var csrfTokenValue="${_csrf.token}";
		  
    $("input[type='file']").change(function(e){//업로드하기 
			  
		  var formData = new FormData();
		  
		  var inputName = $(this).attr("name");
		  
		  if(inputName === "uploadPhoto"){//사진업로드라면
			  
			  var inputFile = $("input[name='uploadPhoto']");
			  
			  var files = inputFile[0].files;
			  
			  var uploadPhotoLi = $(".photoUploadResult ul li");
			  
		  	  if(uploadPhotoLi.length + files.length > 6){
		  		  alert("사진은 6장을 초과할 수 없습니다.")
		  	      return false;       
		  	  }    
			   
			  for(var i = 0; i < files.length; i++){
			      if(!checkImage(files[i].name, files[i].size) ){
			    	 
			    	inputFile.val("");//사진,파일 input value 값 비워주기
			    	
			        return false; 
			      }
		      	  formData.append("uploadFile", files[i]);
		      }
		   		  formData.append("uploadKind", "photo");
		   		  
		  }else if(inputName === "uploadFile"){//파일업로드라면
			  
			  var inputFile = $("input[name='uploadFile']");
			  
			  var files = inputFile[0].files;
			  
			  var uploadFileLi = $(".fileUploadResult ul li");
			  	
			  if(uploadFileLi.length + files.length > 3){  
		  		  alert("첨부파일은 3개를 초과할 수 없습니다.")
		  	      return false;  
		  	  }
			  
			  for(var i = 0; i < files.length; i++){
			      if(!checkFile(files[i].name, files[i].size) ){
			    	 
			    	inputFile.val(""); 
			    	  
			        return false;
			      }
		     	  formData.append("uploadFile", files[i]);
		      }
		     	  formData.append("uploadKind", "file");
		     	  
		  }  
		  		  inputFile.val("");  
		  
		  $.ajax({
		      url: '/uploadFile',
		      type: 'POST',
		      processData: false, 
		      contentType: false,
		      beforeSend: function(xhr) {
		          xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
		      },
		      data: formData,
		      dataType:'json',
	          success: function(result){ 
				  	   showUploadResult(result,inputName); //업로드 결과 처리 함수 
		      }
	      });
	  });  
		  
	//////////////////////////////////////////////////////////////////////////////
		
	$("#divContent").on("keydown", function(e){ //본문 이미지 제거    + 사진 업로드 보여주기도 제거
		
			if(e.keyCode === 8){ 
				
				e.stopPropagation();
		
				//console.log("backspace"); 
				
				var sel = window.getSelection();
				//console.log(sel);
		
				var range = sel.getRangeAt(0).cloneRange(); 
				//console.log(range); 
		      	range.collapse(true);
		
		     	range.setStart($(this).get(0), 0);
		       
		     	var removeTarget = range.cloneContents().lastChild;
				
		     	if(removeTarget.tagName === 'IMG'){
					if(confirm("이미지를 삭제하시겠습니까?")){ 
						 
						 var removeid = removeTarget.getAttribute('data-uuid');
						 var removeLi = $("#"+removeid);
						  
						 removeLi.remove();
						 
						 if($(".photoUploadResult ul li").length == 0 ){ //업로드결과 li가 0개라면
		        	    	$(".photoUploadResult").css("display","none");//div숨기기
				         }
					}else{
						 e.preventDefault();
				    } 
				} 
	       }
    });
	
	//////////////////////////////////////////////////////////////////////////////
	  
	  $(".photoUploadResult, .fileUploadResult").on("click", "button", function(e){//업로드 가상 삭제
		  
		    if(confirm("삭제하시겠습니까?")){//실제삭제는 아니고 화면상에서만 없애주자,디비에 값이 저장안되게 하는거
		    	
			      var type = $(this).data("type");
			      var uuid = $(this).data("uuid");
			      var imgTags = $('#divContent img');
			      
			      var targetLi = $(this).closest("li");
			      targetLi.remove();
			      
			      
			      if(type == "image"){  
		        	    
		        	   if($(".photoUploadResult ul li").length == 0 ){ //업로드결과 li가 0개라면 div숨기기
			        	    $(".photoUploadResult").css("display","none");
			           }
		        	   
		        	   for(var i = 0; i < imgTags.length; i++) {
			                var obj = imgTags[i];
								                     
				  	 		if( uuid == obj.dataset.uuid){  
				  	 			imgTags[i].remove();  //본문 이미지도 삭제해주기
				  	 		}
			       		}
		        	   
	              }else if(type == "file"){
		        	   if($(".fileUploadResult ul li").length == 0 ){ 
			        	    $(".fileUploadResult").css("display","none");
			           }
	              }
		    }
	  }); 
	  
	//////////////////////////////////////////////////////////////////////////////
	
	  function showImage(fileCallPath){//원본 이미지 파일 보기
  	    
	  	    $(".bigPictureWrapper").css("display","flex").show();
	  	    
	  	    $(".bigPicture").html("<img src='/display?fileName="+fileCallPath+"' >");
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
 	  
	//////////////////////////////////////////////////////////////////////////////
	
	$("button[type='submit']").on("click", function(e){//수정완료 등록
    
		    e.preventDefault();
		
		    var selectedValue = $("#selectId option:selected").val();
		    
			var contentVal = $("#divContent").html();
	    	
	    	$("#areaContent").html(contentVal);
		    
		    if(selectedValue == 0){
		    	alert("게시판을 선택 해주세요."); 
		    	return false;
		    }
		    
		    var title = $("#title").val();
				 title = $.trim(title);
				
			if(title == ""){ 
				alert("제목을 입력하세요."); 
				   return false;
			}
				 
			var content = $("#areaContent").val(); 
			content = $.trim(content);
			 
			if(content == ""){ 
				alert("내용을 입력하세요."); 
				   return false;
			}
		    
		    var str = "";
		    var photoLi = $(".photoUploadResult ul li");
		    var fileLi = $(".fileUploadResult ul li");
		    var UploadLis = $.merge(photoLi, fileLi);   
		     
		    UploadLis.each(function(i, arr){ 
		    		 var jobj = $(arr); 
				      str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
				      str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
				      str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
				      str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+ jobj.data("type")+"'>";
			    });
		    
		    var formObj = $("form[role='form']"); 
		    
		    formObj.append(str).submit(); 
    });
	
</script>

</body>
</html> --%>