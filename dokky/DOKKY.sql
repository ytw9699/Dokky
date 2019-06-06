create table DK_BOARD (
  CATEGORY number(10,0) not null,-- 1~10번 게시판
  NUM number(10,0),--PK
  TITLE varchar2(200) not null,
  NICKNAME varchar2(50) not null,
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

---------------------------------------------------------------------------------------

create table DK_REPLY (
reply_num number(10,0),
num number(10,0) not null,
reply_content varchar2(1000) not null,
nickName varchar2(50) not null,
replyDate date default sysdate,
updateDate date default sysdate,
up number(10,0) default 0,
down number(10,0) default 0,
money number(10,0) default 0
);
alter table DK_REPLY add constraint pk_reply primary key (reply_num);

alter table DK_REPLY add constraint fk_reply_board foreign key (num) references DK_BOARD (num);

create sequence seq_dk_reply

create index idx_reply on DK_REPLY(num desc, reply_num asc);

DROP TABLE DK_REPLY PURGE;

select /* INDEX(dk_reply idx_reply) */
rownum rn,num,reply_num,reply_content,nickname from dk_reply where num =221 and reply_num > 0

insert into dk_reply(reply_num,num,reply_content,nickName) values (seq_dk_reply.nextval,221, 'test', 'test')

---------------------------------------------------------------------------------------


