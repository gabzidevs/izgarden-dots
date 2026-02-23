#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OLL_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"

source "${OLL_DIR}/lib/ollama.sh"
source "${OLL_DIR}/lib/ui.sh"

CLAUDE_MODELS=(
  "qwen2.5-coder:32b-instruct-q4_K_M"
  "devstral"
  "qwen3:32b-q4_K_M"
  "qwen3:30b-a3b-q4_K_M"
)

NEAR_ZEN_MODELS=(
  "gpt-oss:20b"
  "glm4"
)

OURS_MODELS=(
  "llama3.2:1b"
)

REASONING_MODELS=(
  "qwen3:32b-q4_K_M"
  "qwen3:30b-a3b-q4_K_M"
  "deepseek-r1:14b"
)

usage() {
  echo "Usage: oll model pull <model|group> [options]"
  echo ""
  echo "Models:"
  echo "  <model>              Pull specific model (e.g., qwen3:8b)"
  echo ""
  echo "Groups:"
  echo "  claudes              Pull Claude-recommended models"
  echo "  nearzen             Pull local equivalents to Zen free models"
  echo "  reasoning            Pull reasoning-focused models"
  echo "  ours                Pull our validated models"
  echo "  all                  Pull full try-ai stack"
  echo ""
  echo "Examples:"
  echo "  oll model pull qwen3:8b"
  echo "  oll model pull claudes"
  echo "  oll model pull nearzen"
  exit 1
}

pull_model() {
  local model="$1"
  echo -e "${BLUE}Pulling ${model}...${NC}"
  ollama pull "$model"
}

pull_group() {
  local group="$1"
  local models=()

  case "$group" in
  claudes)
    models=("${CLAUDE_MODELS[@]}")
    echo -e "${MAGENTA}Pulling Claude recommended models...${NC}"
    ;;
  nearzen)
    models=("${NEAR_ZEN_MODELS[@]}")
    echo -e "${MAGENTA}Pulling near-zen models...${NC}"
    ;;
  reasoning)
    models=("${REASONING_MODELS[@]}")
    echo -e "${MAGENTA}Pulling reasoning models...${NC}"
    ;;
  ours)
    models=("${OURS_MODELS[@]}")
    echo -e "${MAGENTA}Pulling our validated models...${NC}"
    ;;
  all)
    models=("${CLAUDE_MODELS[@]}" "${NEAR_ZEN_MODELS[@]}" "${OURS_MODELS[@]}")
    echo -e "${MAGENTA}Pulling full try-ai stack...${NC}"
    ;;
  *)
    echo "Unknown group: $group"
    usage
    ;;
  esac

  for model in "${models[@]}"; do
    pull_model "$model"
  done

  echo -e "${GREEN}Done!${NC}"
}

model="${1:-}"

# Handle --help before anything else
if [[ $model == "--help" ]] || [[ $model == "-h" ]]; then
  usage
fi

[[ -z $model ]] && usage

check_local || {
  echo "Ollama not running"
  exit 1
}

# Check if it's a group or individual model
case "$model" in
claudes | nearzen | reasoning | ours | all)
  pull_group "$model"
  ;;
*)
  pull_model "$model"
  ;;
esac
