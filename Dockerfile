FROM ghcr.io/linuxserver/baseimage-kasmvnc:alpine320

# 1. Environment variables (No flags needed at runtime)
ENV TZ=Asia/Makassar
ENV PUID=1000
ENV PGID=1000
ENV TITLE="Minimal Edge App"
ENV CUSTOM_USER=admin
ENV PASSWORD=password123

# 2. Install your application
# (Replacing 'mousepad' with whatever app you actually need)
RUN apk add --no-cache mousepad

# 3. The "Pseudo-Entrypoint" logic
# We create the directory and the autostart file.
# The '&' is important if you want to run multiple things, 
# but for one app, the name alone is enough.
RUN mkdir -p /defaults && \
    echo "mousepad" > /defaults/autostart && \
    chmod +x /defaults/autostart

# 4. Standard Port
EXPOSE 3000

# NOTE: No ENTRYPOINT or CMD here. 
# The base image's inherited S6-init handles the boot sequence.
