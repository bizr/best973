#!/bin/sh

# Start nginx in background
nginx

# Wait for nginx to start
sleep 2

# Retry loop with delay
while true; do
    echo "Starting stream conversion..."
    ffmpeg -user_agent "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36" \
        -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 30 \
        -i "http://188.245.77.175:8000/stream/1/" \
        -c:a aac -b:a 128k \
        -f hls \
        -hls_time 4 \
        -hls_list_size 3 \
        -hls_flags delete_segments+append_list \
        -hls_segment_filename /var/www/hls/segment%03d.ts \
        /var/www/hls/stream.m3u8

    echo "FFmpeg exited, waiting 10 seconds before retry..."
    sleep 10
done
