## 버전정보
### 협업 및 배포
- 이슈관리: Jira
- 형상관리: Gitlab
- 빌드/배포 관리: Jenkins
- 커뮤니케이션: Mattermost, Notion, Discord
- 디자인: Figma

### 개발환경
**1. 서버: AWS EC2**
- Ubuntu 20.04 LTS
- Nginx 1.18.0
- OpenSSL 1.1.1f

**2. IDE**
- IntelliJ IDEA 2023.03.02
- Android Studio 2023.2.1 Patch 1
- Terminus

**3. Front-End**
- Flutter SDK 3.19.5

**4. Back-End**
- Java 17
- SpringBoot 3.2.5
- MySQL 8.3.0
  
<br>

## 설정

### 1. Jenkins 설치
```
$ cd /home/ubuntu

$ mkdir jenkins-data

$ sudo chown -R 1000:1000 /home/ubuntu/jenkins-data

$ cd /home/ubuntu/jenkins-data

$ mkdir update-center-rootCAs

$ wget https://cdn.jsdelivr.net/gh/lework/jenkins-update-center/rootCA/update-center.crt -O ./update-center-rootCAs/update-center.crt

$ sudo sed -i 's#https://updates.jenkins.io/update-center.json#https://raw.githubusercontent.com/lework/jenkins-update-center/master/updates/tencent/update-center.json#' ./hudson.model.UpdateCenter.xml

$ docker restart jenkins

$ docker logs jenkins
```

- 외부에서 :9090 포트로 접근하면 젠킨스 포트인 :8080으로 연결해줌
<br>

### 2. nginx 설정
