FROM eclipse-temurin:17-jdk
WORKDIR /app
COPY . .
RUN chmod +x mvnw && ./mvnw -v && ./mvnw clean package -DskipTests

EXPOSE 8080
CMD ["bash","-lc","./mvnw -Djetty.http.port=$PORT jetty:run"]
