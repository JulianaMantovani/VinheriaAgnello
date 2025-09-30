package com.vinheria.model;

import java.util.Date;

public class Avaliacao {
    private int id;
    private int produtoId;
    private int clienteId;
    private String nomeCliente;
    private int nota;
    private String comentario;
    private Date data;
    private boolean aprovada;

    // Construtores
    public Avaliacao() {}

    public Avaliacao(int id, int produtoId, int clienteId, String nomeCliente, int nota, String comentario) {
        this.id = id;
        this.produtoId = produtoId;
        this.clienteId = clienteId;
        this.nomeCliente = nomeCliente;
        this.nota = nota;
        this.comentario = comentario;
        this.data = new Date();
        this.aprovada = false;
    }

    // Getters e Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getProdutoId() {
        return produtoId;
    }

    public void setProdutoId(int produtoId) {
        this.produtoId = produtoId;
    }

    public int getClienteId() {
        return clienteId;
    }

    public void setClienteId(int clienteId) {
        this.clienteId = clienteId;
    }

    public String getNomeCliente() {
        return nomeCliente;
    }

    public void setNomeCliente(String nomeCliente) {
        this.nomeCliente = nomeCliente;
    }

    public int getNota() {
        return nota;
    }

    public void setNota(int nota) {
        this.nota = nota;
    }

    public String getComentario() {
        return comentario;
    }

    public void setComentario(String comentario) {
        this.comentario = comentario;
    }

    public Date getData() {
        return data;
    }

    public void setData(Date data) {
        this.data = data;
    }

    public boolean isAprovada() {
        return aprovada;
    }

    public void setAprovada(boolean aprovada) {
        this.aprovada = aprovada;
    }

    public String getEstrelas() {
        StringBuilder estrelas = new StringBuilder();
        for (int i = 0; i < 5; i++) {
            if (i < nota) {
                estrelas.append("★");
            } else {
                estrelas.append("☆");
            }
        }
        return estrelas.toString();
    }

    public String getDataFormatada() {
        if (data != null) {
            return String.format("%td/%tm/%tY", data, data, data);
        }
        return "";
    }
}

