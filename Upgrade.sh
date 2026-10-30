#!/bin/bash

# ==========================================
# Ubuntu Distribution Upgrade Script
# Upgrade: Ubuntu 24.04 Noble -> 26.04 Resolute
# ==========================================

set -e

echo "=========================================="
echo " Starting Ubuntu Distribution Upgrade"
echo " Noble -> Resolute"
echo "=========================================="

# Check root privileges
if [[ $EUID -ne 0 ]]; then
    echo "Please run this script with sudo."
    exit 1
fi

# 1. Update repository sources
echo "[1/5] Updating Ubuntu repository sources..."
sed -i 's/noble/resolute/g' /etc/apt/sources.list.d/ubuntu.sources

# 2. Update package lists
echo "[2/5] Updating package lists..."
apt update

# 3. Upgrade essential packages
echo "[3/5] Upgrading essential packages..."
apt install -y base-files libc6 libc-bin

# 4. Perform full distribution upgrade
echo "[4/5] Performing full distribution upgrade..."
DEBIAN_FRONTEND=noninteractive NEEDRESTART_MODE=a apt dist-upgrade -y \
    -o Dpkg::Options::="--force-confdef" \
    -o Dpkg::Options::="--force-confold"

# 5. Remove obsolete packages
echo "[5/5] Cleaning up obsolete packages..."
apt autoremove -y
apt autoclean

echo "=========================================="
echo " Ubuntu upgrade completed successfully!"
echo " System will reboot in 10 seconds."
echo "=========================================="

sleep 10
reboot
