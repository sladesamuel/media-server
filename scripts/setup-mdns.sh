#!/usr/bin/env bash
set -e

HOSTNAME="media"

echo "🔍 Checking for Avahi..."

if ! command -v avahi-daemon >/dev/null 2>&1; then
  echo "📦 Installing avahi-daemon..."
  sudo apt update
  sudo apt install -y avahi-daemon
else
  echo "✅ Avahi already installed"
fi

echo "🖥️ Setting hostname to '$HOSTNAME'..."
sudo hostnamectl set-hostname "$HOSTNAME"

echo "🔁 Enabling and starting Avahi..."
sudo systemctl enable avahi-daemon
sudo systemctl restart avahi-daemon

echo "📡 mDNS is now active"
echo "➡️ You should be able to access: http://$HOSTNAME.local"

