#!/usr/bin/env bash
set -e

# ===== CONFIG =====
NGINX_CONF="/etc/nginx/conf.d/readonly-files.conf"
AUTHFILE="/etc/nginx/.htpasswd"
PACKAGES=(nginx apache)
# ==================

if [[ $EUID -ne 0 ]]; then
  echo "Run as root (use sudo)"
  exit 1
fi

USER_HOME="$(getent passwd "$SUDO_USER" | cut -d: -f6)"

echo "[+] Stopping & disabling nginx..."
systemctl stop nginx 2>/dev/null || true
systemctl disable nginx 2>/dev/null || true

echo "[+] Removing nginx config..."
rm -f "$NGINX_CONF"

echo "[+] Removing password file..."
rm -f "$AUTHFILE"

echo "[+] Reloading nginx (if still installed)..."
if command -v nginx >/dev/null; then
  nginx -t && systemctl restart nginx || true
fi

echo "[+] Removing ACL permissions from user directories..."
setfacl -b "$USER_HOME" || true
setfacl -R -b "$USER_HOME/Downloads" "$USER_HOME/Documents" || true

echo "[+] Checking installed packages..."
for pkg in "${PACKAGES[@]}"; do
  if pacman -Qi "$pkg" &>/dev/null; then
    echo "    - $pkg installed"
  fi
done

echo "[+] Removing packages (if not required elsewhere)..."
pacman -Rns --noconfirm "${PACKAGES[@]}" || true

echo
echo "[✓] Cleanup complete"
echo "Your files and permissions are restored"

