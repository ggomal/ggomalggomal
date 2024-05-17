### Jenkins

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/5ef29654-946f-4834-a611-ccd62131e499/2319f81d-fc77-4272-bcd3-95c1c82a717e/Untitled.png)

**특징**

- 세계적으로 많은 개발자들이 사용하기 때문에 많은 레퍼런스가 존재한다.
- 많은 플러그인을 제공하기 때문에 Git 연동, EC2와의 통신을 위한 SSH등이 편리하다.
- 웹 인터페이스를 제공하여 사용이 편리하다. 설치만 하면 CLI가 아니라 GUI로 이용가능하다.
- Java 기반이라 JDK, Gradle, Maven의 설정이 편리하다.

**역할**

1. 개발자가 git에 코드를 통합하면
2. git clone
3. 프로젝트 빌드
4. 빌드한 파일을 앱을 실행할 서버로 전달하고, 앱 구동을 위한 명령어 실행

### Jenkins 설치 
-> docker 이미지로 설치

### Jenkins plugin 설치
- 기본 설치 + Gitlab, Docker pipeline, Nodejs 

### Credential 등록하기
1. aws .pem key 
2. gitlab
3. docker hub
4. application.yml

### Jenkins 파이프라인 생성

### Webhook 걸기
BE + FE -> master
=> BE와 FE에 따로따로 webhook을 걸어주자.

