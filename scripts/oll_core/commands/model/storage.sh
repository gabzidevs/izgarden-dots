#!/usr/bin/env bash

ollama_dir="${HOME}/.ollama/models"

[[ -d $ollama_dir ]] && du -sh "$ollama_dir" && du -sh "$ollama_dir"/* 2>/dev/null | sort -hr | head -10 || echo "No models yet"
