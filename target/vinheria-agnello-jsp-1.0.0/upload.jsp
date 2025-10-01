<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8"/>
    <title>Upload para S3</title>
</head>
<body>
<h2>Upload de arquivo para S3</h2>
<form method="post" action="${pageContext.request.contextPath}/upload" enctype="multipart/form-data">
    <input type="file" name="file" required/>
    <button type="submit">Enviar</button>
</form>
<c:if test="${param.ok == '1'}">
    <p>Upload realizado! Chave S3: ${param.key}</p>
</c:if>
</body>
</html>
