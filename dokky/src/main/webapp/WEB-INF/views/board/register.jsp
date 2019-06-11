<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ include file="../includes/left.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
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
				<select name="category" class="form-control">
					<option value="" selected="selected">게시판을 선택해 주세요.</option>
                       <option value=1>공지사항</option>
                       <option value=2>자유게시판</option>
                       <option value=3>묻고답하기</option>
                       <option value=4>칼럼/Tech</option>
                       <option value=5>정기모임/스터디</option>
			     </select>
			</div>
		          <div class="form-group">
		            <input class="form-control" placeholder="제목을 입력해 주세요" name='title'>
		          </div>
		
		          <div class="form-group">
		            <textarea class="form-control" rows="3" name='content'></textarea>
		          </div>
		          
		          <input type='hidden' name='nickName' value='test' /> 
		        <%--   <input type='hidden' name='amount' value='<c:out value="${pageMaker.cri.amount}"/>' /> --%>
								
		          <button type="submit" class="btn btn-default">등록</button>
		          
		          <button type="reset" class="btn btn-default">다시쓰기</button>
	        </form>
      </div>
    </div>
  </div>
</div>
</div>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script> 
$(document).ready(function(e){
  
  var formObj = $("form[role='form']");
  
  $("button[type='submit']").on("click", function(e){
    
    e.preventDefault();
    
    console.log("submit clicked");
    
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
			str += "<img src='/display?fileName="+fileCallPath+"'>";
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