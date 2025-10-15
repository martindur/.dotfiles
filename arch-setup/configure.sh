#!/usr/bin/env bash

set -e

echo "Configuring system services..."

# Enable lightdm
echo "Enabling lightdm display manager..."
systemctl enable lightdm.service

# Configure lightdm to use slick greeter
echo "Configuring lightdm to use slick greeter..."
cat > /etc/lightdm/lightdm.conf << 'EOF'
[Seat:*]
greeter-session=lightdm-slick-greeter
user-session=i3
EOF

# Configure slick greeter
mkdir -p /etc/lightdm
cat > /etc/lightdm/slick-greeter.conf << 'EOF'
[Greeter]
draw-user-backgrounds=true
EOF

# Enable NetworkManager if not already enabled
if systemctl is-enabled NetworkManager.service &> /dev/null; then
    echo "NetworkManager already enabled"
else
    echo "Enabling NetworkManager..."
    systemctl enable NetworkManager.service
fi

echo "System configuration complete!"
