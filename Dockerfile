# --- Estágio 1: Compilação (Build) ---
    FROM debian:latest AS build-env

    # Instala as dependências necessárias para o Flutter no Linux
    RUN apt-get update && apt-get install -y \
        curl \
        git \
        unzip \
        xz-utils \
        zip \
        libglu1-mesa \
        ca-certificates
    
    # Baixa o SDK do Flutter (canal estável)
    RUN git clone https://github.com/flutter/flutter.git -b stable /usr/local/flutter
    
    # Configura as variáveis de ambiente para o Flutter ser reconhecido no terminal
    ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"
    
    # Habilita o suporte para Web e verifica a instalação
    RUN flutter config --enable-web
    RUN flutter doctor
    
    # Define a pasta de trabalho e copia os arquivos do seu projeto
    WORKDIR /app
    COPY . .
    
    # Executa o build de produção (Flag --web-renderer removida para evitar o Erro 64)
    RUN flutter build web --release
    
    # --- Estágio 2: Servidor de Produção (Nginx) ---
    FROM nginx:stable-alpine
    
    # Copia os arquivos compilados (HTML/JS/CSS) do estágio anterior para o servidor Nginx
    COPY --from=build-env /app/build/web /usr/share/nginx/html
    
    # Cria a configuração do Nginx para:
    # 1. Suportar as rotas do Flutter (try_files)
    # 2. Permitir que o Jestor exiba o app em um Iframe (Content-Security-Policy)
    RUN echo 'server { \
        listen 80; \
        location / { \
            root /usr/share/nginx/html; \
            index index.html; \
            try_files $uri $uri/ /index.html; \
            add_header Content-Security-Policy "frame-ancestors * https://*.jestor.com;"; \
        } \
    }' > /etc/nginx/conf.d/default.conf
    
    # Expõe a porta 80 (Porta padrão do Nginx)
    EXPOSE 80