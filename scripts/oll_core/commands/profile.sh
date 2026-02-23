#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/../lib/host.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../lib/profile.sh"

action="${1:-show}"

case "$action" in
show)
  echo "OCX Profile"
  echo "============"
  echo "Machine: $(detect_machine)"
  echo "Profile: $(get_ocx_profile)"
  echo ""
  echo "Note: Profile plugins are managed by nix-darwin."
  echo "      Run 'just provision' to apply profile changes."
  ;;
list) list_profiles ;;
set)
  export OCX_PROFILE="$2"
  echo "Set OCX_PROFILE=$2"
  echo ""
  echo "Note: This only sets the env var. To install profile plugins,"
  echo "      run 'just provision <hostname>' to apply via nix-darwin."
  ;;
activate)
  activate_profile "$2"
  ;;
*)
  echo "Usage: oll profile [show|list|set <name>|activate <name>]"
  echo ""
  echo "Commands:"
  echo "  show           Show current profile (default)"
  echo "  list          List available profiles"
  echo "  set <name>    Set OCX_PROFILE env var (runtime only)"
  echo "  activate <name>  Activate profile (Note: requires nix-darwin)"
  ;;
esac
