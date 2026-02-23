#!/usr/bin/env bash

model="${1:-}"
[[ -z $model ]] && echo "Usage: oll model rm <model>" && exit 1

echo "Removing $model..."
ollama rm "$model"
echo "Done"
