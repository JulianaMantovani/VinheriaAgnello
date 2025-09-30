package com.vinheria.controller;

import com.vinheria.dao.ProdutoImagemDAO;
import com.vinheria.model.ProdutoImagem;
import software.amazon.awssdk.auth.credentials.DefaultCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.DeleteObjectRequest;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "DeleteProdutoImagemServlet", urlPatterns = {"/admin/delete-produto-imagem"})
public class DeleteProdutoImagemServlet extends HttpServlet {
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
        String idStr = req.getParameter("id");
        if (idStr == null) {
            resp.sendError(400, "id é obrigatório");
            return;
        }
        long id = Long.parseLong(idStr);
        try {
            ProdutoImagemDAO dao = new ProdutoImagemDAO();
            ProdutoImagem pi = dao.getById(id);
            if (pi != null) {
                // remove do S3 primeiro
                s3.deleteObject(DeleteObjectRequest.builder().bucket(bucket).key(pi.getS3Key()).build());
                // remove do banco
                dao.deleteById(id);
            }
        } catch (Exception e) {
            throw new ServletException("Erro ao excluir imagem: " + e.getMessage(), e);
        }
        resp.sendRedirect(req.getContextPath() + "/admin/imagens.jsp?deleted=1");
    }
}
