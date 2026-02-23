#!/usr/bin/env bash

# =============================================================================
# Tools Check (mise, git, gum)
# =============================================================================

check_tools() {
  echo -e "${CYAN}▸ Tools${NC}"

  if command -v mise &>/dev/null; then
    local mise_version
    mise_version=$(mise --version 2>/dev/null | head -1)
    print_status ok "mise: $mise_version"
  else
    print_status error "mise: not installed"
  fi

  if command -v git &>/dev/null; then
    local git_version
    git_version=$(git --version 2>/dev/null)
    print_status ok "git: $git_version"
  else
    print_status error "git: not installed"
  fi

  if command -v gum &>/dev/null; then
    local gum_version
    gum_version=$(gum --version 2>/dev/null)
    print_status ok "gum: $gum_version"
  else
    print_status warn "gum: not installed (TUI will be limited)"
  fi

  if command -v nix &>/dev/null; then
    local nix_version
    nix_version=$(nix --version 2>/dev/null)
    print_status ok "nix: $nix_version"
  else
    print_status error "nix: not installed"
  fi

  if command -v ollama &>/dev/null; then
    local ollama_version
    ollama_version=$(ollama --version 2>/dev/null)
    print_status ok "ollama: $ollama_version"
  else
    print_status warn "ollama: not installed"
  fi

  if command -v sops &>/dev/null; then
    local sops_version
    sops_version=$(sops --version 2>/dev/null)
    print_status ok "sops: $sops_version"
  else
    print_status warn "sops: not installed"
  fi

  return 0
}

fix_tools() {
  print_status info "Tool installation not implemented (use nix-darwin)"
}
