package com.vinheria.dao;

import com.vinheria.model.Avaliacao;
import java.util.*;
import java.util.stream.Collectors;

public class AvaliacaoDAO {
    
    // Simulação de dados em memória
    private static List<Avaliacao> avaliacoes = new ArrayList<>();
    private static int nextId = 1;
    
    static {
        // Inicializar com dados de exemplo
        criarAvaliacoesExemplo();
    }
    
    public List<Avaliacao> buscarPorProduto(int produtoId) {
        return avaliacoes.stream()
                .filter(a -> a.getProdutoId() == produtoId && a.isAprovada())
                .sorted(Comparator.comparing(Avaliacao::getData).reversed())
                .collect(Collectors.toList());
    }
    
    public List<Avaliacao> buscarPorCliente(int clienteId) {
        return avaliacoes.stream()
                .filter(a -> a.getClienteId() == clienteId)
                .sorted(Comparator.comparing(Avaliacao::getData).reversed())
                .collect(Collectors.toList());
    }
    
    public void salvar(Avaliacao avaliacao) {
        if (avaliacao.getId() == 0) {
            avaliacao.setId(nextId++);
        }
        avaliacoes.add(avaliacao);
    }
    
    private static void criarAvaliacoesExemplo() {
        // Avaliação 1
        Avaliacao a1 = new Avaliacao();
        a1.setId(nextId++);
        a1.setProdutoId(1);
        a1.setClienteId(1);
        a1.setNomeCliente("Maria Silva");
        a1.setNota(5);
        a1.setComentario("Simplesmente excepcional! Um vinho que justifica cada centavo. A complexidade aromática é impressionante e a harmonização com o cordeiro foi perfeita. Recomendo!");
        a1.setData(new Date(System.currentTimeMillis() - 86400000 * 5)); // 5 dias atrás
        a1.setAprovada(true);
        avaliacoes.add(a1);
        
        // Avaliação 2
        Avaliacao a2 = new Avaliacao();
        a2.setId(nextId++);
        a2.setProdutoId(1);
        a2.setClienteId(2);
        a2.setNomeCliente("Carlos Mendes");
        a2.setNota(5);
        a2.setComentario("Comprei para uma ocasião especial e superou todas as expectativas. O atendimento da Vinheria Agnello também foi impecável, com explicações detalhadas sobre o vinho.");
        a2.setData(new Date(System.currentTimeMillis() - 86400000 * 10)); // 10 dias atrás
        a2.setAprovada(true);
        avaliacoes.add(a2);
        
        // Avaliação 3
        Avaliacao a3 = new Avaliacao();
        a3.setId(nextId++);
        a3.setProdutoId(1);
        a3.setClienteId(3);
        a3.setNomeCliente("Ana Rodrigues");
        a3.setNota(4);
        a3.setComentario("Vinho magnífico, porém ainda jovem. Seguindo a recomendação do Sr. Giulio, vou guardar algumas garrafas para degustar em alguns anos. A qualidade é indiscutível.");
        a3.setData(new Date(System.currentTimeMillis() - 86400000 * 15)); // 15 dias atrás
        a3.setAprovada(true);
        avaliacoes.add(a3);
    }
}

