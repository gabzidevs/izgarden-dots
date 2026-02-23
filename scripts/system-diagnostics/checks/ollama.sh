#!/usr/bin/env bash

# =============================================================================
# Ollama Check (Enhanced Doctor)
# =============================================================================

check_ollama() {
  echo -e "${CYAN}▸ Ollama Server${NC}"

  if ! command -v ollama &>/dev/null; then
    print_status error "ollama binary not found"
    return 1
  fi
  print_status ok "ollama binary: available"

  local machine
  machine=$(detect_machine)

  if [[ $machine == "nebulanix" ]]; then
    local server_url="http://localhost:11434"

    if curl -s --max-time 3 "${server_url}/api/health" >/dev/null 2>&1; then
      print_status ok "Server health: healthy"
    elif curl -s --max-time 3 "${server_url}/api/tags" >/dev/null 2>&1; then
      print_status ok "Server: running"
    else
      print_status error "Server: not responding"
    fi

    local models
    models=$(curl -s "${server_url}/api/tags" 2>/dev/null | jq -r '.models | length' 2>/dev/null || echo "0")
    print_status ok "Models: $models installed"

    if [[ -d "$HOME/.ollama/models" ]]; then
      local storage
      storage=$(du -sh "$HOME/.ollama/models" 2>/dev/null | awk '{print $1}')
      print_status ok "Storage: $storage"
    fi

  else
    local remote_url="http://nebulanix.local:11434"

    if curl -s --max-time 5 "${remote_url}/api/health" >/dev/null 2>&1; then
      print_status ok "Remote server: healthy"
    elif curl -s --max-time 5 "${remote_url}/api/tags" >/dev/null 2>&1; then
      print_status ok "Remote server: accessible"
    else
      print_status warn "Remote server: not accessible"
      return 2
    fi

    local models
    models=$(curl -s "${remote_url}/api/tags" 2>/dev/null | jq -r '.models | length' 2>/dev/null || echo "0")
    print_status ok "Remote models: $models"

    if curl -s --max-time 5 "${remote_url}/api/tags" 2>/dev/null | jq -r '.models[].name' 2>/dev/null | head -3; then
      :
    fi
  fi

  local ollama_host
  ollama_host="${OLLAMA_HOST:-}"
  if [[ -n $ollama_host ]]; then
    print_status info "OLLAMA_HOST: $ollama_host"
  fi

  return 0
}

fix_ollama() {
  echo -e "${BLUE}Fixing Ollama...${NC}"

  if ! command -v ollama &>/dev/null; then
    print_status error "Cannot fix: ollama not installed"
    return 1
  fi

  local machine
  machine=$(detect_machine)

  if [[ $machine == "nebulanix" ]]; then
    if ! pgrep -f "ollama serve" &>/dev/null; then
      print_status info "Starting ollama server..."
      ollama serve &
      sleep 3
      print_status ok "Ollama server started"
    else
      print_status info "Ollama already running"
    fi
  else
    print_status info "Remote host - cannot start server locally"
  fi
}
