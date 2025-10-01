package com.vinheria.dao;

import com.vinheria.model.Produto;
import com.vinheria.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProdutoDAO {

    // ========= CRUD BÁSICO =========

    // ✅ Cadastrar novo produto
    public void inserir(Produto produto) throws SQLException {
        String sql = "INSERT INTO produto (nome, descricao, preco) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, produto.getNome());
            ps.setString(2, produto.getDescricao());
            ps.setDouble(3, produto.getPreco());
            ps.executeUpdate();
        }
    }

    // ✅ Buscar produto por ID
    public Produto buscarPorId(long id) throws SQLException {
        String sql = "SELECT * FROM produto WHERE id = ?";
        Produto produto = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    produto = mapearProduto(rs);
                }
            }
        }
        return produto;
    }

    // ✅ Listar todos
    public List<Produto> listarTodos() throws SQLException {
        List<Produto> lista = new ArrayList<>();
        String sql = "SELECT * FROM produto ORDER BY nome";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(mapearProduto(rs));
            }
        }
        return lista;
    }

    // ✅ Atualizar
    public void atualizar(Produto produto) throws SQLException {
        String sql = "UPDATE produto SET nome = ?, descricao = ?, preco = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, produto.getNome());
            ps.setString(2, produto.getDescricao());
            ps.setDouble(3, produto.getPreco());
            ps.setLong(4, produto.getId());
            ps.executeUpdate();
        }
    }

    // ✅ Deletar
    public void deletar(long id) throws SQLException {
        String sql = "DELETE FROM produto WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            ps.executeUpdate();
        }
    }

    // ========= MÉTODOS USADOS PELOS SERVLETS =========

    // Busca com filtros e paginação (nome + faixa de preço)
    public List<Produto> buscarComFiltros(String nome, String uva, String pais, String faixaPreco,
                                          int limit, int offset) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT * FROM produto WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (nome != null && !nome.isBlank()) {
            sql.append(" AND LOWER(nome) LIKE ?");
            params.add("%" + nome.toLowerCase() + "%");
        }

        // faixaPreco: "0-50", "50-100", "100+"
        if (faixaPreco != null && !faixaPreco.isBlank()) {
            if (faixaPreco.contains("-")) {
                String[] p = faixaPreco.split("-");
                sql.append(" AND preco BETWEEN ? AND ?");
                params.add(Double.parseDouble(p[0]));
                params.add(Double.parseDouble(p[1]));
            } else if (faixaPreco.endsWith("+")) {
                String base = faixaPreco.substring(0, faixaPreco.length() - 1);
                sql.append(" AND preco >= ?");
                params.add(Double.parseDouble(base));
            }
        }

        sql.append(" ORDER BY id DESC LIMIT ? OFFSET ?");
        params.add(limit <= 0 ? 12 : limit);
        params.add(Math.max(0, offset));

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int i = 1;
            for (Object p : params) {
                if (p instanceof String s) ps.setString(i++, s);
                else if (p instanceof Double d) ps.setDouble(i++, d);
                else if (p instanceof Integer n) ps.setInt(i++, n);
            }

            List<Produto> lista = new ArrayList<>();
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapearProduto(rs));
            }
            return lista;
        }
    }

    // Contagem para paginação (mesmos filtros de nome)
    public int contarComFiltros(String nome, String uva, String pais) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM produto WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (nome != null && !nome.isBlank()) {
            sql.append(" AND LOWER(nome) LIKE ?");
            params.add("%" + nome.toLowerCase() + "%");
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int i = 1;
            for (Object p : params) ps.setString(i++, (String) p);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    // Destaques: usa recentes
    public List<Produto> buscarDestaques() throws SQLException {
        return buscarRecentes(8);
    }

    // Recentes por ID desc
    public List<Produto> buscarRecentes(int limit) throws SQLException {
        String sql = "SELECT * FROM produto ORDER BY id DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, Math.max(1, limit));
            List<Produto> lista = new ArrayList<>();
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapearProduto(rs));
            }
            return lista;
        }
    }

    // Recomendacoes/Favoritos: placeholders
    public List<Produto> buscarRecomendacoes(Integer clienteId) throws SQLException {
        return buscarRecentes(8);
    }

    public List<Produto> buscarFavoritos(Integer clienteId) throws SQLException {
        return buscarRecentes(8);
    }

    // 🔹 RELACIONADOS — usado pelo ProdutoServlet
    public List<Produto> buscarRelacionados(int limit, String termo) throws SQLException {
        int lim = Math.max(1, Math.min(limit, 12));
        List<Produto> lista = new ArrayList<>();

        String sqlSemFiltro = "SELECT id, nome, descricao, preco FROM produto ORDER BY id DESC LIMIT " + lim;
        String sqlComFiltro  = "SELECT id, nome, descricao, preco FROM produto WHERE nome LIKE ? ORDER BY id DESC LIMIT " + lim;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = (termo == null || termo.trim().isEmpty())
                     ? conn.prepareStatement(sqlSemFiltro)
                     : conn.prepareStatement(sqlComFiltro)) {

            if (termo != null && !termo.trim().isEmpty()) {
                ps.setString(1, "%" + termo.trim() + "%");
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Produto p = new Produto();
                    p.setId(rs.getLong("id"));
                    p.setNome(rs.getString("nome"));
                    p.setDescricao(rs.getString("descricao"));
                    p.setPreco(rs.getDouble("preco"));
                    lista.add(p);
                }
            }
        }
        return lista;
    }

    // ========= Helper =========

    private Produto mapearProduto(ResultSet rs) throws SQLException {
        Produto p = new Produto();
        p.setId(rs.getLong("id"));
        p.setNome(rs.getString("nome"));
        p.setDescricao(rs.getString("descricao"));
        p.setPreco(rs.getDouble("preco"));
        return p;
    }
}