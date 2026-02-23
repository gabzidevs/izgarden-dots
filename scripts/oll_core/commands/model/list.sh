#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/../../lib/ollama.sh"

check_local && ollama list || {
  echo "Ollama not running"
  exit 1
}
