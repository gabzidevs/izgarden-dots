---
description: Select best Ollama model for task based on resources
subtask: false
---
Recommend best model based on:
1. Current available RAM (check `ollama-sysopt --status`)
2. Use case:
   - coding: qwen3:8b or qwen3-coder:30b if >40GB
   - vision: gemma3:4b or llama3.2:3b
   - reasoning: deepseek-r1:14b
   - speed: llama3.2:1b
   - general: qwen3:8b

Provide recommendation with reasoning and ensure model is pulled if not available.
