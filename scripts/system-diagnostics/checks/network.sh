#!/usr/bin/env bash

# =============================================================================
# Network Check (SSH agent, connectivity)
# =============================================================================

check_network() {
  echo -e "${CYAN}▸ Network${NC}"

  if is_ssh_session; then
    print_status ok "SSH session: active"
  else
    print_status info "SSH session: not active"
  fi

  if [[ -n $SSH_AUTH_SOCK ]] && ssh-add -l &>/dev/null; then
    print_status ok "SSH agent: running with keys"
  elif [[ -n $SSH_AUTH_SOCK ]]; then
    print_status warn "SSH agent: running but no keys loaded"
  else
    print_status warn "SSH agent: not available"
  fi

  if command -v ping &>/dev/null; then
    if ping -c 1 -W 2 8.8.8.8 &>/dev/null; then
      print_status ok "Internet: reachable"
    else
      print_status error "Internet: not reachable"
    fi
  fi

  if is_ssh_session && [[ -n $SSH_CONNECTION ]]; then
    local target_ip
    target_ip=$(echo "$SSH_CONNECTION" | awk '{print $3}' | cut -d: -f1)
    print_status ok "SSH target: $target_ip"
  fi

  return 0
}

fix_network() {
  echo -e "${BLUE}Attempting to fix SSH agent...${NC}"

  if ! command -v ssh-agent &>/dev/null; then
    print_status error "ssh-agent not available"
    return 1
  fi

  if [[ -z $SSH_AUTH_SOCK ]]; then
    eval "$(ssh-agent -s)" >/dev/null
    print_status ok "SSH agent started"
  else
    print_status info "SSH agent already running"
  fi

  if ssh-add -l &>/dev/null; then
    print_status ok "Keys already loaded"
  else
    print_status info "No keys loaded (run ssh-add or use keychain)"
  fi
}
