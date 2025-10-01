package com.vinheria.controller;

import com.vinheria.dao.ProdutoDAO;
import com.vinheria.model.Produto;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/produto")
public class ProdutoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");
        if (idParam == null || idParam.isBlank()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parâmetro id é obrigatório.");
            return;
        }

        long id;
        try {
            id = Long.parseLong(idParam);
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "id inválido.");
            return;
        }

        ProdutoDAO produtoDAO = new ProdutoDAO();
        try {
            Produto produto = produtoDAO.buscarPorId(id);
            if (produto == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Produto não encontrado.");
                return;
            }

            // relacionados bem simples: últimos itens
            List<Produto> relacionados = produtoDAO.buscarRecentes(4);

            req.setAttribute("produto", produto);
            req.setAttribute("relacionados", relacionados);

            req.getRequestDispatcher("/produto.jsp").forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException("Erro ao buscar produto", e);
        }
    }
}