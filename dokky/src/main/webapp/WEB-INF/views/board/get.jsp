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
    #replyModForm{ 
      display:none;
    }  
    .page-item{
      display:inline;
    }  
</style>
</head>
<body> 
<div class="getWrapper"> 
	<div class="col-lg-12">
     <h1 class="page-header">
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
		        <c:when test="${board.category == 6 }"> 
		   		   		    마이페이지  
		       </c:when>
       </c:choose>
     </h1>
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
          <label>좋아요</label>-<span id="likeCount"><c:out value="${board.up }"/></span>
          <button id="like">좋아요,ajax구현</button>  
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
	<!-- ///////////////////////////////////////////////////////// -->
	<div><!-- 댓글 목록 -->
        <ul class="replyList">
        </ul>
    </div>  
    <div class="replyPage"> <!-- 댓글페이지 -->
    </div>
    
      <div id="replyModForm" ><!-- 댓글 수정 폼+값 불러오기 --> 
              <input name='reply_content' value=''> 
              <button id='replyModFormModBtn' type="button" >수정</button> 
   			  <button id='replyModFormCloseBtn' type="button" >취소</button>
   			  
   			  <input type='hidden' name='nickName' value=''>
              <input type='hidden' name='reply_num' value=''>
      </div>
	
		<div class="replyWriteForm"><!--  댓글쓰기 폼 -->
		   <div> 
                <textarea id="reply_contents" rows="3" name='reply_content'></textarea> 
           </div>  
   		   <button id='replyRegisterBtn' type="button">등록</button>
   		   
   		   <input type='hidden' id="reply_nickName" name='nickName' value='testNickname'>
									   		   		<!-- 테스트닉네임에 회원정보에서 가져와서 넣기 -->
		</div> 
</div> 
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script type="text/javascript" src="/dokky/resources/js/reply.js"></script> <!--댓글 AJAX통신 -->
<script>

     function func_confirm(content){//단순 확인여부 함수
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
		
	    
	    replyService.getList({num:numValue, page: page || 1 }, function(data) {
	      
	   if(page == -1){
		  
	      pageNum = Math.ceil(data.replyCnt/10.0);
	      //alert(pageNum);
	      showReplyList(pageNum);//마지막페이지 찾아서 다시호출
	      return;
	    }
	      
	     var str="";
	     var len = data.list.length;
	     
	     if(data.list == null || len == 0){//댓글 리스트
	       return;  
	     }
	        
	     for (var i = 0; i < len || 0; i++) {
	       str +="<div style='display:none' id=replace"+data.list[i].reply_num+"></div><li data-reply_num='"+data.list[i].reply_num+"'>"+data.list[i].reply_num
	       +" " + data.list[i].nickName
	       +" " + data.list[i].reply_content
	       +" "+replyService.displayTime(data.list[i].replyDate)
	       +" "+"<button data-oper='modify' type='button' data-reply_num='"+data.list[i].reply_num+"'>수정</button>"
	       +"<button data-oper='delete' type='button' data-reply_num='"+data.list[i].reply_num+"'>삭제</button>" 
	       +"</li>"; 
	     }
	     
	     replyList.html(str);//댓글목록안에 채워주기
	     
	     showReplyPage(data.replyCnt);
	     
	   });//end function
	     
	 }//end showReplyList
	 
	 showReplyList(1);//댓글리스트 보여주기
		 
	/////////////////////////////////////////////////////////
		 var replyRegisterBtn = $("#replyRegisterBtn");//댓글 등록 버튼
		 var reply_contents = $("#reply_contents");//댓글 내용
		 var reply_nickName = $("#reply_nickName");//댓글 닉네임

		 replyRegisterBtn.on("click",function(e){// 0. 댓글 등록 이벤트 설치
		    	
		      var reply = {
		    		reply_content:reply_contents.val(), //댓글 내용
		    		nickName:reply_nickName.val(),//댓글 닉네임
		            num:numValue //글번호
		          };
		      
		     	 replyService.add(reply, function(result){//댓글 등록
		        
				        //alert(result);
				        
				        reply_contents.val("");//댓글등록후 폼 비우기
				        
				        showReplyList(-1);//댓글 목록 마지막 페이지 보여주기
			     });
		   });
	/////////////////////////////////////////////////////////이하는 댓글 수정,삭제,수정후 취소

	 	var RecentReplaceTag; //더미 <div>가 댓글 수정폼으로 교체되어지기전 백업해둔 현재 <div>태그
	 	var isReplaceTag = false;//더미 <div>가 댓글 수정폼으로 교체되었는지 체크여부
	 	var replyModFormId ;//현재 댓글 수정폼의 아이디
	     
	$(".replyList").on("click",'button[data-oper="modify"]', function(event){//1. 댓글목록의 수정버튼 이벤트,댓글 데이터 한줄 가져오기
		if(isReplaceTag){//댓글 수정폼이 열려 있다면
			 RecentReplaceTag.replaceAll("#"+replyModFormId);//댓글 수정폼을  더미 <div>로 교체
			$(".selected").css("display", "list-item");//none해둔 수정 댓글은 다시 보이게하기 
		}  
		
		$(this.parentNode).addClass('selected').css("display","none");//수정할려는 댓글 한줄 안보이게
		
		  var reply_num = $(this).data("reply_num");//수정 할려는 댓글의 번호 가져오기
		  var currentReplyModForm = $('#replyModForm').clone();//모형 댓글 수정폼 복제해오기
		  
		  currentReplyModForm.attr('id', "replyModForm"+reply_num);//글번호 넣어서 아이디  바꿔주기
		  replyModFormId = currentReplyModForm.attr('id');//현재 댓글 수정폼의 아이디 저장 
		  
		  currentReplyModForm.find('#replyModFormCloseBtn').attr('id', "replyModFormCloseBtn"+reply_num); //댓글 수정폼 취소버튼 id 글번호 넣어서 바꿔주기
		  currentReplyModForm.find('#replyModFormModBtn').attr('id', "replyModFormModBtn"+reply_num); //댓글 수정폼 수정버튼 id 글번호 넣어서 바꿔주기
		  
		 RecentReplaceTag = $("#replace"+reply_num).clone();//더미 div를 복제해서 잠시 빼둠-추후 댓글 수정폼을 다시 되돌리기 위해
		    
		 currentReplyModForm.replaceAll("#replace"+reply_num);//더미 div를 댓글 수정폼 으로 교체    
		 
		 isReplaceTag = true;//교체 되어졌음을 확인 
		
		    var InputReply_content = currentReplyModForm.find("input[name='reply_content']");
		    var InputNickName = currentReplyModForm.find("input[name='nickName']");
		    var InputReply_num = currentReplyModForm.find("input[name='reply_num']");
		    
		  replyService.get(reply_num, function(Result){//1. 댓글 데이터 한줄 가져오기
			  InputReply_content.val(Result.reply_content);//ReplyVO의 reply_content
			  InputNickName.val(Result.nickName);//ReplyVO의 nickName
			  InputReply_num.val(reply_num);
			  
			  currentReplyModForm.css("display","block");//최종 댓글 수정 입력폼 사용자에게 보여주기   
			  
	/////////////////////////////////////////////////////// 

			  var replyModFormCloseBtn = $("#replyModFormCloseBtn"+reply_num); //댓글 수정폼 취소버튼 가져오기 
			  var replyModFormModBtn = $("#replyModFormModBtn"+reply_num);//댓글 수정폼 수정버튼 가져오기
			  
			  replyModFormModBtn.on("click", function(e){// 1-1. 댓글 수정 등록 
				   	 var reply = {reply_num:InputReply_num.val(), reply_content: InputReply_content.val()};//수정폼의 값을 넘긴다
				   	  
				   	  replyService.update(reply, function(result){
				   	        
				   	    //alert(result); 
				   	      
				   	    showReplyList(pageNum);//수정후 댓글 페이지 유지하면서 리스트 다시불름
				   	 
				   	  });
				   	});
			    
			  replyModFormCloseBtn.on("click", function(e){//1-2. 댓글 수정 취소 
				  RecentReplaceTag.replaceAll("#replyModForm"+reply_num); //수정 취소시 댓글 수정폼을 다시  더미 <div>로 교체  
				 	    
				 	   $(".selected").css("display", "list-item");//숨겨둔 댓글 한줄 다시 보이게
				});
		  });
	});// 1.이벤트 함수 끝
	
///////////////////////////////////////////////////////

	$(".replyList").on("click",'button[data-oper="delete"]', function(event){//2. 댓글 삭제 이벤트 설치
		if(func_confirm('정말 삭제 하시겠습니까?')){ 
		 var reply_num = $(this).data("reply_num");
	
		 replyService.remove(reply_num, function(result){
	   	      //alert(result);
	   	      showReplyList(pageNum);//삭제후 댓글 페이지 유지하면서 리스트 다시불름 
	   	  }); 
		}
	});//2. 이벤트 함수 끝 
	
	
	var like = $("#like");
	
	  like.on("click", function(e){//3. 좋아요 버튼 이벤트 설치 
		   	 var likeData = {num:numValue};//수정폼의 값을 넘긴다
		   	  
		   	  replyService.updateLike(likeData, function(result){
		   	 
		   	//var likeCount = $("#likeCount");
		  // 	likeCount.html(result);  
		   		  alert(result);//좋아요 싫어요는 한번만 해줘야함,트랜잭션도 포함될수있음 여기 나중에다시 개발
		   	  });
		   	});
	  
///////////////////////////////////////////////////////	
	  
	 	var pageNum = 1;
	    var replyPage = $(".replyPage");
	    
    function showReplyPage(replyCnt){
	      
	      var endNum = Math.ceil(pageNum / 10.0) * 10; 
	      	//alert(endNum);
	      /* Math.ceil() : 소수점 이하를 올림한다. */ 
	      var startNum = endNum - 9;
	      //alert(startNum); 
	      var prev = startNum != 1; 
	      //alert(startNum);
	      var next = false; 
	      //100
	      if(endNum * 10 >= replyCnt){
	        endNum = Math.ceil(replyCnt/10.0);
	       					 /* 10은 보여줄 댓글의 갯수 */
	      }
	      
	      if(endNum * 10 < replyCnt){
	        next = true;
	      }
	      
	      var str = "<ul>";
	      	
	      if(prev){ 
	    	  //alert("prev");
	        str+= "<li class='page-item'><a class='page-link' href='"+(startNum -1)+"'>Previous</a></li>";
	      }
	      
	      for(var i = startNum ; i <= endNum; i++){
	        
	        var active = pageNum == i? "active":"";
	          
	        str+= "<li class='page-item "+active+" '><a class='page-link' href='"+i+"'> " +i+ " </a></li>"; 
	      }
	      
	      if(next){
		//alert("next"); 
	        str+= "<li class='page-item'><a class='page-link' href='"+(endNum + 1)+"'>Next</a></li>";
	      }
	      
	      str += "</ul></div>";
	      
	      //console.log(str);
	      
	      replyPage.html(str);
    }
	     
	    
	    replyPage.on("click","li a", function(e){
		       e.preventDefault();
		       
		       var targetPageNum = $(this).attr("href");
		       
		       //console.log("targetPageNum: " + targetPageNum);
		       
		        pageNum = targetPageNum;
		        
		       showReplyList(pageNum);
	     });    
	    
</script>
</body>
</html>


 
