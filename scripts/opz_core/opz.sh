#!/usr/bin/env bash

# Resolve symlinks
SOURCE="${BASH_SOURCE[0]}"
while [ -L "$SOURCE" ]; do
  SOURCE="$(readlink "$SOURCE")"
done
SCRIPT_DIR="$(cd "$(dirname "$SOURCE")" && pwd)"

# Reuse oll's lib
source "${SCRIPT_DIR}/../oll_core/lib/host.sh"
source "${SCRIPT_DIR}/../oll_core/lib/profile.sh"

has_gum() { command -v gum &>/dev/null; }

show_help() {
  echo "Usage: opz [options] [-- args...]"
  echo ""
  echo "Options:"
  echo "  -s, --status     Show OpenCode status"
  echo "  -l, --list       List available profiles"
  echo "  -p, --profile    Set profile explicitly"
  echo "  -h, --help       Show this help message"
  echo ""
  echo "Examples:"
  echo "  opz                    # Launch with auto-detected profile"
  echo "  opz -p nebx            # Launch with specific profile"
  echo "  opz -s                 # Show status"
  echo "  opz -- some args       # Pass args to opencode"
}

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

# Simple status
show_status() {
  echo -e "${CYAN}OpenCode Status${NC}"
  echo "==============="
  echo "Machine: $(detect_machine)"
  echo "Profile: $(get_ocx_profile)"

  if [[ -f "${HOME}/.local/share/opencode/runtime.json.env" ]]; then
    source "${HOME}/.local/share/opencode/runtime.json.env"
    echo "Model: ${OPENCODE_MODEL:-not set}"
  fi
}

case "${1:-}" in
-s | --status) show_status ;;
-l | --list)
  echo "Profiles:"
  list_profiles "$(get_ocx_profile)"
  ;;
-p | --profile)
  export OCX_PROFILE="${2:-}"
  [[ -z $OCX_PROFILE ]] && echo "Error: profile name required" && exit 1
  shift 2
  echo "Launching OpenCode with profile: $OCX_PROFILE"
  exec opencode "$@"
  ;;
-h | --help) show_help ;;
*)
  # Launch opencode with profile
  export OCX_PROFILE="${OCX_PROFILE:-$(get_ocx_profile)}"
  echo "Launching OpenCode with profile: $OCX_PROFILE"
  exec opencode "$@"
  ;;
esac
