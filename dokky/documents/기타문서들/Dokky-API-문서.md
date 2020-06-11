## api 문서의 필요성
- api를 만든것이기 때문에 당연히 기본적으로 필요
- 앞으로 개발을 할때도 + 유지보수를 하기위해서라도 한눈에 볼 수 있는 문서가 필요
- 이 프로젝트가 다른곳에서도 쓰여짐을 가정한다면, 다른사람이 쉽게 이해 할 수 있는 문서가 필요
- 다른 개발자들과 협업을 한다고 하면 api 공유 문서가 필요

## 고민사항
내 프로젝트는 api + rest api 가 혼합..?되어 있다보니 api 문서 작성하는데 있어 혼동이옴..
예를들어 댓글 조회 같은경우 순수한 데이터만 가져오기 때문에 response가 순수한 데이터만 json형태로 보여주지만
글 조회 같은경우는 html에 데이터를 조합해 response 하기 때문에.. 핵심 데이터만 문서에 적을것인지..? 


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








