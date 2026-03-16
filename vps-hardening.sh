#!/bin/bash

set -e

echo "====== VPS HARDENING START ======"

read -p "Enter new username: " USERNAME
read -p "Paste your SSH public key: " PUBKEY

echo "[1/7] Updating system..."
apt update && apt upgrade -y

echo "[2/7] Installing required packages..."
apt install -y sudo ufw fail2ban unattended-upgrades curl

echo "[3/7] Creating user..."
adduser --disabled-password --gecos "" $USERNAME
usermod -aG sudo $USERNAME

echo "[4/7] Setting up SSH key..."
mkdir -p /home/$USERNAME/.ssh
echo "$PUBKEY" > /home/$USERNAME/.ssh/authorized_keys

chmod 700 /home/$USERNAME/.ssh
chmod 600 /home/$USERNAME/.ssh/authorized_keys
chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh

echo "[5/7] Securing SSH..."

SSHD_CONFIG="/etc/ssh/sshd_config"

sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' $SSHD_CONFIG
sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' $SSHD_CONFIG
sed -i 's/^#*PubkeyAuthentication.*/PubkeyAuthentication yes/' $SSHD_CONFIG
sed -i 's/^#*MaxAuthTries.*/MaxAuthTries 3/' $SSHD_CONFIG

echo "[6/7] Configuring firewall..."

ufw default deny incoming
ufw default allow outgoing

ufw allow OpenSSH
ufw allow 80
ufw allow 443

ufw limit OpenSSH

ufw --force enable

echo "[7/7] Enabling security services..."

systemctl enable fail2ban
systemctl start fail2ban

systemctl enable unattended-upgrades

systemctl restart ssh || systemctl restart sshd

echo ""
echo "====== HARDENING COMPLETE ======"
echo ""
echo "User created: $USERNAME"
echo ""
echo "Test login in another terminal:"
echo ""
echo "ssh $USERNAME@SERVER_IP"
echo ""
echo "Do NOT close this root session until you confirm login works."
