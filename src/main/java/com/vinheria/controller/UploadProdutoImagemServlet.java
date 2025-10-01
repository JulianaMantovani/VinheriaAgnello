package com.vinheria.controller;

import com.vinheria.dao.ProdutoDAO;
import com.vinheria.dao.ProdutoImagemDAO;
import com.vinheria.model.ProdutoImagem;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "UploadProdutoImagemServlet", urlPatterns = {"/admin/upload-imagem"})
public class UploadProdutoImagemServlet extends HttpServlet {

    private final ProdutoDAO produtoDAO = new ProdutoDAO();
    private final ProdutoImagemDAO produtoImagemDAO = new ProdutoImagemDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // carrega dados para a tela
            req.setAttribute("produtos", produtoDAO.listarTodos());     // precisa do listarTodos() no ProdutoDAO
            req.setAttribute("imagens", produtoImagemDAO.listAll());    // já existe no seu DAO

            // mensagem de sucesso opcional (após POST + redirect)
            if ("1".equals(req.getParameter("ok"))) {
                req.setAttribute("msgSucesso", "Imagem cadastrada com sucesso!");
            }

            req.getRequestDispatcher("/admin/upload.jsp").forward(req, resp);
        } catch (Exception e) {
            encaminharErro(req, resp, e, "Falha ao carregar página de upload");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String produtoIdStr = req.getParameter("produtoId");  // <select name="produtoId"> no upload.jsp
        String imageUrl     = req.getParameter("imageUrl");    // <input name="imageUrl"> no upload.jsp

        try {
            // validações simples
            if (produtoIdStr == null || produtoIdStr.isBlank()) {
                throw new IllegalArgumentException("Produto é obrigatório.");
            }
            if (imageUrl == null || imageUrl.isBlank()) {
                throw new IllegalArgumentException("URL da imagem é obrigatória.");
            }

            long produtoId = Long.parseLong(produtoIdStr);

            ProdutoImagem img = new ProdutoImagem();
            img.setProdutoId(produtoId);
            // se você usa S3 presigned key, preencha aqui quando tiver: img.setS3Key(...);
            img.setUrl(imageUrl.trim());

            produtoImagemDAO.insert(img);

            // PRG: Post/Redirect/Get para evitar reenvio do formulário
            resp.sendRedirect(req.getContextPath() + "/admin/upload-imagem?ok=1");
        } catch (NumberFormatException e) {
            encaminharErro(req, resp, e, "ID de produto inválido.");
        } catch (IllegalArgumentException | SQLException e) {
            encaminharErro(req, resp, e, e.getMessage());
        } catch (Exception e) {
            encaminharErro(req, resp, e, "Erro inesperado ao salvar imagem.");
        }
    }

    private void encaminharErro(HttpServletRequest req, HttpServletResponse resp, Exception e, String msg)
            throws ServletException, IOException {
        req.setAttribute("errorMessage", msg);
        req.setAttribute("stacktrace", e);
        req.getRequestDispatcher("/error.jsp").forward(req, resp);
    }
}