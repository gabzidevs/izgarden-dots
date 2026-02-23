# Session Archive: Ollama Tooled Models Deployment

**Date:** 2026-02-22  
**Checkpoint:** `ollama-tooled-models-complete`  
**Thread:** `ollama-optimization:tooled-models-deployed`  
**Status:** ✅ Complete

---

## Overview

This session focused on deploying and testing **tooled models** optimized for OpenCode tool calling with character-based personas from Adventure Time.

---

## 4-Tier Character System

A 4-tier character system was developed with temperature mappings for different use cases:

| Tier | Character | Temperature | Use Case |
|------|-----------|-------------|----------|
| **Tier 1** | The Lich | 0.01 | Ultra precision, security audits, production code review |
| **Tier 2** | Princess Bubblegum | 0.1 | Daily development, production tool calling (CURRENT) |
| **Tier 3** | Manticore | 0.1 | Conservative balance, architectural decisions |
| **Tier 4** | GOLB | 0.7 | Creative chaos, brainstorming |

### Temperature Behavior Discovery

**Key Finding:** Temperature affects response length significantly:
- Lower temperatures (0.01-0.1): Shorter, more focused responses
- Higher temperatures (0.5-0.7): Longer, more verbose responses

This is useful for:
- Quick tasks → Use lower temperature (faster, concise)
- Research/exploration → Use higher temperature (thorough, creative)

---

## Technical Constraints

### Mirostat Configuration
- **mirostat: 2** - Best for consistent outputs
- **mirostat_tau:** Target perplexity (lower = more focused)
- **mirostat_eta:** Learning rate (lower = more stable)

### ChatML Template Required
All tooled models use ChatML format:
```modelfile
TEMPLATE """<|im_start|>system
{{ .System }}<|im_end|>
<|im_start|>user
{{ .Prompt }}<|im_end|>
<|im_start|>assistant
"""
```

### Inline Comments Issue
⚠️ **Critical:** Some qwen2.5 models fail with inline comments in system prompt. Use concise, comment-free prompts.

---

## Dual-Layer Config Architecture

### Layer 1: Nix (Immutable Defaults)
- Sets baseline OLLAMA_* environment variables
- Applied at system level via nix-darwin

### Layer 2: CLI (Runtime Overrides)
- Per-model Modelfiles
- Can override any Nix setting at runtime
- Stored in `ollama-templates/`

---

## Hardware Context

### Nebulanix (Primary Ollama Server)
- **Specs:** 48GB M4 Pro, 512GB SSD
- **Role:** Ollama server + primary development
- **IP:** 192.168.1.10
- **Optimal Models:** qwen2.5-coder:32b (19GB), qwen3-coder:30b (18GB)

### Spacehound (Portable Client)
- **Specs:** 18GB M3, 256GB SSD
- **Role:** Portable client with local fallback
- **IP:** 192.168.1.40
- **Optimal Models:** qwen2.5-coder:7b (4.4GB), qwen2.5:3b (1.9GB)

---

## Files Modified/Created

### Modelfiles (ollama-templates/)
| File | Purpose |
|------|---------|
| `qwen2.5-coder-tooled.Modelfile` | Primary tooled model for OpenCode |
| `qwen3-tooled.Modelfile` | Tool calling variant |
| `qwen3-moe-tooled.Modelfile` | MoE architecture variant |
| `examples/tier1-ultra-lich.Modelfile` | Tier 1: Ultra precision |
| `examples/tier2-production-pb.Modelfile` | Tier 2: Production (current) |
| `examples/tier3-conservative-manticore.Modelfile` | Tier 3: Balanced |
| `examples/tier4-turbo-golb.Modelfile` | Tier 4: Creative chaos |

### Documentation
| File | Purpose |
|------|---------|
| `.opencode/time-room/docs/CLAUDE_BOX.md` | Character variants catalog |
| `.opencode/time-room/docs/MODEL_RECOMMENDATIONS.md` | Hardware-specific model recommendations |
| `.opencode/docs/scripts/OLLAMA_OPTIMIZATION.md` | Complete optimization docs |

---

## Testing Instructions

### Quick Test (Verify Tooled Model)
```bash
# Test character voice
ollama run qwen2.5-coder-tooled "Hello, how are you today?"

# Test tool calling (via OpenCode)
# Set model in opencode.json:
{
  "model": "ollama/qwen2.5-coder-tooled",
  "provider": {
    "ollama": {
      "options": {
        "baseURL": "http://192.168.1.10:11434/v1",
        "temperature": 0.1
      }
    }
  }
}
```

### Full Test (OpenCode Integration)
1. Deploy to nebulanix: `just provision nebulanix`
2. Test remote: `oll connect nebulanix:11434/qwen2.5-coder-tooled`
3. Verify character voice in responses
4. Test actual tool calls in OpenCode

---

## Key Discoveries Summary

1. **Temperature → Response Length:** Lower temp = shorter responses
2. **ChatML Required:** Must use `<|im_start|>` template format
3. **Inline Comments Break qwen2.5:** Avoid comments in system prompts
4. **mirostat=2 for Consistency:** Best for tool calling accuracy
5. **Character Personas Work:** Tier 2 (PB) confirmed working

---

## Next Steps

- [ ] Full OpenCode integration test with tool calling
- [ ] Measure tool recognition rate vs base model
- [ ] Document benchmark results
- [ ] Consider adding more character variants

---

*Archived by Prismo - The Wish Master* 🌀✨  
*Session: 2026-02-22*
