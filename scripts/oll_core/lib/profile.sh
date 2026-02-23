#!/usr/bin/env bash

# =============================================================================
# OCX Profile Module
# =============================================================================

# Get current OCX profile
# Note: Profiles are managed by `ocx` CLI - this just reads the active profile
get_ocx_profile() {
  # Priority: explicit env > machine detection
  [[ -n $OCX_PROFILE ]] && {
    echo "$OCX_PROFILE"
    return
  }
  [[ -n $OPENCODE_PROFILE ]] && {
    echo "$OPENCODE_PROFILE"
    return
  }

  # Fallback: detect from machine - use shortcode profile names
  case "$(detect_machine)" in
  nebulanix) echo "nebx" ;;
  spacehound) echo "spchound" ;;
  *) echo "default" ;;
  esac
}

# List available OCX profiles via ocx CLI
list_profiles() {
  local current="${1:-$(get_ocx_profile)}"

  if command -v ocx &>/dev/null; then
    echo "OCX Profiles:"
    ocx profile list 2>/dev/null | sed 's/^/  /'
    echo ""
    echo "Current: $current"
    echo ""
    echo "To switch profiles, update OCX_PROFILE env var or set in nix config."
  else
    echo "  ocx not installed"
    echo "Current: $current"
  fi
}

# Activate a profile (installs plugins for that profile)
activate_profile() {
  local profile="${1:-}"
  [[ -z $profile ]] && echo "Usage: activate_profile <profile-name>" && return 1

  if ! command -v ocx &>/dev/null; then
    echo "Error: ocx CLI not found"
    return 1
  fi

  echo "Activating profile: $profile"
  export OCX_PROFILE="$profile"

  # Install profile plugins - this is what the nix module does during activation
  # In practice, you'd run this after changing OCX_PROFILE
  echo "Note: Profile plugins are managed by nix-darwin. Run 'just provision' to apply."
}
