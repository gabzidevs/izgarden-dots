#!/usr/bin/env bash

# Resolve symlinks to get actual directory
SOURCE="${BASH_SOURCE[0]}"
while [ -L "$SOURCE" ]; do
  SOURCE="$(readlink "$SOURCE")"
done
SCRIPT_DIR="$(cd "$(dirname "$SOURCE")" && pwd)"

# Reuse oll's lib
source "${SCRIPT_DIR}/../oll_core/lib/host.sh"
source "${SCRIPT_DIR}/../oll_core/lib/profile.sh"
source "${SCRIPT_DIR}/../oll_core/lib/ollama.sh"

has_gum() { command -v gum &>/dev/null; }

# Colors
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${MAGENTA}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${MAGENTA}║${NC}            🤖 Ollama Dashboard              ${MAGENTA}║${NC}"
echo -e "${MAGENTA}╚══════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "Machine: ${CYAN}$(detect_machine)${NC}"
echo -e "Profile: ${CYAN}$(get_ocx_profile)${NC}"
echo ""

# Local status
echo -n "Local: "
if check_local; then
  echo -e "${GREEN}● Running${NC}"
else
  echo -e "${RED}○ Not running${NC}"
  echo ""
  echo "  → Run ${YELLOW}oll server start${NC} to start Ollama"
  exit 0
fi

# Remote status
if [[ "$(detect_machine)" != "nebulanix" ]]; then
  echo -n "Remote: "
  if check_remote; then
    echo -e "${GREEN}● Reachable${NC}"
  else
    echo -e "${RED}○ Unreachable${NC}"
  fi
fi

echo ""
echo -e "${CYAN}─── Loaded Models ───${NC}"

# Get loaded models
LOADED=$(ollama ps 2>/dev/null | tail -n +2)
if [[ -z $LOADED ]]; then
  echo -e "  ${YELLOW}No models loaded${NC}"
else
  echo "$LOADED" | while read line; do
    MODEL=$(echo "$line" | awk '{print $1}')
    SIZE=$(echo "$line" | awk '{print $3}')
    PROCESSOR=$(echo "$line" | awk '{print $4}')
    echo -e "  ${GREEN}●${NC} ${CYAN}$MODEL${NC} ${YELLOW}$SIZE${NC} ${PROCESSOR}"
  done
fi

echo ""
echo -e "${CYAN}─── Quick Stats ───${NC}"

# Model count
MODEL_COUNT=$(ollama list 2>/dev/null | tail -n +2 | wc -l | tr -d ' ')
echo -e "  Models: ${GREEN}$MODEL_COUNT${NC} available"

# Total size - extract GB values
TOTAL_SIZE=$(ollama list 2>/dev/null | tail -n +2 | grep -oP '\d+(\.\d+)?\s*GB' | sed 's/\s*GB//' | awk '{sum+=$1} END {printf "%.0f", sum}')
if [[ -n $TOTAL_SIZE ]] && [[ $TOTAL_SIZE != "0" ]]; then
  echo -e "  Total: ${GREEN}${TOTAL_SIZE}GB${NC} installed"
fi

# Memory usage
if command -v free &>/dev/null; then
  MEM=$(free -h 2>/dev/null | awk '/Mem:/ {print $3 "/" $2}')
  echo -e "  RAM: ${GREEN}$MEM${NC} used"
fi

echo ""
echo -e "${CYAN}─── Recommended Models ───${NC}"

# Show recommended models based on available tools
echo -e "  ${GREEN}Quick:${NC}     ${YELLOW}qwen3:8b${NC} (5GB) - Fast general purpose"
echo -e "  ${GREEN}Coding:${NC}   ${YELLOW}qwen3-coder-tooled${NC} (18GB) - With PB prompt"
echo -e "  ${GREEN}Tools:${NC}    ${YELLOW}devstral-tooled${NC} (14GB) - Full tool support"
echo -e "  ${GREEN}Reasoning:${NC} ${YELLOW}deepseek-r1:8b${NC} (5GB) - Complex reasoning"

echo ""
echo -e "${CYAN}─── Commands ───${NC}"
echo "  ${YELLOW}oll status${NC}      → Detailed server status"
echo "  ${YELLOW}oll model list${NC}  → All available models"
echo "  ${YELLOW}oll connect <model>${NC} → Switch model"
echo "  ${YELLOW}opz${NC}            → OpenCode with profile"
