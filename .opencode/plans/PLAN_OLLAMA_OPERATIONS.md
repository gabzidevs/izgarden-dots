# Plan: Ollama Operations Guide

> Daily operations, maintenance, and troubleshooting for the Ollama ecosystem

*In my time, systems were kept alive by runbooks and rituals. Making it yours means knowing the rhythm of your infrastructure.*

---

## Agent Assignments

| Agent | Responsibilities |
|-------|------------------|
| **Simon** | Server infrastructure, Nix configuration, system optimization, thermal management |
| **Fern** | Client configuration, connection testing, playbooks, documentation |
| **Prismo** | Orchestration, coordination, progress reporting |
| **Gunter** | Storage management, model cleanup, resource tracking |

---

## System Reference

| System | Role | Specs | Key Services | Hostname |
|--------|------|-------|--------------|----------|
| **nebulanix** | Ollama Server | 48GB M4 Pro | ollama, smctemp | `nebulanix.local` (mDNS) |
| **spacehound** | Client | 18GB M3 | opencode, crush, local fallback | `spacehound.local` |

> **DYNAMIC IP NOTE:** This network uses dynamic IP addresses (non-static ISP). Always prefer mDNS hostnames (`nebulanix.local`) over hardcoded IPs. Current IP `192.168.1.10` may change after router restart.

---

## Daily Operations Checklist

### Morning Startup

- [ ] Verify nebulanix powered on
- [ ] Check ollama server running: `oll status`
- [ ] Verify spacehound connection: `oll server health`
- [ ] Check thermal baseline: `oll doctor`
- [ ] Confirm desired model loaded

### End of Day

- [ ] Save all work
- [ ] Optional: stop server to save power: `oll server stop`
- [ ] Check disk space if heavy usage: `oll model storage`

### Weekly Maintenance

- [ ] Update models: `oll model pull <model>` for frequently used
- [ ] Check for unused models: `oll model list`
- [ ] Review storage: `oll model storage`
- [ ] Review thermal logs for anomalies

---

## Server Start/Stop Procedures

### Start Ollama Server (Nebulanix)

```bash
# Standard start (recommended)
oll server start

# Start with specific model
oll connect qwen3:8b && opz

# Verify
oll status
oll server health
```

### Stop Ollama Server

```bash
# Recommended
oll server stop

# Force stop if unresponsive
pkill -f ollama
```

### Restart Ollama Server

```bash
# Quick restart (recommended)
oll server restart

# Restart with different model
oll connect qwen3:8b && opz
```

---

## Model Management

### List Models

```bash
# Recommended (detailed)
oll model list

# All models
ollama list

# Storage breakdown
oll model storage

# Show what's currently loaded
ollama ps
```

### Pull New Models

```bash
# Interactive with confirmation (recommended)
oll model pull qwen3:8b

# Direct pull
ollama pull qwen3-coder:30b

# Specific quantization
ollama pull qwen3:8b-q5_K_M
```

### Remove Models

```bash
 # Interactive removal (recommended)
oll model rm <model>

# Direct removal
ollama rm <model>

# Purge old models (30+ days unused)
oll model purge --older-than 30
```

### Model Recommendations

| Use Case | Model | Size | Notes |
|----------|-------|------|-------|
| Daily coding | `qwen3:8b` | 5GB | Best balance |
| Complex code | `qwen3-coder:30b` | 19GB | Highest HumanEval |
| Deep reasoning | `deepseek-r1:8b` | 5GB | Highest MMLU |
| Quick tasks | `gemma3:4b` | 3GB | Fast + vision |
| Local fallback | `llama3.2:3b` | 3GB | Spacehound only |

---

## Model Quantization Explained

### TL;DR

Think of quantization like **MP3 compression for AI models**:
- Just as MP3 removes frequencies you can't hear to make music smaller
- Quantization removes precision you won't notice to make models smaller
- The model still "works" but with slight quality trade-offs

### The Analogy

**Full precision (f16):** Like a 50-page detailed architectural blueprint with every measurement
- 100% accuracy
- Huge file size
- Only for servers with lots of RAM

**Quantized (q4/q8):** Like a simplified sketch with key measurements
- 95-99% accuracy (you probably won't notice)
- 50-75% smaller file
- Fits on consumer hardware

### Quantization Levels (Simplified)

| Format | Full Name | Size vs Original | Quality | When to Use |
|--------|-----------|------------------|---------|--------------|
| **f16** | Float16 | 100% (baseline) | Best | Servers, max quality needed |
| **q8_0** | Q8_0 | ~50% | 98% | Recommended - best balance |
| **q5_K_M** | Q5_K_Medium | ~31% | 95% | Good balance, popular |
| **q4_K_M** | Q4_K_Medium | ~25% | 93% | Good for limited RAM |
| **q4_0** | Q4_0 | ~25% | 90% | Older format, less efficient |
| **q3_K_S** | Q3_K_Small | ~19% | 85% | Tight RAM constraints |
| **q2_K** | Q2_K | ~15% | 80% | Last resort |

### What the Letters Mean

```
q4_K_M
│ │  │ │
│ │  │ └─ M = Medium (better algorithm)
│ │  │    S = Small (smaller, less accurate)
│ │  └──── K = K-means quantization (better than old style)
│ └─────── 4 = 4 bits per weight (how much info kept)
q ───────── quantization type
```

### In Plain English

- **`q8_0`**: "I want almost perfect quality, give me half the size"
  - Best for: Coding, complex reasoning
  - RAM: Uses ~50% of original size

- **`q5_K_M`**: "Good quality, but I'm space-conscious"  
  - Best for: Most users
  - RAM: Uses ~31% of original size

- **`q4_K_M`**: "I need it small, but don't break it"
  - Best for: Laptops, limited RAM
  - RAM: Uses ~25% of original size

### Your Models and Their Quantizations

```
qwen3:8b                  → q4_K_M (~5GB instead of 16GB)
qwen3-coder:30b           → q4_K_M (~18GB instead of 60GB)  
deepseek-r1:8b            → q4_K_M (~5GB instead of 16GB)
devstral:latest           → q4_K_M (~14GB instead of 48GB)
gpt-oss:20b               → q4_K_M (~13GB instead of 40GB)
qwen2.5-coder:32b         → q4_K_M (~19GB instead of 64GB)
```

### Choosing a Quantization

**For nebulanix (48GB RAM):**
- Use default (q4_K_M) for all models
- For critical tasks: use q8_0 if model available
- Context: can go up to 32k-64k with q8_0

**For spacehound (18GB RAM):**
- Stick to q4_K_M or smaller
- Max context: 8k-16k
- Consider 8b models over 30b

**Trade-off Reality:**
- q8_0 vs q4_K_M: ~95% vs ~93% quality
- But q8_0 needs 2x the RAM
- For coding tasks, you likely won't notice the difference

### KV Cache Quantization (Separate from Model!)

**Important:** Model quantization (q4_K_M) and KV cache quantization are **different**:

- **Model quantization:** How the neural network weights are stored
- **KV cache quantization:** How the conversation history is stored

```
OLLAMA_KV_CACHE_TYPE=q8_0   # Cache uses 8-bit (50% of 16-bit)
OLLAMA_KV_CACHE_TYPE=q4_0    # Cache uses 4-bit (25% of 16-bit)
```

This is set via environment variable and affects **memory during inference**, not storage.

---

## Client Configuration

### Spacehound (Client) - OpenCode

**Config Location:** `~/.config/opencode/opencode.json`

```json
{
  "model": "ollama/qwen3:8b",
  "provider": {
    "ollama": {
      "options": {
        "baseURL": "http://nebulanix.local:11434/v1",
        "temperature": 0.7
      }
    }
  },
  "fallback": {
    "enabled": true,
    "local_model": "ollama/llama3.2:3b",
    "local_base_url": "http://localhost:11434/v1"
  }
}
```

> **IP FALLBACK:** If mDNS fails, replace `nebulanix.local` with `192.168.1.10`. Check current IP on nebulanix: `ipconfig getifaddr en0`

**Switching Models (recommended):**
```bash
# Interactive
oll connect

# Direct
oll connect qwen3-coder:30b

# To local fallback
oll connect --local

# Check connection
oll status
```

**Launch OpenCode:**
```bash
# Using opz (recommended - profile aware)
opz

# Or with model switch first
opz -m qwen3:8b
```

### Spacehound (Client) - Crush

**Config Location:** `~/.config/crush/config.toml`

```toml
[server]
url = "http://nebulanix.local:11434/v1"
api_key = ""
timeout = 300

[models]
default = "qwen3:8b"
fast = "gemma3:4b"
code = "qwen3-coder:30b"
reasoning = "deepseek-r1:8b"
local_fallback = "llama3.2:3b"

[features]
lsp_enabled = true
project_context = true
```

> **IP FALLBACK:** If mDNS fails, replace `nebulanix.local` with `192.168.1.10`.

### Nebulanix (Server) - OpenCode

When running OpenCode directly on nebulanix:

```json
{
  "model": "ollama/qwen3:8b",
  "provider": {
    "ollama": {
      "options": {
        "baseURL": "http://localhost:11434/v1",
        "temperature": 0.7
      }
    }
  }
}
```

---

## Performance Optimization

### Presets

| Preset | Context | KV Cache | Parallel | Use Case |
|--------|---------|----------|----------|----------|
| `speed` | 4k | q4_0 | max | Quick queries |
| `balanced` | 16k | q8_0 | moderate | Daily use |
| `power` | 32k | q8_0 | low | Complex tasks |
| `research` | 64k | f16 | 1 | Maximum quality |

**Apply Preset (recommended):**
```bash
oll tune balanced
oll tune speed
oll tune power
oll tune research
```

### Per-Model Configs

```bash
# Apply model-specific defaults (recommended)
oll tune qwen3-coder:30b

# Override settings
oll tune balanced --context 32000 --parallel 2
```

### Environment Variables

```bash
# Core settings
OLLAMA_HOST=0.0.0.0:11434
OLLAMA_CONTEXT_LENGTH=32000
OLLAMA_KV_CACHE_TYPE=q8_0
OLLAMA_FLASH_ATTENTION=1
OLLAMA_NUM_PARALLEL=2

# Check current
cat ~/.config/ollama-optimize/current.env
```

---

## Monitoring & Diagnostics

### Health Checks

```bash
# Quick status (recommended)
oll status

# Server status
oll server status

# Health endpoints
oll server health

# Full diagnostic (recommended)
oll doctor
```

### Thermal Monitoring

```bash
# Quick check (recommended)
oll doctor

# Detailed
smctemp -c  # CPU
smctemp -g  # GPU

# Continuous monitoring
watch -n 5 'smctemp -c && smctemp -g'
```

### Resource Usage

```bash
# Memory
vm_stat | head -10

# Process list
ps aux | grep ollama

# Disk usage
df -h ~/.ollama
oll model storage
```

### Logs

```bash
# Ollama logs
tail -f ~/.ollama/server.log

# OpenCode logs
tail -f ~/.local/state/opencode/opencode.log

# System log (macOS)
log stream --predicate 'process == "ollama"' --level info
```

---

## Troubleshooting Guide

### Issue: Cannot Connect to Nebulanix

**Symptoms:** `oll status` fails, timeout errors

**Diagnosis:**
```bash
# Try mDNS first
ping nebulanix.local
curl http://nebulanix.local:11434/api/tags

# If mDNS fails, try IP fallback
ping 192.168.1.10
curl http://192.168.1.10:11434/api/tags
```

**Solutions:**
1. Check nebulanix is powered on
2. Verify same network
3. Start ollama on nebulanix: `oll server start`
4. Check firewall: `sudo /usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate`
5. **If IP changed:** Get nebulanix's current IP via router admin or run on nebulanix: `ipconfig getifaddr en0`

---

### Issue: Out of Memory / System Freeze

**Symptoms:** Slow responses, beach ball, freeze

**Diagnosis:**
```
oll status
ps aux --sort=-%mem | head-10
```

**Solutions:**
1. Reduce context: `oll tune balanced --context 16000`
2. Use smaller model: `oll connect qwen3:8b`
3. Close other apps
4. Apply speed preset: `oll tune speed`

---

### Issue: High Temperatures (>80C)

**Symptoms:** Fan noise, throttling, slow responses

**Diagnosis:**
```bash
oll doctor
smctemp -c && smctemp -g
```

**Solutions:**
1. Reduce load: `oll tune speed`
2. Reduce context: `oll tune balanced --context 16000`
3. Use smaller model
4. Ensure ventilation
5. Check for dust (hardware)

---

### Issue: Model Not Found

**Symptoms:** "model not found" error

**Solutions:**
```bash
# List available
oll model list

# Pull the model
oll model pull <model-name>

# Check correct name
oll model list | grep -i <partial-name>
```

---

### Issue: Slow First Response

**Symptoms:** Long delay before first token

**Normal Behavior:** First query loads model into memory (5-15s)

**If Excessive:**
1. Pre-load model: `ollama run <model> --keepalive 1h`
2. Check disk I/O
3. Verify model on fast storage

---

### Issue: Inference Errors

**Symptoms:** JSON parse errors, incomplete responses

**Solutions:**
```bash
# Check server health
oll server health

# Restart server
oll server restart

# Check logs
oll server logs
```

---

### Issue: smctemp Not Found

**Symptoms:** `smctemp: command not found`

**Solution:**
```bash
# Via nix (recommended)
just provision nebulanix

# Or manual
brew tap narugit/tap
brew install smctemp
```

---

## Emergency Procedures

### Complete System Reset

```bash
# Stop everything
oll server stop
pkill -f ollama

# Clear optimization config
rm ~/.config/ollama-optimize/current.env

# Reset to defaults
oll tune balanced --reset

# Start fresh
oll server start
```

### Network Emergency (Switch to Local)

```bash
# Immediately switch to local fallback (recommended)
oll connect --local

# Start local ollama if not running
ollama serve &

# Verify
curl http://localhost:11434/api/tags
```

### Data Recovery

```bash
# Models are stored in
~/.ollama/models/

# Backup before major changes
tar -czf ollama-models-backup.tar.gz ~/.ollama/models/

# Restore
tar -xzf ollama-models-backup.tar.gz -C ~/
```

---

## Maintenance Schedule

### Daily (Automatic)
- Model keepalive management
- Basic health checks

### Weekly (Manual)
- [ ] Review storage usage
- [ ] Update frequently-used models
- [ ] Check thermal trends
- [ ] Review logs for errors

### Monthly (Manual)
- [ ] Purge unused models
- [ ] Update optimization profiles
- [ ] Review and update this document
- [ ] Test rollback procedures

### Quarterly (Manual)
- [ ] Full system audit
- [ ] Update model recommendations based on benchmarks
- [ ] Review network configuration
- [ ] Hardware inspection (thermal paste, dust)

---

## Quick Reference Commands

```
======================================================================
                    COMMAND CHEAT SHEET
======================================================================
QUICK STATUS
  oll status              Quick status check
  oll doctor              Full diagnostics
  doll                    TUI Dashboard

SERVER
  oll server start        Start server
  oll server stop         Stop server
  oll server status       Server details
  oll server health       Health check
  oll server logs         View logs
  oll server restart      Restart server

MODELS
  oll model list          List models
  oll model pull <name>   Pull model
  oll model rm <name>     Remove model
  oll model storage       Storage usage
  oll model recommend     Model recommendations

TUNING
  oll tune speed          Optimize for speed
  oll tune balanced       Balanced settings
  oll tune power          Max performance
  oll tune research       Long context

CONNECT
  oll connect             Interactive switch
  oll connect <model>     Switch to model
  oll connect --local     Force local
  oll connect --remote    Force remote

PROFILES
  oll profile show        Show current profile
  oll profile list        List profiles
  oll profile set <name>  Set profile

OPENCODE
  opz                     Launch OpenCode
  opz -s                  Show status
  opz -l                  List profiles
======================================================================
```

---

## Contact & Escalation

*Simon says: "When in doubt, check the logs."*

1. **Self-Service:** This document + `OLLAMA_OPTIMIZATION.md`
2. **Diagnostic:** Run `oll doctor`
3. **Reset:** Follow Emergency Procedures above
4. **Fallback:** Switch to local model, continue work, investigate later

---

## Changelog

| Date | Change | Author |
|------|--------|--------|
| 2026-02-21 | Update all commands to new oll/opz/doll structure | Prismo |
| 2026-02-18 | Replace `192.168.1.10` with `nebulanix.local`, add dynamic IP notes | Fern |
| 2026-02-17 | Add mise x opencode@latest for restart | Simon + Fern |
| 2026-02-17 | Initial operations guide | Simon + Fern |

---

*See also: PLAN_OLLAMA_LOCAL_SWITCH.md for switch playbook*
*See also: OLLAMA_OPTIMIZATION.md for technical details*
*See also: scripts/README.md for script documentation*
