#!/usr/bin/env bash

# Don't allow users to run this script as root
if ((EUID == 0)); then
    echo "This script should not be run as root. Please run it as a regular user."
    exit 1
fi

echo "Setting udev rules to disable PlayStation 4 and PlayStation 5 controller touchpads from acting as a mouse."
cat << 'EOF' | sudo tee /etc/udev/rules.d/72-dualshock4-touchpad.rules > /dev/null
# Disable PlayStation 4 DualShock 4 touchpad acting as mouse
# USB
ATTRS{name}=="Sony Interactive Entertainment Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
# Bluetooth
ATTRS{name}=="Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
EOF

cat << 'EOF' | sudo tee /etc/udev/rules.d/72-dualsense-touchpad.rules > /dev/null
# Disable PlayStation 5 DualSense touchpad acting as mouse
# USB
ATTRS{name}=="Sony Interactive Entertainment DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
# Bluetooth
ATTRS{name}=="DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
EOF

echo "Reloading udev rules"
sudo udevadm control --reload-rules
sudo udevadm trigger
