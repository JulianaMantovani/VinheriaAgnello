package com.vinheria.controller;

import com.vinheria.dao.ProdutoDAO;
import com.vinheria.model.Produto;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/carrinho")
public class CarrinhoServlet extends HttpServlet {

    @SuppressWarnings("unchecked")
    private Map<Long, Integer> getCarrinho(HttpSession session) {
        Object attr = session.getAttribute("carrinho");
        if (attr == null) {
            Map<Long, Integer> novo = new HashMap<>();
            session.setAttribute("carrinho", novo);
            return novo;
        }
        return (Map<Long, Integer>) attr;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/carrinho.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) action = "add";

        HttpSession session = req.getSession();
        Map<Long, Integer> carrinho = getCarrinho(session);

        switch (action) {
            case "add": {
                String idParam = req.getParameter("id");
                String qtyParam = req.getParameter("qty");

                if (idParam == null || qtyParam == null) {
                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parâmetros id/qty são obrigatórios.");
                    return;
                }

                long id;
                int qty;
                try {
                    id = Long.parseLong(idParam);
                    qty = Math.max(1, Integer.parseInt(qtyParam));
                } catch (NumberFormatException e) {
                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parâmetros inválidos.");
                    return;
                }

                // ✅ TRATANDO SQLException AQUI
                try {
                    Produto produto = new ProdutoDAO().buscarPorId(id);
                    if (produto != null) {
                        carrinho.put(id, carrinho.getOrDefault(id, 0) + qty);
                    }
                } catch (SQLException e) {
                    throw new ServletException("Erro ao buscar produto para o carrinho", e);
                }

                resp.sendRedirect(req.getContextPath() + "/carrinho");
                return;
            }

            case "remove": {
                String idParam = req.getParameter("id");
                if (idParam != null) {
                    try {
                        long id = Long.parseLong(idParam);
                        carrinho.remove(id);
                    } catch (NumberFormatException ignored) { }
                }
                resp.sendRedirect(req.getContextPath() + "/carrinho");
                return;
            }

            case "clear": {
                carrinho.clear();
                resp.sendRedirect(req.getContextPath() + "/carrinho");
                return;
            }

            default:
                resp.sendRedirect(req.getContextPath() + "/carrinho");
        }
    }
}