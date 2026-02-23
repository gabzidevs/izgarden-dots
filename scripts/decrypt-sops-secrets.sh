#!/usr/bin/env bash
# Decrypt sops secrets manually (useful when LaunchAgent fails on macOS)
# Usage: ./scripts/decrypt-sops-secrets.sh [--silent]
#
# Options:
#   --silent    Suppress stdout (useful for Raycast integration)
#
# This script finds and runs the sops user script from the current
# home-manager generation to decrypt secrets.

set -euo pipefail

SILENT_MODE=false
if [[ ${1:-} == "--silent" ]]; then
  SILENT_MODE=true
fi

log() {
  if [[ $SILENT_MODE == "false" ]]; then
    echo "$1"
  fi
}

log "Finding sops user script..."

# Try to find the sops-nix-user script from the LaunchAgent plist
SOPS_SCRIPT=""
PLIST_PATH="$HOME/Library/LaunchAgents/org.nix-community.home.sops-nix.plist"

if [[ -f $PLIST_PATH ]]; then
  # Extract the script path from the plist
  SOPS_SCRIPT=$(grep -oE '/nix/store/[^<]+sops-nix-user' "$PLIST_PATH" 2>/dev/null | head -1)
fi

# If not found via plist, try to find it from the home-manager generation
if [[ -z $SOPS_SCRIPT ]]; then
  # Try to find the current generation path
  CURRENT_GEN=""
  for path in \
    "$HOME/.local/state/home-manager/gcroots/current-home" \
    "$HOME/.local/state/nix/profiles/home-manager"; do
    if [[ -e $path ]]; then
      resolved=$(readlink -f "$path" 2>/dev/null) || continue
      if [[ -d $resolved ]]; then
        CURRENT_GEN="$resolved"
        break
      fi
    fi
  done

  if [[ -n $CURRENT_GEN ]]; then
    # Check if LaunchAgents directory exists in generation and extract from plist
    LAUNCH_AGENTS="$CURRENT_GEN/LaunchAgents"
    if [[ -L $LAUNCH_AGENTS ]]; then
      LAUNCH_AGENTS_DIR=$(readlink -f "$LAUNCH_AGENTS" 2>/dev/null) || true
      if [[ -d $LAUNCH_AGENTS_DIR ]]; then
        PLIST_FILE="$LAUNCH_AGENTS_DIR/org.nix-community.home.sops-nix.plist"
        if [[ -f $PLIST_FILE ]]; then
          SOPS_SCRIPT=$(grep -oE '/nix/store/[^<]+sops-nix-user' "$PLIST_FILE" 2>/dev/null | head -1)
        fi
      fi
    fi

    # Try to find sops-nix-user script directly in generation
    if [[ -z $SOPS_SCRIPT ]]; then
      for item in "$CURRENT_GEN"/*-sops-nix-user; do
        if [[ -f $item ]]; then
          SOPS_SCRIPT="$item"
          break
        fi
      done
    fi
  fi
fi

# Last resort: find any sops-nix-user script in the store from recent generations
if [[ -z $SOPS_SCRIPT ]]; then
  log "Searching nix store for sops-nix-user script..."
  # Find the most recent sops-nix-user script that's linked from a home-manager generation
  SOPS_SCRIPT=$(find /nix/store -maxdepth 1 -name "*sops-nix-user" -type f -newer /nix/store/var 2>/dev/null | head -1 || true)
fi

if [[ -z $SOPS_SCRIPT ]] || [[ ! -f $SOPS_SCRIPT ]]; then
  log "ERROR: Could not find sops user script"
  log "Make sure you have sops secrets configured in your home-manager configuration"
  exit 1
fi

log "Running sops decryption from: $SOPS_SCRIPT"
"$SOPS_SCRIPT"

log "Secrets decrypted successfully!"
