#!/usr/bin/env bash

[[ -f ~/.ollama/server.log ]] && tail -n 50 ~/.ollama/server.log || {
  echo "No log file"
  exit 1
}
