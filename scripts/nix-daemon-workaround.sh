#!/usr/bin/env bash
# Temporarily switch to upstream Nix daemon to work around Lix daemon bugs
# Usage: with-nix-daemon.sh <command> [args...]
#
# This is a workaround for a Lix daemon bug that causes "writev broken pipe"
# errors with large build environments on macOS.

set -euo pipefail

if [[ $# -eq 0 ]]; then
  echo "Usage: $0 <command> [args...]"
  exit 1
fi

PLIST="/Library/LaunchDaemons/org.nixos.nix-daemon.plist"
BACKUP="/tmp/org.nixos.nix-daemon.plist.bak"

# Find upstream nix-daemon path
NIX_DAEMON=$(dirname "$(which nix)")/nix-daemon
if [[ ! -x $NIX_DAEMON ]] && [[ ! -L $NIX_DAEMON ]]; then
  echo "Error: Could not find upstream nix-daemon at $NIX_DAEMON"
  exit 1
fi
NIX_STORE_PATH=$(dirname "$(dirname "$NIX_DAEMON")")

echo "Switching to upstream Nix daemon temporarily..."

# Backup current plist
sudo cp "$PLIST" "$BACKUP"

# Restore on exit (success or failure)
cleanup() {
  echo "Restoring Lix daemon..."
  sudo cp "$BACKUP" "$PLIST"
  sudo launchctl unload "$PLIST" 2>/dev/null || true
  sudo launchctl load "$PLIST"
  sudo rm -f "$BACKUP"
}
trap cleanup EXIT

# Create temporary plist with upstream Nix
sudo tee "$PLIST" >/dev/null <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>EnvironmentVariables</key>
    <dict>
        <key>NIX_SSL_CERT_FILE</key>
        <string>/etc/ssl/certs/ca-certificates.crt</string>
    </dict>
    <key>KeepAlive</key>
    <true/>
    <key>Label</key>
    <string>org.nixos.nix-daemon</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/sh</string>
        <string>-c</string>
        <string>/bin/wait4path /nix/store &amp;&amp; exec ${NIX_STORE_PATH}/bin/nix-daemon</string>
    </array>
    <key>SoftResourceLimits</key>
    <dict>
        <key>NumberOfFiles</key>
        <integer>1048576</integer>
    </dict>
</dict>
</plist>
EOF

# Reload daemon
sudo launchctl unload "$PLIST" 2>/dev/null || true
sleep 1
sudo launchctl load "$PLIST"
sleep 2
echo "Switched to upstream Nix daemon"

# Run the command
"$@"
