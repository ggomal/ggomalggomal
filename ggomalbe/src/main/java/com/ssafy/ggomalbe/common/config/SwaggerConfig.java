package com.ssafy.ggomalbe.common.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.servers.Server;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

@Configuration
@RequiredArgsConstructor
public class SwaggerConfig {

    @Bean
    public OpenAPI customOpenAPI(){
        // ** Security 관련 설정 추가하기

        Server localhost = new Server();
        localhost.setUrl("http://localhost:8080");
        Server server = new Server();
        server.setUrl("https://k10e206.p.ssafy.io");

        return new OpenAPI()
                .info(new Info()
                        .title("ggomal API")
                        .description("꼬말꼬말 API")
                        .version("1.0"))
                .servers(List.of(localhost, server));
    }

}
