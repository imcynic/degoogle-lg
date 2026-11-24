#!/bin/sh
# Installs privacy hardening on a rooted LG webOS TV.
# Requires root SSH access via RootMyTV (https://rootmy.tv) or equivalent.
#
# What it does:
#   - Blocks LG telemetry, ACR (content recognition), and ad domains via /etc/hosts
#   - Survives reboots via bind mount from /media/developer
#
# Usage:
#   ./install.sh <tv-ip>

set -e

TV="${1:?Usage: ./install.sh <tv-ip>}"
SSH="ssh -o StrictHostKeyChecking=no root@$TV"

echo "[*] Copying hosts blocklist to TV..."
scp -o StrictHostKeyChecking=no hosts "root@$TV:/media/developer/custom_hosts"

echo "[*] Applying hosts file..."
$SSH 'mount --bind /media/developer/custom_hosts /etc/hosts'

echo "[*] Making persistent across reboots..."
$SSH 'cat > /var/lib/webosbrew/init.d/50-block-telemetry << "INITEOF"
#!/bin/sh
mount --bind /media/developer/custom_hosts /etc/hosts
INITEOF
chmod +x /var/lib/webosbrew/init.d/50-block-telemetry'

echo "[*] Verifying..."
BLOCKED=$($SSH 'grep -c "^0.0.0.0" /etc/hosts')
echo "[+] Done. $BLOCKED domains blocked."
echo "[+] Reboot the TV to confirm persistence."
