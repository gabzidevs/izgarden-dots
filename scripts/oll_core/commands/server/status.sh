#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/../../lib/ollama.sh"

echo -e "${BLUE}Ollama Status${NC}"
echo "=============="

pid=$(get_server_pid)

if [[ -n $pid ]]; then
  echo -e "${GREEN}Process: RUNNING${NC} (PID: $pid)"
  ps -o pid,ppid,%cpu,%mem,rss,etime -p "$pid" 2>/dev/null | tail -1
else
  echo -e "${RED}Process: NOT RUNNING${NC}"
fi

check_local && echo -e "${GREEN}API: HEALTHY${NC}" || echo -e "${RED}API: UNAVAILABLE${NC}"
