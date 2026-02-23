#!/usr/bin/env bash

# =============================================================================
# Nix & nix-darwin Check
# =============================================================================

check_nix() {
  echo -e "${CYAN}▸ Nix & nix-darwin${NC}"

  if ! command -v nix &>/dev/null; then
    print_status error "Nix not installed"
    return 1
  fi
  print_status ok "Nix installed"

  if command -v nix-darwin-rebuild &>/dev/null; then
    print_status ok "nix-darwin available"
  else
    print_status warn "nix-darwin-rebuild not in PATH"
  fi

  if [[ -f "/etc/nix/nix.conf" ]]; then
    if grep -q "sandbox = true" /etc/nix/nix.conf; then
      print_status warn "Sandbox enabled (may cause issues on macOS)"
    else
      print_status ok "Nix config OK"
    fi
  fi

  if launchctl list | grep -q "org.nixos.nix-daemon" 2>/dev/null; then
    print_status ok "Nix daemon running"
  else
    local flake_path="${HOME}/.config/flake"
    local multi_user=false

    if [[ -f "$flake_path/systems/spacehound/users.nix" ]]; then
      if grep -q '"rodz"\|"grcee"' "$flake_path/systems/spacehound/users.nix" 2>/dev/null; then
        multi_user=true
      fi
    fi

    if [[ -f "$flake_path/systems/nebulanix/users.nix" ]]; then
      if grep -q '"rodz"\|"grcee"' "$flake_path/systems/nebulanix/users.nix" 2>/dev/null; then
        multi_user=true
      fi
    fi

    if [[ $multi_user == "true" ]]; then
      print_status error "Nix daemon not running (multi-user config detected!)"
    else
      print_status warn "Nix daemon not in launchctl (single-user mode)"
    fi
  fi

  local nix_store="/nix/store"
  if [[ -d $nix_store ]]; then
    local store_usage
    store_usage=$(df -k "$nix_store" | awk 'NR==2 {print $5}' | tr -d '%')
    if [[ $store_usage -lt 80 ]]; then
      print_status ok "Nix store (${store_usage}% used)"
    elif [[ $store_usage -lt 90 ]]; then
      print_status warn "Nix store (${store_usage}% used)"
    else
      print_status error "Nix store (${store_usage}% used)"
    fi
  fi

  return 0
}

fix_nix() {
  echo -e "${BLUE}Fixing Nix issues...${NC}"

  if [[ -d "$HOME/.nix-defexpr" ]]; then
    chmod -R 755 "$HOME/.nix-defexpr" 2>/dev/null || true
  fi

  if [[ -d "$HOME/.nix-channels" ]]; then
    chmod 700 "$HOME/.nix-channels" 2>/dev/null || true
  fi

  print_status ok "Nix fixes applied"
}
