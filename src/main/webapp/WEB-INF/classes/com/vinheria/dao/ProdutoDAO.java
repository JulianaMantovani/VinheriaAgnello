package com.vinheria.dao;

import com.vinheria.model.Produto;
import java.util.*;
import java.util.stream.Collectors;

public class ProdutoDAO {
    
    // Simulação de dados em memória
    private static List<Produto> produtos = new ArrayList<>();
    private static int nextId = 1;
    
    static {
        // Inicializar com dados de exemplo
        criarProdutosExemplo();
    }
    
    public List<Produto> buscarDestaques() {
        return produtos.stream()
                .filter(Produto::isAtivo)
                .limit(3)
                .collect(Collectors.toList());
    }
    
    public List<Produto> buscarComFiltros(String tipo, String pais, String preco, String ordenacao, int offset, int limit) {
        List<Produto> resultado = new ArrayList<>(produtos);
        
        // Aplicar filtros
        if (tipo != null && !tipo.isEmpty()) {
            resultado = resultado.stream()
                    .filter(p -> p.getTipo() != null && p.getTipo().toLowerCase().contains(tipo.toLowerCase()))
                    .collect(Collectors.toList());
        }
        
        if (pais != null && !pais.isEmpty()) {
            resultado = resultado.stream()
                    .filter(p -> p.getPais() != null && p.getPais().toLowerCase().contains(pais.toLowerCase()))
                    .collect(Collectors.toList());
        }
        
        if (preco != null && !preco.isEmpty()) {
            resultado = aplicarFiltroPreco(resultado, preco);
        }
        
        // Aplicar ordenação
        if (ordenacao != null) {
            switch (ordenacao) {
                case "preco-menor":
                    resultado.sort(Comparator.comparing(Produto::getPreco));
                    break;
                case "preco-maior":
                    resultado.sort(Comparator.comparing(Produto::getPreco).reversed());
                    break;
                case "nome":
                    resultado.sort(Comparator.comparing(Produto::getNome));
                    break;
                case "avaliacao":
                    resultado.sort(Comparator.comparing(Produto::getNumAvaliacoes).reversed());
                    break;
            }
        }
        
        // Aplicar paginação
        int start = Math.min(offset, resultado.size());
        int end = Math.min(start + limit, resultado.size());
        
        return resultado.subList(start, end);
    }
    
    public int contarComFiltros(String tipo, String pais, String preco) {
        List<Produto> resultado = new ArrayList<>(produtos);
        
        if (tipo != null && !tipo.isEmpty()) {
            resultado = resultado.stream()
                    .filter(p -> p.getTipo() != null && p.getTipo().toLowerCase().contains(tipo.toLowerCase()))
                    .collect(Collectors.toList());
        }
        
        if (pais != null && !pais.isEmpty()) {
            resultado = resultado.stream()
                    .filter(p -> p.getPais() != null && p.getPais().toLowerCase().contains(pais.toLowerCase()))
                    .collect(Collectors.toList());
        }
        
        if (preco != null && !preco.isEmpty()) {
            resultado = aplicarFiltroPreco(resultado, preco);
        }
        
        return resultado.size();
    }
    
    public Produto buscarPorId(int id) {
        return produtos.stream()
                .filter(p -> p.getId() == id)
                .findFirst()
                .orElse(null);
    }
    
    public List<Produto> buscarRelacionados(int produtoId, String tipo) {
        return produtos.stream()
                .filter(p -> p.getId() != produtoId)
                .filter(p -> p.getTipo() != null && p.getTipo().equals(tipo))
                .limit(3)
                .collect(Collectors.toList());
    }
    
    public List<Produto> buscarRecomendacoes(int clienteId) {
        // Simulação de recomendações baseadas no histórico do cliente
        return produtos.stream()
                .filter(Produto::isAtivo)
                .limit(3)
                .collect(Collectors.toList());
    }
    
    public List<Produto> buscarFavoritos(int clienteId) {
        // Simulação de favoritos do cliente
        return produtos.stream()
                .filter(Produto::isAtivo)
                .limit(5)
                .collect(Collectors.toList());
    }
    
    private List<Produto> aplicarFiltroPreco(List<Produto> produtos, String preco) {
        switch (preco) {
            case "0-100":
                return produtos.stream()
                        .filter(p -> p.getPreco() <= 100)
                        .collect(Collectors.toList());
            case "100-300":
                return produtos.stream()
                        .filter(p -> p.getPreco() > 100 && p.getPreco() <= 300)
                        .collect(Collectors.toList());
            case "300-500":
                return produtos.stream()
                        .filter(p -> p.getPreco() > 300 && p.getPreco() <= 500)
                        .collect(Collectors.toList());
            case "500-1000":
                return produtos.stream()
                        .filter(p -> p.getPreco() > 500 && p.getPreco() <= 1000)
                        .collect(Collectors.toList());
            case "1000+":
                return produtos.stream()
                        .filter(p -> p.getPreco() > 1000)
                        .collect(Collectors.toList());
            default:
                return produtos;
        }
    }
    
    private static void criarProdutosExemplo() {
        // Produto 1
        Produto p1 = new Produto();
        p1.setId(nextId++);
        p1.setNome("Château Margaux 2018");
        p1.setDescricao("Bordeaux francês com notas de frutas vermelhas e taninos elegantes.");
        p1.setPreco(1850.00);
        p1.setImagem("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 200 300'%3E%3Crect fill='%23722F37' width='200' height='300'/%3E%3Ctext x='100' y='150' text-anchor='middle' fill='%23D4AF37' font-size='16' font-family='serif'%3EVinho Tinto%3C/text%3E%3C/svg%3E");
        p1.setPais("França");
        p1.setRegiao("Bordeaux");
        p1.setTipo("Tinto");
        p1.setTeorAlcoolico(14);
        p1.setSafra(2018);
        p1.setTemperatura("16-18°C");
        p1.setUva("Cabernet Sauvignon, Merlot");
        p1.setProdutor("Château Margaux");
        p1.setVolume("750ml");
        p1.setGuarda("25-30 anos");
        p1.setAvaliacao("★★★★★");
        p1.setNumAvaliacoes(12);
        p1.setEstoque(10);
        p1.setAtivo(true);
        produtos.add(p1);
        
        // Produto 2
        Produto p2 = new Produto();
        p2.setId(nextId++);
        p2.setNome("Chardonnay Reserve 2020");
        p2.setDescricao("Branco californiano com toques de carvalho e notas cítricas.");
        p2.setPreco(320.00);
        p2.setImagem("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 200 300'%3E%3Crect fill='%23F5F5DC' width='200' height='300'/%3E%3Ctext x='100' y='150' text-anchor='middle' fill='%23722F37' font-size='16' font-family='serif'%3EVinho Branco%3C/text%3E%3C/svg%3E");
        p2.setPais("EUA");
        p2.setRegiao("Califórnia");
        p2.setTipo("Branco");
        p2.setTeorAlcoolico(13);
        p2.setSafra(2020);
        p2.setTemperatura("8-10°C");
        p2.setUva("Chardonnay");
        p2.setProdutor("Napa Valley Winery");
        p2.setVolume("750ml");
        p2.setGuarda("5-7 anos");
        p2.setAvaliacao("★★★★☆");
        p2.setNumAvaliacoes(8);
        p2.setEstoque(15);
        p2.setAtivo(true);
        produtos.add(p2);
        
        // Produto 3
        Produto p3 = new Produto();
        p3.setId(nextId++);
        p3.setNome("Brunello di Montalcino 2017");
        p3.setDescricao("Italiano encorpado com aromas complexos de frutas maduras.");
        p3.setPreco(890.00);
        p3.setImagem("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 200 300'%3E%3Crect fill='%238B0000' width='200' height='300'/%3E%3Ctext x='100' y='150' text-anchor='middle' fill='%23D4AF37' font-size='14' font-family='serif'%3EBrunello%3C/text%3E%3C/svg%3E");
        p3.setPais("Itália");
        p3.setRegiao("Toscana");
        p3.setTipo("Tinto");
        p3.setTeorAlcoolico(14);
        p3.setSafra(2017);
        p3.setTemperatura("16-18°C");
        p3.setUva("Sangiovese");
        p3.setProdutor("Tenuta di Montalcino");
        p3.setVolume("750ml");
        p3.setGuarda("15-20 anos");
        p3.setAvaliacao("★★★★★");
        p3.setNumAvaliacoes(15);
        p3.setEstoque(8);
        p3.setAtivo(true);
        produtos.add(p3);
    }
}

