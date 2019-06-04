<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Dokky</title>
<%@include file="../includes/left.jsp"%>
<style>
	body{
		background-color: #323639; 
	}
	.getWrapper { 
	    border-color: #e6e6e6; 
		border-style: solid; 
		background-color: #323639; 
		color: #e6e6e6;
		margin-left: 15%;
		margin-top: 1%; 
	}
        .modal{
          display:none;
        }  
</style>
</head>
<body>
<div class="getWrapper"> 
	<div class="col-lg-12">
     <h1 class="page-header">${board.category}게시판</h1>
    </div>

		<div class="form-group">
          <label>날짜</label>-<fmt:formatDate pattern="yyyy-MM-dd-HH:mm"
								value="${board.regDate}" />
        </div>
        <div class="form-group">
          <label>수정됨</label>-<fmt:formatDate pattern="yyyy-MM-dd-HH:mm"
								value="${board.updateDate}" />
        </div>						
		<div class="form-group">
          <label>닉네임</label>-<c:out value="${board.nickName }"/>  
        </div>
         <div class="form-group">
          <label>번호</label>-<c:out value="${board.num }"/>
        </div>

        <div class="form-group">
          <label>제목</label>-<c:out value="${board.title }"/>
        </div>

        <div class="form-group">
          <label>내용</label>-<c:out value="${board.content }"/>
        </div>
        
        <div class="form-group">
          <label>좋아요</label>-<c:out value="${board.up }"/>
          <button onclick="">좋아요,ajax구현</button> 
        </div>
        
        <div class="form-group">
          <label>싫어요</label>-<c:out value="${board.down }"/>
          <button onclick="">싫어요,ajax구현</button> 
        </div>
        
        <div class="form-group">
          <label>기부금</label>-<c:out value="${board.money }"/>
          <button onclick="">기부금,ajax구현</button> 
        </div>
        <div class="form-group">
          <label>조회수</label>-<c:out value="${board.hitCnt }"/>
        </div>
        <div class="form-group">
          <label>댓글</label>-<c:out value="${board.replyCnt }"/>
        </div>
		<div>
			<button id="modify_button">수정 </button> 
	        <button id="list_button">목록보기 </button> 
	        <button id="remove_button">삭제 </button>
	        
			<form id='operForm' action="/dokky/board/modify" method="get">
			  <input type='hidden' id='num' name='num' value='<c:out value="${board.num}"/>'>
			  <input type='hidden' name='category' value='<c:out value="${cri.category}"/>'>
			  <input type='hidden' name='pageNum' value='<c:out value="${cri.pageNum}"/>'>
			  <input type='hidden' name='amount' value='<c:out value="${cri.amount}"/>'>
			  <input type='hidden' name='keyword' value='<c:out value="${cri.keyword}"/>'>
  			  <input type='hidden' name='type' value='<c:out value="${cri.type}"/>'>  
			</form>

		</div>
	
	<div class='row'><!-- 댓글 목록 -->
	        <ul class="replyList">
	        </ul>
    </div>
    
    <!-- Modal -->
      <div class="modal" id="myModal" >
                <label>댓글내용</label>  
                <input class="form-control" name='reply_content' value=''> 
                <input type='hidden' class="form-control" name='nickName' value=''>
                <input type='hidden' class="form-control" name='reply_num' value=''>
                <button id='modalModBtn' type="button" class="btn btn-warning">수정</button> 
       			<button id='modalCloseBtn' type="button" class="btn btn-default">취소</button>
      </div>
	
	<div>
		 댓글쓰기
		<div>
		   <div> 
                <textarea id="reply_contents" rows="3" name='reply_content'></textarea> 
           </div>  
           <input type='hidden' id="reply_nickName" name='nickName' value='testNickname'> 
   		   <button id='replyRegisterBtn' type="button">등록</button>
		</div> 
	</div>  
</div> 
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script type="text/javascript" src="/dokky/resources/js/reply.js"></script> <!--댓글 AJAX통신 -->
<script>

     function func_confirm(content){//확인여부함수
         if(confirm(content)){//true
         	return true;
         } else {//false
         	return false;
         }
     }
	/////////////////////////////////////////////////////////
	
	var operForm = $("#operForm");  

	$("#list_button").on("click", function(e){//글 목록
	    operForm.find("#num").remove();
	    operForm.attr("action","/dokky/board/list")
	    operForm.submit();
 	 }); 
	
	$("#modify_button").on("click", function(e){//글 수정
	    operForm.submit();   
 	 }); 
	   
	$("#remove_button").on("click", function(e){//글 삭제
		if(func_confirm('정말 삭제 하시겠습니까?')){
			operForm.attr("action","/dokky/board/remove")
		    operForm.submit();
		}
 	 }); 
	
	/////////////////////////////////////////////////////////
 	 var numValue = '<c:out value="${board.num}"/>';// 글번호
 	 var replyList = $(".replyList");//댓글목록
	    
	function showReplyList(page){ //댓글 목록 가져오기
		
		//console.log("show list " + page);
	    
	    replyService.getList({num:numValue, page: page || 1 }, function(data) {
	      
	    //console.log("replyCnt: "+ replyCnt );
	    //console.log("data: " + data);
	    
	   /*  if(page == -1){
	      pageNum = Math.ceil(replyCnt/10.0);
	      showReplyList(pageNum);
	      return;
	    } */
	      
	     var str="";
	      
	     if(data.list == null || data.list.length == 0){//댓글 리스트
	       return;
	     }
	        
	     for (var i = 0; i < data.list.length || 0; i++) {
	       str +="<div style='display:none' id=replace"+data.list[i].reply_num+"></div><li data-reply_num='"+data.list[i].reply_num+"'>"+data.list[i].reply_num
	       +" " + data.list[i].nickName
	       +" " + data.list[i].reply_content
	       +" "+replyService.displayTime(data.list[i].replyDate)
	       +" "+"<button data-oper='modify' id='deleteBtn' type='button' data-reply_num='"+data.list[i].reply_num+"'>댓글 수정</button>"
	       +"<button data-oper='delete' id='deleteBtn' type='button' data-reply_num='"+data.list[i].reply_num+"'>댓글 삭제</button>"
	       +"</li>"; 
	     }
	     
	     replyList.html(str);
	     
	   });//end function
	     
	 }//end showReplyList
	 
	 showReplyList(1);//댓글리스트 보여주기
		 
	/////////////////////////////////////////////////////////
		 var replyRegisterBtn = $("#replyRegisterBtn");//댓글 등록 버튼
		 var reply_contents = $("#reply_contents");//댓글 내용
		 var reply_nickName = $("#reply_nickName");//댓글 닉네임

		 replyRegisterBtn.on("click",function(e){//댓글 등록 이벤트
		    	
		      var reply = {
		    		reply_content:reply_contents.val(), //댓글 내용
		    		nickName:reply_nickName.val(),//댓글 닉네임
		            num:numValue //글번호
		          };
		      
		      replyService.add(reply, function(result){//댓글 등록
		        
		        alert(result);
		        
		        reply_contents.val("");
		        
		        showReplyList(1);
		        
		      });
		    });
	/////////////////////////////////////////////////////////이하는 댓글 수정,삭제,수정후 취소

	 	var commonMyModal = $('#myModal'); //공통 모달
	 	var RecentReplaceModal; //현재 교체 모달
	 	var isReplaceModal = false;//리플레이스 모달이 존재를 하는지 체크여부
	 	var currentModalId ;//현재 모달 아이디
	     
	$(".replyList").on("click",'button[data-oper="modify"]', function(event){//댓글목록의 수정버튼 이벤트
		if(isReplaceModal){
			 RecentReplaceModal.clone().replaceAll("#"+currentModalId); 
			$(".selected").css("display", "list-item");//수정 버튼을 2번이나 눌르게되면 다른 수정li는 다시 보이게하기 
		}  
		// alert(this);   
		 //alert(event);    
		//$(".modal").css("display", "none");  
		
		$(this.parentNode).addClass('selected').css("display","none");//수정할려는 댓글 한줄 안보이게
		
		  var reply_num = $(this).data("reply_num");//수정 할려는 댓글의 번호 가져오기
		  
		  var currentModal = commonMyModal;//댓글 입력창 불러오기
		  
		  currentModal.attr('id', "myModal"+reply_num);//아이디 글번호 넣어서 바꿔주기
		  
		  currentModalId = currentModal.attr('id');//현재 모달아이디 저장 
		  
		 RecentReplaceModal = $("#replace"+reply_num).clone();//댓글 목록의 교체 해줄 div를 복제해서 잠시 빼둠
		 
		 currentModal.clone().replaceAll("#replace"+reply_num);//복제후 댓글 입력창으로 교체
		 
		 isReplaceModal = true;//복제후 교체 되어졌음을 확인
		
		  var modal = $("#myModal"+reply_num);
		    var InputReply_content = modal.find("input[name='reply_content']");
		    var InputNickName = modal.find("input[name='nickName']");
		    var InputReply_num = modal.find("input[name='reply_num']");
		    
		  replyService.get(reply_num, function(Result){//댓글 데이터 한줄 가져오기
			  InputReply_content.val(Result.reply_content);//ReplyVO의 reply_content
			  InputNickName.val(Result.nickName);//ReplyVO의 nickName
			  InputReply_num.val(reply_num);
			  
			  modal.css("display","block");//댓글 수정 입력폼 보여주기   
			  
	///////////////////////////////////////////////////////

			  var modalCloseBtn = $("#modalCloseBtn");//추후 수정    
			  var modalModBtn = $("#modalModBtn");//추후 수정
			  
			  modalModBtn.on("click", function(e){//댓글 수정 등록
				   	 var reply = {reply_num:InputReply_num.val(), reply_content: InputReply_content.val()};
				   	  
				   	  replyService.update(reply, function(result){
				   	        
				   	    alert(result);
				   	    
				   	    showReplyList(1);
				   	    
				   	 RecentReplaceModal.clone().replaceAll("#myModal"+reply_num);
				   	  });
				   	});
			    
			  modalCloseBtn.on("click", function(e){//댓글 수정 취소
				  RecentReplaceModal.clone().replaceAll("#myModal"+reply_num);
			  
				 	   modal.css("display", "none");//""은 block이든 inline이든 기본 적용
				 	   
				 	   $(".selected").css("display", "list-item");//list-item은 li디자인을 의미  block inline도있음
					});
		  });
	 	 });
	
///////////////////////////////////////////////////////

	$(".replyList").on("click",'button[data-oper="delete"]', function(event){//댓글 삭제 이벤트 설치
		if(func_confirm('정말 삭제 하시겠습니까?')){
		 var reply_num = $(this).data("reply_num");
	
		 replyService.remove(reply_num, function(result){
	   	        
	   	      alert(result);
	   	      showReplyList(1);
	   	  }); 
		}//if문 끝
	});//댓글 삭제 이벤트 설치 종료
	
</script>
</body>
</html>


 
