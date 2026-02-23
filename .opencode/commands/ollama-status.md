---
description: Quick status check - server, resources, thermal, disk
subtask: false
---
Run quick Ollama status check:
1. `ollamactl status` - server running?
2. `ollama-sysopt --status` - RAM available?
3. `ollama-sysopt --thermal` - CPU temp?
4. `df -h ~/.ollama` - disk space?
5. `ollama ps` - running models?

Report status with color coding:
- 🟢 Green: RAM >20GB, Temp <70°C, Disk >50GB
- 🟡 Yellow: RAM 10-20GB, Temp 70-80°C, Disk 20-50GB
- 🔴 Red: RAM <10GB, Temp >80°C, Disk <20GB
