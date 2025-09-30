<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.vinheria.model.Produto" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="pt-BR">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Catálogo de Vinhos - Vinheria Agnello</title>
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
                    <li><a href="catalogo.jsp" class="active">Catálogo</a></li>
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
            <span>Catálogo</span>
        </nav>
    </div>

    <!-- Filtros -->
    <section class="container">
        <form action="catalogo" method="get" class="filtros">
            <h3>Filtrar Vinhos</h3>
            <div class="filtros-group">
                <div>
                    <label for="tipo">Tipo:</label>
                    <select id="tipo" name="tipo">
                        <option value="">Todos</option>
                        <option value="tinto" <%= "tinto".equals(request.getParameter("tipo")) ? "selected" : "" %>>Tinto</option>
                        <option value="branco" <%= "branco".equals(request.getParameter("tipo")) ? "selected" : "" %>>Branco</option>
                        <option value="rose" <%= "rose".equals(request.getParameter("tipo")) ? "selected" : "" %>>Rosé</option>
                        <option value="espumante" <%= "espumante".equals(request.getParameter("tipo")) ? "selected" : "" %>>Espumante</option>
                    </select>
                </div>

                <div>
                    <label for="pais">País:</label>
                    <select id="pais" name="pais">
                        <option value="">Todos</option>
                        <option value="franca" <%= "franca".equals(request.getParameter("pais")) ? "selected" : "" %>>França</option>
                        <option value="italia" <%= "italia".equals(request.getParameter("pais")) ? "selected" : "" %>>Itália</option>
                        <option value="espanha" <%= "espanha".equals(request.getParameter("pais")) ? "selected" : "" %>>Espanha</option>
                        <option value="brasil" <%= "brasil".equals(request.getParameter("pais")) ? "selected" : "" %>>Brasil</option>
                        <option value="chile" <%= "chile".equals(request.getParameter("pais")) ? "selected" : "" %>>Chile</option>
                        <option value="argentina" <%= "argentina".equals(request.getParameter("pais")) ? "selected" : "" %>>Argentina</option>
                        <option value="eua" <%= "eua".equals(request.getParameter("pais")) ? "selected" : "" %>>Estados Unidos</option>
                    </select>
                </div>

                <div>
                    <label for="preco">Faixa de Preço:</label>
                    <select id="preco" name="preco">
                        <option value="">Todas</option>
                        <option value="0-100" <%= "0-100".equals(request.getParameter("preco")) ? "selected" : "" %>>Até R$ 100</option>
                        <option value="100-300" <%= "100-300".equals(request.getParameter("preco")) ? "selected" : "" %>>R$ 100 - R$ 300</option>
                        <option value="300-500" <%= "300-500".equals(request.getParameter("preco")) ? "selected" : "" %>>R$ 300 - R$ 500</option>
                        <option value="500-1000" <%= "500-1000".equals(request.getParameter("preco")) ? "selected" : "" %>>R$ 500 - R$ 1.000</option>
                        <option value="1000+" <%= "1000+".equals(request.getParameter("preco")) ? "selected" : "" %>>Acima de R$ 1.000</option>
                    </select>
                </div>

                <div>
                    <label for="ordenacao">Ordenar por:</label>
                    <select id="ordenacao" name="ordenacao">
                        <option value="relevancia" <%= "relevancia".equals(request.getParameter("ordenacao")) ? "selected" : "" %>>Relevância</option>
                        <option value="preco-menor" <%= "preco-menor".equals(request.getParameter("ordenacao")) ? "selected" : "" %>>Menor Preço</option>
                        <option value="preco-maior" <%= "preco-maior".equals(request.getParameter("ordenacao")) ? "selected" : "" %>>Maior Preço</option>
                        <option value="nome" <%= "nome".equals(request.getParameter("ordenacao")) ? "selected" : "" %>>Nome A-Z</option>
                        <option value="avaliacao" <%= "avaliacao".equals(request.getParameter("ordenacao")) ? "selected" : "" %>>Melhor Avaliados</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-primary">Aplicar Filtros</button>
            </div>
        </form>
    </section>

    <!-- Resultados -->
    <section class="container" style="padding-bottom: 4rem;">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
            <h2>Nosso Catálogo (<%= request.getAttribute("totalProdutos") != null ? request.getAttribute("totalProdutos") : "0" %> vinhos encontrados)</h2>
            <div style="display: flex; gap: 1rem;">
                <button class="btn btn-secondary" id="view-grid">Grade</button>
                <button class="btn btn-secondary" id="view-list">Lista</button>
            </div>
        </div>

        <div class="produtos-grid" id="produtos-container">
            <%
                List<Produto> produtos = (List<Produto>) request.getAttribute("produtos");
                if (produtos != null && !produtos.isEmpty()) {
                    for (Produto produto : produtos) {
            %>
            <div class="card">
                <img src="<%= produto.getImagem() %>" alt="<%= produto.getNome() %>">
                <h3><%= produto.getNome() %></h3>
                <p><strong><%= produto.getPais() %> • <%= produto.getRegiao() %></strong></p>
                <p><%= produto.getDescricao() %></p>
                <div style="margin: 1rem 0;">
                    <span style="color: #D4AF37;"><%= produto.getAvaliacao() %></span>
                    <span style="color: #666; font-size: 0.9rem;">(<%= produto.getNumAvaliacoes() %> avaliações)</span>
                </div>
                <div class="price">R$ <%= String.format("%.2f", produto.getPreco()).replace(".", ",") %></div>
                <div style="display: flex; gap: 0.5rem; margin-top: 1rem;">
                    <a href="produto.jsp?id=<%= produto.getId() %>" class="btn btn-secondary" style="flex: 1;">Ver Detalhes</a>
                    <form action="carrinho" method="post" style="flex: 1; display: inline;">
                        <input type="hidden" name="acao" value="adicionar">
                        <input type="hidden" name="produtoId" value="<%= produto.getId() %>">
                        <button type="submit" class="btn btn-primary" style="width: 100%;">Adicionar</button>
                    </form>
                </div>
            </div>
            <%
                    }
                } else {
            %>
            <!-- Fallback para quando não há produtos -->
            <div class="card">
                <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 200 300'%3E%3Crect fill='%23722F37' width='200' height='300'/%3E%3Ctext x='100' y='140' text-anchor='middle' fill='%23D4AF37' font-size='14' font-family='serif'%3EChâteau%3C/text%3E%3Ctext x='100' y='160' text-anchor='middle' fill='%23D4AF37' font-size='14' font-family='serif'%3EMargaux%3C/text%3E%3C/svg%3E"
                    alt="Château Margaux">
                <h3>Château Margaux 2018</h3>
                <p><strong>França • Bordeaux</strong></p>
                <p>Bordeaux excepcional com taninos elegantes e notas de frutas vermelhas maduras.</p>
                <div style="margin: 1rem 0;">
                    <span style="color: #D4AF37;">★★★★★</span>
                    <span style="color: #666; font-size: 0.9rem;">(12 avaliações)</span>
                </div>
                <div class="price">R$ 1.850,00</div>
                <div style="display: flex; gap: 0.5rem; margin-top: 1rem;">
                    <a href="produto.jsp" class="btn btn-secondary" style="flex: 1;">Ver Detalhes</a>
                    <button class="btn btn-primary" style="flex: 1;">Adicionar</button>
                </div>
            </div>
            <%
                }
            %>
        </div>

        <!-- Paginação -->
        <div style="display: flex; justify-content: center; margin-top: 3rem; gap: 1rem;">
            <%
                Integer paginaAtual = (Integer) request.getAttribute("paginaAtual");
                Integer totalPaginas = (Integer) request.getAttribute("totalPaginas");
                if (paginaAtual != null && totalPaginas != null) {
                    if (paginaAtual > 1) {
            %>
            <a href="catalogo?pagina=<%= paginaAtual - 1 %>" class="btn btn-secondary">← Anterior</a>
            <%
                    }
                    for (int i = 1; i <= totalPaginas; i++) {
                        if (i == paginaAtual) {
            %>
            <span class="btn btn-primary"><%= i %></span>
            <%
                        } else {
            %>
            <a href="catalogo?pagina=<%= i %>" class="btn btn-secondary"><%= i %></a>
            <%
                        }
                    }
                    if (paginaAtual < totalPaginas) {
            %>
            <a href="catalogo?pagina=<%= paginaAtual + 1 %>" class="btn btn-secondary">Próximo →</a>
            <%
                    }
                }
            %>
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
        // Funcionalidade de filtros e visualização
        document.addEventListener('DOMContentLoaded', function () {
            const viewGrid = document.getElementById('view-grid');
            const viewList = document.getElementById('view-list');
            const container = document.getElementById('produtos-container');

            viewGrid.addEventListener('click', function () {
                container.className = 'produtos-grid';
                viewGrid.classList.add('btn-primary');
                viewGrid.classList.remove('btn-secondary');
                viewList.classList.add('btn-secondary');
                viewList.classList.remove('btn-primary');
            });

            viewList.addEventListener('click', function () {
                container.className = 'produtos-lista';
                container.style.display = 'flex';
                container.style.flexDirection = 'column';
                container.style.gap = '1rem';
                viewList.classList.add('btn-primary');
                viewList.classList.remove('btn-secondary');
                viewGrid.classList.add('btn-secondary');
                viewGrid.classList.remove('btn-primary');

                // Ajustar layout dos cards para lista
                const cards = container.querySelectorAll('.card');
                cards.forEach(card => {
                    card.style.display = 'flex';
                    card.style.alignItems = 'center';
                    card.style.gap = '2rem';
                    card.style.padding = '1.5rem';

                    const img = card.querySelector('img');
                    if (img) {
                        img.style.width = '120px';
                        img.style.height = '150px';
                        img.style.flexShrink = '0';
                    }
                });
            });
        });
    </script>
</body>

</html>

