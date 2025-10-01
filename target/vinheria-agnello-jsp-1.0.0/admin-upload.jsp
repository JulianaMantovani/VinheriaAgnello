<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>Upload de Imagem de Produto</title></head>
<body>
<h2>Upload de Imagem de Produto</h2>
<form method="post" action="${pageContext.request.contextPath}/admin/upload-produto-imagem" enctype="multipart/form-data">
    <label>Produto ID:</label>
    <input type="number" name="produtoId" required/>
    <br/><br/>
    <input type="file" name="file" accept="image/*" required/>
    <button type="submit">Enviar</button>
</form>
<p><a href="${pageContext.request.contextPath}/admin/imagens.jsp">Gerenciar Imagens</a></p>
</body>
</html>
