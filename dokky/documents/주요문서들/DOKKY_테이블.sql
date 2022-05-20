	1.-----------------------------------------------------
	
	create table DK_BOARD (--게시판 테이블
	
		  CATEGORY number(10,0) not null,-- 0~5번 게시판
		  BOARD_NUM number(10,0),--PK --글번호
		  TITLE varchar2(200) not null, --글제목
		  NICKNAME varchar2(50) not null, --작성자 닉네임
 		  userId varchar2(50) not null, -- 작성자 아이디
		  CONTENT varchar2(4000) not null, --글 내용
		  REGDATE date default sysdate, --글 작성날짜
		  UPDATEDATE date default sysdate, -- 글 수정 날짜
		  likeCnt number(10,0) default 0, -- 좋아요 수
		  dislikeCnt number(10,0) default 0, --싫어요 수
		  MONEY number(10,0) default 0, -- 기부금액
		  HITCNT number(10,0) default 0, -- 조회수
		  REPLYCNT number(10,0) default 0, -- 댓글수 (게시물 목록조회는 많이 일어나기 때문에, 댓글수를 조인을 통해가져오기 보다는 컬럼을 추가해준것이다. 역정규화)
		  constraint PK_DK_BOARD primary key(BOARD_NUM) --PK
	);
	
	--delete_check number(10,0) default 0,	
	--BLIND varchar2(10) default '미적용',
	--STATUS varchar2(10) default '정상', 
	
	create sequence seq_dk_board;
	
	DROP TABLE DK_BOARD PURGE;
	
	insert into DK_BOARD(CATEGORY, NUM, TITLE, NICKNAME, CONTENT)
	values (1, seq_dk_board.nextval, '제목1','닉네임1','콘텐트1');
	
	--디폴트값 입력 필요 캐시 충전
	insert into DK_BOARD(CATEGORY, board_NUM, TITLE, NICKNAME, CONTENT,userId)
	values (0, 0, '디폴트','디폴트','디폴트','admin');
	
	2.---------------------------------------------------------------------------------------
	
	create table DK_REPLY (--댓글 테이블
	
		reply_num number(10,0), --pk
		board_num number(10,0) not null, --게시글 번호
		reply_content varchar2(4000) not null,--댓글 내용
		nickName varchar2(50) not null,  --댓글 작성자 닉네임
		userId varchar2(50) not null, --댓글 작성자 아이디
		toUserId varchar2(50), --댓글의 답글 보낼 아이디
		toNickName varchar2(50),--댓글의 답글 보낼 닉네임
		replyDate date default sysdate,--작성날짜
		updateDate date default sysdate, --수정날짜
		likeCnt number(10,0) default 0, --좋아요 수
		dislikeCnt number(10,0) default 0, --싫어요 수
		money number(10,0) default 0, --기부금
		group_num number(10,0) not null,--댓글 묶음 번호 , 그룹을 이루는 번호
		order_step number(10,0) not null,--댓글 출력 순서
		depth number(10,0) not null--댓글 깊이 depth = 루트글인지,답변글인지,답변에 답변글인지..답변에 답변에 답변인지 쭉~
	);

	--delete_check varchar2(10) default 'possible'
	
	alter table DK_REPLY add constraint pk_reply primary key (reply_num);
	
	alter table DK_REPLY add constraint fk_reply_board foreign key (board_num) references DK_BOARD (board_num) on delete cascade;--on delete cascade는 자식테이블을 같이 삭제시켜줌
	
	create sequence seq_dk_reply
	
	create index idx_reply on DK_REPLY(board_num desc, reply_num asc);--430p
	--글번호 desc순 + 댓글 asc순으로 정렬되어야함 그래야 성능상 문제가 없음 , 즉 게시물의 번호에 맞게 댓글들을 모아서 빠르게 찾을수 있는 구조로 만든것, range scan사용
	
	--디폴트값입력해줘야 캐시충전됨
	insert into dk_reply(reply_num, board_num, reply_content, nickName, userId, group_num, order_step, depth)
	 values (0,0, '디폴트', '디폴트','admin',0,0,0)
	 
	DROP TABLE DK_REPLY PURGE;
	
	insert into dk_reply(reply_num, board_num, reply_content, nickName) values (seq_dk_reply.nextval,221, 'test', 'test')
	
	insert into DK_REPLY(reply_num, board_num, reply_content, nickName,userId)
	(select seq_dk_reply.nextval, board_num, reply_content, nickName from DK_REPLY);
	
	3.------------------------------------------------------------------------------------------
	create table dk_member(--뉴 회원 테이블
	
		  member_num number(10,0) unique,
	      userId varchar2(50) primary key,
	      userPw varchar2(100) not null,
	      nickName varchar2(100) not null unique,
	      cash number(10,0) default 0,
	      bankName varchar2(50),
	      account varchar2(50),
	      regDate date default sysdate, 
	      preLoginDate date default sysdate, --가장 마지막 이전의 로그인 날짜
	      lastLoginDate date default sysdate, -- 가장 마지막 로그인날짜
	      enabled char(1) default '1'-- 계정의 활성 비활성 여부 
	      accountNonLocked char(1) default '1'-- 계정의 잠금 여부
	);
	
	https://codedragon.tistory.com/6159
	
	create sequence seq_dk_member
	
	drop table dk_member purge 
	
	insert into dk_member(member_num, userId, userPw, nickName) values (seq_dk_member.nextval, 'admin', 'admin', '슈퍼관리자')
	
	5.------------------------------------------------------------------------------------------
	create table dk_member_auth (--권한 테이블
	
	     userId varchar2(50) not null,
	     auth varchar2(50) default 'ROLE_USER',
	     constraint fk_member_auth foreign key(userId) references dk_member(userId)
	);
	
	insert into dk_member_auth(userId, auth) values ('admin','ROLE_SUPER');
	
	drop table dk_member_auth purge 
	
	4.---------------------------------------------------------------------------------------
	create table DK_NOTE (--쪽지 테이블
		  NOTE_NUM number(10,0),--PK --쪽지 번호
		  CONTENT varchar2(4000) not null, --쪽지 내용
		  FROM_NICKNAME varchar2(50) not null, --보낸 닉네임
 		  FROM_ID varchar2(50) not null, --보낸 아이디
 		  TO_NICKNAME varchar2(50) not null, --받는 닉네임
 		  TO_ID varchar2(50) not null, --받는 아이디
		  REGDATE date default sysdate, --쪽지 작성날짜
		  read_check VARCHAR2(10) DEFAULT 'NO',--쪽지 읽음 체크
		  from_check VARCHAR2(10) DEFAULT 'NO',--보낸쪽지함 삭제 체크
		  to_check VARCHAR2(10) DEFAULT 'NO',--받은쪽지함 삭제 체크
		  constraint PK_DK_NOTE primary key(NOTE_NUM) --PK
	);
	
	create sequence seq_dk_note;
	
	DROP TABLE DK_NOTE PURGE;
	
	insert into DK_NOTE(NOTE_NUM, CONTENT, FROM_NICKNAME, FROM_ID, TO_NICKNAME, TO_ID) values (seq_dk_note.nextval,'테스트','관리자','admin','관리자','admin')
	
	4.---------------------------------------------------------------------------------------
	create table dk_attach(--업로드 테이블
	
		uuid varchar2(100) not null,
		uploadPath varchar2(200) not null,-- 실제 파일이 업로드된 경로
		fileName varchar2(100) not null, --파일 이름을 의미
		fileType char(1) default 'I', --이미지 파일 여부를판단
		board_num number(10,0) -- 해당 게시물 번호를 저장
	);
	
	alter table dk_attach add constraint pk_attach primary key (uuid);
	alter table dk_attach add constraint fk_board_attach foreign key (board_num) references DK_BOARD(board_num);
	
	insert into dk_attach(uuid, uploadPath, fileName, board_num)
	values ('11', '테스트 제목','테스트 내용',3);
	
	DROP TABLE dk_attach PURGE;
	
	
	
	6.------------------------------------------------------------------------------------------
	create table persistent_logins ( --인증 테이블
	
		username varchar(64) not null,--username은 userid임
		series varchar(64) primary key,
		token varchar(64) not null,
		last_used timestamp not null
	);
	--테이블을 생성하는 스크립트는 특정한 데이터베이스에 맞게 테이블 이름과 칼럼명을 제
	--외한 칼럼의 타입 등을 적당히 조정해서 사용하면 됩니다. 오라클에서는 varchar를 그대
	--로 이용하거나 varchar2로 변경해서 사용하면 됩니다
	
	-----------------------------------------------------
	7.게시글 좋아요 테이블
	create table dk_board_like (
	
		 userId varchar2(50) not null,
	     board_num number(10,0) not null,
	     constraint fk_board_like foreign key(board_num) references DK_BOARD(board_num) on delete cascade
	);
	
	drop table dk_board_like purge
	-----------------------------------------------------
	8.게시글 싫어요 테이블
	create table dk_board_dislike (
	
		 userId varchar2(50) not null,
	     board_num number(10,0) not null,
	     constraint fk_board_dislike foreign key(board_num) references DK_BOARD(board_num) on delete cascade
	);
	
	drop table dk_board_dislike purge
	-----------------------------------------------------
	9.댓글 좋아요 테이블
	create table dk_reply_like (
	
		 userId varchar2(50) not null,
	     reply_num number(10,0) not null,
	     constraint fk_reply_like foreign key(reply_num) references DK_REPLY(reply_num) on delete cascade
	);
	
	drop table dk_reply_like purge
	
	-----------------------------------------------------
	10.댓글 싫어요 테이블
	create table dk_reply_dislike (
	
		 userId varchar2(50) not null,
	     reply_num number(10,0) not null,
	     constraint fk_reply_dislike foreign key(reply_num) references DK_REPLY(reply_num) on delete cascade
	);
	
	drop table dk_reply_dislike purge
	
	-----------------------------------------------------
	11. 스크랩 테이블
	create table dk_scrap (
	
		 scrap_num number(10,0),
	     userId varchar2(50) not null,
	     board_num number(10,0) not null,
	     regDate date default sysdate,
	     constraint pk_scrap PRIMARY KEY (scrap_num),
	     constraint fk_scrap foreign key(board_num) references dk_board(board_num) on delete cascade
    	 --constraint pk_scrap PRIMARY KEY (userId, NUM)
	);
	
	create sequence seq_dk_scrap
	--create index idx_scrap on dk_scrap(scrap_num desc);
	drop table dk_scrap purge
	
	12.캐시내역 테이블
	create table dk_cash (
		 cash_num number(10,0),--pk
		 cashKind varchar2(50) not null, --충전,환전,기부하기,기부받기
		 cashAmount number(10,0) not null,
		 regDate date default sysdate, 
		 userId varchar2(50) not null,
		 nickName varchar2(50), -- 반드시 not null 이면 안됨 
		 specification varchar2(50), --미승인/승인완료
		 board_num number(10,0) default 0,
		 reply_num number(10,0) default 0,
		 constraint pk_cash PRIMARY KEY (cash_num)
	);
	
	 --reply_num number(10,0) default 0,--무결성제약조건에 걸리지않기 위해 디폴트값 입력바람
	 --constraint fk_cash_board_num foreign key(board_num) references dk_board(NUM),
	 --constraint fk_cash_reply_num foreign key(reply_num) references dk_reply(reply_num),
	
	create sequence seq_dk_cash
	
	drop table dk_cash purge
	
	insert into dk_cash (
							cash_num,
							cashKind,
							cashAmount,
							userId,
							specification,
							board_num
							) values 
										(
										seq_dk_cash.nextval,
										'기부하기',
										10,
										'admin90',
										'게시판' ,
										684
										)
	
										12.캐시내역 테이블
14.신고테이블 -----------------------------------------------------
	create table dk_report (
	
		 report_num number(10,0), --pk
		 reportKind varchar2(50) not null, --게시글,댓글
		 reportingId varchar2(50) not null, --신고 하는자 아이디
		 reportingNick varchar2(50) not null, --신고 하는자 닉네임
		 reportedId varchar2(50) not null, --신고 받는자 아이디
		 reportedNick varchar2(50) not null, --신고 받는자 닉네임
		 board_num number(10,0) default 0, --글번호  
		 reason varchar2(200) not null, --사유
		 regDate date default sysdate, --신고날짜
		 constraint pk_report PRIMARY KEY (report_num)
	);

	--constraint fk_report_board_num foreign key(board_num) references dk_board(NUM),
	
	create sequence seq_dk_report
	
	drop table dk_report purge
	
14.방문자 테이블 -----------------------------------------------------

	 CREATE TABLE dk_visitor(
	 
		 visitor_num number(10,0), --기본키
		 ip varchar(100) not null, --접속자 아이피
		 visit_time date default sysdate,  --접속자 접속시간
		 refer varchar(300), --접속자가 어느사이트를 타고 들어왔는지
		 agent varchar(400) not null, --접속자 브라우저 정보
		 constraint pk_visitor PRIMARY KEY (visitor_num)
    )
    
    create sequence seq_dk_visitor
	
	drop table dk_visitor purge
	
14.알림 테이블 -----------------------------------------------------

 CREATE TABLE dk_alarm(
 
		 alarmNum number(10,0), --기본키
		 checking VARCHAR2(10) DEFAULT 'NO',
		 target VARCHAR2(50) NOT NULL,
		 writerNick VARCHAR2(50) NOT NULL,
		 writerId VARCHAR2(50) NOT NULL,
		 kind VARCHAR2(10) NOT NULL,--1~9
		 commonVar1 VARCHAR2(200),
		 commonVar2 VARCHAR2(200),
		 commonVar3 number(10,0),
		 regdate date default sysdate,
		 constraint pk_alarm PRIMARY KEY (alarmNum)
)

insert into dk_alarm( alarmNum, target, writerNick, writerId, kind, commonVar1, commonVar2, 
) VALUES ( seq_dk_alarm.nextval, 'admin90', 'test닉', 'test', '1', 'ff' '742' )

create sequence seq_dk_alarm

drop table dk_alarm purge


15.s3 키관리 테이블 -----------------------------------------------------
create table DK_s3key(
	
		accessKey varchar2(50),
		secretKey varchar2(50)
)
	
insert into DK_s3key( accessKey, secretKey) VALUES ('accessKey', 'secretKey')

	
15. 채팅룸 테이블 -----------------------------------------------------

create table dk_chat_room(
 
		 chatRoomNum number(10,0), --기본키 pk
		 chat_title VARCHAR2(50), -- 방 제목
		 roomOwnerId VARCHAR2(50) NOT NULL, --방장 아이디
		 roomOwnerNick VARCHAR2(50) NOT NULL, --방장 닉네임
		 chat_type number NOT NULL, -- -- 채팅방의 타입 ( 0 = 1:1채팅방 , 1 = 그룹 채팅방) 
		 headCount number NOT NULL, -- 방의 총 인원수
		 constraint pk_chat_room PRIMARY KEY(chatRoomNum)
)


create sequence seq_dk_chat_room;

DROP TABLE dk_chat_room PURGE;

16. 채팅룸의 멤버 테이블 -----------------------------------------------------

create table dk_chat_member(
 
		 chatRoomNum number(10,0) not null,--fk
		 chat_memberId VARCHAR2(50) NOT NULL, -- 채팅룸 멤버 아이디
		 chat_memberNick VARCHAR2(50) NOT NULL, -- 채팅룸 멤버 닉네임
		 recentOutDate date, --방에서 나간 최근 날짜
		 present_position number default 0, --(현재 멤버의 위치) 0 = 방에서 안나감 , 1 = 방에서 나감
		 constraint fk_chat_member foreign key(chatRoomNum) references dk_chat_room(chatRoomNum) on delete cascade
)

DROP TABLE dk_chat_member PURGE;

17. 채팅 내용 테이블-----------------------------------------------------

create table dk_chat_content(
 
		 chatContentNum number(10,0), --pk
		 chatRoomNum number(10,0) not null, --fk
		 chat_content varchar2(4000) not null, --채팅 내용
		 chat_writerId VARCHAR2(50), -- 글쓴이 아이디
		 chat_writerNick VARCHAR2(50), -- 글쓴이 닉네임
		 content_type number default 0,  -- 채팅 내용 종류 (0 = 일반내용 , 1 = 공지내용)
		 readCount number,  -- 현재 읽지 않은 인원수
		 regdate date default sysdate, 
		 constraint pk_chat_content PRIMARY KEY(chatContentNum),
		 constraint fk_chat_content foreign key(chatRoomNum) references dk_chat_room(chatRoomNum) on delete cascade
)

create sequence seq_dk_chat_content;

DROP TABLE dk_chat_content PURGE;

insert into dk_chat_content( chatContentNum, chatRoomNum, chat_content, chat_writerId, chat_writerNick, content_type) 
					VALUES ( seq_dk_chat_content.nextval, 81, 'chat_content', 'admin', '슈퍼관리자', 0)
					
18. 채팅 내용 읽음 여부 테이블-----------------------------------------------------

create table dk_chat_read(
 
		 chatReadNum number(10,0), --pk
		 chatContentNum number(10,0) NOT NULL, --fk
		 chatRoomNum number(10,0) NOT NULL, --fk
		 chat_memberId VARCHAR2(50) NOT NULL, -- 채팅룸 멤버 아이디
		 chat_memberNick VARCHAR2(50) NOT NULL, -- 채팅룸 멤버 닉네임
 		 read_type number default 0, -- 메시지 읽음 여부 (0 = 읽지않음 , 1 = 읽음)
		 constraint pk_chat_read PRIMARY KEY(chatReadNum),
		 constraint fk_chat_read_first foreign key(chatContentNum) references dk_chat_content(chatContentNum) on delete cascade,
		 constraint fk_chat_read_second foreign key(chatRoomNum) references dk_chat_room(chatRoomNum) on delete cascade
)

create sequence seq_dk_chat_read;

DROP TABLE dk_chat_read PURGE;


14.기타 -----------------------------------------------------
	컬럼수정
	alter table dk_board modify(content varchar2(4000) not null)
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
	
	컬럼 값 변경
	update dk_cash set specification = '미승인' where specification = '승인중'
	
	update dk_member_auth set auth = 'ROLE_ADMIN' where userid = 'admin'
	
	시퀀스 삭제
	drop sequence seq_dk_reply ;
	
	테이블 데이터만 삭제
	DELETE FROM DK_REPLY
	
	테이블 깔끔히 삭제
	TRUNCATE TABLE DK_REPLY
	
	인덱스 만드는 방법
	create unique index idx_board_reg_date on boardtable (reg_date, idx) 

6.-----------------------------------------------------
테이블 복사 방법
테이블은 이미 생성되어 있고 데이터만 복사 (테이블 구조가 동일할 때)

INSERT INTO 복사할테이블명 SELECT * FROM 테이블명 [WHERE 절]

EX) INSERT INTO TB_BOARD_TEMP SELECT * FROM TB_BOARD

테이블은 이미 생성되어 있고 데이터만 복사 (테이블 구조가 다를 때)

INSERT INTO 복사할테이블명 (NUM, TITLE, CONTENTS) SELECT NUM, TITLE, CONTENTS FROM 테이블명

EX) INSERT INTO TB_BOARD_TEMP (NUM, TITLE, CONTENTS) SELECT NUM, TITLE, CONTENTS FROM TB_BOARD

출처: https://server-engineer.tistory.com/500 [HelloWorld]

7. 카운트 구하기
select count(*) from dk_board

8. 데이터베이스 통째로 복사

https://parkpurong.tistory.com/156

SELECT * FROM USER_SEQUENCES --시퀀스 전체 조회

select seq_dk_chat_read.nextval from dual -- 시퀀스 증가분 만큼 증가하기

SELECT seq_dk_chat_read.CURRVAL FROM DUAL; -- 시퀀스 현재 값 조회

ALTER SEQUENCE seq_dk_chat_read INCREMENT BY 10652; -- 시퀀스 증가분 변경 특정값으로
ALTER SEQUENCE seq_dk_chat_read INCREMENT BY 1; -- 시퀀스 증가분 변경 다시 1로

--특정 증가분으로 변경시켜 증가시킨후에 다시 1로원위치 시키기

select * from dk_chat_content order by member_NUM desc -- 값 조회해보기




