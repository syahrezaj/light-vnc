FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Copy install and remove teneo
COPY Teneo.Beacon_0.4.2_amd64.deb /tmp/

RUN apt install /tmp/Teneo.Beacon_0.4.2_amd64.deb || apt-get install -f -y && rm /tmp/Teneo.Beacon_0.4.2_amd64.deb

# Install ultra-light desktop stack
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    openssh-server \
    tigervnc-standalone-server \
    openbox \
    micro \
    pcmanfm \
    xterm \
    dbus-x11 \
    sudo \
    locales \
    && locale-gen en_US.UTF-8 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    # Strip docs, man pages, and non-English locales
    && rm -rf /usr/share/doc/* /usr/share/man/* \
    && find /usr/share/locale -mindepth 1 -maxdepth 1 \
       -not -name 'en*' -not -name 'locale.alias' \
       -exec rm -rf {} + 2>/dev/null || true

# Generate SSH host keys
RUN ssh-keygen -A

# Create non-root user
RUN useradd -m -s /bin/bash -G sudo desktopuser

ENV SSH_PASSWORD=12345 \
    VNC_PASSWORD=12345

# Setup VNC startup script (WM + file manager + terminal)
USER desktopuser
RUN mkdir -p ~/.vnc && \
    printf '#!/bin/sh\nopenbox-session &\npcmanfm --desktop &\nxterm &\nwait\n' > ~/.vnc/xstartup && \
    chmod +x ~/.vnc/xstartup
USER root

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 22 5901
