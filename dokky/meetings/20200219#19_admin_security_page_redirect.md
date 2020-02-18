# 미팅 기록

## 리뷰 준비 문서

- [https://github.com/ytw9699/Dokky/wiki/02.12~02.18.-%EB%A6%AC%EB%B7%B0](https://github.com/ytw9699/Dokky/wiki/02.12~02.18.-%EB%A6%AC%EB%B7%B0)

## 로그인 리다이렉트 1

- 인터셉터를 구현한건데 파리미터 값까지의 URL이 오지 않는 문제
- getParameter를 통해 값을 얻어오면 full url을 만들 수 있음

## 로그인 리다이렉트 2

- 완전히 해결하지 못한 것에 대한 아쉬움
  - 커뮤니티 사이트에 질문을 해서 같은 고민을 한 사람의 답변을 얻는다.
  - 관련된 글을 찾다 보면 뜻하지 않게 문제 해결의 실마리를 발견할 수 있다.

## 로그인 후에 인증 과정 처리

- 동작 하게만 만든 일련의 로직이 묶여 있는 코드의 문제점 인식
- 느낀점 세번째를 잘 의미를 되살려서, 실제로 리팩토링 해 가면서 만들어 보는 기회가 왔습니다!
  - 지금 있는 코드가 어떤 방식이던 개선이 된다면 좋은 훈련이 될 것 같습니다.
  - 그게 interface or class inheritance or controller or service 뭐든지 간에 개선이 된다면 됩니다.

## tomcat 실행 안되는 문제

- 8080 포트가 열리지 않음 의심해 볼 것
  - pom.xml
  - package update 하기 전으로 rollback
  - 인증서 갱신 문제?
  - tomcat server.xml
  - java update 때문?
    - [https://support.eset.com/en/kb5550-apache-tomcat-is-not-running-service-could-not-starthow-do-i-fix-this-issue-era-6x](https://support.eset.com/en/kb5550-apache-tomcat-is-not-running-service-could-not-starthow-do-i-fix-this-issue-era-6x)
- diff 파일 보는 법 확인하기