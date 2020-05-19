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
		<!-- <script type="text/javascript" src="/resources/SmartEditor/js/HuskyEZCreator.js" charset="utf-8" ></script> -->
		<title>Dokky - 새 글쓰기</title>  
		<link href="/ROOT/resources/css/register.css" rel="stylesheet" type="text/css">
	</head>
<body> 

<div class='bigPictureWrapper'>
  <div class='bigPicture'>
  </div>
</div>
<div id="profileGray"></div> 

<div class="registerWrapper"> 
	              <div class="row">
			     	 	<span id="category">새 글쓰기</span>   
			      </div> 
			  
	          <form role="form" action="/board/register" method="post">
			      <div class="row">
					<select id="selectId" name="category" class="">
						   <option value=0>게시판을 선택해 주세요.</option>
							   <sec:authorize access="hasAnyRole('ROLE_ADMIN','ROLE_SUPER')">
		   		 					<option value=1>공지사항</option>
			   		 		   </sec:authorize>
	                       <option value=2>자유게시판</option>
	                       <option value=3>묻고답하기</option> 
	                       <option value=4>칼럼/Tech</option>
	                       <option value=5>정기모임/스터디</option>
				     </select>
				  </div>
				 
		          <div class="row">
		            <input id="title" placeholder="제목을 입력해 주세요." name='title' oninput="checkLength(this,40);" autofocus/>   
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
		
	$(document).ready(function(e){
		 $("#selectId option[value='${category}']").attr('selected','selected');
		
		/* 스마트 에디터 */
		/* var oEditors = [];
		
		nhn.husky.EZCreator.createInIFrame({  
		 oAppRef: oEditors, // 전역변수 명과 동일해야 함
		 elPlaceHolder: "ir1",// 에디터가 그려질 textarea ID 값과 동일 해야 함
		 sSkinURI: "/resources/SmartEditor/SmartEditor2Skin.html",
		 fCreator: "createSEditor2", // SE2BasicCreator.js 메소드명이니 변경 금지
		 htParams : {
	        bUseToolbar : true,        // 툴바 사용 여부 (true:사용/ false:사용하지 않음)
	        bUseVerticalResizer : true,// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
	        bUseModeChanger : true // 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
	      }
		}); */
		/* 스마트 에디터 */ 
	});
	
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
		    
			    b+=c>>11?2:c>>7?2:1;
			    //3은 한글인 경우 한글자당 3바이트를 의미,영어는 1바이트 의미 
			    //3을2로바꾸면 한글은 2바이트 영어는 1바이트 의미
			    //현재 나의 오라클 셋팅 같은경우 한글을 한자당 3바이트로 처리
			    //3에서 2로 바꿈
			    if (b > maxByte) { 
			    	break;
			    }
			    
			    reStr = str.substring(0,i);
		    }
		    
		    return b //b는 바이트수 의미
		    
		})(str);
		
		if(obj.tagName === "INPUT" || obj.tagName === "TEXTAREA"){ 
			if (stringByteLength > maxByte) {// 전체길이를 초과하면          
				openAlert(maxByte + " Byte 이상 입력할 수 없습니다");         
				obj.value = reStr;       
			}   
		}else if(obj.tagName === "DIV"){
			if (stringByteLength > maxByte) {// 전체길이를 초과하면          
				openAlert(maxByte + " Byte 이상 입력할 수 없습니다");         
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
		      openAlert("파일 사이즈가 5MB를 초과하였습니다");
		      return false;
		    }
		    
		    if(regex.test(fileName)){
		      openAlert("해당 확장자 파일은 업로드할 수 없습니다");
		      return false;
		    }
		    return true;
	  }
	
	//////////////////////////////////////////////////////////////////////////////

	  function checkImage(fileName, fileSize) {
			var maxSize = 5242880; //5MB
			var type = fileName.substring(fileName.lastIndexOf('.')+1, fileName.length);
			
			if (fileSize >= maxSize) {
				openAlert("파일 사이즈가 5MB를 초과하였습니다");
				return false; 
			}
			if(type.toUpperCase() == 'JPG' || type.toUpperCase() == 'GIF' || type.toUpperCase() == 'PNG' || type.toUpperCase() == 'BMP'){
				return true; 
			}else{
				openAlert("해당 확장자 파일은 업로드할 수 없습니다");
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
	    var divContent = $("#divContent");//본문 내용
	    
	    var contentVal ="";
	  		contentVal = divContent.html();
	    
	    $(uploadResultArr).each(function(i, obj){ 
	    	
			if(obj.image){//이미지라면 1 true
				
				str += "<li id='"+obj.uuid+"' data-path='"+obj.uploadPath+"'";
				str +=" data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'"
				str +" >";            
				str += "<br><img src='/displayS3?path="+obj.uploadPath+"&filename=s_"+obj.uuid+"_"+obj.fileName+"' data-path='"+obj.uploadPath+"' data-filename='"+obj.uuid+"_"+obj.fileName+"'>";
				str += "<button type='button' data-uuid='"+obj.uuid+"' data-filename='"+obj.uuid+"_"+obj.fileName+"' data-path='"+obj.uploadPath+"'"
				str += "data-type='image' class='btn btn-warning btn-circle'><span class='css-cancel'></span></button>"; 
				str +"</li>";
				
				contentVal += "<img src='/displayS3?path="+obj.uploadPath+"&filename=s_"+obj.uuid+"_"+obj.fileName+"' data-type='image' data-uuid='"+obj.uuid+"' data-path='"+obj.uploadPath+"' data-filename='"+obj.uuid+"_"+obj.fileName+"'>";
				divContent.html(contentVal);//본문 삽입  
				
			}else{//일반파일이라면
				
				str += "<li " 
				str += "data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"' >";
				str += obj.fileName;  
				str += "<button type='button' data-uuid='"+obj.uuid+"' data-filename='"+obj.uuid+"_"+obj.fileName+"' data-path='"+obj.uploadPath+"'"
				str += "data-type='file' class='btn btn-warning btn-circle'><span class='css-cancel'></span></button>";   
				str +"</li>";   
			}
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
	    
	}//end showUploadResult 함수
	
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
		  		  openAlert("사진은 6장을 초과할 수 없습니다")
		  	      return false;       
		  	  }    
			   
			  for(var i = 0; i < files.length; i++){
				  
			      if(!checkImage(files[i].name, files[i].size) ){
			    	 
			    	inputFile.val("");//사진 input value 값 비워주기
			    	
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
		  		  openAlert("첨부파일은 3개를 초과할 수 없습니다")
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
			      url: '/s3upload',
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
	  
	//////////////////////////////////////////////////////////////////////////////

	$("#divContent").on("keydown", function(e){ //본문 이미지 제거시     + 사진 업로드 보여주기도 제거 
		
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
						  
						 removeLi.remove();//photoUploadResult ul li의 이미지도 삭제한다
						 
						 var path = removeTarget.getAttribute('data-path');
						 var filename = removeTarget.getAttribute('data-filename');
						 var type = removeTarget.getAttribute('data-type');
						 
						 $.ajax({
						      url: '/deleteS3File',
						      type: 'POST',
						      dataType:'text',
						      data: {	
							    	  	path		: path,
							    	  	filename	: filename,
					    	  		    type		: type
						    	  	},
						      beforeSend: function(xhr) {
						          xhr.setRequestHeader(csrfHeaderName, csrfTokenValue); 
						      },
						      
					          success: function(result){
					      	    		
					        	  if(result === "deleted"){
						              if(type == "image"){
							        	    
							        	   if($(".photoUploadResult ul li").length == 0 ){ //사진 업로드결과 li가 0개라면 div숨기기
								        	    $(".photoUploadResult").css("display","none");
								           }
							          }
					        	  }
					          } 
					     });//$.ajax
					    
					}else{
						 e.preventDefault();
				    } 
				} 
		    }
    });

	//////////////////////////////////////////////////////////////////////////////
	
	$(".photoUploadResult, .fileUploadResult").on("click", "button", function(e){//업로드 삭제    
	  	
		if(confirm("삭제하시겠습니까?")){
		
			var imgObj = $(this);
			var path = imgObj.data("path"); 
		 	var filename = imgObj.data("filename");
		    var type = imgObj.data("type");
		    var uuid = imgObj.data("uuid");
		    var targetLi = imgObj.closest("li");
		    var imgTags = $('#divContent img');
		    
		    $.ajax({
			      url: '/deleteS3File',
			      type: 'POST',
			      dataType:'text',
			      data: {	
				    	  	path		: path,
				    	  	filename	: filename,
		    	  		    type		: type
			    	  	},
			      beforeSend: function(xhr) {
			          xhr.setRequestHeader(csrfHeaderName, csrfTokenValue); 
			      },
			      
		          success: function(result){
		      	    		
		        	  if(result === "deleted"){
		        		  
		        		  targetLi.remove();//프론트 업로드결과의 사진 or 파일 삭제
				           
			              if(type == "image"){
				        	    
				        	   if($(".photoUploadResult ul li").length == 0 ){ //사진 업로드결과 li가 0개라면 div숨기기
					        	    $(".photoUploadResult").css("display","none");
					           }
				        	   
				        	   for(var i = 0; i < imgTags.length; i++) {
					                var obj = imgTags[i];
										                     
						  	 		if( uuid == obj.dataset.uuid){  
						  	 			imgTags[i].remove();//본문 이미지도 삭제해주기
						  	 		}
					       		}
				        	   
				          }else if(type == "file"){//파일 업로드결과 li가 0개라면 div숨기기
				        	   if($(".fileUploadResult ul li").length == 0 ){ 
					        	    $(".fileUploadResult").css("display","none");
					           }
				          }
		        	  }
		          } 
		    });//$.ajax
	    
		}
   });

	////////////////////////////////////////////////////////////////////////////// 
	
    function showImage(path, filename){//원본 이미지 파일 보기
    	    
			$(".bigPictureWrapper").css("display","flex").show(); 
    	    
    	    $(".bigPicture").html("<img src='/displayS3?path="+path+"&filename="+filename+"'>");
    	    
    	    $("#profileGray").css("display","block");
    }
		
    $(".bigPictureWrapper").on("click", function(e){//원본 이미지 파일 숨기기 
  		  
			$('.bigPictureWrapper').hide();
  
			$("#profileGray").hide();
    });
	  
    $(".photoUploadResult, #divContent").on("click","img", function(e){//이미지를 클릭한다면
   	      
    	    var imgObj = $(this);    
    	    var path = imgObj.data("path"); 
  		 	var filename = imgObj.data("filename");
    	    
   	    	showImage(path, filename);
	});
	  
	//////////////////////////////////////////////////////////////////////////////

	$("button[type='submit']").on("click", function(e){//글쓰기 등록
    
		    e.preventDefault();
		
		    var selectedValue = $("#selectId option:selected").val();
		    
			var contentVal = $("#divContent").html();
	    	
	    	$("#areaContent").html(contentVal);
		    
		    if(selectedValue == 0){
		    	openAlert("게시판을 선택 해주세요"); 
		    	return false;
		    }
		    
		    var title = $("#title").val();
				 title = $.trim(title);//공백제거
				
			if(title == ""){ 
				openAlert("제목을 입력하세요"); 
				   return false;
			}
				 
			var content = $("#areaContent").val();
			content = $.trim(content);
			
			if(content == ""){ 
				openAlert("내용을 입력하세요"); 
				   return false;
			}
		    
		    //oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);// 스마트 에디터 - textarea에 값 옮겨주기
		    
		    var str = "";
		    var photoLi = $(".photoUploadResult ul li");
		    var fileLi = $(".fileUploadResult ul li");
		    var UploadLis = $.merge(photoLi, fileLi);   
		     
		    UploadLis.each(function(i, arr){ 
		    		 var jobj = $(arr); 
				     /*  console.dir(jobj);
				      console.log("-------------------------"); 
				      console.log(jobj.data("filename")); */
				      str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
				      str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
				      str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
				      str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+ jobj.data("type")+"'>";
				      
			    });
		     
		    //console.log(str);
		    
		    var formObj = $("form[role='form']"); 
		    
		    formObj.append(str).submit();
    });
	
</script>
</body>
</html>