package com.vinheria.cloud;

import software.amazon.awssdk.auth.credentials.DefaultCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.model.GetObjectRequest;
import software.amazon.awssdk.services.s3.presigner.S3Presigner;
import software.amazon.awssdk.services.s3.presigner.model.GetObjectPresignRequest;

import java.net.URL;
import java.time.Duration;
import java.util.Optional;

public class S3PresignUtil {

    private static S3Presigner presigner() {
        String region = Optional.ofNullable(System.getenv("AWS_REGION")).orElse("us-east-1");
        return S3Presigner.builder()
                .region(Region.of(region))
                .credentialsProvider(DefaultCredentialsProvider.create())
                .build();
    }

    public static String presignGet(String bucket, String key, int minutes) {
        try (S3Presigner sp = presigner()) {
            GetObjectRequest get = GetObjectRequest.builder()
                    .bucket(bucket)
                    .key(key)
                    .build();
            GetObjectPresignRequest req = GetObjectPresignRequest.builder()
                    .signatureDuration(Duration.ofMinutes(minutes))
                    .getObjectRequest(get)
                    .build();
            URL url = sp.presignGetObject(req).url();
            return url.toString();
        }
    }
}
