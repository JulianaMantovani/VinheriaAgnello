<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.vinheria.model.Produto" %>
<%@ page import="com.vinheria.model.Avaliacao" %>
<%@ page import="java.util.List" %>
<%
    Produto produto = (Produto) request.getAttribute("produto");
    List<Produto> relacionados = (List<Produto>) request.getAttribute("relacionados");
    List<Avaliacao> avaliacoes = (List<Avaliacao>) request.getAttribute("avaliacoes");
    
    if (produto == null) {
        // Fallback para quando não há produto específico
        produto = new Produto();
        produto.setId(1);
        produto.setNome("Château Margaux 2018");
        produto.setDescricao("Bordeaux francês com notas de frutas vermelhas e taninos elegantes.");
        produto.setPreco(1850.00);
        produto.setImagem("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 300 400'%3E%3Crect fill='%23722F37' width='300' height='400'/%3E%3Ctext x='150' y='180' text-anchor='middle' fill='%23D4AF37' font-size='18' font-family='serif'%3EChâteau%3C/text%3E%3Ctext x='150' y='210' text-anchor='middle' fill='%23D4AF37' font-size='18' font-family='serif'%3EMargaux%3C/text%3E%3Ctext x='150' y='240' text-anchor='middle' fill='%23D4AF37' font-size='16' font-family='serif'%3E2018%3C/text%3E%3C/svg%3E");
        produto.setPais("França");
        produto.setRegiao("Bordeaux");
        produto.setTipo("Tinto");
        produto.setTeorAlcoolico(14);
        produto.setSafra(2018);
        produto.setTemperatura("16-18°C");
        produto.setUva("Cabernet Sauvignon, Merlot");
        produto.setProdutor("Château Margaux");
        produto.setVolume("750ml");
        produto.setGuarda("25-30 anos");
        produto.setAvaliacao("★★★★★");
        produto.setNumAvaliacoes(12);
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= produto.getNome() %> - Vinheria Agnello</title>
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
            <a href="catalogo.jsp" style="color: #722F37;">Catálogo</a> >
            <a href="catalogo.jsp?tipo=<%= produto.getTipo().toLowerCase() %>" style="color: #722F37;">Vinhos <%= produto.getTipo() %>s</a> >
            <span><%= produto.getNome() %></span>
        </nav>
    </div>

    <!-- Produto Principal -->
    <section class="container" style="padding: 2rem 0;">
        <div class="produto-detalhes">
            <div class="produto-imagem">
                <img src="<%= produto.getImagem() %>" alt="<%= produto.getNome() %>">

                <!-- Miniaturas -->
                <div style="display: flex; gap: 1rem; margin-top: 1rem; justify-content: center;">
                    <img src="<%= produto.getImagem() %>" style="width: 60px; height: 80px; border: 2px solid #D4AF37; cursor: pointer;">
                    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 60 80'%3E%3Crect fill='%238B0000' width='60' height='80'/%3E%3C/svg%3E" style="width: 60px; height: 80px; border: 1px solid #ddd; cursor: pointer;">
                    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 60 80'%3E%3Crect fill='%23654321' width='60' height='80'/%3E%3C/svg%3E" style="width: 60px; height: 80px; border: 1px solid #ddd; cursor: pointer;">
                </div>
            </div>

            <div class="produto-info">
                <h1><%= produto.getNome() %></h1>

                <div style="display: flex; align-items: center; gap: 1rem; margin-bottom: 1rem;">
                    <div style="color: #D4AF37; font-size: 1.2rem;"><%= produto.getAvaliacao() %></div>
                    <span style="color: #666;">(<%= produto.getNumAvaliacoes() %> avaliações)</span>
                    <span style="color: #722F37; font-weight: 600;"><%= produto.getPais() %> • <%= produto.getRegiao() %></span>
                </div>

                <div class="price">R$ <%= String.format("%.2f", produto.getPreco()).replace(".", ",") %></div>
                <p style="color: #666; margin-bottom: 2rem;">ou 12x de R$ <%= String.format("%.2f", produto.getPreco() / 12).replace(".", ",") %> sem juros</p>

                <div class="descricao">
                    <p><strong>Um dos grandes vinhos de <%= produto.getRegiao() %></strong></p>
                    <p><%= produto.getDescricao() %></p>
                    <p>
                        Com potencial de guarda de <%= produto.getGuarda() %>, este vinho desenvolverá ainda
                        mais complexidade ao longo do tempo, revelando camadas aromáticas
                        de trufa, tabaco e couro fino.
                    </p>
                </div>

                <!-- Informações Técnicas -->
                <div style="background-color: #f5f5f5; padding: 1.5rem; border-radius: 10px; margin-bottom: 2rem;">
                    <h3 style="margin-bottom: 1rem;">Informações Técnicas</h3>
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                        <div><strong>Tipo:</strong> <%= produto.getTipo() %></div>
                        <div><strong>Teor Alcoólico:</strong> <%= produto.getTeorAlcoolico() %>%</div>
                        <div><strong>Safra:</strong> <%= produto.getSafra() %></div>
                        <div><strong>Temperatura:</strong> <%= produto.getTemperatura() %></div>
                        <div><strong>Uva:</strong> <%= produto.getUva() %></div>
                        <div><strong>Produtor:</strong> <%= produto.getProdutor() %></div>
                        <div><strong>Volume:</strong> <%= produto.getVolume() %></div>
                        <div><strong>Guarda:</strong> <%= produto.getGuarda() %></div>
                    </div>
                </div>

                <!-- Ações -->
                <div style="display: flex; gap: 1rem; margin-bottom: 2rem;">
                    <div style="display: flex; align-items: center; gap: 1rem;">
                        <label for="quantidade"><strong>Quantidade:</strong></label>
                        <div class="quantidade-control">
                            <button type="button" onclick="alterarQuantidade(-1)">-</button>
                            <input type="number" id="quantidade" value="1" min="1" max="6" style="width: 60px; text-align: center; border: 1px solid #ddd; padding: 0.5rem;">
                            <button type="button" onclick="alterarQuantidade(1)">+</button>
                        </div>
                        <span style="color: #666; font-size: 0.9rem;">(máx. 6 unidades)</span>
                    </div>
                </div>

                <div style="display: flex; gap: 1rem; margin-bottom: 2rem;">
                    <form action="carrinho" method="post" style="flex: 2;">
                        <input type="hidden" name="acao" value="adicionar">
                        <input type="hidden" name="produtoId" value="<%= produto.getId() %>">
                        <input type="hidden" name="quantidade" id="quantidadeHidden" value="1">
                        <button type="submit" class="btn btn-primary" style="width: 100%;">
                            Adicionar ao Carrinho
                        </button>
                    </form>
                    <button class="btn btn-secondary" style="flex: 1;" onclick="adicionarFavoritos()">
                        ♡ Favoritar
                    </button>
                </div>

                <!-- Benefícios -->
                <div style="background-color: #722F37; color: white; padding: 1.5rem; border-radius: 10px;">
                    <h4 style="color: #D4AF37; margin-bottom: 1rem;">Benefícios da Vinheria Agnello</h4>
                    <ul style="list-style: none; padding: 0;">
                        <li style="margin-bottom: 0.5rem;">✓ Frete grátis para compras acima de R$ 300</li>
                        <li style="margin-bottom: 0.5rem;">✓ Garantia de procedência e autenticidade</li>
                        <li style="margin-bottom: 0.5rem;">✓ Consultoria gratuita com nossos sommeliers</li>
                        <li style="margin-bottom: 0.5rem;">✓ Programa de fidelidade com pontos</li>
                        <li>✓ Devolução em até 30 dias</li>
                    </ul>
                </div>
            </div>
        </div>
    </section>

    <!-- Harmonização -->
    <section class="container">
        <div class="harmonizacao">
            <h3>Harmonização Sugerida pelo Sr. Giulio</h3>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 2rem; margin-top: 1.5rem;">
                <div style="text-align: center;">
                    <div style="font-size: 3rem; margin-bottom: 0.5rem;">🥩</div>
                    <h4>Carnes Vermelhas</h4>
                    <p>Filé mignon, costela assada, cordeiro grelhado</p>
                </div>
                <div style="text-align: center;">
                    <div style="font-size: 3rem; margin-bottom: 0.5rem;">🧀</div>
                    <h4>Queijos Maduros</h4>
                    <p>Roquefort, Camembert, queijos de cabra curados</p>
                </div>
                <div style="text-align: center;">
                    <div style="font-size: 3rem; margin-bottom: 0.5rem;">🍄</div>
                    <h4>Pratos Elaborados</h4>
                    <p>Risotto de cogumelos, caça, pratos com trufa</p>
                </div>
            </div>
        </div>
    </section>

    <!-- História do Vinho -->
    <section class="container" style="padding: 3rem 0;">
        <div style="background-color: white; padding: 2rem; border-radius: 10px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
            <h3 style="margin-bottom: 1.5rem;">A História por Trás do Rótulo</h3>
            <div style="display: grid; grid-template-columns: 1fr 2fr; gap: 2rem; align-items: center;">
                <div>
                    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 300 200'%3E%3Crect fill='%23722F37' width='300' height='200'/%3E%3Ctext x='150' y='100' text-anchor='middle' fill='%23D4AF37' font-size='16' font-family='serif'%3ESr. Giulio%3C/text%3E%3C/svg%3E"
                        alt="Sr. Giulio falando sobre o vinho" style="width: 100%; border-radius: 10px;">
                    <p style="text-align: center; margin-top: 1rem; font-style: italic; color: #666;">
                        Sr. Giulio na adega, explicando a seleção
                    </p>
                </div>
                <div>
                    <p style="margin-bottom: 1rem;">
                        <em>"O <%= produto.getNome() %> é mais que um vinho, é uma obra de arte líquida.
                            Cada garrafa carrega séculos de tradição e o melhor do terroir <%= produto.getPais().toLowerCase() %>."</em>
                    </p>
                    <p style="margin-bottom: 1rem;">
                        O <%= produto.getNome() %>, propriedade histórica de <%= produto.getRegiao() %>, produz vinhos desde o século XII.
                        A safra de <%= produto.getSafra() %> foi particularmente excepcional, com condições climáticas ideais
                        que resultaram em uvas de qualidade superior.
                    </p>
                    <p>
                        Nossa seleção deste rótulo seguiu critérios rigorosos de qualidade, garantindo
                        que cada garrafa chegue até você em perfeitas condições de guarda e degustação.
                    </p>
                </div>
            </div>
        </div>
    </section>

    <!-- Avaliações -->
    <section class="container" style="padding-bottom: 3rem;">
        <h3 style="margin-bottom: 2rem;">Avaliações dos Clientes</h3>

        <div style="display: grid; gap: 1.5rem;">
            <%
                if (avaliacoes != null && !avaliacoes.isEmpty()) {
                    for (Avaliacao avaliacao : avaliacoes) {
            %>
            <div class="card">
                <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 1rem;">
                    <div>
                        <h4><%= avaliacao.getNomeCliente() %></h4>
                        <div style="color: #D4AF37;"><%= avaliacao.getEstrelas() %></div>
                    </div>
                    <span style="color: #666; font-size: 0.9rem;"><%= avaliacao.getDataFormatada() %></span>
                </div>
                <p>"<%= avaliacao.getComentario() %>"</p>
            </div>
            <%
                    }
                } else {
            %>
            <!-- Fallback para avaliações -->
            <div class="card">
                <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 1rem;">
                    <div>
                        <h4>Maria Silva</h4>
                        <div style="color: #D4AF37;">★★★★★</div>
                    </div>
                    <span style="color: #666; font-size: 0.9rem;">15/08/2024</span>
                </div>
                <p>"Simplesmente excepcional! Um vinho que justifica cada centavo. A complexidade aromática é
                    impressionante e a harmonização com o cordeiro foi perfeita. Recomendo!"</p>
            </div>

            <div class="card">
                <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 1rem;">
                    <div>
                        <h4>Carlos Mendes</h4>
                        <div style="color: #D4AF37;">★★★★★</div>
                    </div>
                    <span style="color: #666; font-size: 0.9rem;">02/08/2024</span>
                </div>
                <p>"Comprei para uma ocasião especial e superou todas as expectativas. O atendimento da Vinheria Agnello
                    também foi impecável, com explicações detalhadas sobre o vinho."</p>
            </div>
            <%
                }
            %>
        </div>

        <div style="text-align: center; margin-top: 2rem;">
            <button class="btn btn-secondary">Ver Todas as Avaliações</button>
            <button class="btn btn-primary" style="margin-left: 1rem;">Escrever Avaliação</button>
        </div>
    </section>

    <!-- Produtos Relacionados -->
    <%
        if (relacionados != null && !relacionados.isEmpty()) {
    %>
    <section style="background-color: white; padding: 3rem 0;">
        <div class="container">
            <h3 style="margin-bottom: 2rem;">Produtos Relacionados</h3>

            <div class="produtos-grid">
                <%
                    for (Produto relacionado : relacionados) {
                %>
                <div class="card">
                    <img src="<%= relacionado.getImagem() %>" alt="<%= relacionado.getNome() %>">
                    <h4><%= relacionado.getNome() %></h4>
                    <p><%= relacionado.getPais() %> • <%= relacionado.getRegiao() %></p>
                    <div class="price">R$ <%= String.format("%.2f", relacionado.getPreco()).replace(".", ",") %></div>
                    <a href="produto.jsp?id=<%= relacionado.getId() %>" class="btn btn-primary" style="width: 100%; margin-top: 1rem;">Ver Produto</a>
                </div>
                <%
                    }
                %>
            </div>
        </div>
    </section>
    <%
        }
    %>

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
        function alterarQuantidade(delta) {
            const quantidadeInput = document.getElementById('quantidade');
            const quantidadeHidden = document.getElementById('quantidadeHidden');
            const currentValue = parseInt(quantidadeInput.value);
            const newValue = currentValue + delta;

            if (newValue >= 1 && newValue <= 6) {
                quantidadeInput.value = newValue;
                quantidadeHidden.value = newValue;
            }
        }

        function adicionarFavoritos() {
            const btn = event.target;
            if (btn.textContent.includes('♡')) {
                btn.innerHTML = '♥ Favoritado';
                btn.style.backgroundColor = '#722F37';
                btn.style.color = 'white';
                alert('Produto adicionado aos favoritos!');
            } else {
                btn.innerHTML = '♡ Favoritar';
                btn.style.backgroundColor = '';
                btn.style.color = '';
                alert('Produto removido dos favoritos!');
            }
        }

        // Controle de quantidade
        document.addEventListener('DOMContentLoaded', function () {
            const quantidadeInput = document.getElementById('quantidade');
            const quantidadeHidden = document.getElementById('quantidadeHidden');
            
            quantidadeInput.addEventListener('change', function() {
                const value = parseInt(this.value);
                if (value >= 1 && value <= 6) {
                    quantidadeHidden.value = value;
                } else {
                    this.value = 1;
                    quantidadeHidden.value = 1;
                }
            });
        });
    </script>
</body>

</html>

