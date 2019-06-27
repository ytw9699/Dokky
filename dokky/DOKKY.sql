1.-----------------------------------------------------
ALTER TABLE DK_BOARD ADD(userId VARCAHR2(50) not null); 

create table DK_BOARD (
  CATEGORY number(10,0) not null,-- 1~10번 게시판
  NUM number(10,0),--PK
  TITLE varchar2(200) not null,
  NICKNAME varchar2(50) not null,
  userId varchar2(50) not null,
  CONTENT varchar2(4000) not null,
  STATUS varchar2(50) default '정상',
  REGDATE date default sysdate, 
  UPDATEDATE date default sysdate,
  UP number(10,0) default 0,
  DOWN number(10,0) default 0,
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

create table DK_REPLY (
reply_num number(10,0),
num number(10,0) not null,
reply_content varchar2(1000) not null,
nickName varchar2(50) not null,
userId varchar2(50) not null,
replyDate date default sysdate,
updateDate date default sysdate,
up number(10,0) default 0,
down number(10,0) default 0,
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
create table dk_attach(
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

create table dk_member(
      userId varchar2(50) not null primary key,
      userPw varchar2(100) not null,
      nickName varchar2(100) not null,
      email varchar2(100) not null,
      phoneNum varchar2(50),
      bankName varchar2(50),
      account varchar2(50),
      regDate date default sysdate, 
      updateDate date default sysdate,
      enabled char(1) default '1'
);

drop table dk_member purge 

create table dk_member_auth (
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

5.-----------------------------------------------------
테이블 복사 방법
테이블은 이미 생성되어 있고 데이터만 복사 (테이블 구조가 동일할 때)

INSERT INTO 복사할테이블명 SELECT * FROM 테이블명 [WHERE 절]

EX) INSERT INTO TB_BOARD_TEMP SELECT * FROM TB_BOARD

6.-----------------------------------------------------
테이블은 이미 생성되어 있고 데이터만 복사 (테이블 구조가 다를 때)

INSERT INTO 복사할테이블명 (NUM, TITLE, CONTENTS) SELECT NUM, TITLE, CONTENTS FROM 테이블명

EX) INSERT INTO TB_BOARD_TEMP (NUM, TITLE, CONTENTS) SELECT NUM, TITLE, CONTENTS FROM TB_BOARD

출처: https://server-engineer.tistory.com/500 [HelloWorld]
-----------------------------------------------------
7. -----------------------------------------------------
컬럼추가
ALTER TABLE DK_BOARD ADD userId VARCHAR2(50) NOT NULL;
