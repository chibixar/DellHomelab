#!/bin/bash

set -e

echo "==== Secure Server Setup ===="

read -p "Enter new username: " USERNAME

read -p "Paste your SSH public key: " PUBKEY

echo "[+] Creating user..."
adduser --disabled-password --gecos "" $USERNAME

echo "[+] Adding user to sudo group..."
usermod -aG sudo $USERNAME

echo "[+] Creating SSH directory..."
mkdir -p /home/$USERNAME/.ssh

echo "[+] Adding public key..."
echo "$PUBKEY" > /home/$USERNAME/.ssh/authorized_keys

echo "[+] Setting permissions..."
chmod 700 /home/$USERNAME/.ssh
chmod 600 /home/$USERNAME/.ssh/authorized_keys
chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh

echo "[+] Securing SSH config..."

SSHD_CONFIG="/etc/ssh/sshd_config"

sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' $SSHD_CONFIG
sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' $SSHD_CONFIG
sed -i 's/^#*PubkeyAuthentication.*/PubkeyAuthentication yes/' $SSHD_CONFIG

echo "[+] Restarting SSH service..."
systemctl restart ssh || systemctl restart sshd

echo ""
echo "==== Setup Complete ===="
echo "New user: $USERNAME"
echo ""
echo "IMPORTANT:"
echo "Open a NEW terminal and test login before closing this session:"
echo ""
echo "ssh $USERNAME@SERVER_IP"
echo ""
