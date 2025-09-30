package com.vinheria.dao;

import com.vinheria.model.Cliente;
import java.util.*;

public class ClienteDAO {
    
    // Simulação de dados em memória
    private static Map<Integer, Cliente> clientes = new HashMap<>();
    private static int nextId = 1;
    
    static {
        // Inicializar com dados de exemplo
        criarClientesExemplo();
    }
    
    public Cliente buscarPorId(int id) {
        return clientes.get(id);
    }
    
    public Cliente buscarPorEmail(String email) {
        return clientes.values().stream()
                .filter(c -> c.getEmail().equals(email))
                .findFirst()
                .orElse(null);
    }
    
    public Cliente autenticar(String email, String senha) {
        Cliente cliente = buscarPorEmail(email);
        if (cliente != null && cliente.getSenha().equals(senha) && cliente.isAtivo()) {
            return cliente;
        }
        return null;
    }
    
    public void salvar(Cliente cliente) {
        if (cliente.getId() == 0) {
            cliente.setId(nextId++);
        }
        clientes.put(cliente.getId(), cliente);
    }
    
    private static void criarClientesExemplo() {
        Cliente cliente = new Cliente();
        cliente.setId(nextId++);
        cliente.setNome("Mariana Silva");
        cliente.setEmail("mariana.silva@email.com");
        cliente.setTelefone("(11) 99999-9999");
        cliente.setCpf("123.456.789-00");
        cliente.setSenha("123456");
        cliente.setAtivo(true);
        cliente.setPontos(347);
        cliente.setPlanoClube("Sommelier");
        clientes.put(cliente.getId(), cliente);
    }
}

