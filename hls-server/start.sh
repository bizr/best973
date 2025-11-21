#!/bin/sh

nginx

exec ffmpeg -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 5 \
    -i "https://stream.best973.gr/stream/1/" \
    -c:a aac -b:a 128k \
    -f hls \
    -hls_time 4 \
    -hls_list_size 3 \
    -hls_flags delete_segments+append_list \
    -hls_segment_filename /var/www/hls/segment%03d.ts \
    /var/www/hls/stream.m3u8
