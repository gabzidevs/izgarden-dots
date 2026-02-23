# Plan: Ollama Local Switch Playbook

> A reusable checklist for switching OpenCode to use local Ollama server

---

## Quick Restart (5 Steps)

```
1. PRE-FLIGHT:    oll status
2. RESOURCES:    oll doctor  (check: RAM >20GB, temps <80°C)
3. SERVER:        oll server start && oll tune balanced
4. CONNECT:       oll connect qwen3:8b
5. RESTART:       [CONFIRM] -> clipboard: opz
```

**TUI Alternative (Interactive):**
```bash
# Interactive model selection with gum
oll connect
opz
```

**Phase 6 requires user confirmation** -> Show actions, wait for "ready", copy to clipboard.

---

## What's Automated by oll connect

| Component        | Automation Level | Command                        |
| ---------------- | ---------------- | ------------------------------ |
| Machine detection| Full             | Auto-detected via hostname     |
| Connection check | Full             | `oll status`                   |
| Model selection  | Full             | `oll connect qwen3:8b`         |
| Config generation| Full             | Auto-generates runtime.json    |
| Fallback to local| Full (TUI)       | Shows gum prompts if unreachable |

**What it sets:**
- `CURRENT_MACHINE` - "nebulanix" | "spacehound" | "unknown"
- `OLLAMA_HOST` - Current server endpoint
- `OPENCODE_MODEL` - Active model name

---

## Manual Steps (Still Required)

| Step             | Why Manual           | Command                  |
| ---------------- | -------------------- | ------------------------ |
| Resource check   | Human judgment       | `oll doctor`             |
| Server start     | Safety confirmation  | `oll server start`       |
| Optimization     | Task-dependent       | `oll tune <preset>`      |
| Thermal monitor  | Safety               | `oll doctor`             |

---

## Quick Mode (Trust the Script)

For days when you just want to work:

```bash
oll connect                       # Auto-selects best option
opz                               # Launch OpenCode with profile
```

---

## Extended Options

### Custom Host
```bash
oll connect --host 192.168.1.100:11434 qwen3:8b
oll connect --host server.example.com:11434
```

### SSH Session Support
When SSH'd into another machine:
- Auto-detects target from `SSH_CONNECTION`
- Shows warning: "SSH session detected - use --local or --host to override"
- Override with explicit flags: `--local`, `--remote`, `--host`

### Full Command Reference

| Command | Description |
|---------|-------------|
| `oll connect` | Auto-connect with fallback |
| `oll connect qwen3:8b` | Use specific model |
| `oll connect --local` | Force localhost |
| `oll connect --remote` | Force nebulanix |
| `oll connect --host <url>` | Custom server |
| `oll status` | Quick status check |
| `oll server health` | Server health check |

---

## Quick Reference

| Role | Action |
|------|--------|
| **Simon** | Server health, resource monitoring, optimization |
| **Fern** | Client configuration, connection testing, rollback |
| **Prismo** | Coordinates the full workflow |

---

## Phase 1: Standby Protocol

> USER CLARIFICATION (2026-02-17): Do NOT auto-commit. Present dashboard first, let user decide.

### 1.1 Time Room Dashboard

```bash
doll    # Or run the dashboard manually:
echo "TIME ROOM DASHBOARD"
echo "UNCOMMITTED CHANGES:"
git status --short 2>/dev/null || echo "  (clean)"
```

### 1.2 User Decision

- [ ] User reviews dashboard above
- [ ] Proceed with activation OR request commit/push first

---

## Phase 2: Resource Assessment

### 2.1 Check Resources (nebulanix)

```bash
oll doctor
df -h ~/.ollama
ollama ps
```

### 2.2 Thresholds

| Metric | Green | Yellow | Red |
|--------|-------|--------|-----|
| Free RAM | >20GB | 10-20GB | <10GB |
| CPU Temp | <70C | 70-80C | >80C |
| Disk Free | >50GB | 20-50GB | <20GB |

- [ ] All GREEN or YELLOW -> proceed
- [ ] Any RED -> Phase 8 (Optimization)

---

## Phase 3: Model Selection

> USER CLARIFICATION (2026-02-17): Always ensure LOW-END fallback available.

### 3.1 Fallback Model (REQUIRED)

```bash
ollama list | grep -E 'llama3.2:1b|gemma3:1b|tinyllama' || ollama pull llama3.2:1b
```

### 3.2 Model Priority (Updated: Feb 2026)

| Priority | Model | Size | RAM | Pull If |
|----------|-------|------|-----|---------|
| 1 (REQ) | `llama3.2:1b` | ~1.2GB | 2GB | ALWAYS - fallback |
| 2 | `gemma3:4b` | ~3GB | 6GB | >10GB free |
| 3 | `qwen3:8b` | ~5GB | 10GB | >20GB free |
| 4 | `qwen3:14b` | ~9GB | 16GB | >30GB free |
| 5 | `deepseek-r1:14b` | ~9GB | 16GB | >30GB free |
| 6 | `llama3.3:70b` | ~40GB | 48GB | >60GB free |
| 7 | `qwen3-coder:30b` | ~18GB | 24GB | >40GB free |

### 3.3 Recommended Combinations

| Use Case | Primary | Fallback |
|----------|---------|----------|
| General | `qwen3:8b` | `llama3.2:1b` |
| Coding | `qwen3-coder:30b` | `qwen3:8b` |
| Vision | `llama3.2:3b` | `gemma3:4b` |
| Reasoning | `deepseek-r1:14b` | `qwen3:14b` |
| Speed | `llama3.2:1b` | (none needed) |

- [ ] Fallback verified: `llama3.2:1b`
- [ ] Model selected: `______________`

---

## Phase 4: Server Activation

```bash
oll server start
# Or: oll server start --model qwen3:8b
oll server status
oll tune balanced
```

- [ ] Server running on `0.0.0.0:11434`

---

## Phase 5: Connection Verification

```bash
oll status
curl http://nebulanix.local:11434/api/tags || curl http://192.168.1.10:11434/api/tags
```

> DYNAMIC IP: If `nebulanix.local` fails, fallback to `192.168.1.10`

- [ ] Connection successful
- [ ] Model accessible

---

## Phase 6: OpenCode Reconnection (Migration)

> USER CLARIFICATION (2026-02-17): FULL RESTART required.

### 6.1 User Confirmation (REQUIRED)

```bash
# 1. Present summary of actions
# 2. Wait for user "ready", "go", or "confirmed"
# 3. On confirmation:
echo "opz" | pbcopy
# 4. Tell user: "Command copied! Paste and run."
```

### 6.2 Switch & Restart

```bash
oll connect qwen3:8b
# Then run manually: opz
```

- [ ] OpenCode restarts with local LLM

---

## Phase 7: Monitoring

### 7.1 Status Handoff

```bash
# Before restart, write status:
cat > ~/.local/state/opencode/server-status.json << 'EOF'
{
  "timestamp": "$(date -Iseconds)",
  "model": "qwen3:8b",
  "server": "nebulanix.local:11434",
  "status": "restarted"
}
EOF
```

### 7.2 Thermal Limits

| Temp | Action |
|------|--------|
| <80C | Normal |
| 80-90C | Warning |
| >90C | Throttle |

---

## Phase 8: Optimization (If Needed)

```bash
# Aggressive optimization
oll tune speed

# Or reduce context
oll tune speed  # Uses --context 16000 --parallel 1 internally
```

---

## Phase 9: Rollback

```bash
# Switch to local fallback
oll connect --local

# Or different model
oll connect llama3.2:1b
```

---

## One-Liners

```
Activate:     oll server start && oll connect qwen3:8b && opz
Health:       oll status && oll doctor
Fallback:     oll connect --local
Stop:         oll server stop
```

---

## OpenCode Commands

Use these commands in OpenCode for automated workflows:

| Command | Purpose | Feature |
| -------- | ------- | -------- |
| `oll connect` | Interactive model switch | TUI |
| `oll status` | Quick health check | Simple |
| `oll tune <preset>` | Optimize based on resources | Presets |
| `oll server health` | Test connection to server | Simple |
| `oll model recommend` | Recommend best model for task | Conditional |

### Usage Examples

```bash
# Full switch with model selection
oll connect qwen3:8b

# Quick status check
oll status

# Emergency fallback
oll connect --local

# Optimize for speed
oll tune speed

# Get model recommendation
oll model recommend
```

---

## Automated TUI Workflow

### Full Automation Script
```bash
#!/usr/bin/env bash
# oll connect - Interactive local LLM switcher (built into oll)

set -e

gum style --foreground 212 "Ollama Local Switch"

# Phase 1: Check status
gum spin --title "Checking Ollama status..." -- oll server status

# Phase 2: Resource check
oll doctor

# Phase 3: Model selection
MODEL=$(gum choose --header="Select model for today" \
    "llama3.2:1b (fallback)" \
    "gemma3:4b (fast+vision)" \
    "qwen3:8b (coding)" \
    "deepseek-r1:8b (reasoning)" \
    "qwen3-coder:30b (complex)" \
)

MODEL_NAME=$(echo "$MODEL" | awk '{print $1}')

# Phase 4: Start server
gum spin --title "Starting Ollama..." -- oll server start
gum spin --title "Optimizing..." -- oll tune balanced

# Phase 5: Switch
oll connect "$MODEL_NAME"

# Phase 6: Confirm restart
gum confirm "Switch to $MODEL_NAME? (Copying restart command...)" && \
    echo "opz" | pbcopy && \
    gum style --foreground 212 "Copied! Paste in terminal to restart."
```

### Quick Actions Menu
```bash
# Built into oll with subcommands:
ACTION=$(gum choose --header="Ollama Actions" \
    "start" "stop" "status" "tune" "connect" "health" "doctor")

case "$ACTION" in
    start)      oll server start ;;
    stop)       oll server stop ;;
    status)     oll server status ;;
    tune)       oll tune balanced ;;
    connect)    oll connect ;;
    health)     oll server health ;;
    doctor)     oll doctor ;;
esac
```

---

## Changelog

| Date | Change | Author |
|------|--------|--------|
| 2026-02-21 | Update all commands to use new oll/opz/doll scripts | Prismo |
| 2026-02-21 | Add subtask2 commands section | Prismo |
| 2026-02-21 | Update model list with Feb 2026 models | Prismo |
| 2026-02-19 | Add TUI automation scripts | Jake |
| 2026-02-19 | Streamlined playbook - consolidated phases, removed redundancy | Prismo |
| 2026-02-18 | Phase 6: Add confirmation workflow | Prismo |
| 2026-02-18 | Add Quick Restart Summary | Fern |
