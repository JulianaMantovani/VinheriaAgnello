package com.vinheria.controller;

import com.vinheria.model.Produto;
import com.vinheria.dao.ProdutoDAO;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class IndexServlet extends HttpServlet {
    private ProdutoDAO produtoDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        produtoDAO = new ProdutoDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Buscar produtos em destaque
            List<Produto> destaques = produtoDAO.buscarDestaques();
            request.setAttribute("destaques", destaques);
            
            // Contar itens no carrinho (simulação)
            HttpSession session = request.getSession();
            Integer carrinhoCount = (Integer) session.getAttribute("carrinhoCount");
            if (carrinhoCount == null) {
                carrinhoCount = 0;
            }
            request.setAttribute("carrinhoCount", carrinhoCount);
            
            // Forward para index.jsp
            RequestDispatcher dispatcher = request.getRequestDispatcher("/index.jsp");
            dispatcher.forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro ao carregar página inicial");
        }
    }
}

