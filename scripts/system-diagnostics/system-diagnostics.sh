#!/usr/bin/env bash

# Don't use set -e since we want to run all checks even if some fail

# =============================================================================
# system-diagnostics - Comprehensive system diagnostics suite
# =============================================================================
# Usage: system-diagnostics [OPTIONS]
# =============================================================================

SOURCE="${BASH_SOURCE[0]}"
while [ -L "$SOURCE" ]; do
  SOURCE="$(readlink "$SOURCE")"
done

SD_DIR="$(cd "$(dirname "$SOURCE")" && pwd)"

source "${SD_DIR}/lib/host.sh"
source "${SD_DIR}/lib/ui.sh"
source "${SD_DIR}/lib/json.sh"

MODE="interactive"
FIX_MODE=false

declare -A CHECK_RESULTS

show_help() {
  echo -e "${MAGENTA}system-diagnostics${NC} - Comprehensive system diagnostics suite"
  echo ""
  echo "Usage: system-diagnostics [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  --check         Run all checks, exit with code (no TUI)"
  echo "  --fix          Attempt auto-fix for common issues"
  echo "  --json         Output results in JSON format"
  echo "  --interactive  TUI with gum if available (default)"
  echo "  -h, --help     Show this help"
  echo ""
  echo "Checks:"
  echo "  A) OpenCode plugins status"
  echo "  B) Time room agent health"
  echo "  C) Secrets/sops status"
  echo "  D) Nix & nix-darwin"
  echo "  E) System resources (CPU, memory, disk)"
  echo "  F) Network (SSH agent, connectivity)"
  echo "  G) Tools (mise, git, gum)"
  echo "  H) Ollama server & models"
}

run_check() {
  local check_name="$1"
  local check_file="${SD_DIR}/checks/${check_name}.sh"

  if [[ ! -f $check_file ]]; then
    print_status error "Check not found: $check_name"
    return 1
  fi

  source "$check_file"

  local result
  if [[ $FIX_MODE == "true" ]]; then
    fix_"$check_name" 2>/dev/null || true
  fi

  check_"$check_name"
  result=$?

  CHECK_RESULTS["$check_name"]=$result
  return $result
}

run_all_checks() {
  local checks=("nix" "system" "network" "tools" "ollama" "opencode" "agents" "secrets")
  local total=0
  local passed=0
  local failed=0
  local warnings=0

  for check in "${checks[@]}"; do
    ((total++))

    echo -e "${CYAN}Checking: $check${NC}"
    run_check "$check"
    local result=$?

    CHECK_RESULTS["$check"]=$result

    case $result in
    0) ((passed++)) ;;
    1) ((failed++)) ;;
    2) ((warnings++)) ;;
    esac
  done

  if [[ $MODE == "json" ]]; then
    output_json "$total" "$passed" "$failed" "$warnings"
  else
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo -e "${BLUE}  Summary: $passed passed, $warnings warnings, $failed failed${NC}"
    echo -e "${BLUE}═══════════════════════════════════════${NC}"

    if [[ $failed -gt 0 ]]; then
      return 1
    fi
  fi

  return 0
}

while [[ $# -gt 0 ]]; do
  case "$1" in
  --check)
    MODE="check"
    shift
    ;;
  --fix)
    FIX_MODE=true
    shift
    ;;
  --json)
    MODE="json"
    shift
    ;;
  --interactive)
    MODE="interactive"
    shift
    ;;
  -h | --help)
    show_help
    exit 0
    ;;
  *)
    echo "Unknown option: $1"
    show_help
    exit 1
    ;;
  esac
done

if [[ $MODE == "interactive" ]]; then
  echo -e "${MAGENTA}╔═══════════════════════════════════════╗${NC}"
  echo -e "${MAGENTA}║${NC}       System Diagnostics           ${MAGENTA}║${NC}"
  echo -e "${MAGENTA}╚═══════════════════════════════════════╝${NC}"
  echo ""
  echo -e "Machine: ${CYAN}$(detect_machine)${NC}"
  echo -e "SSH:     ${CYAN}$(is_ssh_session && echo 'yes' || echo 'no')${NC}"
  echo ""
fi

run_all_checks
