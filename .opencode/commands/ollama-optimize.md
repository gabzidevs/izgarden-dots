---
description: Optimize Ollama server based on current resources
subtask: true
---
Optimize Ollama server:
1. Check current resources (RAM, CPU cores)
2. Select preset based on resources:
   - >40GB RAM: speed
   - 20-40GB RAM: balanced
   - <20GB RAM: power
 3. Run `oll tune <preset>`
4. Report what was applied
