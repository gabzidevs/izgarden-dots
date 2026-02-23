#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/../../lib/ollama.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/ui.sh"

if check_local; then
  print_status ok "API responding"
  echo "Models: $(get_local_models | wc -l | tr -d ' ')"
else
  print_status error "API not responding"
  exit 1
fi
