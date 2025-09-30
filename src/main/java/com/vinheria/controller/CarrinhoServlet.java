package com.vinheria.controller;

import com.vinheria.model.ItemCarrinho;
import com.vinheria.model.Produto;
import com.vinheria.dao.ProdutoDAO;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;

public class CarrinhoServlet extends HttpServlet {
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
            HttpSession session = request.getSession();
            
            // Buscar itens do carrinho da sessão
            @SuppressWarnings("unchecked")
            Map<Integer, ItemCarrinho> carrinho = (Map<Integer, ItemCarrinho>) session.getAttribute("carrinho");
            if (carrinho == null) {
                carrinho = new HashMap<>();
            }
            
            List<ItemCarrinho> itens = new ArrayList<>(carrinho.values());
            double subtotal = calcularSubtotal(itens);
            double total = subtotal; // Sem frete por enquanto
            
            request.setAttribute("itensCarrinho", itens);
            request.setAttribute("subtotal", subtotal);
            request.setAttribute("total", total);
            request.setAttribute("totalItens", itens.size());
            
            // Forward para carrinho.jsp
            RequestDispatcher dispatcher = request.getRequestDispatcher("/carrinho.jsp");
            dispatcher.forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro ao carregar carrinho");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String acao = request.getParameter("acao");
            HttpSession session = request.getSession();
            
            @SuppressWarnings("unchecked")
            Map<Integer, ItemCarrinho> carrinho = (Map<Integer, ItemCarrinho>) session.getAttribute("carrinho");
            if (carrinho == null) {
                carrinho = new HashMap<>();
            }
            
            if ("adicionar".equals(acao)) {
                adicionarItem(request, carrinho);
            } else if ("remover".equals(acao)) {
                removerItem(request, carrinho);
            } else if ("atualizar".equals(acao)) {
                atualizarQuantidade(request, carrinho);
            } else if ("aplicarCupom".equals(acao)) {
                aplicarCupom(request, carrinho);
            }
            
            session.setAttribute("carrinho", carrinho);
            session.setAttribute("carrinhoCount", carrinho.size());
            
            response.sendRedirect("carrinho");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro ao processar carrinho");
        }
    }
    
    private void adicionarItem(HttpServletRequest request, Map<Integer, ItemCarrinho> carrinho) {
        try {
            int produtoId = Integer.parseInt(request.getParameter("produtoId"));
            Produto produto = produtoDAO.buscarPorId(produtoId);
            
            if (produto != null) {
                ItemCarrinho item = carrinho.get(produtoId);
                if (item == null) {
                    item = new ItemCarrinho(produto, 1);
                    carrinho.put(produtoId, item);
                } else {
                    item.setQuantidade(item.getQuantidade() + 1);
                }
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
    }
    
    private void removerItem(HttpServletRequest request, Map<Integer, ItemCarrinho> carrinho) {
        try {
            int produtoId = Integer.parseInt(request.getParameter("produtoId"));
            carrinho.remove(produtoId);
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
    }
    
    private void atualizarQuantidade(HttpServletRequest request, Map<Integer, ItemCarrinho> carrinho) {
        try {
            int produtoId = Integer.parseInt(request.getParameter("produtoId"));
            String operacao = request.getParameter("operacao");
            
            ItemCarrinho item = carrinho.get(produtoId);
            if (item != null) {
                int novaQuantidade = item.getQuantidade();
                if ("aumentar".equals(operacao)) {
                    novaQuantidade++;
                } else if ("diminuir".equals(operacao)) {
                    novaQuantidade--;
                }
                
                if (novaQuantidade <= 0) {
                    carrinho.remove(produtoId);
                } else {
                    item.setQuantidade(novaQuantidade);
                }
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
    }
    
    private void aplicarCupom(HttpServletRequest request, Map<Integer, ItemCarrinho> carrinho) {
        String cupom = request.getParameter("cupom");
        // Implementar lógica de cupom aqui
    }
    
    private double calcularSubtotal(List<ItemCarrinho> itens) {
        return itens.stream()
                .mapToDouble(ItemCarrinho::getSubtotal)
                .sum();
    }
}

