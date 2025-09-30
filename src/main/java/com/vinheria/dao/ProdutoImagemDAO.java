package com.vinheria.dao;

import com.vinheria.model.ProdutoImagem;
import com.vinheria.cloud.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProdutoImagemDAO {

    public ProdutoImagem insert(ProdutoImagem img) throws SQLException {
        String sql = "INSERT INTO produto_imagem (produto_id, s3_key, url) VALUES (?, ?, ?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, img.getProdutoId());
            ps.setString(2, img.getS3Key());
            ps.setString(3, img.getUrl());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) img.setId(rs.getLong(1));
            }
        }
        return img;
    }

    public List<ProdutoImagem> listAll() throws SQLException {
        String sql = "SELECT id, produto_id, s3_key, url, created_at FROM produto_imagem ORDER BY created_at DESC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            List<ProdutoImagem> out = new ArrayList<>();
            while (rs.next()) out.add(map(rs));
            return out;
        }
    }

    public List<ProdutoImagem> listByProdutoId(long produtoId) throws SQLException {
        String sql = "SELECT id, produto_id, s3_key, url, created_at FROM produto_imagem WHERE produto_id=? ORDER BY created_at DESC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, produtoId);
            try (ResultSet rs = ps.executeQuery()) {
                List<ProdutoImagem> out = new ArrayList<>();
                while (rs.next()) out.add(map(rs));
                return out;
            }
        }
    }

    public ProdutoImagem getById(long id) throws SQLException {
        String sql = "SELECT id, produto_id, s3_key, url, created_at FROM produto_imagem WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
                return null;
            }
        }
    }

    public void deleteById(long id) throws SQLException {
        String sql = "DELETE FROM produto_imagem WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, id);
            ps.executeUpdate();
        }
    }

    private ProdutoImagem map(ResultSet rs) throws SQLException {
        ProdutoImagem pi = new ProdutoImagem();
        pi.setId(rs.getLong("id"));
        pi.setProdutoId(rs.getLong("produto_id"));
        pi.setS3Key(rs.getString("s3_key"));
        pi.setUrl(rs.getString("url"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) pi.setCreatedAt(ts.toInstant());
        return pi;
    }
}
