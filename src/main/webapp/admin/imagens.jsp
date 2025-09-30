<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*,com.vinheria.dao.*,com.vinheria.model.*" %>
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>Imagens de Produtos</title></head>
<body>
<h2>Imagens de Produtos (S3 + DB)</h2>

<form method="get" action="imagens.jsp">
    <label>Filtrar por Produto ID:</label>
    <input type="number" name="produtoId" value="<%= request.getParameter("produtoId") == null ? "" : request.getParameter("produtoId") %>"/>
    <button type="submit">Filtrar</button>
    <a href="imagens.jsp">Limpar</a>
</form>

<p><a href="${pageContext.request.contextPath}/admin-upload.jsp">Enviar nova imagem</a></p>

<%
    List<ProdutoImagem> imagens;
    ProdutoImagemDAO dao = new ProdutoImagemDAO();
    String pid = request.getParameter("produtoId");
    if (pid != null && !pid.isBlank()) {
        imagens = dao.listByProdutoId(Long.parseLong(pid));
    } else {
        imagens = dao.listAll();
    }
%>

<table border="1" cellpadding="6" cellspacing="0">
    <tr>
        <th>ID</th>
        <th>Produto ID</th>
        <th>Preview</th>
        <th>URL</th>
        <th>Chave S3</th>
        <th>Criação</th>
        <th>Ações</th>
    </tr>
<% for (ProdutoImagem pi : imagens) { %>
    <tr>
        <td><%= pi.getId() %></td>
        <td><%= pi.getProdutoId() %></td>
        <td><%
    String _bucket = System.getenv("S3_BUCKET");
    String _url = com.vinheria.cloud.S3PresignUtil.presignGet(_bucket, pi.getS3Key(), 10);
%>
<img src="<%= _url %>" alt="img" style="max-height:80px"/>
</td>
        <td><a href="<%= com.vinheria.cloud.S3PresignUtil.presignGet(System.getenv("S3_BUCKET"), pi.getS3Key(), 10) %>" target="_blank">Abrir (10 min)</a></td>
        <td><code><%= pi.getS3Key() %></code></td>
        <td><%= pi.getCreatedAt() %></td>
        <td>
            <form method="post" action="${pageContext.request.contextPath}/admin/delete-produto-imagem" onsubmit="return confirm('Excluir esta imagem?');">
                <input type="hidden" name="id" value="<%= pi.getId() %>"/>
                <button type="submit">Excluir</button>
            </form>
        </td>
    </tr>
<% } %>
</table>

</body>
</html>
