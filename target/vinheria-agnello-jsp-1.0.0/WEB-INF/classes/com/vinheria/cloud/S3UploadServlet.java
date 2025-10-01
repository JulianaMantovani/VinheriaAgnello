package com.vinheria.cloud;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import software.amazon.awssdk.auth.credentials.DefaultCredentialsProvider;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

import java.io.IOException;
import java.io.InputStream;
import java.time.Instant;
import java.util.Optional;

/**
 * Minimal S3 file upload servlet using AWS SDK v2.
 * Configure via environment:
 *   AWS_REGION=us-east-1
 *   S3_BUCKET=vinheria-agnello-uploads
 *
 * Deploy to Tomcat/Elastic Beanstalk. Ensure IAM role or access keys are configured.
 */
@WebServlet(name = "S3UploadServlet", urlPatterns = {"/upload"})
@MultipartConfig
public class S3UploadServlet extends HttpServlet {

    private S3Client s3;

    @Override
    public void init() throws ServletException {
        String region = Optional.ofNullable(System.getenv("AWS_REGION")).orElse("us-east-1");
        this.s3 = S3Client.builder()
                .region(Region.of(region))
                .credentialsProvider(DefaultCredentialsProvider.create())
                .build();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String bucket = System.getenv("S3_BUCKET");
        if (bucket == null || bucket.isBlank()) {
            resp.sendError(500, "S3_BUCKET env var not set");
            return;
        }
        Part filePart = req.getPart("file");
        if (filePart == null || filePart.getSize() == 0) {
            resp.sendError(400, "No file");
            return;
        }
        String key = "uploads/" + Instant.now().toEpochMilli() + "-" + PathSanitizer.clean(filePart.getSubmittedFileName());
        try (InputStream in = filePart.getInputStream()) {
            s3.putObject(PutObjectRequest.builder()
                            .bucket(bucket)
                            .key(key)
                            .contentType(filePart.getContentType())
                            .build(),
                    RequestBody.fromInputStream(in, filePart.getSize()));
        }
        resp.sendRedirect(req.getContextPath() + "/upload.jsp?ok=1&key=" + key);
    }

    // Simple filename cleaner
    static class PathSanitizer {
        static String clean(String name) {
            if (name == null) return "file";
            return name.replaceAll("[^a-zA-Z0-9._-]", "_");
        }
    }
}
