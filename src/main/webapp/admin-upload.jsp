<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="com.vinheria.model.Produto" %>
<%@ page import="com.vinheria.dao.ProdutoDAO" %>
<%@ page import="java.util.List" %>

<%
    // Buscar lista de produtos para associar a imagem
    ProdutoDAO produtoDAO = new ProdutoDAO();
    List<Produto> produtos = produtoDAO.listarTodos();
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Upload de Imagem - Vinheria Agnello</title>
    <link rel="stylesheet" href="../styles.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f7f3ef;
            margin: 0;
            padding: 0;
        }

        .container {
            width: 600px;
            margin: 50px auto;
            background: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0px 2px 8px rgba(0,0,0,0.1);
        }

        h1 {
            color: #7b2e2f;
            text-align: center;
            margin-bottom: 25px;
        }

        form {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        label {
            font-weight: bold;
        }

        select, input[type="text"] {
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            width: 100%;
        }

        button {
            background: #7b2e2f;
            color: #fff;
            padding: 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }

        button:hover {
            background: #5c1f20;
        }

        .back-link {
            text-align: center;
            margin-top: 20px;
        }

        .back-link a {
            color: #7b2e2f;
            text-decoration: none;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Upload de Imagem para Produto</h1>

    <form action="../upload" method="post">
        <div>
            <label for="produtoId">Selecione o Produto:</label>
            <select name="produtoId" id="produtoId" required>
                <option value="">-- Escolha um produto --</option>
                <% for (Produto p : produtos) { %>
                    <option value="<%= p.getId() %>"><%= p.getNome() %></option>
                <% } %>
            </select>
        </div>

        <div>
            <label for="imageUrl">URL da Imagem:</label>
            <input type="text" id="imageUrl" name="imageUrl" placeholder="Cole aqui a URL da imagem" required>
        </div>

        <button type="submit">Enviar Imagem</button>
    </form>

    <div class="back-link">
        <a href="../index.jsp">← Voltar ao Início</a>
    </div>
</div>
</body>
</html>