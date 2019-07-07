	1.-----------------------------------------------------
	create table DK_BOARD (--게시판 테이블
	  CATEGORY number(10,0) not null,-- 1~10번 게시판
	  NUM number(10,0),--PK
	  TITLE varchar2(200) not null,
	  NICKNAME varchar2(50) not null,
	  userId varchar2(50) not null,
	  CONTENT varchar2(4000) not null,
	  BLIND varchar2(50) default '미적용',
	  REGDATE date default sysdate, 
	  UPDATEDATE date default sysdate,
	  likeCnt number(10,0) default 0,
	  dislikeCnt number(10,0) default 0,
	  MONEY number(10,0) default 0,
	  HITCNT number(10,0) default 0,
	  REPLYCNT number(10,0) default 0,
	  constraint PK_DK_BOARD primary key(NUM)
	);
	
	create sequence seq_dk_board;
	
	DROP TABLE DK_BOARD PURGE;
	
	insert into DK_BOARD(CATEGORY, NUM, TITLE, NICKNAME, CONTENT)
	values (1, seq_dk_board.nextval, '제목1','닉네임1','콘텐트1');
	
	2.---------------------------------------------------------------------------------------
	
	insert into DK_REPLY(reply_num, num, reply_content, nickName,userId)
	(select seq_dk_reply.nextval, num, reply_content, nickName from DK_REPLY);
	
	create table DK_REPLY (--댓글 테이블
	reply_num number(10,0),--pk
	num number(10,0) not null,
	reply_content varchar2(1000) not null,
	nickName varchar2(50) not null,
	userId varchar2(50) not null,
	replyDate date default sysdate,
	updateDate date default sysdate,
	likeCnt number(10,0) default 0,
	dislikeCnt number(10,0) default 0,
	money number(10,0) default 0
	);
	alter table DK_REPLY add constraint pk_reply primary key (reply_num);
	
	alter table DK_REPLY add constraint fk_reply_board foreign key (num) references DK_BOARD (num) on delete cascade;--on delete cascade는 자식테이블을 같이 삭제시켜줌
	
	create sequence seq_dk_reply
	
	create index idx_reply on DK_REPLY(num desc, reply_num asc);
	
	DROP TABLE DK_REPLY PURGE;
	
	select /* INDEX(dk_reply idx_reply) */
	rownum rn,num,reply_num,reply_content,nickname from dk_reply where num =221 and reply_num > 0
	
	insert into dk_reply(reply_num,num,reply_content,nickName) values (seq_dk_reply.nextval,221, 'test', 'test')
	
	3.---------------------------------------------------------------------------------------
	create table dk_attach(--업로드 테이블
	uuid varchar2(100) not null,
	uploadPath varchar2(200) not null,-- 실제 파일이 업로드된 경로
	fileName varchar2(100) not null, --파일 이름을 의미
	fileType char(1) default 'I', --이미지 파일 여부를판단
	NUM number(10,0) -- 해당 게시물 번호를 저장
	);
	
	alter table dk_attach add constraint pk_attach primary key (uuid);
	alter table dk_attach add constraint fk_board_attach foreign key (NUM) references DK_BOARD(NUM);
	
	insert into dk_attach(uuid, uploadPath, fileName, NUM)
	values ('11', '테스트 제목','테스트 내용',3);
	
	DROP TABLE dk_attach PURGE;
	
	4.------------------------------------------------------------------------------------------
	create table dk_member(--회원 테이블
	      userId varchar2(50) not null primary key,
	      userPw varchar2(100) not null,
	      nickName varchar2(100) not null,
	      email varchar2(100) not null,
	      phoneNum varchar2(50),
	      cash number(10,0) default 0,
	      bankName varchar2(50),
	      account varchar2(50),
	      regDate date default sysdate, 
	      loginDate date default sysdate,
	      enabled char(1) default '1'
	);
	
	drop table dk_member purge 
	
	5.------------------------------------------------------------------------------------------
	create table dk_member_auth (--인증 테이블
	     userId varchar2(50) not null,
	     auth varchar2(50) default 'ROLE_USER',
	     constraint fk_member_auth foreign key(userId) references dk_member(userId)
	);
	
	drop table dk_member_auth purge 
	
	create table persistent_logins (
		username varchar(64) not null,--username은 userid임
		series varchar(64) primary key,
		token varchar(64) not null,
		last_used timestamp not null
	);
	--테이블을 생성하는 스크립트는 특정한 데이터베이스에 맞게 테이블 이름과 칼럼명을 제
	--외한 칼럼의 타입 등을 적당히 조정해서 사용하면 됩니다. 오라클에서는 varchar를 그대
	--로 이용하거나 varchar2로 변경해서 사용하면 됩니다
	
	6.-----------------------------------------------------
	테이블 복사 방법
	테이블은 이미 생성되어 있고 데이터만 복사 (테이블 구조가 동일할 때)
	
	INSERT INTO 복사할테이블명 SELECT * FROM 테이블명 [WHERE 절]
	
	EX) INSERT INTO TB_BOARD_TEMP SELECT * FROM TB_BOARD
	
	테이블은 이미 생성되어 있고 데이터만 복사 (테이블 구조가 다를 때)
	
	INSERT INTO 복사할테이블명 (NUM, TITLE, CONTENTS) SELECT NUM, TITLE, CONTENTS FROM 테이블명
	
	EX) INSERT INTO TB_BOARD_TEMP (NUM, TITLE, CONTENTS) SELECT NUM, TITLE, CONTENTS FROM TB_BOARD
	
	출처: https://server-engineer.tistory.com/500 [HelloWorld]
	
	-----------------------------------------------------
	7.게시글 좋아요 테이블
	create table dk_board_like (
		 userId varchar2(50) not null,
	     num number(10,0) not null,
	     likeValue varchar2(50) not null,--좋아요 눌르면 push,다시 눌르면 pull
	     constraint fk_board_like foreign key(num) references DK_BOARD(num) on delete cascade
	);
	
	drop table dk_board_like purge
	-----------------------------------------------------
	8.게시글 싫어요 테이블
	create table dk_board_dislike (
		 userId varchar2(50) not null,
	     num number(10,0) not null,
	     dislikeValue varchar2(50) not null,--싫어요 눌르면 push,다시 눌르면 pull
	     constraint fk_board_dislike foreign key(num) references DK_BOARD(num) on delete cascade
	);
	
	drop table dk_board_dislike purge
	-----------------------------------------------------
	9.댓글 좋아요 테이블
	create table dk_reply_like (
		 userId varchar2(50) not null,
	     reply_num number(10,0) not null,
	     likeValue varchar2(50) not null,--좋아요 눌르면 push,다시 눌르면 pull
	     constraint fk_reply_like foreign key(reply_num) references DK_REPLY(reply_num) on delete cascade
	);
	
	drop table dk_reply_like purge
	
	-----------------------------------------------------
	10.댓글 싫어요 테이블
	create table dk_reply_dislike (
		 userId varchar2(50) not null,
	     reply_num number(10,0) not null,
	     dislikeValue varchar2(50) not null,--싫어요 눌르면 push,다시 눌르면 pull
	     constraint fk_reply_dislike foreign key(reply_num) references DK_REPLY(reply_num) on delete cascade
	);
	
	drop table dk_reply_dislike purge
	
	-----------------------------------------------------
	11. 스크랩 테이블
	create table dk_scrap (
		 scrap_num number(10,0),
	     userId varchar2(50) not null,
	     NUM number(10,0) not null,
	     constraint fk_scrap foreign key(NUM) references dk_board(NUM) on delete cascade,
    	 constraint pk_scrap PRIMARY KEY (scrap_num)
    	 --constraint pk_scrap PRIMARY KEY (userId, NUM)
);
	create sequence seq_dk_scrap
	--create index idx_scrap on dk_scrap(scrap_num desc);
	drop table dk_scrap purge
	
	12.캐시내역 테이블
	create table dk_cash (
		 cash_num number(10,0),--pk
		 cashKind varchar2(50) not null,--충전,환전,기부하기,기부받기
		 cashAmount number(10,0) not null,
		 regDate date default sysdate, 
		 userId varchar2(50) not null,
		 specification varchar2(50) not null,--승인중/승인완료
		 board_num number(10,0) not null,
		 reply_num number(10,0),
		 constraint fk_cash_board_num foreign key(board_num) references dk_board(NUM),
		 constraint fk_cash_reply_num foreign key(reply_num) references dk_reply(reply_num),
		 constraint pk_cash PRIMARY KEY (cash_num)
	);
	
	14.기타 -----------------------------------------------------
	컬럼추가
	ALTER TABLE DK_BOARD ADD userId VARCHAR2(50) NOT NULL;
	ALTER TABLE DK_member ADD cash number(10,0) default 0;
	ALTER TABLE DK_BOARD ADD(userId VARCAHR2(50) not null); 
	컬럼 이름 변경
	ALTER TABLE dk_board RENAME COLUMN down TO dislikeCnt;
	ALTER TABLE DK_member RENAME COLUMN updateDate TO logindate;
	컬럼 디폴트 값 변경
	ALTER TABLE dk_board MODIFY (BLIND DEFAULT '미적용');
	데이터 배로 증가
	insert into tbl_board(bno, title, content, writer)
	(select seq_board.nextval, title, content, writer from tbl_board);
	

