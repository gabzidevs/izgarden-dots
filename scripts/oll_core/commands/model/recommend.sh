#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/../../lib/host.sh"

case "$(detect_machine)" in
nebulanix)
  echo "Nebulanix (48GB):"
  echo "  • qwen3:8b (~5GB) - Daily driver"
  echo "  • qwen3-coder:30b (~19GB) - Coding"
  echo "  • deepseek-r1:8b (~5GB) - Reasoning"
  ;;
spacehound)
  echo "Spacehound (18GB):"
  echo "  • llama3.2:3b (~2GB) - Fallback"
  echo "  • gemma3:1b (~1GB) - Ultra-fast"
  ;;
esac
