# Vinheria Agnello (JSP) — Projeto Maven (Tomcat 9 + javax.servlet)

Gerado em 29/09/2025 00:50.

## Requisitos
- Java 17 (ou 11)
- Maven 3.8+
- Servidor: **Tomcat 9.x** (Servlet 4.0, `javax.servlet`)

## Como buildar
```bash
mvn clean package
```
Gera `target/vinheria-agnello-jsp.war`.

## Variáveis de ambiente (Cloud)
- `AWS_REGION=us-east-1` (ou sua região)
- `S3_BUCKET=<nome-do-bucket>`
- `DB_URL=jdbc:mysql://<endpoint>:3306/<dbname>?useSSL=true&allowPublicKeyRetrieval=true`
- `DB_USER=<usuario>`
- `DB_PASS=<senha>`

## Testes rápidos
- Upload: acesse `/<context>/upload.jsp`, envie um arquivo, confirme no S3.
- A aplicação usa `com.vinheria.cloud.DBConnection` nos DAOs (ajuste conforme o seu projeto).

## Deploy
### Tomcat 9 (local ou servidor)
1. Copie o `.war` para `TOMCAT_HOME/webapps/`
2. Exponha as variáveis de ambiente no serviço/VM
3. Acesse `http://host:8080/vinheria-agnello-jsp/`

### AWS Elastic Beanstalk
- Plataforma: Tomcat 8.5/9 (Java 17 compatível)
- Faça upload do `.war` gerado
- Configure as variáveis no ambiente (Configuration → Software)

## Observações
- O projeto original usava `javax.servlet.*`; mantivemos compatibilidade (Tomcat 9).
- Se desejar migrar para **Jakarta 10/EE 10** (Tomcat 10+), será preciso converter imports para `jakarta.*` e ajustar taglibs.


## Imagens de Produto (S3 + DB)
### SQL
Veja `db/schema_produto_imagem.sql` e aplique no seu RDS.

### Rotas
- `GET  /admin-upload.jsp` — formulário para enviar imagem de produto
- `POST /admin/upload-produto-imagem` — upload para S3 + insert no MySQL
- `GET  /admin/imagens.jsp` — listagem/preview/links
- `POST /admin/delete-produto-imagem` — remove do S3 e do MySQL

### Variáveis necessárias
`AWS_REGION`, `S3_BUCKET`, `DB_URL`, `DB_USER`, `DB_PASS`

> Observação: para URL pública direta (`https://<bucket>.s3.amazonaws.com/<key>`), mantenha o bucket com acesso público **apenas** via política específica do prefixo de imagens ou gere **URLs pré-assinadas** no backend para maior segurança.


## Bucket privado + URLs pré-assinadas
- O bucket S3 deve permanecer **privado**.
- A listagem `admin/imagens.jsp` não usa URL pública; em vez disso, gera uma **URL pré-assinada (10 min)** via `S3PresignUtil.presignGet(...)` para cada imagem.
- No upload, a coluna `url` guarda um esquema `s3://bucket/key` apenas para referência (a leitura sempre usa pré-assinada).
