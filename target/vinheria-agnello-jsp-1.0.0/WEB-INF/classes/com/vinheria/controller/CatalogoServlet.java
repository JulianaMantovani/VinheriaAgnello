package com.vinheria.controller;

import com.vinheria.model.Produto;
import com.vinheria.dao.ProdutoDAO;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class CatalogoServlet extends HttpServlet {
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
            // Parâmetros de filtro
            String tipo = request.getParameter("tipo");
            String pais = request.getParameter("pais");
            String preco = request.getParameter("preco");
            String ordenacao = request.getParameter("ordenacao");
            String paginaStr = request.getParameter("pagina");
            
            int pagina = 1;
            if (paginaStr != null && !paginaStr.isEmpty()) {
                try {
                    pagina = Integer.parseInt(paginaStr);
                } catch (NumberFormatException e) {
                    pagina = 1;
                }
            }
            
            int itensPorPagina = 12;
            int offset = (pagina - 1) * itensPorPagina;
            
            // Buscar produtos com filtros
            List<Produto> produtos = produtoDAO.buscarComFiltros(tipo, pais, preco, ordenacao, offset, itensPorPagina);
            int totalProdutos = produtoDAO.contarComFiltros(tipo, pais, preco);
            int totalPaginas = (int) Math.ceil((double) totalProdutos / itensPorPagina);
            
            request.setAttribute("produtos", produtos);
            request.setAttribute("totalProdutos", totalProdutos);
            request.setAttribute("paginaAtual", pagina);
            request.setAttribute("totalPaginas", totalPaginas);
            
            // Contar itens no carrinho
            HttpSession session = request.getSession();
            Integer carrinhoCount = (Integer) session.getAttribute("carrinhoCount");
            if (carrinhoCount == null) {
                carrinhoCount = 0;
            }
            request.setAttribute("carrinhoCount", carrinhoCount);
            
            // Forward para catalogo.jsp
            RequestDispatcher dispatcher = request.getRequestDispatcher("/catalogo.jsp");
            dispatcher.forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro ao carregar catálogo");
        }
    }
}

