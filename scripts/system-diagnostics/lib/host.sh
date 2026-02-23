#!/usr/bin/env bash

# =============================================================================
# Host Detection - Reuse from oll_core or provide fallback
# =============================================================================

# Get the parent directory of system-diagnostics
SD_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SD_DIR="$(cd "$SD_LIB_DIR/.." && pwd)"

if [[ -f "$SD_DIR/oll_core/lib/host.sh" ]]; then
  source "$SD_DIR/oll_core/lib/host.sh"
else
  detect_machine() {
    if [[ -n $SSH_CLIENT || -n $SSH_CONNECTION || -n $SSH_TTY ]]; then
      if [[ -n $SSH_CONNECTION ]]; then
        local target_ip
        target_ip=$(echo "$SSH_CONNECTION" | awk '{print $3}' | cut -d: -f1)
        case "$target_ip" in
        192.168.1.10 | nebulanix | nebulanix.local) echo "nebulanix" && return ;;
        192.168.1.* | spacehound | spacehound.local) echo "spacehound" && return ;;
        esac
      fi
    fi

    local hostname_lower
    hostname_lower=$(hostname 2>/dev/null | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]')

    case "$hostname_lower" in
    nebulanix | nebula*) echo "nebulanix" ;;
    spacehound | space*) echo "spacehound" ;;
    *)
      if grep -qi "nebulanix" /etc/hosts 2>/dev/null; then
        echo "nebulanix"
      elif grep -qi "spacehound" /etc/hosts 2>/dev/null; then
        echo "spacehound"
      else
        echo "unknown"
      fi
      ;;
    esac
  }

  is_ssh_session() {
    [[ -n $SSH_CLIENT || -n $SSH_CONNECTION || -n $SSH_TTY ]]
  }
fi
