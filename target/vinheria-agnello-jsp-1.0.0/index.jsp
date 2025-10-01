<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.vinheria.model.Produto" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="pt-BR">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vinheria Agnello - Vinhos Selecionados</title>
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

    <!-- Hero Section -->
    <section class="hero">
        <div class="container">
            <h1>Bem-vindos à Vinheria Agnello</h1>
            <p>Três gerações de tradição em vinhos selecionados. Descubra rótulos únicos com a curadoria especializada
                do Sr. Giulio e experimente o melhor do mundo vinícola.</p>
            <a href="catalogo.jsp" class="btn btn-primary">Explorar Vinhos</a>
        </div>
    </section>

    <!-- Destaques -->
    <section class="container" style="padding: 4rem 0;">
        <h2 style="text-align: center; margin-bottom: 3rem;">Vinhos em Destaque</h2>

        <div class="produtos-grid">
            <%
                List<Produto> destaques = (List<Produto>) request.getAttribute("destaques");
                if (destaques != null && !destaques.isEmpty()) {
                    for (Produto produto : destaques) {
            %>
            <div class="card fade-in">
                <img src="<%= produto.getImagem() %>" alt="<%= produto.getNome() %>">
                <h3><%= produto.getNome() %></h3>
                <p><%= produto.getDescricao() %></p>
                <div class="price">R$ <%= String.format("%.2f", produto.getPreco()).replace(".", ",") %></div>
                <a href="produto.jsp?id=<%= produto.getId() %>" class="btn btn-primary" style="width: 100%; margin-top: 1rem;">Ver Detalhes</a>
            </div>
            <%
                    }
                } else {
            %>
            <!-- Fallback para quando não há produtos -->
            <div class="card fade-in">
                <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 200 300'%3E%3Crect fill='%23722F37' width='200' height='300'/%3E%3Ctext x='100' y='150' text-anchor='middle' fill='%23D4AF37' font-size='16' font-family='serif'%3EVinho Tinto%3C/text%3E%3C/svg%3E"
                    alt="Bordeaux Premium">
                <h3>Château Margaux 2018</h3>
                <p>Bordeaux francês com notas de frutas vermelhas e taninos elegantes.</p>
                <div class="price">R$ 1.850,00</div>
                <a href="produto.jsp" class="btn btn-primary" style="width: 100%; margin-top: 1rem;">Ver Detalhes</a>
            </div>

            <div class="card fade-in">
                <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 200 300'%3E%3Crect fill='%23F5F5DC' width='200' height='300'/%3E%3Ctext x='100' y='150' text-anchor='middle' fill='%23722F37' font-size='16' font-family='serif'%3EVinho Branco%3C/text%3E%3C/svg%3E"
                    alt="Chardonnay Premium">
                <h3>Chardonnay Reserve 2020</h3>
                <p>Branco californiano com toques de carvalho e notas cítricas.</p>
                <div class="price">R$ 320,00</div>
                <a href="produto.jsp" class="btn btn-primary" style="width: 100%; margin-top: 1rem;">Ver Detalhes</a>
            </div>

            <div class="card fade-in">
                <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 200 300'%3E%3Crect fill='%238B0000' width='200' height='300'/%3E%3Ctext x='100' y='150' text-anchor='middle' fill='%23D4AF37' font-size='14' font-family='serif'%3EBrunello%3C/text%3E%3C/svg%3E"
                    alt="Brunello di Montalcino">
                <h3>Brunello di Montalcino 2017</h3>
                <p>Italiano encorpado com aromas complexos de frutas maduras.</p>
                <div class="price">R$ 890,00</div>
                <a href="produto.jsp" class="btn btn-primary" style="width: 100%; margin-top: 1rem;">Ver Detalhes</a>
            </div>
            <%
                }
            %>
        </div>
    </section>

    <!-- Recomendações por Ocasião -->
    <section style="background-color: white; padding: 4rem 0;">
        <div class="container">
            <h2 style="text-align: center; margin-bottom: 3rem;">Recomendações por Ocasião</h2>

            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 2rem;">
                <div class="card">
                    <h3>Jantar Romântico</h3>
                    <p>Vinhos tintos elegantes e brancos aromáticos para momentos especiais a dois.</p>
                    <a href="catalogo.jsp?ocasiao=romantico" class="btn btn-secondary">Ver Seleção</a>
                </div>

                <div class="card">
                    <h3>Churrasco</h3>
                    <p>Tintos encorpados e robustos que harmonizam perfeitamente com carnes grelhadas.</p>
                    <a href="catalogo.jsp?ocasiao=churrasco" class="btn btn-secondary">Ver Seleção</a>
                </div>

                <div class="card">
                    <h3>Confraternização</h3>
                    <p>Espumantes e vinhos leves para celebrar com amigos e familiares.</p>
                    <a href="catalogo.jsp?ocasiao=festa" class="btn btn-secondary">Ver Seleção</a>
                </div>
            </div>
        </div>
    </section>

    <!-- Clube de Assinaturas -->
    <section class="container" style="padding: 4rem 0;">
        <div class="card"
            style="text-align: center; background: linear-gradient(135deg, #722F37, #8B4513); color: white;">
            <h2 style="color: #D4AF37; margin-bottom: 2rem;">Clube Agnello</h2>
            <p style="font-size: 1.2rem; margin-bottom: 2rem; max-width: 600px; margin-left: auto; margin-right: auto;">
                Receba mensalmente vinhos selecionados pelo Sr. Giulio com histórias exclusivas e fichas técnicas
                detalhadas.
            </p>
            <div style="display: flex; justify-content: center; gap: 2rem; flex-wrap: wrap;">
                <div>
                    <h4 style="color: #D4AF37;">Plano Descoberta</h4>
                    <p>2 garrafas por mês</p>
                    <div style="font-size: 1.5rem; font-weight: bold; margin: 1rem 0;">R$ 180/mês</div>
                </div>
                <div>
                    <h4 style="color: #D4AF37;">Plano Sommelier</h4>
                    <p>4 garrafas por mês</p>
                    <div style="font-size: 1.5rem; font-weight: bold; margin: 1rem 0;">R$ 340/mês</div>
                </div>
            </div>
            <a href="cliente.jsp" class="btn btn-primary" style="margin-top: 2rem;">Assinar Agora</a>
        </div>
    </section>

    <!-- Sobre -->
    <section id="sobre" style="background-color: white; padding: 4rem 0;">
        <div class="container">
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 3rem; align-items: center;">
                <div>
                    <h2>Nossa História</h2>
                    <p style="margin-bottom: 1rem;">
                        Há três gerações, a família Agnello dedica-se à arte de selecionar os melhores vinhos do mundo.
                        O Sr. Giulio, com sua vasta experiência, e sua filha Bianca continuam essa tradição,
                        oferecendo não apenas vinhos excepcionais, mas também conhecimento e paixão.
                    </p>
                    <p>
                        Cada garrafa em nossa adega conta uma história, carrega a tradição de seu terroir
                        e representa nossa busca incansável pela excelência.
                    </p>
                </div>
                <div>
                    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 400 300'%3E%3Crect fill='%23722F37' width='400' height='300'/%3E%3Ctext x='200' y='150' text-anchor='middle' fill='%23D4AF37' font-size='24' font-family='serif'%3ESr. Giulio%3C/text%3E%3C/svg%3E"
                        alt="Sr. Giulio na vinheria" style="width: 100%; border-radius: 10px;">
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
        // Animação fade-in simples
        document.addEventListener('DOMContentLoaded', function () {
            const cards = document.querySelectorAll('.fade-in');

            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.style.opacity = '1';
                        entry.target.style.transform = 'translateY(0)';
                    }
                });
            });

            cards.forEach(card => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                card.style.transition = 'all 0.6s ease-out';
                observer.observe(card);
            });
        });
    </script>
</body>

</html>

