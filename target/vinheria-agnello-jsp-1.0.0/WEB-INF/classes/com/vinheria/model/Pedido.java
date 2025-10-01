package com.vinheria.model;

import java.util.Date;
import java.util.List;
import java.util.ArrayList;

public class Pedido {
    private int id;
    private int clienteId;
    private Date data;
    private String status;
    private double total;
    private String formaPagamento;
    private String enderecoEntrega;
    private List<String> itens;

    // Construtores
    public Pedido() {
        this.itens = new ArrayList<>();
    }

    public Pedido(int id, int clienteId, Date data, String status, double total) {
        this.id = id;
        this.clienteId = clienteId;
        this.data = data;
        this.status = status;
        this.total = total;
        this.itens = new ArrayList<>();
    }

    // Getters e Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getClienteId() {
        return clienteId;
    }

    public void setClienteId(int clienteId) {
        this.clienteId = clienteId;
    }

    public Date getData() {
        return data;
    }

    public void setData(Date data) {
        this.data = data;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }

    public String getFormaPagamento() {
        return formaPagamento;
    }

    public void setFormaPagamento(String formaPagamento) {
        this.formaPagamento = formaPagamento;
    }

    public String getEnderecoEntrega() {
        return enderecoEntrega;
    }

    public void setEnderecoEntrega(String enderecoEntrega) {
        this.enderecoEntrega = enderecoEntrega;
    }

    public List<String> getItens() {
        return itens;
    }

    public void setItens(List<String> itens) {
        this.itens = itens;
    }

    public void addItem(String item) {
        this.itens.add(item);
    }

    public String getDataFormatada() {
        if (data != null) {
            return String.format("%td/%tm/%tY", data, data, data);
        }
        return "";
    }
}

