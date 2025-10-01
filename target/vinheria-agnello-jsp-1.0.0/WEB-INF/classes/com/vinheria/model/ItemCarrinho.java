package com.vinheria.model;

public class ItemCarrinho {
    private Produto produto;
    private int quantidade;
    private double subtotal;

    // Construtores
    public ItemCarrinho() {}

    public ItemCarrinho(Produto produto, int quantidade) {
        this.produto = produto;
        this.quantidade = quantidade;
        this.subtotal = produto.getPreco() * quantidade;
    }

    // Getters e Setters
    public Produto getProduto() {
        return produto;
    }

    public void setProduto(Produto produto) {
        this.produto = produto;
    }

    public int getQuantidade() {
        return quantidade;
    }

    public void setQuantidade(int quantidade) {
        this.quantidade = quantidade;
        if (produto != null) {
            this.subtotal = produto.getPreco() * quantidade;
        }
    }

    public double getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(double subtotal) {
        this.subtotal = subtotal;
    }

    public void calcularSubtotal() {
        if (produto != null) {
            this.subtotal = produto.getPreco() * quantidade;
        }
    }
}

