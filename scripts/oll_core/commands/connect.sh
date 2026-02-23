#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OLL_DIR="$(dirname "$SCRIPT_DIR")"
source "${OLL_DIR}/lib/host.sh"
source "${OLL_DIR}/lib/ollama.sh"
source "${OLL_DIR}/lib/ui.sh"

RUNTIME_CONFIG="${HOME}/.local/share/opencode/runtime.json"

usage() {
  echo "Usage: $0 [model] [options]"
  echo "  model              Model name (e.g., qwen3:8b)"
  echo "  --local            Force local connection"
  echo "  --remote           Force remote connection (nebulanix)"
  echo "  --host <url>       Custom host URL"
  echo ""
  echo "Examples:"
  echo "  $0                 # Interactive model selection"
  echo "  $0 qwen3:8b        # Connect with specific model"
  echo "  $0 --remote        # Force remote (nebulanix)"
  echo "  $0 --local         # Force local"
  exit 1
}

generate_config() {
  local model="$1"
  local host="$2"

  mkdir -p "$(dirname "$RUNTIME_CONFIG")"
  local model_name="${model#ollama/}"

  # Subagent models that must always be available for task delegation
  # These are character models with custom Modelfiles (lich, lemongrab)
  cat >"$RUNTIME_CONFIG" <<EOF
{
  "\$schema": "https://opencode.ai/config.json",
  "provider": {
    "ollama": {
      "npm": "@ai-sdk/openai-compatible",
      "options": { "baseURL": "${host}/v1" },
      "models": {
        "${model_name}": { "modelName": "${model_name}", "tools": true },
        "qwen2.5-3b-lich": { "modelName": "qwen2.5-3b-lich", "tools": true },
        "qwen3-8b-lich": { "modelName": "qwen3-8b-lich", "tools": true },
        "qwen2.5-3b-lemongrab": { "modelName": "qwen2.5-3b-lemongrab", "tools": true },
        "qwen3-8b-lemongrab": { "modelName": "qwen3-8b-lemongrab", "tools": true },
        "qwen2.5-3b-magicman": { "modelName": "qwen2.5-3b-magicman", "tools": true },
        "qwen2.5-coder-magicman": { "modelName": "qwen2.5-coder-magicman", "tools": true },
        "qwen2.5-3b-golb": { "modelName": "qwen2.5-3b-golb", "tools": true },
        "llama3.2:3b": { "modelName": "llama3.2:3b", "tools": true },
        "qwen3:8b": { "modelName": "qwen3:8b", "tools": true }
      }
    }
  }
}
EOF

  cat >"${RUNTIME_CONFIG}.env" <<EOF
export OPENCODE_MODEL="ollama/${model_name}"
export OPENCODE_CONFIG="${RUNTIME_CONFIG}"
export OLLAMA_HOST="${host}"
EOF

  local status_label="$model @ $host"
  case "$status" in
  ok | running) echo "✓ $status_label" ;;
  warn | warning) echo "⚠ $status_label" ;;
  error | failed) echo "✗ $status_label" ;;
  *) echo "$status_label" ;;
  esac
}

force_host=""
while [[ $# -gt 0 ]]; do
  case "$1" in
  --local) force_host="$LOCAL_URL" && shift ;;
  --remote) force_host="$NEBULANIX_URL" && shift ;;
  --host)
    force_host="$2"
    shift 2
    ;;
  --help | -h) usage ;;
  -*) echo "Unknown option: $1" && usage ;;
  *) model="$1" && shift ;;
  esac
done

machine=$(detect_machine)

if [[ -n $force_host ]]; then
  host="$force_host"
elif [[ $machine == "nebulanix" ]]; then
  host="$LOCAL_URL"
else
  check_remote && host="$NEBULANIX_URL" || host="$LOCAL_URL"
fi

models=$(get_models_for_host "$host")
if [[ -z $models ]]; then
  echo "✗ No models found at $host"

  if [[ $host == "$NEBULANIX_URL" ]]; then
    echo "Trying local fallback..."
    host="$LOCAL_URL"
    models=$(get_models_for_host "$host")
    if [[ -z $models ]]; then
      echo "✗ No local models either"
      exit 1
    fi
  else
    exit 1
  fi
fi

if [[ -z $model ]]; then
  if has_gum; then
    model=$(echo "$models" | gum filter --placeholder "Select model...") || true
  else
    echo "Available models:"
    echo "$models" | nl -w2 -s". "
    echo -n "Select: "
    read model
  fi
fi

[[ -z $model ]] && exit 0

generate_config "$model" "$host"
