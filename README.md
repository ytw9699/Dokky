## 프로젝트 주제

#### &emsp; Dokky는 개발자 커뮤니티 입니다.

## 프로젝트의 동기

#### &emsp; 기존의 Okky_커뮤니티(https://okky.kr) 에서 불편한 기능들을 개선해 더 편리한 커뮤니티를 만들고 싶었습니다. [프로젝트의 동기](https://github.com/ytw9699/Dokky/blob/master/dokky/documents/mainDocumnets/%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8%EC%9D%98%20%EB%8F%99%EA%B8%B0.md) 


## 프로젝트 도메인 주소

#### &emsp; https://dokky.site

## 테스트 계정
#### &emsp; 아이디 : admin
#### &emsp; 비밀번호 : dokky
#### &emsp; 슈퍼 관리자 로그인 : https://dokky.site/superAdminLogin

## 기술 스택 및 개발 환경
#### &emsp; Java8, Spring-Framework
#### &emsp; Spring-Security, Oauth2-Client
#### &emsp; Oracle11, Mybatis
#### &emsp; AWS ( EC2, RDS, S3 )
#### &emsp; Apache2, Tomcat9
#### &emsp; SSL, WebSocket
#### &emsp; Git, SourceTree
#### &emsp; Maven, Eclipse
#### &emsp; HTML/ CSS / JS / Ajax / jQuery / JSP
#### &emsp; Postman, Restlet Client


## 프로젝트 주요 특징

#### &emsp;1. Spring-Security (세션 기반 인증, 인가)

- 인증 커스텀 구현(AuthenticationProvider, UserDetailsService 및 각종 Handler 처리)
- 일반 유저, 일반 관리자, 슈퍼 관리자로 권한 분리
- 일반유저와 일반관리자의 경우 소셜 로그인 인증
- 슈퍼관리자의 경우 ID/PW 기반 폼 인증 및 자동 로그인 구현
- BCyptPasswordEncoder를 이용한 패스워드 암호화 처리
- CSRF 토큰 처리

#### &emsp;2. OAuth2-Client 와 Spring-Security 연동 인증

- 사용자에게 소셜 로그인(구글, 네이버)으로 인증 편의성 제공
- 사용자의 개인 정보(아이디, 비밀번호)를 관리하지 않아 신뢰성 제공

#### &emsp;3. WebSocket 통신 (채팅, 알림, 쪽지)

- 웹소켓을 통해 실시간 통신 기능들을 구현
- 사용자의 중복 접속을 고려한 웹소켓 세션 관리
- 텍스트 기반의 TextWebSocketHandler를 구현

#### &emsp;4. HTTPS 통신을 위한 SSL 적용

- HTTPS로 암호화 통신( 보안 강화 )
- Let's Encrypt 인증서 발급 후 도메인 적용
- 서버의 검증을 통해 데이터의 위,변조 방지

#### &emsp;5. 클라우드 인프라 구축 및 운영(AWS - EC2, RDS, S3)

- 운영 서버로 EC2(Ubuntu), 이미지와 파일 저장소로 S3 , DB 서버로 RDS 구축
- 서버(EC2, RDS, S3)들을 분리함으로써 안정성 향상

#### &emsp;6. 업로드, 다운로드

- S3를 이용한 파일 및 이미지 업로드, 다운로드 구현
- 이미지의 경우 섬네일 이미지도 생성

## 프로젝트 주요 문서

&emsp; [1. Server Architecture](https://github.com/ytw9699/Dokky/blob/master/dokky/documents/mainDocumnets/ServerArchitecture.md)  
&emsp; [2. 데이터 모델링(개념적, 논리적, 물리적 모델링) ](https://github.com/ytw9699/Dokky/blob/master/dokky/documents/mainDocumnets/%EB%8D%B0%EC%9D%B4%ED%84%B0%EB%AA%A8%EB%8D%B8%EB%A7%81.md)    
&emsp; [3. 데이터 정의](https://github.com/ytw9699/Dokky/blob/master/dokky/documents/mainDocumnets/%EB%8D%B0%EC%9D%B4%ED%84%B0%EC%A0%95%EC%9D%98.md)      
&emsp; [4. 서비스 구현 기능들](https://github.com/ytw9699/Dokky/blob/master/dokky/documents/mainDocumnets/%EC%84%9C%EB%B9%84%EC%8A%A4%20%EA%B5%AC%ED%98%84%20%EA%B8%B0%EB%8A%A5%EB%93%A4.md)  
&emsp; [5. Use Case Diagram ](https://github.com/ytw9699/Dokky/blob/master/dokky/documents/mainDocumnets/UseCaseDiagram.md)  
&emsp; [6. 요구사항 명세서](https://github.com/ytw9699/Dokky/blob/master/dokky/documents/mainDocumnets/%EC%9A%94%EA%B5%AC%EC%82%AC%ED%95%AD%20%EB%AA%85%EC%84%B8%EC%84%9C.md)     
  


			


