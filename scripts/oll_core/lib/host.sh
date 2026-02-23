#!/usr/bin/env bash

# =============================================================================
# Host Detection Module
# =============================================================================

detect_machine() {
  # Check SSH session first
  if [[ -n $SSH_CLIENT || -n $SSH_CONNECTION || -n $SSH_TTY ]]; then
    if [[ -n $SSH_CONNECTION ]]; then
      local target_ip
      target_ip=$(echo "$SSH_CONNECTION" | awk '{print $3}' | cut -d: -f1)
      # Match known IPs and hostnames
      case "$target_ip" in
      192.168.1.10 | nebulanix | nebulanix.local) echo "nebulanix" && return ;;
      192.168.1.* | spacehound | spacehound.local) echo "spacehound" && return ;;
      esac
      # Unknown SSH - try reverse DNS
      if [[ -n $target_ip ]]; then
        local resolved
        resolved=$(getent hosts "$target_ip" 2>/dev/null | awk '{print $2}' | cut -d. -f1)
        case "$resolved" in
        nebulanix*) echo "nebulanix" && return ;;
        spacehound*) echo "spacehound" && return ;;
        esac
      fi
    fi
  fi

  # Check hostname (case-insensitive)
  local hostname_lower
  hostname_lower=$(hostname 2>/dev/null | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]')

  case "$hostname_lower" in
  nebulanix | nebula*) echo "nebulanix" ;;
  spacehound | space*) echo "spacehound" ;;
  *)
    # Fallback: check /etc/hosts or network config
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

get_host_config() {
  case "$(detect_machine)" in
  nebulanix) echo "local" ;;
  *) echo "remote" ;;
  esac
}
