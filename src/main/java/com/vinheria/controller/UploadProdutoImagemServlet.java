package com.vinheria.controller;

import com.vinheria.dao.ProdutoImagemDAO;
import com.vinheria.model.ProdutoImagem;
import software.amazon.awssdk.auth.credentials.DefaultCredentialsProvider;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.time.Instant;
import java.util.Optional;

@WebServlet(name = "UploadProdutoImagemServlet", urlPatterns = {"/admin/upload-produto-imagem"})
@MultipartConfig
public class UploadProdutoImagemServlet extends HttpServlet {
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
            resp.sendError(500, "S3_BUCKET não configurado");
            return;
        }
        String produtoIdStr = req.getParameter("produtoId");
        if (produtoIdStr == null || produtoIdStr.isBlank()) {
            resp.sendError(400, "produtoId é obrigatório");
            return;
        }
        long produtoId = Long.parseLong(produtoIdStr);
        Part filePart = req.getPart("file");
        if (filePart == null || filePart.getSize() == 0) {
            resp.sendError(400, "Arquivo ausente");
            return;
        }
        String safeName = filePart.getSubmittedFileName().replaceAll("[^a-zA-Z0-9._-]", "_");
        String key = "produto/" + produtoId + "/" + Instant.now().toEpochMilli() + "-" + safeName;

        try (InputStream in = filePart.getInputStream()) {
            s3.putObject(PutObjectRequest.builder()
                            .bucket(bucket)
                            .key(key)
                            .contentType(filePart.getContentType())
                            .build(),
                    RequestBody.fromInputStream(in, filePart.getSize()));
        }

        String url = "s3://" + bucket + "/" + key;

        // Salva no banco
        try {
            ProdutoImagemDAO dao = new ProdutoImagemDAO();
            ProdutoImagem pi = new ProdutoImagem();
            pi.setProdutoId(produtoId);
            pi.setS3Key(key);
            pi.setUrl(url);
            dao.insert(pi);
        } catch (Exception e) {
            // Obs: em caso de erro de DB, o objeto fica no S3; considere fila/rollback em produção
            throw new ServletException("Erro ao salvar no banco: " + e.getMessage(), e);
        }

        resp.sendRedirect(req.getContextPath() + "/admin/imagens.jsp?ok=1&produtoId=" + produtoId);
    }
}
