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

insert into DK_BOARD(CATEGORY, NUM, TITLE, NICKNAME, CONTENT)
values (2, seq_dk_board.nextval, '제목2','닉네임2','콘텐트2');

insert into DK_BOARD(CATEGORY, NUM, TITLE, NICKNAME, CONTENT)
values (3, seq_dk_board.nextval, '제목3','닉네임3','콘텐트3');

insert into DK_BOARD(CATEGORY, NUM, TITLE, NICKNAME, CONTENT)
values (4, seq_dk_board.nextval, '제목4','닉네임4','콘텐트4');

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

DROP TABLE DK_REPLY PURGE;

create sequence seq_dk_reply

alter table DK_REPLY add constraint pk_reply primary key (reply_num);

alter table DK_REPLY add constraint fk_reply_board

foreign key (num) references DK_BOARD (num);

---------------------------------------------------------------------------------------

alter table tbl_board add (replycnt number default 0 );

update tbl_board set replycny = (select count(rno) from tbl_reply where tbl_reply.bno = tbl_board.bno);


alter table tbl_board add constraint pk_board 
primary key (bno);

insert into tbl_board(bno, title, content, writer)
values (seq_board.nextval, '테스트 제목','테스트 내용','user00');

--재귀 복사를 통해서 2배씩 증가시킴
insert into tbl_board(bno, title, content, writer)
(select seq_board.nextval, title, content, writer from tbl_board);

select count(*) from tbl_board

--tbl_board 테이블에 pk_board 인덱스를 역순으로 이용해 줄 것
select /*+ INDEX_DESC(tbl_board pk_board) */ * from tbl_board where bno > 0

select * /*+ INDEX_DESC(tbl_board pk_board) */ from tbl_board where bno > 0


select * from tbl_board where bno = 26746;

select rownum rn, bno, title from tbl_board

select /* INDEX_ASC(tbl_board pk_board) */ rownum rn, bno, title, content from tbl_board where rownum <=10

select bno, title, content from ( 
select /*+ INDEX_DESC(tbl_board pk_board) */ rownum rn, bno, title, content from tbl_board where rownum <= 20 
) where rn >10;




