package com.vinheria.controller;

import com.vinheria.model.Produto;
import com.vinheria.model.Avaliacao;
import com.vinheria.dao.ProdutoDAO;
import com.vinheria.dao.AvaliacaoDAO;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class ProdutoServlet extends HttpServlet {
    private ProdutoDAO produtoDAO;
    private AvaliacaoDAO avaliacaoDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        produtoDAO = new ProdutoDAO();
        avaliacaoDAO = new AvaliacaoDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String produtoIdStr = request.getParameter("id");
            int produtoId = 1; // Default
            
            if (produtoIdStr != null && !produtoIdStr.isEmpty()) {
                try {
                    produtoId = Integer.parseInt(produtoIdStr);
                } catch (NumberFormatException e) {
                    produtoId = 1;
                }
            }
            
            // Buscar produto
            Produto produto = produtoDAO.buscarPorId(produtoId);
            if (produto == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Produto não encontrado");
                return;
            }
            
            // Buscar produtos relacionados
            List<Produto> relacionados = produtoDAO.buscarRelacionados(produtoId, produto.getTipo());
            
            // Buscar avaliações
            List<Avaliacao> avaliacoes = avaliacaoDAO.buscarPorProduto(produtoId);
            
            request.setAttribute("produto", produto);
            request.setAttribute("relacionados", relacionados);
            request.setAttribute("avaliacoes", avaliacoes);
            
            // Contar itens no carrinho
            HttpSession session = request.getSession();
            Integer carrinhoCount = (Integer) session.getAttribute("carrinhoCount");
            if (carrinhoCount == null) {
                carrinhoCount = 0;
            }
            request.setAttribute("carrinhoCount", carrinhoCount);
            
            // Forward para produto.jsp
            RequestDispatcher dispatcher = request.getRequestDispatcher("/produto.jsp");
            dispatcher.forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro ao carregar produto");
        }
    }
}

