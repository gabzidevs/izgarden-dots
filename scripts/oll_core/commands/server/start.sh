#!/usr/bin/env bash

OLL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

source "${OLL_DIR}/lib/host.sh"
source "${OLL_DIR}/lib/ollama.sh"
source "${OLL_DIR}/lib/ui.sh"

cmd_start() {
  if is_server_running; then
    print_status ok "Ollama is already running"
    return 0
  fi

  echo -e "${BLUE}Starting Ollama...${NC}"

  local opt_config="${HOME}/.config/ollama-optimize/current.env"
  [[ -f $opt_config ]] && {
    set -a
    source "$opt_config"
    set +a
  } || {
    export OLLAMA_CONTEXT_LENGTH="${OLLAMA_CONTEXT_LENGTH:-64000}"
    export OLLAMA_KV_CACHE_TYPE="${OLLAMA_KV_CACHE_TYPE:-q8_0}"
  }

  export OLLAMA_HOST="${OLLAMA_HOST:-0.0.0.0:11434}"
  export OLLAMA_NUM_PARALLEL="${OLLAMA_NUM_PARALLEL:-4}"
  export OLLAMA_KEEP_ALIVE="${OLLAMA_KEEP_ALIVE:-30m}"

  mkdir -p ~/.ollama
  env OLLAMA_HOST="$OLLAMA_HOST" OLLAMA_FLASH_ATTENTION="$OLLAMA_FLASH_ATTENTION" OLLAMA_KV_CACHE_TYPE="$OLLAMA_KV_CACHE_TYPE" OLLAMA_CONTEXT_LENGTH="$OLLAMA_CONTEXT_LENGTH" OLLAMA_NUM_PARALLEL="$OLLAMA_NUM_PARALLEL" OLLAMA_KEEP_ALIVE="$OLLAMA_KEEP_ALIVE" nohup ollama serve >~/.ollama/server.log 2>&1 &

  print_status ok "Started Ollama (${OLLAMA_HOST})"

  for i in {1..30}; do
    check_local && {
      print_status ok "API ready"
      return 0
    }
    sleep 1
  done

  print_status error "Timeout waiting for API"
  exit 1
}

cmd_start
