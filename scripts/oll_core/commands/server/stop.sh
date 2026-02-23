#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/../../lib/ollama.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/ui.sh"

pid=$(get_server_pid)

if [[ -z $pid ]]; then
  print_status warn "Ollama was not running"
  exit 0
fi

echo -e "${BLUE}Stopping Ollama...${NC}"
kill "$pid" 2>/dev/null || true
sleep 1

kill -0 "$pid" 2>/dev/null && {
  kill -9 "$pid" 2>/dev/null
  print_status ok "Force stopped"
} || print_status ok "Stopped"
