package org.my.domain.chat;

public enum ChatMessageType {
	
	CHAT, //채팅할때
	OPEN, //기존의 채팅 방을 열때 or 내가 채팅방을 새롭게 만들때
	IN, //만들어진 1:1채팅방에 재입장할때(현재는 1:1채팅방에 한정)
	CLOSED, //방을 닫을때
	INVITE, //초대할때
	LEAVE, //방에서 나갈때
	TITLE, //제목바꿀때
	READ //메시지 읽을때
}

