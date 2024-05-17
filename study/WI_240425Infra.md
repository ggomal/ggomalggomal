## nginx 설정
### /etc/nginx/nginx.conf
```
user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
        worker_connections 768;
        # multi_accept on;
}

http {

        ##
        # Basic Settings
        ##

        sendfile on;
        tcp_nopush on;
        tcp_nodelay on;
        keepalive_timeout 65;
        types_hash_max_size 2048;
        # server_tokens off;

        # server_names_hash_bucket_size 64;
        # server_name_in_redirect off;

        include /etc/nginx/mime.types;
        default_type application/octet-stream;

        ##
        # SSL Settings
        ##

        ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3; # Dropping SSLv3, ref: POODLE
        ssl_prefer_server_ciphers on;

        ##
        # Logging Settings
        ##

        access_log /var/log/nginx/access.log;
        error_log /var/log/nginx/error.log;

        ##
        # Gzip Settings
        ##

        gzip on;

        # gzip_vary on;
        # gzip_proxied any;
        # gzip_comp_level 6;
        # gzip_buffers 16 8k;
        # gzip_http_version 1.1;
        # gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

        ##
        # Virtual Host Configs
        ##

        # include /etc/nginx/conf.d/*.conf;
        include /etc/nginx/sites-enabled/ggomal.conf;
}

#mail {
#       # See sample authentication script at:
#       # http://wiki.nginx.org/ImapAuthenticateWithApachePhpScript
#
#       # auth_http localhost/auth.php;
#       # pop3_capabilities "TOP" "USER";
#       # imap_capabilities "IMAP4rev1" "UIDPLUS";
#
#       server {
#               listen     localhost:110;
#               protocol   pop3;
#               proxy      on;
#       }
#
#       server {
#               listen     localhost:143;
#               protocol   imap;
#               proxy      on;
#       }
#}
```

<br>

### /etc/nginx/sites-available/ggomal.conf
```
server {
    listen       80;
    server_name  k10e206.p.ssafy.io;
    root         html;
  
        location / {
        return 301 https://k10e206.p.ssafy.io$request_uri;
    }
}

server {
  listen 443 ssl http2;


  # ssl 인증서 적용하기
  ssl_certificate /etc/letsencrypt/live/k10e206.p.ssafy.io/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/k10e206.p.ssafy.io/privkey.pem;

  location / { # location 이후 특정 url을 처리하는 방법을 정의(여기서는 / -> >즉, 모든 request)
    proxy_pass http://localhost:3000;
    proxy_set_header Host $http_host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
  }

  location /swagger-ui {
    proxy_pass http://localhost:8080/swagger-ui;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
  }

  location /api/v1 {
    proxy_pass http://localhost:8080;
    proxy_set_header Host $http_host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;

  }

  location /fast {
            proxy_pass http://localhost:5000;
    }
}
```


→ 이렇게 하고 symlink로 연결해주고 nginx restart 했는데 502 bad gateway 발생

<br>

## Mysql 설정
1. Docker compose 로 연결
    ```
    volumes:
        mysql_vol:
            external: true
            name: mysql_vol
    services:
        mysql:
            container_name: mysql
            image: mysql:latest
            restart: always
            ports:
                - "3306:3306"
            environment:
                - TZ=Asia/Seoul
                - MYSQL_ROOT_PASSWORD=password
            command:
                - --character-set-server=utf8mb4
                - --collation-server=utf8mb4_unicode_ci
            volumes:
                - mysql_vol:/var/lib/mysql
    ```
2. volume 설정
    ```nginx
    # 도커 볼륨 생성
    $ docker volume create [volume-name]

    # 도커 볼륨 조회
    $ docker volume ls

    # 도커 볼륨 정보 확인
    $ docker volume inspect [volume-name]

    # 도커 볼륨 삭제
    $ docker volume rm [volume-name]

    # 도커 볼륨 전체 삭제
    $ docker volume prune    
    ```

→ 이렇게 하면 컨테이너를 지웠다가 재실행 시켜도 데이터 영속성이 보장된다.