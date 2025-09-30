package com.vinheria.controller;

import com.vinheria.model.Cliente;
import com.vinheria.model.Pedido;
import com.vinheria.model.Produto;
import com.vinheria.dao.ClienteDAO;
import com.vinheria.dao.PedidoDAO;
import com.vinheria.dao.ProdutoDAO;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class ClienteServlet extends HttpServlet {
    private ClienteDAO clienteDAO;
    private PedidoDAO pedidoDAO;
    private ProdutoDAO produtoDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        clienteDAO = new ClienteDAO();
        pedidoDAO = new PedidoDAO();
        produtoDAO = new ProdutoDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String secao = request.getParameter("secao");
            if (secao == null) {
                secao = "dashboard";
            }
            
            HttpSession session = request.getSession();
            Integer clienteId = (Integer) session.getAttribute("clienteId");
            
            if (clienteId == null) {
                // Cliente não logado - redirecionar para login
                response.sendRedirect("login.jsp");
                return;
            }
            
            // Buscar dados do cliente
            Cliente cliente = clienteDAO.buscarPorId(clienteId);
            if (cliente == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Cliente não encontrado");
                return;
            }
            
            request.setAttribute("cliente", cliente);
            request.setAttribute("secaoAtiva", secao);
            
            // Buscar dados específicos da seção
            switch (secao) {
                case "pedidos":
                    List<Pedido> pedidos = pedidoDAO.buscarPorCliente(clienteId);
                    request.setAttribute("pedidos", pedidos);
                    break;
                    
                case "recomendacoes":
                    List<Produto> recomendacoes = produtoDAO.buscarRecomendacoes(clienteId);
                    request.setAttribute("recomendacoes", recomendacoes);
                    break;
                    
                case "favoritos":
                    List<Produto> favoritos = produtoDAO.buscarFavoritos(clienteId);
                    request.setAttribute("favoritos", favoritos);
                    break;
                    
                case "pontos":
                    request.setAttribute("pontos", cliente.getPontos());
                    break;
            }
            
            // Contar itens no carrinho
            Integer carrinhoCount = (Integer) session.getAttribute("carrinhoCount");
            if (carrinhoCount == null) {
                carrinhoCount = 0;
            }
            request.setAttribute("carrinhoCount", carrinhoCount);
            
            // Forward para cliente.jsp
            RequestDispatcher dispatcher = request.getRequestDispatcher("/cliente.jsp");
            dispatcher.forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro ao carregar área do cliente");
        }
    }
}

