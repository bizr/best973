FROM alpine:latest

RUN apk add --no-cache ffmpeg nginx

# Create directories
RUN mkdir -p /var/www/hls /run/nginx

# Nginx config for HLS
RUN cat > /etc/nginx/http.d/default.conf << 'EOF'
server {
    listen 8080;

    location /hls {
        alias /var/www/hls;

        # CORS headers for AirPlay
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Allow-Methods 'GET, OPTIONS';
        add_header Access-Control-Allow-Headers 'Origin, Content-Type, Accept';

        # HLS MIME types
        types {
            application/vnd.apple.mpegurl m3u8;
            video/mp2t ts;
            audio/aac aac;
        }

        # Disable caching for live stream
        add_header Cache-Control no-cache;
    }

    location /health {
        return 200 'ok';
        add_header Content-Type text/plain;
    }
}
EOF

# Start script
RUN cat > /start.sh << 'EOF'
#!/bin/sh

# Start nginx in background
nginx

# Start FFmpeg to convert stream to HLS
exec ffmpeg -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 5 \
    -i "https://stream.best973.gr/stream/1/" \
    -c:a aac -b:a 128k \
    -f hls \
    -hls_time 4 \
    -hls_list_size 3 \
    -hls_flags delete_segments+append_list \
    -hls_segment_filename /var/www/hls/segment%03d.ts \
    /var/www/hls/stream.m3u8
EOF

RUN chmod +x /start.sh

EXPOSE 8080

CMD ["/start.sh"]
