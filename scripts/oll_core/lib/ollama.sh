#!/usr/bin/sh

NEBULANIX_HOST="${NEBULANIX_HOST:-nebulanix.local}"
NEBULANIX_URL="http://${NEBULANIX_HOST}:11434"
LOCAL_URL="http://0.0.0.0:11434"

check_local() { curl -s --max-time 3 "${LOCAL_URL}/api/tags" >/dev/null 2>&1; }
check_remote() { curl -s --max-time 5 "${NEBULANIX_URL}/api/tags" >/dev/null 2>&1; }

get_local_models() { curl -s "${LOCAL_URL}/api/tags" 2>/dev/null | jq -r '.models[].name' 2>/dev/null || echo ""; }
get_remote_models() { curl -s "${NEBULANIX_URL}/api/tags" 2>/dev/null | jq -r '.models[].name' 2>/dev/null || echo ""; }

get_models_for_host() {
  [[ "$1" == "local" ]] || [[ "$1" == "$LOCAL_URL" ]] && get_local_models || get_remote_models
}

get_server_pid() { pgrep -f "ollama serve" 2>/dev/null || true; }
is_server_running() { [[ -n "$(get_server_pid)" ]] && check_local; }
