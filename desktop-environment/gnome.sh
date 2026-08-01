#!/usr/bin/env bash

# Don't allow users to run this script as root
if ((EUID == 0)); then
    echo "This script should not be run as root. Please run it as a regular user."
    exit 1
fi

# Installs the GNOME desktop environment along with the extra applications group
echo "Installing GNOME and extra applications"
sudo pacman -Syu --needed gnome gnome-extra

# Warns if a different display manager is already enabled before GDM takes over
current_dm=$(basename "$(readlink -f /etc/systemd/system/display-manager.service 2> /dev/null)" 2> /dev/null)
if [[ -n "$current_dm" && "$current_dm" != "gdm.service" ]]; then
    echo "Note: $current_dm is currently enabled as the display manager, it will be replaced with GDM."
fi

# Enables the GDM display manager so GNOME starts automatically on boot
echo "Enabling GDM display manager"
sudo systemctl enable gdm.service

# Enables NetworkManager so networking works out of the box in GNOME
echo "Enabling NetworkManager"
sudo systemctl enable NetworkManager.service
