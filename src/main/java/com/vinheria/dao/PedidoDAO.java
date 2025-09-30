package com.vinheria.dao;

import com.vinheria.model.Pedido;
import java.util.*;
import java.util.stream.Collectors;

public class PedidoDAO {
    
    // Simulação de dados em memória
    private static List<Pedido> pedidos = new ArrayList<>();
    private static int nextId = 1;
    
    static {
        // Inicializar com dados de exemplo
        criarPedidosExemplo();
    }
    
    public List<Pedido> buscarPorCliente(int clienteId) {
        return pedidos.stream()
                .filter(p -> p.getClienteId() == clienteId)
                .sorted(Comparator.comparing(Pedido::getData).reversed())
                .collect(Collectors.toList());
    }
    
    public Pedido buscarPorId(int id) {
        return pedidos.stream()
                .filter(p -> p.getId() == id)
                .findFirst()
                .orElse(null);
    }
    
    public void salvar(Pedido pedido) {
        if (pedido.getId() == 0) {
            pedido.setId(nextId++);
        }
        pedidos.add(pedido);
    }
    
    private static void criarPedidosExemplo() {
        // Pedido 1
        Pedido p1 = new Pedido();
        p1.setId(nextId++);
        p1.setClienteId(1);
        p1.setData(new Date(System.currentTimeMillis() - 86400000 * 15)); // 15 dias atrás
        p1.setStatus("Entregue");
        p1.setTotal(1170.00);
        p1.setFormaPagamento("Cartão de Crédito");
        p1.setEnderecoEntrega("Rua das Flores, 123 - São Paulo/SP");
        p1.addItem("Brunello di Montalcino 2017 (1x)");
        p1.addItem("Decanter de Cristal (1x)");
        pedidos.add(p1);
        
        // Pedido 2
        Pedido p2 = new Pedido();
        p2.setId(nextId++);
        p2.setClienteId(1);
        p2.setData(new Date(System.currentTimeMillis() - 86400000 * 30)); // 30 dias atrás
        p2.setStatus("Em Trânsito");
        p2.setTotal(3850.00);
        p2.setFormaPagamento("PIX");
        p2.setEnderecoEntrega("Rua das Flores, 123 - São Paulo/SP");
        p2.addItem("Château Margaux 2018 (2x)");
        p2.addItem("Kit 2 Taças Bordeaux (1x)");
        pedidos.add(p2);
    }
}

