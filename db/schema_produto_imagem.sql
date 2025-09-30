-- Vinheria Agnello - Tabela de imagens de produto (AWS S3)
CREATE TABLE IF NOT EXISTS produto_imagem (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  produto_id BIGINT NOT NULL,
  s3_key VARCHAR(512) NOT NULL,
  url VARCHAR(1024) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_produto_imagem_produto FOREIGN KEY (produto_id) REFERENCES produto(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
