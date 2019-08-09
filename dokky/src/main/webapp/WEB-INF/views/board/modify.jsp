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
<title>Dokky</title>
</head>
<style>

@media screen and (max-width:500px){ 
		.modifyWrapper { 
				    width: 80%;  
				    display: inline-block;
				    margin-left: 15%;
				    margin-top: 1%;
				    min-height: 500px; 
				    border-color: #e6e6e6;
					border-style: solid;
					background-color: #323639; 
					color: #e6e6e6;
					display: inline-block;
				}     
        }
        @media screen and (min-width: 501px) and (max-width:1500px){
	        .modifyWrapper {
				    width: 80%; 
				    display: inline-block;
				    margin-left: 15%;
				    margin-top: 1%;
				    min-height: 500px; 
				    border-color: #e6e6e6;
					border-style: solid;
					background-color: #323639; 
					color: #e6e6e6;
					display: inline-block;
				}
        }
        @media screen and (min-width: 1501px){    
          .modifyWrapper { 
			    width: 51%; 
			    display: inline-block;
			    margin-left: 29%;
			    margin-top: 1%;
			    min-height: 500px; 
			    border-color: #e6e6e6;
				border-style: solid;
				background-color: #323639; 
				color: #e6e6e6;
				display: inline-block;
			}
        }
	body{
		background-color: #323639; 
	}
	
	.uploadResult {
  width:100%;
  background-color: gray;
}
.uploadResult ul{
  display:flex;
  flex-flow: row;
  justify-content: center;
  align-items: center;
}
.uploadResult ul li {
  list-style: none;
  padding: 10px;
  align-content: center;
  text-align: center;
}
.uploadResult ul li img{
  width: 100px;
}
.uploadResult ul li span {
  color:white;
}
.bigPictureWrapper {
  position: absolute;
  display: none;
  justify-content: center;
  align-items: center;
  top:0%;
  width:100%;
  height:100%;
  background-color: gray; 
  z-index: 100;
  background:rgba(255,255,255,0.5);
}
.bigPicture {
  position: relative;
  display:flex;
  justify-content: center;
  align-items: center;
}

.bigPicture img {
  width:600px;
}
</style>
<body>
<div class="modifyWrapper">
	<div class="col-lg-12">
	    <h1 class="page-header">${board.category}게시판</h1>
	  </div>
	  
	  <div class="row">
  <div class="col-lg-12">
    <div class="panel panel-default">

      <div class="panel-heading">Files</div>
      <!-- /.panel-heading -->
      <div class="panel-body">
        <div class="form-group uploadDiv">
            <input type="file" name='uploadFile' multiple="multiple">
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
	  
	<form role="form" action="/dokky/board/modify" method="post"> 
				
			<div class="form-group">
			  <label>제목</label> 
			  <input class="form-control" name='title' oninput="checkLength(this,30);" value='<c:out value="${board.title }"/>'>
			</div>
			<div class="form-group">
			  <label>내용</label>
			  <textarea class="form-control" rows="3" name='content' oninput="checkLength(this,3500);"><c:out value="${board.content}"/></textarea>
			</div>
			
		   <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/> 
			
		   <input type='hidden' name='userId' value='<c:out value="${board.userId }"/>'>  
		   <input type='hidden' name='num' value='<c:out value="${board.num }"/>'>
		   <input type='hidden' name='category' value='<c:out value="${cri.category}"/>'>
		   <input type='hidden' name='pageNum' value='<c:out value="${cri.pageNum}"/>'>
		   <input type='hidden' name='amount' value='<c:out value="${cri.amount}"/>'>
		   <input type='hidden' name='type' value='<c:out value="${cri.type }"/>'>
		   <input type='hidden' name='keyword' value='<c:out value="${cri.keyword }"/>'>
     
     <sec:authentication property="principal" var="userInfo"/>
		 
		 	<sec:authorize access="isAuthenticated()">
		        <c:if test="${userInfo.username eq board.userId}">
		       		 <button type="submit">수정완료</button>
		        </c:if>
	        </sec:authorize>
	        
     	   <button type="reset" class="btn btn-default">다시쓰기</button>
	</form>
</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script> 

function checkLength(obj, maxlength) {    
	var str = obj.value; // 이벤트가 일어난 컨트롤의 value 값    
	var str_length = str.length; // 전체길이       // 변수초기화     
	var max_length = maxlength; // 제한할 글자수 크기     
	var i = 0; // for문에 사용     
	var ko_byte = 0; // 한글일경우는 2 그밗에는 1을 더함     
	var li_len = 0; // substring하기 위해서 사용     
	var one_char = ""; // 한글자씩 검사한다     
	var reStr = ""; // 글자수를 초과하면 제한할수 글자전까지만 보여준다.       
	for (i = 0; i < str_length; i++) {         // 한글자추출         
		one_char = str.charAt(i);            
		ko_byte++;        
	}              
	if (ko_byte <= max_length) {// 전체 크기가 max_length를 넘지않으면                
		li_len = i + 1;         
	}       
	if (ko_byte > max_length) {// 전체길이를 초과하면          
			alert(max_length + " 글자 이상 입력할 수 없습니다.");         
			reStr = str.substr(0, max_length);         
			obj.value = reStr;      
			}     
		obj.focus();  
	}
	
$(document).ready(function() {

	  var formObj = $("form");

	  $("button[type='submit']").on("click", function(e){
	    
	    e.preventDefault(); 
	        
	        var str = "";
	        
	        $(".uploadResult ul li").each(function(i, obj){
	          
	          var jobj = $(obj);
	          
	          //console.dir(jobj);
	          
	          str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
	          str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
	          str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
	          str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+ jobj.data("type")+"'>";
	          
	        });
	        formObj.append(str).submit();
	  });
});

$(document).ready(function() {
  (function(){
    
    var num = '<c:out value="${board.num}"/>';
    
    $.getJSON("/dokky/board/getAttachList", {num: num}, function(arr){
    
      console.log(arr);
      
      var str = "";


      $(arr).each(function(i, attach){
          
          //image type
          if(attach.fileType){
            var fileCallPath =  encodeURIComponent( attach.uploadPath+ "/s_"+attach.uuid +"_"+attach.fileName);
            
            str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' "
            str +=" data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"' ><div>";
            str += "<span> "+ attach.fileName+"</span>";
            str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='image' "
            str += "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
            str += "<img src='/dokky/display?fileName="+fileCallPath+"'>";
            str += "</div>";
            str +"</li>";
          }else{
              
            str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' "
            str += "data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"' ><div>";
            str += "<span> "+ attach.fileName+"</span><br/>";
            str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' "
            str += " class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
            str += "<img src='/dokky/resources/img/attach.png'></a>";
            str += "</div>";
            str +"</li>";
          }
       });

 
      $(".uploadResult ul").html(str);
      
    });//end getjson
  })();//end function
  
  
  $(".uploadResult").on("click", "button", function(e){
	    
    console.log("delete file");
      
    if(confirm("Remove this file? ")){
    
      var targetLi = $(this).closest("li");
      targetLi.remove();
    }
  });  
  
  var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
  var maxSize = 5242880; //5MB
  
  function checkExtension(fileName, fileSize){
    
    if(fileSize >= maxSize){
      alert("파일 사이즈 초과");
      return false;
    }
    
    if(regex.test(fileName)){
      alert("해당 종류의 파일은 업로드할 수 없습니다.");
      return false;
    }
    return true;
  }
  
  var csrfHeaderName ="${_csrf.headerName}"; 
  var csrfTokenValue="${_csrf.token}";
  
  $("input[type='file']").change(function(e){

    var formData = new FormData();
    
    var inputFile = $("input[name='uploadFile']");
    
    var files = inputFile[0].files;
    
    for(var i = 0; i < files.length; i++){

      if(!checkExtension(files[i].name, files[i].size) ){
        return false;
      }
      formData.append("uploadFile", files[i]);
      
    }
    
    $.ajax({
      url: '/dokky/uploadAjaxAction',
      processData: false, 
      contentType: false,data: 
      formData,type: 'POST',
      beforeSend: function(xhr) {
          xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
      },
      dataType:'json',
        success: function(result){
          console.log(result); 
		  showUploadResult(result); //업로드 결과 처리 함수 

      }
    }); //$.ajax
    
  });    

  function showUploadResult(uploadResultArr){
	    
    if(!uploadResultArr || uploadResultArr.length == 0){ return; }
    
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
  
});

</script>

</body>
</html>