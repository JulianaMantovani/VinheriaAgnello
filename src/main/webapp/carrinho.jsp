<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.vinheria.model.ItemCarrinho" %>
<%@ page import="com.vinheria.model.Produto" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.DecimalFormat" %>
<%
    List<ItemCarrinho> itens = (List<ItemCarrinho>) request.getAttribute("itensCarrinho");
    Double subtotal = (Double) request.getAttribute("subtotal");
    Double total = (Double) request.getAttribute("total");
    Integer totalItens = (Integer) request.getAttribute("totalItens");
    
    DecimalFormat df = new DecimalFormat("#,##0.00");
    
    if (itens == null) {
        itens = new java.util.ArrayList<>();
    }
    if (subtotal == null) {
        subtotal = 0.0;
    }
    if (total == null) {
        total = 0.0;
    }
    if (totalItens == null) {
        totalItens = 0;
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Carrinho de Compras - Vinheria Agnello</title>
    <link rel="stylesheet" href="styles.css">
</head>

<body>
    <!-- Header -->
    <header class="header">
        <div class="header-container">
            <a href="index.jsp" class="logo">Vinheria Agnello</a>

            <nav class="nav">
                <ul>
                    <li><a href="index.jsp">Início</a></li>
                    <li><a href="catalogo.jsp">Catálogo</a></li>
                    <li><a href="#sobre">Sobre</a></li>
                    <li><a href="#contato">Contato</a></li>
                </ul>
            </nav>

            <div class="header-actions">
                <form action="buscar" method="get" style="display: inline;">
                    <input type="search" name="termo" class="search-box" placeholder="Buscar vinhos...">
                </form>
                <a href="cliente.jsp" class="btn btn-secondary">Minha Conta</a>
                <a href="carrinho.jsp" class="btn btn-primary">Carrinho (<%= totalItens %>)</a>
            </div>
        </div>
    </header>

    <!-- Breadcrumb -->
    <div class="container" style="padding: 1rem 0;">
        <nav style="color: #666;">
            <a href="index.jsp" style="color: #722F37;">Início</a> >
            <span>Carrinho de Compras</span>
        </nav>
    </div>

    <!-- Carrinho -->
    <section class="container" style="padding: 2rem 0;">
        <h2 style="margin-bottom: 2rem;">Seu Carrinho de Compras</h2>

        <%
            if (itens.isEmpty()) {
        %>
        <div style="text-align: center; padding: 4rem 0;">
            <div style="font-size: 4rem; margin-bottom: 2rem;">🛒</div>
            <h3 style="margin-bottom: 1rem;">Seu carrinho está vazio</h3>
            <p style="color: #666; margin-bottom: 2rem;">Que tal explorar nossos vinhos selecionados?</p>
            <a href="catalogo.jsp" class="btn btn-primary">Explorar Catálogo</a>
        </div>
        <%
            } else {
        %>
        <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 3rem;">
            <!-- Lista de Produtos -->
            <div>
                <%
                    for (ItemCarrinho item : itens) {
                        Produto produto = item.getProduto();
                %>
                <div class="carrinho-item">
                    <img src="<%= produto.getImagem() %>" alt="<%= produto.getNome() %>">

                    <div class="carrinho-item-info">
                        <h4><%= produto.getNome() %></h4>
                        <p style="color: #666; margin-bottom: 0.5rem;"><%= produto.getPais() %> • <%= produto.getRegiao() %></p>
                        <p style="color: #722F37; font-weight: 600;">R$ <%= df.format(produto.getPreco()) %></p>

                        <div class="quantidade-control">
                            <span>Quantidade:</span>
                            <form action="carrinho" method="post" style="display: inline;">
                                <input type="hidden" name="acao" value="atualizar">
                                <input type="hidden" name="produtoId" value="<%= produto.getId() %>">
                                <button type="submit" name="operacao" value="diminuir" onclick="return confirm('Diminuir quantidade?')">-</button>
                                <span style="margin: 0 1rem; font-weight: 600;"><%= item.getQuantidade() %></span>
                                <button type="submit" name="operacao" value="aumentar" onclick="return confirm('Aumentar quantidade?')">+</button>
                            </form>
                        </div>

                        <div style="margin-top: 1rem;">
                            <form action="carrinho" method="post" style="display: inline;">
                                <input type="hidden" name="acao" value="remover">
                                <input type="hidden" name="produtoId" value="<%= produto.getId() %>">
                                <button type="submit" onclick="return confirm('Remover este item do carrinho?')"
                                    style="background: none; border: none; color: #722F37; text-decoration: underline; cursor: pointer;">
                                    🗑️ Remover
                                </button>
                            </form>
                            <button onclick="salvarParaDepois(<%= produto.getId() %>)"
                                style="background: none; border: none; color: #722F37; text-decoration: underline; cursor: pointer; margin-left: 1rem;">
                                ♡ Salvar para depois
                            </button>
                        </div>
                    </div>

                    <div style="text-align: right;">
                        <div style="font-size: 1.2rem; font-weight: 600; color: #722F37;">
                            R$ <%= df.format(item.getSubtotal()) %>
                        </div>
                    </div>
                </div>
                <%
                    }
                %>

                <!-- Cupom de Desconto -->
                <div style="background-color: #f5f5f5; padding: 1.5rem; border-radius: 10px; margin-top: 2rem;">
                    <h4 style="margin-bottom: 1rem;">Cupom de Desconto</h4>
                    <form action="carrinho" method="post" style="display: flex; gap: 1rem;">
                        <input type="hidden" name="acao" value="aplicarCupom">
                        <input type="text" name="cupom" placeholder="Digite seu cupom" style="flex: 1; padding: 0.75rem; border: 1px solid #ddd; border-radius: 5px;">
                        <button type="submit" class="btn btn-secondary">Aplicar</button>
                    </form>
                </div>

                <!-- Continuar Comprando -->
                <div style="margin-top: 2rem;">
                    <a href="catalogo.jsp" class="btn btn-secondary">← Continuar Comprando</a>
                </div>
            </div>

            <!-- Resumo do Pedido -->
            <div class="carrinho-resumo">
                <h3 style="margin-bottom: 1.5rem;">Resumo do Pedido</h3>

                <div style="border-bottom: 1px solid #eee; padding-bottom: 1rem; margin-bottom: 1rem;">
                    <div style="display: flex; justify-content: space-between; margin-bottom: 0.5rem;">
                        <span>Subtotal (<%= totalItens %> itens):</span>
                        <span>R$ <%= df.format(subtotal) %></span>
                    </div>
                    <div style="display: flex; justify-content: space-between; margin-bottom: 0.5rem;">
                        <span>Frete:</span>
                        <%
                            if (subtotal >= 300) {
                        %>
                        <span style="color: #22c55e; font-weight: 600;">GRÁTIS</span>
                        <%
                            } else {
                        %>
                        <span>R$ 25,00</span>
                        <%
                            }
                        %>
                    </div>
                    <%
                        if (subtotal >= 300) {
                    %>
                    <div style="display: flex; justify-content: space-between; color: #666; font-size: 0.9rem;">
                        <span>Desconto frete (compra acima R$ 300):</span>
                        <span>-R$ 25,00</span>
                    </div>
                    <%
                        }
                    %>
                </div>

                <div style="display: flex; justify-content: space-between; font-size: 1.2rem; font-weight: 600; color: #722F37; margin-bottom: 1.5rem;">
                    <span>Total:</span>
                    <span>R$ <%= df.format(total) %></span>
                </div>

                <!-- Opções de Entrega -->
                <div style="margin-bottom: 1.5rem;">
                    <h4 style="margin-bottom: 1rem;">Entrega</h4>
                    <form action="carrinho" method="post">
                        <input type="hidden" name="acao" value="alterarEntrega">
                        <div style="border: 1px solid #ddd; border-radius: 5px; padding: 1rem;">
                            <input type="radio" id="entrega-normal" name="tipoEntrega" value="normal" checked>
                            <label for="entrega-normal" style="margin-left: 0.5rem;">
                                <strong>Entrega Normal (5-7 dias úteis)</strong><br>
                                <span style="color: #666; font-size: 0.9rem;">Grátis para compras acima de R$ 300</span>
                            </label>
                        </div>
                        <div style="border: 1px solid #ddd; border-radius: 5px; padding: 1rem; margin-top: 0.5rem;">
                            <input type="radio" id="entrega-expressa" name="tipoEntrega" value="expressa">
                            <label for="entrega-expressa" style="margin-left: 0.5rem;">
                                <strong>Entrega Expressa (2-3 dias úteis)</strong><br>
                                <span style="color: #666; font-size: 0.9rem;">+ R$ 35,00</span>
                            </label>
                        </div>
                        <button type="submit" class="btn btn-secondary" style="margin-top: 1rem;">Atualizar Entrega</button>
                    </form>
                </div>

                <!-- Formas de Pagamento -->
                <div style="margin-bottom: 2rem;">
                    <h4 style="margin-bottom: 1rem;">Pagamento</h4>
                    <div style="background-color: #f5f5f5; padding: 1rem; border-radius: 5px; font-size: 0.9rem;">
                        <div style="margin-bottom: 0.5rem;">💳 <strong>Cartão de Crédito</strong> em até 12x sem juros</div>
                        <div style="margin-bottom: 0.5rem;">💵 <strong>PIX</strong> com 5% de desconto</div>
                        <div>🏦 <strong>Boleto</strong> com 3% de desconto</div>
                    </div>
                </div>

                <!-- Segurança -->
                <div style="text-align: center; margin-bottom: 2rem; padding: 1rem; background-color: #f0f9ff; border-radius: 5px;">
                    <div style="font-size: 1.5rem; margin-bottom: 0.5rem;">🔒</div>
                    <div style="font-size: 0.9rem; color: #666;">
                        <strong>Compra 100% Segura</strong><br>
                        Certificado SSL e dados criptografados
                    </div>
                </div>

                <form action="checkout" method="post">
                    <button type="submit" class="btn btn-primary" style="width: 100%; padding: 1rem; font-size: 1.1rem; font-weight: 600;">
                        Finalizar Compra
                    </button>
                </form>

                <!-- Programa de Pontos -->
                <div style="margin-top: 1.5rem; padding: 1rem; background-color: #722F37; color: white; border-radius: 5px; text-align: center;">
                    <div style="color: #D4AF37; font-weight: 600; margin-bottom: 0.5rem;">🏆 Programa Agnello</div>
                    <div style="font-size: 0.9rem;">
                        Você ganhará <strong><%= (int)(subtotal * 0.1) %> pontos</strong> com esta compra!<br>
                        <span style="color: #D4AF37;">100 pontos = R$ 10 de desconto</span>
                    </div>
                </div>
            </div>
        </div>
        <%
            }
        %>
    </section>

    <!-- Produtos Salvos para Depois -->
    <section class="container" style="padding-bottom: 3rem;" id="salvos-section" style="display: none;">
        <h3 style="margin-bottom: 1.5rem;">Salvos para Depois</h3>
        <div id="produtos-salvos"></div>
    </section>

    <!-- Recomendações -->
    <section style="background-color: white; padding: 3rem 0;">
        <div class="container">
            <h3 style="margin-bottom: 2rem;">Frequentemente Comprados Juntos</h3>

            <div class="produtos-grid">
                <div class="card">
                    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 200 300'%3E%3Crect fill='%238B0000' width='200' height='300'/%3E%3Ctext x='100' y='150' text-anchor='middle' fill='%23D4AF37' font-size='14' font-family='serif'%3EDecanter%3C/text%3E%3C/svg%3E"
                        alt="Decanter">
                    <h4>Decanter de Cristal</h4>
                    <p>Realça os aromas dos vinhos tintos</p>
                    <div class="price">R$ 280,00</div>
                    <form action="carrinho" method="post" style="margin-top: 1rem;">
                        <input type="hidden" name="acao" value="adicionar">
                        <input type="hidden" name="produtoId" value="999">
                        <button type="submit" class="btn btn-primary" style="width: 100%;">
                            Adicionar ao Carrinho
                        </button>
                    </form>
                </div>

                <div class="card">
                    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 200 300'%3E%3Crect fill='%23B8860B' width='200' height='300'/%3E%3Ctext x='100' y='150' text-anchor='middle' fill='%23722F37' font-size='14' font-family='serif'%3ETaças%3C/text%3E%3C/svg%3E"
                        alt="Taças">
                    <h4>Kit 2 Taças Bordeaux</h4>
                    <p>Taças específicas para vinhos tintos</p>
                    <div class="price">R$ 150,00</div>
                    <form action="carrinho" method="post" style="margin-top: 1rem;">
                        <input type="hidden" name="acao" value="adicionar">
                        <input type="hidden" name="produtoId" value="998">
                        <button type="submit" class="btn btn-primary" style="width: 100%;">
                            Adicionar ao Carrinho
                        </button>
                    </form>
                </div>

                <div class="card">
                    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 200 300'%3E%3Crect fill='%234169E1' width='200' height='300'/%3E%3Ctext x='100' y='150' text-anchor='middle' fill='%23D4AF37' font-size='14' font-family='serif'%3ESaca-rolhas%3C/text%3E%3C/svg%3E"
                        alt="Saca-rolhas">
                    <h4>Saca-rolhas Sommelier</h4>
                    <p>Profissional com lâmina cortadora</p>
                    <div class="price">R$ 85,00</div>
                    <form action="carrinho" method="post" style="margin-top: 1rem;">
                        <input type="hidden" name="acao" value="adicionar">
                        <input type="hidden" name="produtoId" value="997">
                        <button type="submit" class="btn btn-primary" style="width: 100%;">
                            Adicionar ao Carrinho
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="footer-content">
                <div>
                    <h4>Contato</h4>
                    <p>📞 (11) 3456-7890</p>
                    <p>📧 contato@vinheriaagnello.com.br</p>
                    <p>📍 Rua dos Vinhos, 123 - São Paulo/SP</p>
                </div>

                <div>
                    <h4>Atendimento</h4>
                    <p>Segunda a Sexta: 9h às 18h</p>
                    <p>Sábado: 9h às 16h</p>
                    <p>WhatsApp: (11) 99999-9999</p>
                </div>

                <div>
                    <h4>Informações</h4>
                    <ul style="list-style: none;">
                        <li><a href="#">Política de Privacidade</a></li>
                        <li><a href="#">Termos de Uso</a></li>
                        <li><a href="#">Trocas e Devoluções</a></li>
                        <li><a href="#">Entrega</a></li>
                    </ul>
                </div>

                <div>
                    <h4>Redes Sociais</h4>
                    <ul style="list-style: none;">
                        <li><a href="#">Instagram</a></li>
                        <li><a href="#">Facebook</a></li>
                        <li><a href="#">YouTube</a></li>
                    </ul>
                </div>
            </div>

            <div class="footer-bottom">
                <p>&copy; 2025 Vinheria Agnello. Todos os direitos reservados.</p>
            </div>
        </div>
    </footer>

    <script>
        function salvarParaDepois(produtoId) {
            if (confirm('Salvar este produto para depois?')) {
                // Aqui implementaria a lógica para salvar para depois
                alert('Produto salvo para depois!');
            }
        }
    </script>
</body>

</html>

