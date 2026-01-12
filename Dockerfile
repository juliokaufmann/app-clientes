# Estágio de Build
FROM debian:latest AS build-env
RUN apt-get update && apt-get install -y curl git unzip xz-utils zip libglu1-mesa
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"
RUN flutter config --enable-web
COPY . /app
WORKDIR /app
RUN flutter build web --release --web-renderer html

# Estágio do Servidor (Nginx)
FROM nginx:stable-alpine
COPY --from=build-env /app/build/web /usr/share/nginx/html
# Configuração para o Jestor aceitar o Iframe
RUN echo 'server { \
    listen 80; \
    location / { \
        root /usr/share/nginx/html; \
        try_files $uri $uri/ /index.html; \
        add_header Content-Security-Policy "frame-ancestors * https://*.jestor.com;"; \
    } \
}' > /etc/nginx/conf.d/default.conf
EXPOSE 80