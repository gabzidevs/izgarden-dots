#!/usr/bin/env bash

# =============================================================================
# UI & Colors - Reuse from oll_core or provide fallback
# =============================================================================

SD_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SD_DIR="$(cd "$SD_LIB_DIR/.." && pwd)"

if [[ -f "$SD_DIR/oll_core/lib/ui.sh" ]]; then
  source "$SD_DIR/oll_core/lib/ui.sh"
else
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  BLUE='\033[0;34m'
  CYAN='\033[0;36m'
  MAGENTA='\033[0;35m'
  NC='\033[0m'

  has_gum() { command -v gum &>/dev/null; }

  print_status() {
    local status="$1"
    local label="$2"
    case "$status" in
    ok | running | healthy) echo -e "${GREEN}✓${NC} $label" ;;
    warn | warning) echo -e "${YELLOW}⚠${NC} $label" ;;
    error | failed | unhealthy) echo -e "${RED}✗${NC} $label" ;;
    info) echo -e "${BLUE}ℹ${NC} $label" ;;
    *) echo "$label" ;;
    esac
  }
fi
