package com.ssafy.ggomalbe.common.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import software.amazon.awssdk.regions.Region;

import java.net.URI;

@ConfigurationProperties(prefix = "aws.s3")
@Data
public class S3ClientConfigurationProperties {
    private Region region = Region.AP_SOUTHEAST_2;
    private String accessKeyId;
    private String secretAccessKey;
    private URI endpoint = null;
    private String bucket;

}
