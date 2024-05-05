package com.ssafy.ggomalbe.common.config;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.enums.SecuritySchemeIn;
import io.swagger.v3.oas.annotations.enums.SecuritySchemeType;
import io.swagger.v3.oas.annotations.security.SecurityScheme;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.parameters.HeaderParameter;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.servers.Server;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

@Configuration
@SecurityScheme(
        name = "AccessToken",
        type = SecuritySchemeType.HTTP,
        in = SecuritySchemeIn.HEADER,
        scheme = "bearer",
        bearerFormat = "JWT"
)
@RequiredArgsConstructor
public class SwaggerConfig {

    private static final String BEARER_TOKEN_PREFIX = "Bearer";

    private Info setInfo(){
        return new Info().title("ggomal API")
                .description("꼬말꼬말 API")
                .version("1.0");
    }

    @Bean
    public OpenAPI customOpenAPI(){
        Server localhost = new Server();
        localhost.setUrl("http://localhost:8080");
        Server server = new Server();
        server.setUrl("https://k10e206.p.ssafy.io");

        HeaderParameter authorizationHeader = new HeaderParameter();
        authorizationHeader.setName("Authorization");
        authorizationHeader.setDescription("Access Token");
        authorizationHeader.setRequired(false);
        authorizationHeader.setSchema(new io.swagger.v3.oas.models.media.StringSchema());


        return new OpenAPI()
                .info(setInfo())
                .servers(List.of(localhost, server))
                .addSecurityItem(new SecurityRequirement().addList("AccessToken"))
                .components(new io.swagger.v3.oas.models.Components()
                        .addParameters("Authorization", authorizationHeader));
    }

}
