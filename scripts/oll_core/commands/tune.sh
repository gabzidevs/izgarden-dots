#!/usr/bin/env bash

declare -A PRESETS=(
  ["speed"]="4096 q4_0 1 8 2"
  ["balanced"]="16384 q8_0 1 4 2"
  ["power"]="32000 q8_0 1 2 2"
  ["research"]="64000 f16 1 1 1"
)

preset="${1:-balanced}"

[[ -z ${PRESETS[$preset]} ]] && {
  echo "Unknown: $preset"
  echo "Valid: speed, balanced, power, research"
  exit 1
}

read -r ctx kv flash parallel loaded <<<"${PRESETS[$preset]}"

export OLLAMA_CONTEXT_LENGTH="$ctx" OLLAMA_KV_CACHE_TYPE="$kv" OLLAMA_FLASH_ATTENTION="$flash"
export OLLAMA_NUM_PARALLEL="$parallel" OLLAMA_MAX_LOADED_MODELS="$loaded"
export OLLAMA_KEEP_ALIVE="30m"

mkdir -p "${HOME}/.config/ollama-optimize"
cat >"${HOME}/.config/ollama-optimize/current.env" <<EOF
OLLAMA_CONTEXT_LENGTH=$ctx
OLLAMA_KV_CACHE_TYPE=$kv
OLLAMA_FLASH_ATTENTION=$flash
OLLAMA_NUM_PARALLEL=$parallel
OLLAMA_MAX_LOADED_MODELS=$loaded
OLLAMA_KEEP_ALIVE=30m
EOF

echo "Applied: $preset (ctx=$ctx, kv=$kv, parallel=$parallel)"
echo "Restart server to apply: oll server restart"
