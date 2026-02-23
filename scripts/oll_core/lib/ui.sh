#!/usr/bin/env bash

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
  *) echo "$label" ;;
  esac
}
