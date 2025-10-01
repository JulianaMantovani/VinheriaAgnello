<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8"/>
    <title>Upload de Imagem do Produto</title>
</head>
<body>

<h2>Upload de Imagem</h2>

<form method="post" action="${pageContext.request.contextPath}/admin/upload-imagem">
    <label for="produtoId">Selecione o produto:</label>
    <select name="produtoId" id="produtoId" required>
        <c:forEach var="p" items="${produtos}">
            <option value="${p.id}">${p.nome}</option>
        </c:forEach>
    </select>

    <br><br>

    <label for="imageUrl">URL da Imagem:</label>
    <input type="text" name="imageUrl" id="imageUrl" placeholder="https://..." required />

    <br><br>

    <button type="submit">Enviar</button>
</form>

<c:if test="${not empty msgSucesso}">
    <p style="color: green;">${msgSucesso}</p>
</c:if>

<h3>Imagens Cadastradas</h3>
<table border="1" cellpadding="5">
    <tr>
        <th>ID</th>
        <th>Produto</th>
        <th>URL</th>
        <th>Data</th>
    </tr>
    <c:forEach var="img" items="${imagens}">
        <tr>
            <td>${img.id}</td>
            <td>${img.produtoId}</td>
            <td><a href="${img.url}" target="_blank">${img.url}</a></td>
            <td>${img.createdAt}</td>
        </tr>
    </c:forEach>
</table>

</body>
</html>