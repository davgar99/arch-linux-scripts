#!/usr/bin/env bash

sudo pacman -S --needed libva-nvidia-driver

cat << 'EOF' | sudo tee -a /etc/environment
NVD_BACKEND=direct
EOF