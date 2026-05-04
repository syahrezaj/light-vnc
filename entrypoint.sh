#!/bin/bash
set -e

# 1. Set SSH password
if [ -n "$SSH_PASSWORD" ]; then
    echo "desktopuser:${SSH_PASSWORD}" | chpasswd
fi

# 2. Generate VNC password securely
if [ -n "$VNC_PASSWORD" ]; then
    mkdir -p /home/desktopuser/.vnc
    echo "$VNC_PASSWORD" | vncpasswd -f > /home/desktopuser/.vnc/passwd
    chmod 600 /home/desktopuser/.vnc/passwd
    chown desktopuser:desktopuser /home/desktopuser/.vnc/passwd
fi

# 3. Start SSH daemon
/usr/sbin/sshd -D &

# 4. Start VNC server
sudo -u desktopuser vncserver :1 -geometry 1280x720 -depth 24 &

# 5. Keep container alive
wait
