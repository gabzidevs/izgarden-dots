#!/usr/bin/env bash

# =============================================================================
# OpenCode Plugins Check (A)
# =============================================================================

check_opencode() {
  echo -e "${CYAN}▸ OpenCode Plugins${NC}"

  if command -v opencode &>/dev/null; then
    print_status ok "opencode CLI: available"
  else
    print_status warn "opencode CLI: not in PATH"
  fi

  local ocx_dir="$HOME/.config/opencode"
  if [[ -d $ocx_dir ]]; then
    print_status ok "OpenCode config: $ocx_dir"
  else
    print_status warn "OpenCode config: not found"
  fi

  if [[ -n $OCX_PROFILE ]]; then
    print_status ok "OCX_PROFILE: $OCX_PROFILE"
  else
    print_status warn "OCX_PROFILE not set"
  fi

  if command -v mise &>/dev/null; then
    if mise x ocx@latest -- ocx --version &>/dev/null; then
      local ocx_version
      ocx_version=$(mise x ocx@latest -- ocx --version 2>&1 | head -1)
      print_status ok "OCX: $ocx_version"

      local plugins_output
      plugins_output=$(mise x ocx@latest -- ocx plugin list 2>&1)
      if [[ -n $plugins_output ]]; then
        print_status info "Plugins:"
        echo "$plugins_output" | while read -r line; do
          echo "  $line"
        done
      fi
    else
      print_status warn "OCX not installed (run: mise x ocx@latest)"
    fi
  else
    print_status warn "mise not available"
  fi

  return 0
}

fix_opencode() {
  print_status info "OpenCode plugin fixes not implemented"
}
