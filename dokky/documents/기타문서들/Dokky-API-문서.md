

## 1) 글 작성

### HTTP Request Header

HTTP Header| value 
---- | ----
Method | POST
URI Path | /board/register

### HTTP Request Body

key | comment | type | 필수
---- | ---- | ---- | ----
category | 글 카테고리 종류 번호(0~5) | Int | O
title | 글 제목 | String | O
nickName | 작성자 닉네임 | String | O
userId | 작성자 아이디 | String | O
content | 글 내용 | String | O

### Request Body example

key | value 
---- | ----
category | 1   
title | 공지사항 입니다.
nickName | 슈퍼 관리자 
userId | admin 
content | 도키 커뮤니티에 오신것을 환영합니다.

## 2) 글 조회

### HTTP Request Header

HTTP Header| value 
---- | ----
Method | GET
URI Path | /board/get

### Queries of HTTP Request Header

key | comment  | 필수
---- | ---- | ----
board_num | 글 번호 |  O
category | 글 카테고리 종류 번호(0~5) |  O
pageNum | 현재 리스트 페이지 번호 |  O
amount | 현재 리스트에서 보여주는 글 갯수 |  O
keyword | 글 검색어 |  X
type | 검색 타입 |  X

### HTTP Request Body

Nothing

### Query String Parameters example

pageNum=1&amount=10&category=0&type=&keyword=&board_num=744

### HTTP Response 핵심 데이터

key | comment | type 
---- | ---- | ---- 
category | 글 카테고리 종류 번호(0~5) | Int 
board_num | 글 번호 | Long 
title | 글 제목 | String 
nickName | 작성자 닉네임 | String 
userId | 작성자 아이디 | String 
content | 글 내용 | String
regDate | 글 작성 날짜 | Date
updateDate | 글 수정 날짜| Date
likeCnt | 좋아요 수 | Int
dislikeCnt | 싫어요 수 | Int
money | 글 기부금액 | Int
hitCnt | 조회수 | Long
replyCnt | 댓글수 | Int

## 3) 글 수정

### HTTP Request Header

HTTP Header| value 
---- | ----
Method | POST
URI Path | /board/modify

### HTTP Request Body

key | comment | type | 필수
---- | ---- | ---- | ----
category | 글 카테고리 종류 번호(0~5) | Int | O
title | 글 제목 | String | O
userId | 작성자 아이디 | String | O
content | 글 내용 | String | O
board_num | 글 번호 | Long | O
pageNum | 현재 리스트 페이지 번호 | int | O
amount | 현재 리스트에서 보여주는 글 갯수 | int | O
type | 검색 타입 | String | X
keyword | 글 검색어  | String | X

### Request Body example

key | value 
---- | ----
category | 1
title | 공지사항을 수정합니다.
userId | admin
content | 도키 커뮤니티에 오신것을 다시 환영합니다.
board_num | 744
pageNum | 1
amount | 10
type | null
keyword | null

## 4) 글 삭제

### HTTP Request Header

HTTP Header| value 
---- | ----
Method | POST
URI Path | /board/remove

### HTTP Request Body

key | comment | type | 필수
---- | ---- | ---- | ----
category | 글 카테고리 종류 번호(0~5) | Int | O
userId | 작성자 아이디 | String | O
board_num | 글 번호 | Long | O
pageNum | 현재 리스트 페이지 번호 | int | O
amount | 현재 리스트에서 보여주는 글 갯수 | int | O
type | 검색 타입 | String | X
keyword | 글 검색어  | String | X

### Request Body example

key | value 
---- | ----
category | 1
userId | admin
board_num | 744
pageNum | 1
amount | 10
type | null
keyword | null


## 5) 댓글 작성

### HTTP Request Header

HTTP Header| value 
---- | ----
Method | POST
URI Path | /replies/new

### HTTP Request Body

key | comment | type | 필수
---- | ---- | ---- | ----
reply_content | 댓글 내용 | String | O
userId | 댓글 작성자 아이디 | String | O
nickName |댓글 작성자 닉네임 | String | O
board_num | 해당 글번호 | Long | O

### Request Body example

 	{replyVO : {
			reply_content : "754번글에 댓글을 달아봅니다.",
				   userId : "admin",
				 nickName : "슈퍼 관리자",
				 board_num : "754" 
			}
 	}

## 6) 댓글 수정

### HTTP Request Header

HTTP Header| value 
---- | ----
Method | PUT
URI Path | /replies/new

### HTTP Request Body

key | comment | type | 필수
---- | ---- | ---- | ----
reply_num | 댓글 번호 | Long | O
reply_content | 댓글 내용 | String | O
userId |댓글 작성자 아이디 | String | O

### Request Body example

 	{replyVO : {
			 reply_num : "222",
		   	 reply_content : "222번 댓글내용을 수정해봅니다.",
		 	 userId : "admin"
			}
 	}

## 7) 댓글 삭제

### HTTP Request Header

HTTP Header| value 
---- | ----
Method | DELETE
URI Path | /replies/{reply_num}

### PathVariable of HTTP Request Header

key | comment | type | 필수
---- | ---- | ---- | ----
reply_num | 댓글 번호 | Long | O

### HTTP Request Body

key | comment | type | 필수
---- | ---- | ---- | ----
userId |댓글 작성자 아이디 | String | O

### Request Body example

 	{replyVO : {
		 	 userId : "admin",
			}
 	}

## 8) 댓글 조회

### HTTP Request Header

HTTP Header| value 
---- | ----
Method | GET
URI Path | /replies/{reply_num}

### PathVariable of HTTP Request Header

key | comment | type | 필수
---- | ---- | ---- | ----
reply_num | 댓글 번호 | Long | O

### HTTP Request Body

Nothing

### HTTP Response Body

key | comment | type | 필수
---- | ---- | ---- | ----
reply_num | 댓글 번호 | Long | O
board_num | 해당 글번호 | Long | O
reply_content | 댓글 내용 | String | O
nickName |댓글 작성자 닉네임 | String | O
userId | 댓글 작성자 아이디 | String | O
toUserId | 댓글의 답글 보낼 아이디 | String | X
toNickName | 댓글의 답글 보낼 닉네임| String | X
replyDate | 댓글 작성날짜 | Date | O
updateDate | 댓글 수정날짜 | Date | X
likeCnt | 좋아요 수 | Int | O
dislikeCnt | 싫어요 수 | Int | O
money | 기부금 | Int | O
group_num | 댓글 묶음 번호 | Int | O
order_step | 댓글 출력 순서 | Int | O
depth | 댓글 깊이 | Int | O

### HTTP Response Body example

 	{ 
 	 	"reply_num":424,
 	 	"board_num":785,
 	 	"reply_content":"댓글내용",
 	 	"nickName":"슈퍼관리자",
	 	"userId":"admin",
	 	"toNickName":null,
	 	"toUserId":null,
	 	"replyDate":1592053977000,
	 	"updateDate":1592053977000,
	 	"likeCnt":0,
	 	"dislikeCnt":0,
	 	"money":0,
	 	"group_num":424,
	 	"order_step":0,
	 	"depth":0
 	}

## 9) 댓글 리스트 조회

### HTTP Request Header

HTTP Header| value 
---- | ----
Method | GET
URI Path | /replies/pages/{board_num}/{page}

### PathVariable of HTTP Request Header

key | comment | type | 필수
---- | ---- | ---- | ----
board_num | 해당 글번호 | Long | O
page | 댓글의 페이지 | Int | O

### HTTP Request Body

Nothing

### HTTP Response Body

key | comment | type | 필수
---- | ---- | ---- | ----
replyCnt | 총 댓글 수 | Int | O
reply_num | 댓글 번호 | Long | O
board_num | 해당 글번호 | Long | O
reply_content | 댓글 내용 | String | O
nickName |댓글 작성자 닉네임 | String | O
userId | 댓글 작성자 아이디 | String | O
toUserId | 댓글의 답글 보낼 아이디 | String | X
toNickName | 댓글의 답글 보낼 닉네임| String | X
replyDate | 댓글 작성날짜 | Date | O
updateDate | 댓글 수정날짜 | Date | X
likeCnt | 좋아요 수 | Int | O
dislikeCnt | 싫어요 수 | Int | O
money | 기부금 | Int | O
group_num | 댓글 묶음 번호 | Int | O
order_step | 댓글 출력 순서 | Int | O
depth | 댓글 깊이 | Int | O

### HTTP Response Body example

 	{
 	 	"replyCnt":1,
 	 	"list":[{
			 	 	"reply_num":424,
			 	 	"board_num":785,
			 	 	"reply_content":"댓글내용",
			 	 	"nickName":"슈퍼관리자",
				 	"userId":"admin",
				 	"toNickName":null,
				 	"toUserId":null,
				 	"replyDate":1592053977000,
				 	"updateDate":1592053977000,
				 	"likeCnt":0,
				 	"dislikeCnt":0,
				 	"money":0,
				 	"group_num":424,
				 	"order_step":0,
				 	"depth":0
		 	   }]
	}
