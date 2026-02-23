#!/usr/bin/env bash

set -e

# Find the actual script location (handle symlinks)
SOURCE="${BASH_SOURCE[0]}"
while [ -L "$SOURCE" ]; do
  SOURCE="$(readlink "$SOURCE")"
done

OLL_DIR="$(cd "$(dirname "$SOURCE")" && pwd)"

source "${OLL_DIR}/lib/host.sh"
source "${OLL_DIR}/lib/profile.sh"
source "${OLL_DIR}/lib/ollama.sh"
source "${OLL_DIR}/lib/ui.sh"

subcommand="${1:-}"

[[ -z $subcommand ]] && has_gum && exec "${OLL_DIR}/../doll"

case "$subcommand" in
-h | --help)
  echo -e "${MAGENTA}oll${NC} - Ollama Unified CLI"
  echo "Usage: oll <subcommand> [options]"
  echo ""
  echo "Host: $(detect_machine) | Profile: $(get_ocx_profile)"
  echo ""
  echo "Subcommands:"
  echo "  connect [model]   Switch model"
  echo "  server <action>   start, stop, restart, status, health, logs, list"
  echo "  model <action>    list, pull, rm, storage, recommend"
  echo "  tune [preset]     speed, balanced, power, research"
  echo "  profile           show, list, set"
  echo "  template          apply, create, list custom models"
  echo "  doctor            Diagnostics"
  echo "  status            Quick status"
  echo ""
  echo "Dashboard: doll"
  ;;

c | connect)
  shift
  source "${OLL_DIR}/commands/connect.sh" "$@"
  ;;
s | server)
  shift
  source "${OLL_DIR}/commands/server/${1:-status}.sh" "${@:2}"
  ;;
m | model)
  shift
  source "${OLL_DIR}/commands/model/${1:-list}.sh" "${@:2}"
  ;;
t | tune)
  shift
  source "${OLL_DIR}/commands/tune.sh" "$@"
  ;;
p | profile)
  shift
  source "${OLL_DIR}/commands/profile.sh" "$@"
  ;;
template)
  shift
  source "${OLL_DIR}/commands/template.sh" "$@"
  ;;
doctor)
  echo -e "${BLUE}🏥 Ollama Doctor${NC}"
  echo "===================="
  echo ""
  echo -e "Machine: ${CYAN}$(detect_machine)${NC}"
  echo -e "Profile: ${CYAN}$(get_ocx_profile)${NC}"
  echo ""
  echo -n "Local: "
  check_local && echo -e "${GREEN}✓ Running${NC}" || echo -e "${RED}✗ Not running${NC}"
  echo -n "ollama: "
  command -v ollama &>/dev/null && echo -e "${GREEN}✓${NC}" || echo -e "${RED}✗${NC}"
  echo -n "gum: "
  has_gum && echo -e "${GREEN}✓${NC}" || echo -e "${YELLOW}⚠${NC}"
  ;;
status)
  echo -e "${MAGENTA}╔═══════════════════════════════════════╗${NC}"
  echo -e "${MAGENTA}║${NC}         📊 Ollama Status          ${MAGENTA}║${NC}"
  echo -e "${MAGENTA}╚═══════════════════════════════════════╝${NC}"
  echo ""
  echo -e "Machine: ${CYAN}$(detect_machine)${NC}"
  echo -e "Profile: ${CYAN}$(get_ocx_profile)${NC}"
  echo ""
  echo -n "Local: "
  check_local && echo -e "${GREEN}Running${NC}" || echo -e "${RED}Not running${NC}"
  ;;
*)
  echo "Unknown: $subcommand"
  exit 1
  ;;
esac
