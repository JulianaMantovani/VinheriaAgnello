<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head><meta charset="utf-8"><title>Erro</title></head>
<body>
  <h1>Ops! Algo deu errado</h1>

  <h3>Mensagem</h3>
  <pre><%= (exception != null ? exception.toString() : "sem exception") %></pre>

  <h3>Stacktrace</h3>
  <pre>
  <% if (exception != null) { exception.printStackTrace(new java.io.PrintWriter(out)); } %>
  </pre>
</body>
</html>

