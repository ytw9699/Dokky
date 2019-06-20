<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ include file="../includes/left.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!-- <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script> -->
<script src="//code.jquery.com/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/dokky/resources/SmartEditor/js/HuskyEZCreator.js" charset="utf-8" ></script>

<title>Dokky 새 글쓰기</title>
<style>
.uploadResult { 
	width: 100%;
	background-color: gray;
}

.uploadResult ul {
	display: flex;
	flex-flow: row;
	justify-content: center;
	align-items: center;
}

.uploadResult ul li {
	list-style: none;
	padding: 10px;
}

.uploadResult ul li img {
	width: 100px;
}
</style>
</head>
<style> 
	body{
		background-color: #323639; 
	}
	.registerWrapper { 
	    border-color: #e6e6e6;
		border-style: solid;
		background-color: #323639; 
		color: white;
		margin-left: 15%;
		margin-top: 1%; 
	}
</style>
<body>
<div class="registerWrapper">

<div class="row">
  <div class="col-lg-12">
    <h1 class="page-header">새 글쓰기</h1>  
  </div>
</div>

<div class="row">
  <div class="col-lg-12">
    <div class="panel panel-default">
      <div class="panel-heading"></div>
      <!-- /.panel-heading -->
      <div class="panel-body">
        <div class="form-group uploadDiv">
            <input type="file" name='uploadFile' multiple>
        </div>
        <div class='uploadResult'> 
          <ul>
          </ul>
        </div>
      </div>
      <!--  end panel-body -->
    </div>
    <!--  end panel-body -->
  </div>
  <!-- end panel -->
</div>
<!-- /.row -->


<div class="row">
  <div class="col-lg-12">
    <div class="panel panel-default">

      <div class="panel-body">
	        <form role="form" action="/dokky/board/register" method="post">  
	        <div>
	        ${category} 카테고리값에 따라 selected를 변경시켜줘야함
				<select id="selectId" name="category" class="form-control">
					   <option value=9 selected="selected">게시판을 선택해 주세요.</option>
                       <option value=1>공지사항</option>
                       <option value=2>자유게시판</option>
                       <option value=3>묻고답하기</option> 
                       <option value=4>칼럼/Tech</option>
                       <option value=5>정기모임/스터디</option>
			     </select>
			</div>
		          <div class="form-group">
		            <input id="title" class="form-control" placeholder="제목을 입력해 주세요" name='title'>
		          </div>
		
		          <div class="form-group"> 
		          <textarea class="form-control" name="content" id="ir1" rows="20" cols="100"></textarea>
		          </div>
		          					 			 					<!-- 현재 사용자의 아이디가 출력 -->
		          <input type='hidden' name='nickName' value='<sec:authentication property="principal.username"/>' /> 
		        <%--   <input type='hidden' name='amount' value='<c:out value="${pageMaker.cri.amount}"/>' /> --%>
								
				  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
				  
		    	  <button type="submit" class="btn btn-default">등록</button>
		          
		          <button type="reset" class="btn btn-default">다시쓰기</button>
	        </form>
      </div>
    </div>
  </div>
</div>
</div>

<script> 
$(document).ready(function(e){
	
	/* 스마트 에디터 */
	var oEditors = [];
	
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
	});
	/* 스마트 에디터 */
  
  var formObj = $("form[role='form']");
  
  $("button[type='submit']").on("click", function(e){
    
    e.preventDefault();

    var selectedValue = $("#selectId option:selected").val();
    
    if(selectedValue == 9){
    	alert("게시판을 선택 해주세요.");
    	return false;
    }
    
    var title = $("#title").val();
		 title = $.trim(title);//공백제거
		
	if(title == ""){ 
		alert("제목을 입력하세요."); 
		   return false;
	}
    
    oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);// 스마트 에디터 - textarea에 값 옮겨주기
    
    //console.log("submit clicked"); 
    
    var str = "";
    
    $(".uploadResult ul li").each(function(i, obj){
      
      var jobj = $(obj);
      
      console.dir(jobj);
      console.log("-------------------------");
      console.log(jobj.data("filename"));
      
      
      str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
      str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
      str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
      str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+ jobj.data("type")+"'>";
      
    });
    
    console.log(str);
    
    formObj.append(str).submit();
    
  });
  
  var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
  var maxSize = 5242880; //5MB
  
  function checkExtension(fileName, fileSize){
    
    if(fileSize >= maxSize){
      alert("파일 사이즈는 5MB를 초과할 수 없습니다.");
      return false;
    }
    
    if(regex.test(fileName)){
      alert("해당 종류의 파일은 업로드할 수 없습니다.");
      return false;
    }
    return true;
  }
  
  $("input[type='file']").change(function(e){

    var formData = new FormData();
    
    var inputFile = $("input[name='uploadFile']");
    
    var files = inputFile[0].files;
    
    //console.log(files); 
    
    for(var i = 0; i < files.length; i++){
      if(!checkExtension(files[i].name, files[i].size) ){
        return false;
      }
      formData.append("uploadFile", files[i]);
      
    }
	    $.ajax({
	      url: '/dokky/uploadAjaxAction',
	      processData: false, 
	      contentType: false,
	      data: formData,
	      type: 'POST',
	      dataType:'json',
	        success: function(result){
	          //console.log(result); 
			  showUploadResult(result); //업로드 결과 처리 함수 
	      }
	    }); //$.ajax
  });  
  
  function showUploadResult(uploadResultArr){
	    
    if(!uploadResultArr || uploadResultArr.length == 0){ 
    	return; 
    }
    
    var uploadUL = $(".uploadResult ul");
    
    var str ="";
    
    $(uploadResultArr).each(function(i, obj){
		if(obj.image){
			var fileCallPath =  encodeURIComponent( obj.uploadPath+ "/s_"+obj.uuid +"_"+obj.fileName);
			str += "<li data-path='"+obj.uploadPath+"'";
			str +=" data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'"
			str +" ><div>";
			str += "<span> "+ obj.fileName+"</span>";
			str += "<button type='button' data-file=\'"+fileCallPath+"\' "
			str += "data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
			str += "<img src='/dokky/display?fileName="+fileCallPath+"'>";
			str += "</div>";
			str +"</li>";
		}else{
			var fileCallPath =  encodeURIComponent( obj.uploadPath+"/"+ obj.uuid +"_"+obj.fileName);			      
		    var fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");
		      
			str += "<li "
			str += "data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"' ><div>";
			str += "<span> "+ obj.fileName+"</span>";
			str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' " 
			str += "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
			str += "<img src='/dokky/resources/img/attach.png'></a>";
			str += "</div>";
			str +"</li>";
		}
    });
    	uploadUL.append(str);
  }

  $(".uploadResult").on("click", "button", function(e){
	    
    console.log("delete file"); 
      	
    var targetFile = $(this).data("file");
    var type = $(this).data("type");
    
    var targetLi = $(this).closest("li");//가장가까운
    
    $.ajax({
      url: '/dokky/deleteFile',
      data: {fileName: targetFile, type:type},
      dataType:'text',
      type: 'POST',
        success: function(result){
           targetLi.remove();
         }
    }); //$.ajax
   });
  
});
</script>
</body>
</html>