package com.vinheria.dao;

import com.vinheria.model.Produto;
import com.vinheria.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProdutoDAO {

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
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                produto = new Produto();
                produto.setId(rs.getLong("id"));
                produto.setNome(rs.getString("nome"));
                produto.setDescricao(rs.getString("descricao"));
                produto.setPreco(rs.getDouble("preco"));
            }
        }
        return produto;
    }

    // ✅ Novo método: listar todos os produtos
    public List<Produto> listarTodos() throws SQLException {
        List<Produto> lista = new ArrayList<>();
        String sql = "SELECT * FROM produto ORDER BY nome";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Produto produto = new Produto();
                produto.setId(rs.getLong("id"));
                produto.setNome(rs.getString("nome"));
                produto.setDescricao(rs.getString("descricao"));
                produto.setPreco(rs.getDouble("preco"));
                lista.add(produto);
            }
        }
        return lista;
    }

    // ✅ Atualizar produto existente
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

    // ✅ Deletar produto
    public void deletar(long id) throws SQLException {
        String sql = "DELETE FROM produto WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, id);
            ps.executeUpdate();
        }
    }
}