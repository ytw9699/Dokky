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
	
	<div class='row'>
	        <ul class="replyData">
	        </ul>
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
	
	<!-- Modal -->
      <div class="modal" id="myModal" >
                <label>댓글내용</label>  
                <input class="form-control" name='reply_content' value=''> 
                <input type='hidden' class="form-control" name='nickName' value=''>
                <input type='hidden' class="form-control" name='reply_num' value=''>
                <button id='modalModBtn' type="button" class="btn btn-warning">수정</button> 
       			<button id='modalCloseBtn' type="button" class="btn btn-default">취소</button>
      </div>
</div> 
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script type="text/javascript" src="/dokky/resources/js/reply.js"></script>
<script>


     function func_confirm(content){//확인여부
         if(confirm(content)){//true
         	return true;
         } else {//false
         	return false;
         }
     }

	var operForm = $("#operForm");  

	$("#list_button").on("click", function(e){
	    operForm.find("#num").remove();
	    operForm.attr("action","/dokky/board/list")
	    operForm.submit();
 	 }); 
	
	$("#modify_button").on("click", function(e){
	    operForm.submit(); 
 	 }); 
	   
	$("#remove_button").on("click", function(e){
		if(func_confirm('정말 삭제 하시겠습니까?')){
			operForm.attr("action","/dokky/board/remove")
		    operForm.submit();
		}
 	 }); 
	 
	//console.log(replyService);
	
	/* replyService.add(
	    {num:"221", reply_content:"TESTCONTENT", nickName:"tester"}
	    ,
	    function(result){ 
	      alert("RESULT: " + result);
	      alert("댓글");  
	    }  
	); */
	
	   /* replyService.getList({num:221, page:1}, function(data){//댓글 리스트 테스트
	  for(var i = 0, len = data.list.length||0; i < len; i++ ){
	    console.log(data.list[i]);
	  }
	}); */
	
	/* 
	 replyService.remove(1, function(count) { //1번 댓글 삭제 테스트 

	   console.log(count);

	   if (count === "success") {
	     alert("REMOVED");
	   }
	 }, function(err) {
	   alert('ERROR...');
	 }); */
	 

	/* //12번 댓글 수정 
	 replyService.update({
	  reply_num : 2,
	  num : 221,
	  reply_content : "Modified Reply11...." 
	}, function(result) {
		 if (result === "success") {
	  alert("수정 완료...1"); 
	  }
	});   */
	
	/* 	
	replyService.get(2, function(data) { //댓글하나조회

		   console.log(data); 
		 }); */
		 
		  var numValue = '<c:out value="${board.num}"/>';
		  var replyUL = $(".replyData");
		    
		function showList(page){ 
			
			console.log("show list " + page);
		    
		    replyService.getList({num:numValue, page: page || 1 }, function(data) {
		      
		    //console.log("replyCnt: "+ replyCnt );
		    console.log("data: " + data);
		    
		   /*  if(page == -1){
		      pageNum = Math.ceil(replyCnt/10.0);
		      showList(pageNum);
		      return;
		    } */
		      
		     var str="";
		     
		     if(data.list == null || data.list.length == 0){
		       return;
		     }
		     
		     for (var i = 0, len = data.list.length || 0; i < len; i++) {
		       str +="<div style='display:none' id=replace"+data.list[i].reply_num+">dd</div><li data-reply_num='"+data.list[i].reply_num+"'>"+data.list[i].reply_num
		       +" " + data.list[i].nickName
		       +" " + data.list[i].reply_content
		       +" "+replyService.displayTime(data.list[i].replyDate)
		       +" "+"<button data-oper='modify' id='deleteBtn' type='button' data-reply_num='"+data.list[i].reply_num+"'>수정</button>"
		       +"<button data-oper='delete' id='deleteBtn' type='button' data-reply_num='"+data.list[i].reply_num+"'>삭제</button>"
		       +"</li>"; 
		     }
		     
		     replyUL.html(str);
		     
		   });//end function
		     
		 }//end showList
		 
		 showList(1);//댓글리스트 보여주기
		 
		 var replyRegisterBtn = $("#replyRegisterBtn");
		 var reply_contents = $("#reply_contents");
		 var reply_nickName = $("#reply_nickName");

		 replyRegisterBtn.on("click",function(e){
		    	
		      var reply = {
		    		reply_content:reply_contents.val(), 
		    		nickName:reply_nickName.val(),
		            num:numValue
		          };
		      replyService.add(reply, function(result){
		        
		        alert(result);
		        
		        reply_contents.val("");
		        
		        showList(1);
		        
		      });
		      
		    });
		
         
		 	var commonMyModal = $('#myModal');
		 	var RecentReplaceModal;
		 	var isReplaceModal = false;//리플레이스 모달이 존재를 하는지 체크여부
		 	var currentModalId ;
		     
		$(".replyData").on("click",'button[data-oper="modify"]', function(event){//수정버튼 처음 누름
			if(isReplaceModal){
				 RecentReplaceModal.clone().replaceAll("#"+currentModalId); 
			}
			// alert(this); 
			 //alert(event);    
			$(".modal").css("display", "none");
			$(".selected").css("display", "list-item");//수정 버튼을 2번이나 눌르게되면 다른 수정li는 다시 보이게하기
			$(this.parentNode).addClass('selected').css("display","none");
			  var reply_num = $(this).data("reply_num");
			  
			  var currentModal = commonMyModal;
			  currentModal.attr('id', "myModal"+reply_num);
			  
			 // $('#myModal').clone().replaceAll("#replace"+reply_num);//복제후 교체  
			 RecentReplaceModal = $("#replace"+reply_num).clone();
			 currentModal.clone().replaceAll("#replace"+reply_num);//복제후 교체
			 
			 isReplaceModal = true;
			currentModalId = currentModal.attr('id');//현재 모달아이디 저장 
			
			
			  var modal = $(".modal");
			    var InputReply_content = modal.find("input[name='reply_content']");
			    var InputNickName = modal.find("input[name='nickName']");
			    var InputReply_num = modal.find("input[name='reply_num']");
			    
			  replyService.get(reply_num, function(Result){
				  InputReply_content.val(Result.reply_content);//ReplyVO의reply_content
				  InputNickName.val(Result.nickName);//ReplyVO의nickName
				  InputReply_num.val(Result.reply_num);//ReplyVO의nickName
				  modal.data("reply_num", Result.reply_num);
				 // $(".modal").show();
				   $("#myModal"+reply_num).css("display","block");   
				  //$(".modal").css("display","block"); 
				   
				  var modalCloseBtn = $("#modalCloseBtn");   
				   var modalModBtn = $("#modalModBtn");
				  
				  modalModBtn.on("click", function(e){//댓글수정
						 var modal = $(".modal");
					   	  var reply = {reply_num:modal.data("reply_num"), reply_content: InputReply_content.val()};
					   	  
					   	  replyService.update(reply, function(result){
					   	        
					   	    alert(result);
					   	    showList(1);
					   	 RecentReplaceModal.clone().replaceAll("#myModal"+reply_num);
					   	 $(".modal").css("display", "none");
					   	  });
					   	   
					   	});
				   
				  
				  modalCloseBtn.on("click", function(e){//댓글 수정 취소
					  RecentReplaceModal.clone().replaceAll("#myModal"+reply_num);
					 	 //  $(".modal").hide();
					 	 //  $(".modal").show();
					 	   $(".modal").css("display", "none");//""은 block이든 inline이든 기본 적용
					 	   $(".selected").css("display", "list-item");//list-item은 li디자인을 의미  block inline도있음
						});
						 	
			  });
			  //alert("#replace"+reply_num); 
			 
		 	 });
		
		
		
		$(".replyData").on("click",'button[data-oper="delete"]', function(event){//댓글 삭제
			if(func_confirm('정말 삭제 하시겠습니까?')){
			 var reply_num = $(this).data("reply_num");
		
			 replyService.remove(reply_num, function(result){
		   	        
		   	      alert(result);
		   	      showList(1);
		   	  }); 
				}
		 	 });
		
		/* modalModBtn1.on("click", function(e){//댓글수정
		 	    alert(1);
		 	 //  $(".modal").hide();
		 	 //  $(".modal").show();
		 	   $(".modal").css("display", "");//""은 block이든 inline이든 기본 적용
		 	}); */
		 	
		
 
		    
</script>
</body>
</html>


 
