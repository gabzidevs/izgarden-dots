#!/usr/bin/env bash

# =============================================================================
# Secrets/SOPS Check (C)
# =============================================================================

check_secrets() {
  echo -e "${CYAN}▸ Secrets (SOPS)${NC}"

  if ! command -v sops &>/dev/null; then
    print_status error "sops not installed"
    return 1
  fi
  print_status ok "sops: installed"

  local sops_config
  sops_config=$(find . -maxdepth 2 -name ".sops.yaml" -o -name ".sops.yml" 2>/dev/null | head -1)

  if [[ -n $sops_config ]]; then
    print_status ok "SOPS config: $sops_config"
  else
    print_status warn "No .sops.yaml found in flake root"
  fi

  if command -v age &>/dev/null; then
    print_status ok "age: installed"

    local age_key_file
    age_key_file=$(find "$HOME/.ssh" -name "*.agekey" 2>/dev/null | head -1)

    if [[ -n $age_key_file ]]; then
      print_status ok "Age key (SSH): $age_key_file"
    else
      age_key_file=$(find "$HOME/.config/sops" -name "keys.txt" 2>/dev/null | head -1)
      if [[ -n $age_key_file ]]; then
        print_status ok "Age key (sops): found"
      else
        age_key_file=$(find "$HOME/.config/sops" -name "age.key" 2>/dev/null | head -1)
        if [[ -n $age_key_file ]]; then
          print_status ok "Age key (sops alt): found"
        else
          print_status warn "No age key found"
        fi
      fi
    fi
  else
    print_status error "age not installed"
  fi

  local secrets_dir="$HOME/.config/flake/secrets"
  if [[ -d $secrets_dir ]]; then
    local encrypted_count
    encrypted_count=$(find "$secrets_dir" -name "*.sops.yaml" -o -name "*.sops.json" 2>/dev/null | wc -l)
    print_status ok "Encrypted files: $encrypted_count"
  else
    print_status info "No secrets directory"
  fi

  if [[ -f ".sops.yaml" ]]; then
    if grep -q "age:" .sops.yaml 2>/dev/null; then
      print_status ok "SOPS age rules configured"
    fi
  fi

  return 0
}

fix_secrets() {
  print_status info "Secret fixes not implemented (manual key management required)"
}
