<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.vinheria.model.Cliente" %>
<%@ page import="com.vinheria.model.Pedido" %>
<%@ page import="com.vinheria.model.Produto" %>
<%@ page import="java.util.List" %>
<%
    Cliente cliente = (Cliente) request.getAttribute("cliente");
    List<Pedido> pedidos = (List<Pedido>) request.getAttribute("pedidos");
    List<Produto> recomendacoes = (List<Produto>) request.getAttribute("recomendacoes");
    List<Produto> favoritos = (List<Produto>) request.getAttribute("favoritos");
    Integer pontos = (Integer) request.getAttribute("pontos");
    String secaoAtiva = (String) request.getAttribute("secaoAtiva");
    
    if (secaoAtiva == null) {
        secaoAtiva = "dashboard";
    }
    
    if (cliente == null) {
        // Fallback para cliente de exemplo
        cliente = new Cliente();
        cliente.setNome("Mariana Silva");
        cliente.setEmail("mariana.silva@email.com");
        cliente.setTelefone("(11) 99999-9999");
    }
    
    if (pontos == null) {
        pontos = 347;
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Minha Conta - Vinheria Agnello</title>
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
                <a href="carrinho.jsp" class="btn btn-primary">Carrinho (<%= request.getAttribute("carrinhoCount") != null ? request.getAttribute("carrinhoCount") : "0" %>)</a>
            </div>
        </div>
    </header>

    <!-- Breadcrumb -->
    <div class="container" style="padding: 1rem 0;">
        <nav style="color: #666;">
            <a href="index.jsp" style="color: #722F37;">Início</a> >
            <span>Minha Conta</span>
        </nav>
    </div>

    <!-- Boas-vindas -->
    <section class="container" style="padding: 2rem 0;">
        <div style="background: linear-gradient(135deg, #722F37, #8B4513); color: white; padding: 2rem; border-radius: 15px; text-align: center;">
            <h1 style="color: #D4AF37; margin-bottom: 1rem;">Olá, <%= cliente.getNome() %>!</h1>
            <p style="font-size: 1.1rem; margin-bottom: 1.5rem;">
                Bem-vinda de volta à Vinheria Agnello. Explore suas recomendações personalizadas e gerencie suas
                assinaturas.
            </p>
            <div style="display: flex; justify-content: center; gap: 1rem; flex-wrap: wrap;">
                <div style="background-color: rgba(255,255,255,0.1); padding: 1rem; border-radius: 10px;">
                    <div style="font-size: 1.5rem; font-weight: bold; color: #D4AF37;"><%= pontos %></div>
                    <div style="font-size: 0.9rem;">Pontos Acumulados</div>
                </div>
                <div style="background-color: rgba(255,255,255,0.1); padding: 1rem; border-radius: 10px;">
                    <div style="font-size: 1.5rem; font-weight: bold; color: #D4AF37;">12</div>
                    <div style="font-size: 0.9rem;">Pedidos Realizados</div>
                </div>
                <div style="background-color: rgba(255,255,255,0.1); padding: 1rem; border-radius: 10px;">
                    <div style="font-size: 1.5rem; font-weight: bold; color: #D4AF37;">Ativo</div>
                    <div style="font-size: 0.9rem;">Clube Agnello</div>
                </div>
            </div>
        </div>
    </section>

    <!-- Menu da Conta -->
    <section class="container">
        <div class="cliente-menu">
            <ul>
                <li><a href="cliente?secao=dashboard" class="menu-item <%= "dashboard".equals(secaoAtiva) ? "active" : "" %>">Dashboard</a></li>
                <li><a href="cliente?secao=pedidos" class="menu-item <%= "pedidos".equals(secaoAtiva) ? "active" : "" %>">Meus Pedidos</a></li>
                <li><a href="cliente?secao=clube" class="menu-item <%= "clube".equals(secaoAtiva) ? "active" : "" %>">Clube Agnello</a></li>
                <li><a href="cliente?secao=recomendacoes" class="menu-item <%= "recomendacoes".equals(secaoAtiva) ? "active" : "" %>">Recomendações</a></li>
                <li><a href="cliente?secao=favoritos" class="menu-item <%= "favoritos".equals(secaoAtiva) ? "active" : "" %>">Favoritos</a></li>
                <li><a href="cliente?secao=perfil" class="menu-item <%= "perfil".equals(secaoAtiva) ? "active" : "" %>">Meu Perfil</a></li>
                <li><a href="cliente?secao=enderecos" class="menu-item <%= "enderecos".equals(secaoAtiva) ? "active" : "" %>">Endereços</a></li>
                <li><a href="cliente?secao=pontos" class="menu-item <%= "pontos".equals(secaoAtiva) ? "active" : "" %>">Programa de Pontos</a></li>
            </ul>
        </div>
    </section>

    <!-- Conteúdo Dinâmico -->
    <section class="container" style="padding-bottom: 4rem;">

        <!-- Dashboard -->
        <% if ("dashboard".equals(secaoAtiva)) { %>
        <div id="dashboard-content" class="content-section">
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 2rem;">

                <!-- Último Pedido -->
                <div class="card">
                    <h3 style="margin-bottom: 1rem;">Último Pedido</h3>
                    <div style="border-bottom: 1px solid #eee; padding-bottom: 1rem; margin-bottom: 1rem;">
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <span><strong>Pedido #1247</strong></span>
                            <span style="color: #22c55e; font-weight: 600;">Entregue</span>
                        </div>
                        <div style="color: #666; font-size: 0.9rem; margin-top: 0.5rem;">
                            15 de agosto de 2024
                        </div>
                    </div>
                    <div style="font-size: 0.9rem; color: #666; margin-bottom: 1rem;">
                        • Brunello di Montalcino 2017<br>
                        • Decanter de Cristal
                    </div>
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <span style="font-weight: 600;">Total: R$ 1.170,00</span>
                        <a href="cliente?secao=pedidos" class="btn btn-secondary" style="font-size: 0.9rem;">Ver Detalhes</a>
                    </div>
                </div>

                <!-- Próxima Entrega do Clube -->
                <div class="card">
                    <h3 style="margin-bottom: 1rem;">Clube Agnello</h3>
                    <div style="background-color: #722F37; color: white; padding: 1rem; border-radius: 10px; margin-bottom: 1rem;">
                        <div style="color: #D4AF37; font-weight: 600; margin-bottom: 0.5rem;">Plano Sommelier Ativo</div>
                        <div style="font-size: 0.9rem;">Próxima entrega em 5 dias</div>
                    </div>
                    <div style="margin-bottom: 1rem;">
                        <div style="font-weight: 600; margin-bottom: 0.5rem;">Seleção de Setembro:</div>
                        <div style="font-size: 0.9rem; color: #666;">
                            • Chianti Classico DOCG 2019<br>
                            • Sancerre Loire Valley 2021<br>
                            • Rioja Gran Reserva 2016<br>
                            • Champagne Brut Premier Cru
                        </div>
                    </div>
                    <a href="cliente?secao=clube" class="btn btn-primary" style="width: 100%;">Gerenciar Assinatura</a>
                </div>

                <!-- Recomendações -->
                <div class="card">
                    <h3 style="margin-bottom: 1rem;">Recomendado para Você</h3>
                    <%
                        if (recomendacoes != null && !recomendacoes.isEmpty()) {
                            Produto recomendado = recomendacoes.get(0);
                    %>
                    <div style="text-align: center; margin-bottom: 1rem;">
                        <img src="<%= recomendado.getImagem() %>" style="width: 100px; height: 130px; border-radius: 5px;" alt="<%= recomendado.getNome() %>">
                    </div>
                    <h4 style="text-align: center; margin-bottom: 0.5rem;"><%= recomendado.getNome() %></h4>
                    <p style="text-align: center; color: #666; font-size: 0.9rem; margin-bottom: 1rem;">
                        Baseado no seu gosto por tintos estruturados
                    </p>
                    <div style="text-align: center; font-weight: 600; color: #722F37; margin-bottom: 1rem;">
                        R$ <%= String.format("%.2f", recomendado.getPreco()).replace(".", ",") %>
                    </div>
                    <a href="produto.jsp?id=<%= recomendado.getId() %>" class="btn btn-primary" style="width: 100%;">Ver Produto</a>
                    <%
                        } else {
                    %>
                    <div style="text-align: center; margin-bottom: 1rem;">
                        <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 150 200'%3E%3Crect fill='%23800080' width='150' height='200'/%3E%3Ctext x='75' y='100' text-anchor='middle' fill='%23D4AF37' font-size='12' font-family='serif'%3EBarolo%3C/text%3E%3C/svg%3E"
                            style="width: 100px; height: 130px; border-radius: 5px;" alt="Barolo DOCG">
                    </div>
                    <h4 style="text-align: center; margin-bottom: 0.5rem;">Barolo DOCG 2016</h4>
                    <p style="text-align: center; color: #666; font-size: 0.9rem; margin-bottom: 1rem;">
                        Baseado no seu gosto por tintos estruturados
                    </p>
                    <div style="text-align: center; font-weight: 600; color: #722F37; margin-bottom: 1rem;">
                        R$ 1.200,00
                    </div>
                    <a href="produto.jsp" class="btn btn-primary" style="width: 100%;">Ver Produto</a>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>
        <% } %>

        <!-- Meus Pedidos -->
        <% if ("pedidos".equals(secaoAtiva)) { %>
        <div id="pedidos-content" class="content-section">
            <h2 style="margin-bottom: 2rem;">Meus Pedidos</h2>

            <div style="margin-bottom: 2rem;">
                <div style="display: flex; gap: 1rem; flex-wrap: wrap;">
                    <button class="btn btn-primary">Todos</button>
                    <button class="btn btn-secondary">Entregues</button>
                    <button class="btn btn-secondary">Em Andamento</button>
                    <button class="btn btn-secondary">Cancelados</button>
                </div>
            </div>

            <%
                if (pedidos != null && !pedidos.isEmpty()) {
                    for (Pedido pedido : pedidos) {
            %>
            <div class="card" style="margin-bottom: 1.5rem;">
                <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 1rem;">
                    <div>
                        <h4>Pedido #<%= pedido.getId() %></h4>
                        <p style="color: #666;"><%= pedido.getDataFormatada() %></p>
                    </div>
                    <span style="color: #22c55e; font-weight: 600; background-color: #f0f9ff; padding: 0.5rem 1rem; border-radius: 20px;">
                        <%= pedido.getStatus() %>
                    </span>
                </div>
                <div style="border-top: 1px solid #eee; padding-top: 1rem;">
                    <div style="margin-bottom: 1rem;">
                        <strong>Itens:</strong><br>
                        <%
                            for (String item : pedido.getItens()) {
                        %>
                        • <%= item %><br>
                        <%
                            }
                        %>
                    </div>
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <span><strong>Total: R$ <%= String.format("%.2f", pedido.getTotal()).replace(".", ",") %></strong></span>
                        <div style="display: flex; gap: 1rem;">
                            <button class="btn btn-secondary">Ver Detalhes</button>
                            <button class="btn btn-primary">Comprar Novamente</button>
                        </div>
                    </div>
                </div>
            </div>
            <%
                    }
                } else {
            %>
            <!-- Fallback para pedidos -->
            <div class="card" style="margin-bottom: 1.5rem;">
                <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 1rem;">
                    <div>
                        <h4>Pedido #1247</h4>
                        <p style="color: #666;">15 de agosto de 2024</p>
                    </div>
                    <span style="color: #22c55e; font-weight: 600; background-color: #f0f9ff; padding: 0.5rem 1rem; border-radius: 20px;">
                        Entregue
                    </span>
                </div>
                <div style="border-top: 1px solid #eee; padding-top: 1rem;">
                    <div style="margin-bottom: 1rem;">
                        <strong>Itens:</strong><br>
                        • Brunello di Montalcino 2017 (1x)<br>
                        • Decanter de Cristal (1x)
                    </div>
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <span><strong>Total: R$ 1.170,00</strong></span>
                        <div style="display: flex; gap: 1rem;">
                            <button class="btn btn-secondary">Ver Detalhes</button>
                            <button class="btn btn-primary">Comprar Novamente</button>
                        </div>
                    </div>
                </div>
            </div>
            <%
                }
            %>
        </div>
        <% } %>

        <!-- Clube Agnello -->
        <% if ("clube".equals(secaoAtiva)) { %>
        <div id="clube-content" class="content-section">
            <h2 style="margin-bottom: 2rem;">Clube Agnello</h2>

            <div class="card" style="background: linear-gradient(135deg, #722F37, #8B4513); color: white; margin-bottom: 2rem;">
                <div style="text-align: center;">
                    <h3 style="color: #D4AF37; margin-bottom: 1rem;">Plano Sommelier</h3>
                    <div style="font-size: 2rem; font-weight: bold; margin-bottom: 0.5rem;">R$ 340/mês</div>
                    <div style="margin-bottom: 2rem;">4 garrafas selecionadas mensalmente</div>

                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 1rem; margin-bottom: 2rem;">
                        <div style="background-color: rgba(255,255,255,0.1); padding: 1rem; border-radius: 10px;">
                            <div style="font-weight: bold; color: #D4AF37;">Status</div>
                            <div>Ativo</div>
                        </div>
                        <div style="background-color: rgba(255,255,255,0.1); padding: 1rem; border-radius: 10px;">
                            <div style="font-weight: bold; color: #D4AF37;">Próxima Cobrança</div>
                            <div>15/09/2024</div>
                        </div>
                        <div style="background-color: rgba(255,255,255,0.1); padding: 1rem; border-radius: 10px;">
                            <div style="font-weight: bold; color: #D4AF37;">Entregas</div>
                            <div>8 realizadas</div>
                        </div>
                    </div>

                    <div style="display: flex; gap: 1rem; justify-content: center; flex-wrap: wrap;">
                        <button class="btn btn-secondary">Pausar Assinatura</button>
                        <button class="btn btn-primary">Alterar Plano</button>
                    </div>
                </div>
            </div>

            <div class="card">
                <h3 style="margin-bottom: 1.5rem;">Próxima Seleção - Setembro 2024</h3>
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1.5rem;">
                    <div style="text-align: center;">
                        <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 120 160'%3E%3Crect fill='%23B22222' width='120' height='160'/%3E%3Ctext x='60' y='80' text-anchor='middle' fill='%23D4AF37' font-size='10' font-family='serif'%3EChianti%3C/text%3E%3C/svg%3E"
                            style="width: 80px; height: 100px;">
                        <h4 style="margin: 0.5rem 0;">Chianti Classico</h4>
                        <p style="font-size: 0.9rem; color: #666;">Toscana, Itália</p>
                    </div>
                    <div style="text-align: center;">
                        <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 120 160'%3E%3Crect fill='%23F5F5DC' width='120' height='160'/%3E%3Ctext x='60' y='80' text-anchor='middle' fill='%23722F37' font-size='10' font-family='serif'%3ESancerre%3C/text%3E%3C/svg%3E"
                            style="width: 80px; height: 100px;">
                        <h4 style="margin: 0.5rem 0;">Sancerre</h4>
                        <p style="font-size: 0.9rem; color: #666;">Loire Valley, França</p>
                    </div>
                    <div style="text-align: center;">
                        <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 120 160'%3E%3Crect fill='%234B0082' width='120' height='160'/%3E%3Ctext x='60' y='80' text-anchor='middle' fill='%23D4AF37' font-size='10' font-family='serif'%3ERioja%3C/text%3E%3C/svg%3E"
                            style="width: 80px; height: 100px;">
                        <h4 style="margin: 0.5rem 0;">Rioja Gran Reserva</h4>
                        <p style="font-size: 0.9rem; color: #666;">La Rioja, Espanha</p>
                    </div>
                    <div style="text-align: center;">
                        <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 120 160'%3E%3Crect fill='%23FFD700' width='120' height='160'/%3E%3Ctext x='60' y='80' text-anchor='middle' fill='%23722F37' font-size='10' font-family='serif'%3EChampagne%3C/text%3E%3C/svg%3E"
                            style="width: 80px; height: 100px;">
                        <h4 style="margin: 0.5rem 0;">Champagne Brut</h4>
                        <p style="font-size: 0.9rem; color: #666;">Champagne, França</p>
                    </div>
                </div>
            </div>
        </div>
        <% } %>

        <!-- Recomendações -->
        <% if ("recomendacoes".equals(secaoAtiva)) { %>
        <div id="recomendacoes-content" class="content-section">
            <h2 style="margin-bottom: 2rem;">Recomendações Personalizadas</h2>

            <div style="background-color: #f5f5f5; padding: 1.5rem; border-radius: 10px; margin-bottom: 2rem;">
                <h3 style="margin-bottom: 1rem;">Baseado no seu Perfil</h3>
                <div style="display: flex; gap: 2rem; flex-wrap: wrap; align-items: center;">
                    <div><strong>Preferência:</strong> Tintos Estruturados</div>
                    <div><strong>Ocasião Frequente:</strong> Jantares Românticos</div>
                    <div><strong>Faixa de Preço:</strong> R$ 200 - R$ 800</div>
                </div>
            </div>

            <div class="produtos-grid">
                <%
                    if (recomendacoes != null && !recomendacoes.isEmpty()) {
                        for (Produto produto : recomendacoes) {
                %>
                <div class="card">
                    <img src="<%= produto.getImagem() %>" alt="<%= produto.getNome() %>">
                    <h4><%= produto.getNome() %></h4>
                    <p><strong>96% de compatibilidade</strong></p>
                    <p><%= produto.getDescricao() %></p>
                    <div class="price">R$ <%= String.format("%.2f", produto.getPreco()).replace(".", ",") %></div>
                    <a href="produto.jsp?id=<%= produto.getId() %>" class="btn btn-primary" style="width: 100%; margin-top: 1rem;">Ver Produto</a>
                </div>
                <%
                        }
                    } else {
                %>
                <!-- Fallback para recomendações -->
                <div class="card">
                    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 200 300'%3E%3Crect fill='%23800080' width='200' height='300'/%3E%3Ctext x='100' y='150' text-anchor='middle' fill='%23D4AF37' font-size='14' font-family='serif'%3EBarolo%3C/text%3E%3C/svg%3E"
                        alt="Barolo">
                    <h4>Barolo DOCG 2016</h4>
                    <p><strong>96% de compatibilidade</strong></p>
                    <p>Tinto estruturado italiano, perfeito para seus jantares especiais.</p>
                    <div class="price">R$ 1.200,00</div>
                    <a href="produto.jsp" class="btn btn-primary" style="width: 100%; margin-top: 1rem;">Ver Produto</a>
                </div>
                <%
                    }
                %>
            </div>
        </div>
        <% } %>

        <!-- Favoritos -->
        <% if ("favoritos".equals(secaoAtiva)) { %>
        <div id="favoritos-content" class="content-section">
            <h2 style="margin-bottom: 2rem;">Meus Favoritos</h2>

            <div class="produtos-grid">
                <%
                    if (favoritos != null && !favoritos.isEmpty()) {
                        for (Produto produto : favoritos) {
                %>
                <div class="card">
                    <img src="<%= produto.getImagem() %>" alt="<%= produto.getNome() %>">
                    <div style="position: absolute; top: 10px; right: 10px; color: red; font-size: 1.5rem;">♥</div>
                    <h4><%= produto.getNome() %></h4>
                    <p><%= produto.getPais() %> • <%= produto.getRegiao() %></p>
                    <div class="price">R$ <%= String.format("%.2f", produto.getPreco()).replace(".", ",") %></div>
                    <div style="display: flex; gap: 0.5rem; margin-top: 1rem;">
                        <a href="produto.jsp?id=<%= produto.getId() %>" class="btn btn-primary" style="flex: 1;">Ver Produto</a>
                        <form action="favoritos" method="post" style="display: inline;">
                            <input type="hidden" name="acao" value="remover">
                            <input type="hidden" name="produtoId" value="<%= produto.getId() %>">
                            <button type="submit" class="btn btn-secondary" onclick="return confirm('Remover dos favoritos?')">♥</button>
                        </form>
                    </div>
                </div>
                <%
                        }
                    } else {
                %>
                <!-- Fallback para favoritos -->
                <div class="card">
                    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 200 300'%3E%3Crect fill='%23722F37' width='200' height='300'/%3E%3Ctext x='100' y='150' text-anchor='middle' fill='%23D4AF37' font-size='14' font-family='serif'%3EMargaux%3C/text%3E%3C/svg%3E"
                        alt="Château Margaux">
                    <div style="position: absolute; top: 10px; right: 10px; color: red; font-size: 1.5rem;">♥</div>
                    <h4>Château Margaux 2018</h4>
                    <p>França • Bordeaux</p>
                    <div class="price">R$ 1.850,00</div>
                    <div style="display: flex; gap: 0.5rem; margin-top: 1rem;">
                        <a href="produto.jsp" class="btn btn-primary" style="flex: 1;">Ver Produto</a>
                        <button class="btn btn-secondary" onclick="removerFavorito(this)">♥</button>
                    </div>
                </div>
                <%
                    }
                %>
            </div>
        </div>
        <% } %>

        <!-- Programa de Pontos -->
        <% if ("pontos".equals(secaoAtiva)) { %>
        <div id="pontos-content" class="content-section">
            <h2 style="margin-bottom: 2rem;">Programa de Pontos Agnello</h2>

            <div class="card" style="background: linear-gradient(135deg, #722F37, #8B4513); color: white; text-align: center; margin-bottom: 2rem;">
                <h3 style="color: #D4AF37; margin-bottom: 1rem;">Seus Pontos</h3>
                <div style="font-size: 3rem; font-weight: bold; margin-bottom: 1rem;"><%= pontos %></div>
                <div style="margin-bottom: 2rem;">pontos disponíveis</div>
                <div style="color: #D4AF37; margin-bottom: 1rem;">= R$ <%= String.format("%.2f", pontos * 0.1).replace(".", ",") %> em desconto</div>
                <button class="btn btn-primary">Resgatar Pontos</button>
            </div>

            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 2rem;">
                <div class="card">
                    <h4 style="margin-bottom: 1rem;">Como Ganhar Pontos</h4>
                    <ul style="list-style: none; padding: 0;">
                        <li style="margin-bottom: 0.5rem;">🛒 <strong>1 ponto</strong> para cada R$ 10 gastos</li>
                        <li style="margin-bottom: 0.5rem;">⭐ <strong>20 pontos</strong> por avaliação de produto</li>
                        <li style="margin-bottom: 0.5rem;">📱 <strong>50 pontos</strong> por indicação de amigo</li>
                        <li style="margin-bottom: 0.5rem;">🎂 <strong>100 pontos</strong> no seu aniversário</li>
                    </ul>
                </div>

                <div class="card">
                    <h4 style="margin-bottom: 1rem;">Histórico de Pontos</h4>
                    <div style="font-size: 0.9rem;">
                        <div style="display: flex; justify-content: space-between; margin-bottom: 0.5rem; padding-bottom: 0.5rem; border-bottom: 1px solid #eee;">
                            <span>Compra #1247</span>
                            <span style="color: #22c55e;">+117 pontos</span>
                        </div>
                        <div style="display: flex; justify-content: space-between; margin-bottom: 0.5rem; padding-bottom: 0.5rem; border-bottom: 1px solid #eee;">
                            <span>Avaliação produto</span>
                            <span style="color: #22c55e;">+20 pontos</span>
                        </div>
                        <div style="display: flex; justify-content: space-between; margin-bottom: 0.5rem; padding-bottom: 0.5rem; border-bottom: 1px solid #eee;">
                            <span>Desconto usado</span>
                            <span style="color: #ef4444;">-100 pontos</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <% } %>

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
        function removerFavorito(btn) {
            if (confirm('Remover este produto dos favoritos?')) {
                btn.closest('.card').remove();
            }
        }

        // Simulação de funcionalidades
        function pausarAssinatura() {
            alert('Assinatura pausada! Você pode reativá-la a qualquer momento.');
        }

        function alterarPlano() {
            alert('Redirecionando para seleção de planos...');
        }

        function resgatarPontos() {
            alert('Seus pontos foram convertidos em desconto de R$ <%= String.format("%.2f", pontos * 0.1).replace(".", ",") %>!');
        }
    </script>
</body>

</html>

