# Chapter 3: The Nebulanix Stack

*"Everything stays, right where you left it..."*

— Marceline, on why local-first AI just works

---

## The Foundation

Before you can wield AI agents effectively, you need to understand your tool belt. Just like how Marceline's bass guitar has evolved over a thousand years, your Nebulanix setup has been carefully tuned for maximum power.

This chapter covers the stack that makes local AI agents possible.

---

## The Hardware: M4 Pro (48GB)

*"In my time, we didn't have this much memory..."*

Actually, let's not go there. Here's what matters:

### Why 48GB Matters

| RAM | What You Can Run |
|-----|------------------|
| 8GB | Lightweight models (1-3B parameters) |
| 16GB | Medium models (7-8B), basic coding |
| 32GB | Good models (14B), some multi-tasking |
| **48GB** | **Premium models (30B+), multiple loaded** |

The M4 Pro's unified memory architecture means the GPU and CPU share the same memory. No more moving data between VRAM and RAM. Everything stays in one place.

### The Spacehound Fallback

Your other machine, spacehound (18GB M3), can't run the big models. But that's okay:

- **Always available:** gemma3:1b, llama3.2:1b (~1GB each)
- **On demand:** llama3.2:3b (~3GB)
- **Auto-fallback:** When nebulanix is unreachable

*"Sometimes you gotta work with what you got. That's what I've learned in a thousand years."* — Marceline

---

## The Software Stack

```
┌─────────────────────────────────────────────┐
│              OpenCode (You)                  │
│         "Mathematical!" - Finn              │
├─────────────────────────────────────────────┤
│           Crush (Augmentation)               │
│      LSP integration, exploration            │
├─────────────────────────────────────────────┤
│         Ollama (Local LLM Server)            │
│        Models: qwen3, deepseek, etc         │
├─────────────────────────────────────────────┤
│       Nebulanix (macOS Sequoia)              │
│         48GB M4 Pro, optimized               │
└─────────────────────────────────────────────┘
```

### Layer 1: Ollama

Ollama is the engine that runs local LLMs. Think of it as a web server, but instead of serving websites, it serves AI responses.

```bash
# The essential commands
ollama serve          # Start the server
ollama pull <model>  # Download a model
ollama list          # See what you have
ollama run <model>   # Chat with a model
```

**Why Ollama?**
- Runs locally (privacy!)
- Open source
- Mac-native (Apple Silicon optimized)
- Simple API for integration

### Layer 2: OpenCode

OpenCode is your primary agent. It:
- Connects to Ollama via API
- Uses tools (read, edit, bash, grep, etc.)
- Plans and executes multi-step tasks
- Asks before doing risky things

### Layer 3: Crush (Optional)

Crush is Charmbracelet's TUI assistant. Use it for:
- Interactive exploration
- Multi-file refactoring
- Architecture discussions

*"Both tools, different vibes."*

---

## The Model Library

Based on benchmarks and your use case:

### Essential Set (Nebulanix)

| Model | Size | Best For |
|-------|------|----------|
| **qwen3:8b** | ~5GB | Daily driver, balanced |
| **qwen3-coder:30b** | ~19GB | Coding tasks |
| **deepseek-r1:8b** | ~5GB | Reasoning |
| **gemma3:4b** | ~3GB | Fast + vision |

### Fallback Set (Spacehound)

| Model | Size | Use |
|-------|------|-----|
| gemma3:1b | ~1GB | Ultra-fast |
| llama3.2:1b | ~1GB | Lightweight |
| llama3.2:3b | ~3GB | General |

---

## The Network

```
┌──────────────┐          ┌──────────────┐
│  Spacehound  │────HTTP──│   Nebulanix  │
│   (Client)   │  :11434  │   (Server)   │
└──────────────┘          └──────────────┘
      │                          │
      │ Local fallback           │ Ollama
      │ (when offline)          │ API
      ▼                          ▼
┌──────────────┐          ┌──────────────┐
│ Local Ollama │          │  Remote API  │
└──────────────┘          └──────────────┘
```

The setup is designed for resilience:
- Nebulanix always available? → Use remote
- Working offline? → Switch to local
- Need thermal relief? → Use smaller models

---

## System Optimizations

### VRAM Override

macOS limits GPU memory to 75% of unified memory by default. For 48GB systems, that's ~36GB.

**The fix:**
```bash
sudo sysctl iogpu.wired_limit_mb=45000
```

This allows Ollama to use ~45GB, enabling larger models.

### Thermal Monitoring

Using `smctemp` to watch temperatures:
- Warning: 80°C
- Throttle: 90°C
- Emergency: 95°C

If things get too hot, the system auto-adjusts:
- Reduce context length
- Reduce parallel requests
- Switch to lighter models

*"The night is dark and full of thermal throttling..."* — Starchy (paraphrased)

---

## Configuration Files

### opencode.json

```json
{
  "model": "ollama/qwen3:8b",
  "provider": {
    "ollama": {
      "options": {
        "baseURL": "http://192.168.1.10:11434/v1"
      }
    }
  }
}
```

### ollama-optimize presets

| Preset | Context | KV Cache | Use Case |
|--------|---------|----------|----------|
| Speed | 4k | Q4_0 | Quick queries |
| Balanced | 16k | Q8_0 | Daily work |
| Power | 32k+ | Q8_0 | Complex tasks |

---

## What Stays, What Changes

The beauty of this stack is stability:

**Stays (unless you change it):**
- Hardware configuration
- Ollama server setup
- Model library
- Network topology

**Changes (daily):**
- Active model selection
- Context length
- Temperature/top-k settings
- Prompt strategies

*"That's the thing about foundations. You build them once, then you can focus on what matters."* — Marceline

---

## Next Steps

Now that you understand the stack:

1. **Part 2** will dive deeper into OpenCode's architecture
2. **Part 4** covers prompt engineering
3. **Part 5** has the model selection guide

*"The stack is built. Now learn to play it."*

---

*Previous: [Chapter 2: LLM Basics](02-llm-basics.md)*  
*Next: [Part 2: OpenCode Deep Dive - Architecture](../part2-opencode-deep-dive/architecture.md)*
