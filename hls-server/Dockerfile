FROM alpine:latest

RUN apk add --no-cache ffmpeg nginx

# Create directories
RUN mkdir -p /var/www/hls /run/nginx

# Copy config files
COPY nginx.conf /etc/nginx/http.d/default.conf
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 8080

CMD ["/start.sh"]
