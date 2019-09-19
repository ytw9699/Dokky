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
	<!-- <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script> -->
	<!-- <script type="text/javascript" src="/dokky/resources/SmartEditor/js/HuskyEZCreator.js" charset="utf-8" ></script> -->
	<title>Dokky - 새 글쓰기</title>  
	<link href="/dokky/resources/css/register.css" rel="stylesheet" type="text/css">
</head>
<body> 

<div class='bigPictureWrapper'>
  <div class='bigPicture'>
  </div>
</div>

<div class="registerWrapper">
          <div class="formWrapper">
	           <div class="row">
			     <h1>새 글쓰기</h1>   
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
		            <input id="title" class="" placeholder="제목을 입력해 주세요." name='title' oninput="checkLength(this,30);"/> 
		          </div>
		          
		          <div class="">
		          	<textarea id="areaContent" name='content'></textarea>
		          </div>
		              
				  <div class="row" id="divContent" contenteditable="true" placeholder="내용을 입력해 주세요." oninput="checkLength(this,1300);"></div>    
				  
		          <div class='photoUploadResult'> 
			          <ul>
			          </ul>
			      </div>
			      
			      <div class='fileUploadResult'> 
			      	첨부파일
			          <ul>
			          </ul>
			      </div>
			      
		          <div class="bottomMenuWrap">  
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
				          	<button type="submit" class="btn btn-default">등록</button> 
				          </li>
			          </ul> 
		          </div>
		          
		          <input type='hidden' name='nickName' value='<sec:authentication property="principal.member.nickName"/>' /> 
		          <input type='hidden' name='userId' value='<sec:authentication property="principal.username"/>' /> 
				  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
	        </form>
       </div>
</div>

<script> 
		
	$(document).ready(function(e){
		 $("#selectId option[value='${category}']").attr('selected','selected');
		
		/* 스마트 에디터 */
		/* var oEditors = [];
		
		nhn.husky.EZCreator.createInIFrame({  
		 oAppRef: oEditors, // 전역변수 명과 동일해야 함
		 elPlaceHolder: "ir1",// 에디터가 그려질 textarea ID 값과 동일 해야 함
		 sSkinURI: "/dokky/resources/SmartEditor/SmartEditor2Skin.html",
		 fCreator: "createSEditor2", // SE2BasicCreator.js 메소드명이니 변경 금지
		 htParams : {
	        bUseToolbar : true,        // 툴바 사용 여부 (true:사용/ false:사용하지 않음)
	        bUseVerticalResizer : true,// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
	        bUseModeChanger : true // 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
	      }
		}); */
		/* 스마트 에디터 */ 
	});

	function checkLength(obj, maxlength) {  

			if(obj.tagName === "INPUT"){ 
				var str = obj.value; 
			}else if(obj.tagName === "DIV"){
				var str = obj.innerHTML; 
			}
			// 이벤트가 일어난 컨트롤의 value 값    
			var str_length = str.length; // 전체길이       // 변수초기화     
			var max_length = maxlength; // 제한할 글자수 크기     
			var i = 0; // for문에 사용     
			var ko_byte = 0; // 한글일경우는, 2그밗에는 1을 더함     
			var li_len = 0; // substring하기 위해서 사용     
			var one_char = ""; // 한글자씩 검사한다     
			var reStr = ""; // 글자수를 초과하면 제한할수 글자전까지만 보여준다.  
			
			for (i = 0; i < str_length; i++) { // 한글자추출         
				one_char = str.charAt(i);            
				ko_byte++;        
			}     
			
			if (ko_byte <= max_length) {// 전체 크기가 max_length를 넘지않으면                
				li_len = i + 1;         
			}  
			
			if(obj.tagName === "INPUT"){ 
				if (ko_byte > max_length) {// 전체길이를 초과하면          
					alert(max_length + " 글자 이상 입력할 수 없습니다.");         
					reStr = str.substr(0, max_length);         
					obj.value = reStr;      
				}   
			}else if(obj.tagName === "DIV"){
				if (ko_byte > max_length) {// 전체길이를 초과하면          
					alert(max_length + " 글자 이상 입력할 수 없습니다.");         
					reStr = str.substr(0, max_length);         
					obj.innerHTML=reStr;    
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
				str += "<br><img src='/dokky/display?fileName="+fileCallPath+"' data-type='"+obj.image+"' data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"'>";
				str += "<button type='button' data-uuid='"+obj.uuid+"' data-filecallpath=\'"+fileCallPath+"\' "
				str += "data-type='image' class='btn btn-warning btn-circle'><span class='css-cancel'></span></button>"; 
				str +"</li>";   
				fileCallPath =  encodeURIComponent( obj.uploadPath+"/"+ obj.uuid +"_"+obj.fileName); 
				contentVal += "<img src='/dokky/display?fileName="+fileCallPath+"' data-uuid='"+obj.uuid+"' data-filecallpath='"+fileCallPath+"'>";
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
		      url: '/dokky/uploadFile',
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

	$("#divContent").on("keydown", function(e){ //본문 이미지 제거     
		
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
	
	$(".photoUploadResult, .fileUploadResult").on("click", "button", function(e){//업로드 삭제    
	  
	    var fileCallPath = $(this).data("filecallpath");
	    var type = $(this).data("type");
	    var uuid = $(this).data("uuid");
	    var targetLi = $(this).closest("li");
	    var imgTags = $('#divContent img');
	    
	    $.ajax({
		      url: '/dokky/deleteFile',
		      type: 'POST',
		      dataType:'text',
		      data: {	
	    	  			fileCallPath: fileCallPath,
	    	  		    type: type
		    	  	},
		      beforeSend: function(xhr) {
		          xhr.setRequestHeader(csrfHeaderName, csrfTokenValue); 
		      },
		      
	          success: function(result){
	      	    
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
	    }); //$.ajax
   });

	////////////////////////////////////////////////////////////////////////////// 
		
	  function showImage(fileCallPath){//원본 이미지 파일 보기
    	    
    	    $(".bigPictureWrapper").css("display","flex").show();
    	    
    	    $(".bigPicture").html("<img src='/dokky/display?fileName="+fileCallPath+"' >");
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

	$("button[type='submit']").on("click", function(e){//글쓰기 등록
    
		    e.preventDefault();
		
		    var selectedValue = $("#selectId option:selected").val();
		    
			var contentVal = $("#divContent").html();
	    	
	    	$("#areaContent").html(contentVal);
		    
		    if(selectedValue == 0){
		    	alert("게시판을 선택 해주세요."); 
		    	return false;
		    }
		    
		    var title = $("#title").val();
				 title = $.trim(title);//공백제거
				
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