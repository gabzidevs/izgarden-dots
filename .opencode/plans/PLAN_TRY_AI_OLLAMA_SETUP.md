# Plan: try-ai Stack - Ollama Setup

> Established: 2026-02-22
> Ecosystem: oll, opz, doll tools for Trying AI

---

## Overview

This plan establishes the **try-ai ecosystem** with optimal Ollama parameters, model catalog, and dual-mode fallback capability for nebula (M4 MBP, 38GB RAM).

---

## 1. Parameter Tuning

### Gap Analysis

| Parameter              | Current      | Recommended | Action                 |
| ---------------------- | ------------ | ----------- | ---------------------- |
| `OLLAMA_FLASH_ATTENTION` | 1 (varies)   | 1 (fixed)   | ✅ Already correct     |
| `OLLAMA_NUM_PARALLEL`    | varies (1-8) | 1           | Update presets         |
| `OLLAMA_KEEP_ALIVE`      | **NOT SET**  | 30m         | **Add to server start** |
| Per-model `num_ctx`     | **NOT SET**  | 65536       | **Add to opencode config** |

### Implementation

1. **Server start** (`oll_core/commands/server/start.sh`): Add `OLLAMA_KEEP_ALIVE=30m`
2. **Tune presets** (`oll_core/commands/tune.sh`): Set `OLLAMA_NUM_PARALLEL=1` consistently
3. **Documentation**: Update `OLLAMA_OPTIMIZATION.md`

---

## 2. Model Catalog (nebula)

### Tag System

| Tag      | Source                  | Description                          |
| -------- | ----------------------- | ------------------------------------ |
| `ours`     | Current list            | Already validated                    |
| `claude's` | Claude's recommendation | High-performance picks               |
| `near-zen` | Zen cloud analogs       | Local equivalents to free Zen models |

### Complete Model Stack

| Intent    | Model                             | RAM   | Tag      | Benchmark          |
| --------- | --------------------------------- | ----- | -------- | ------------------ |
| Coding    | `qwen2.5-coder:32b-instruct-q4_K_M` | ~20GB | claude's | Claude-recommended |
| Agentic   | `devstral` (small 2)                | ~14GB | claude's | 68% SWE-bench      |
| Reasoning | `qwen3:32b-q4_K_M`                  | ~20GB | claude's | DeepSeek rival     |
| Fast/MoE  | `qwen3:30b-a3b-q4_K_M`              | ~18GB | claude's | 10x faster         |
| near-zen  | `gpt-oss:20b`                       | ~16GB | near-zen | OpenAI open-weight |
| near-zen  | `glm4`                              | ~6GB  | near-zen | GLM-4.7 base       |
| Fallback  | `llama3.2:1b`                       | ~2GB  | ours     | Emergency          |

### Intent Usage Guide

| Intent    | When to Use                                    |
| --------- | ---------------------------------------------- |
| Coding    | Daily coding, file edits, bug fixes            |
| Agentic   | Complex multi-file refactors, deep exploration |
| Reasoning | Research, analysis, chain-of-thought tasks      |
| Fast/MoE  | Quick tasks, speed over depth                  |
| near-zen  | Testing OpenCode-optimized models locally      |
| Fallback  | RAM tight or other models fail                 |

### Pull Groups

```bash
# claude's picks
ollama pull qwen2.5-coder:32b-instruct-q4_K_M
ollama pull devstral
ollama pull qwen3:32b-q4_K_M
ollama pull qwen3:30b-a3b-q4_K_M

# near-zen picks
ollama pull gpt-oss:20b
ollama pull glm4

# ours
ollama pull llama3.2:1b
```

---

## 3. Dual Mode Fallback

### Research Findings

| Mode          | Status           | Implementation                       |
| ------------- | ---------------- | ------------------------------------ |
| Local → Cloud | ✅ Works         | OpenCode provider fallback           |
| Local → Local | ⚠️ Plugin needed | `@azumag/opencode-rate-limit-fallback` |
| Native        | 🔄 In progress   | OpenCode issue #7602                 |

### Plugin Setup

1. **Install**: Add `"@azumag/opencode-rate-limit-fallback"` to plugins
2. **Config**: Create `rate-limit-fallback.json`:
```json
{
  "fallbacks": [
    "ollama/qwen2.5-coder:32b-instruct-q4_K_M",
    "ollama/devstral",
    "ollama/gpt-oss:20b",
    "ollama/llama3.2:1b"
  ]
}
```

---

## 4. Implementation Phases

### Phase 1: Server Environment (HIGH PRIORITY)
- [ ] Add `OLLAMA_KEEP_ALIVE=30m` to server start
- [ ] Update tune presets: set `OLLAMA_NUM_PARALLEL=1`
- [ ] Update `OLLAMA_OPTIMIZATION.md`

### Phase 2: OpenCode Module Extension (HIGH PRIORITY)
- [ ] Add `models` option with per-model config (name, tools, reasoning, num_ctx)
- [ ] Generate model-specific options in runtime.json
- [ ] Support fallback models via plugin

### Phase 3: Model Catalog (MEDIUM PRIORITY)
- [ ] Add models to `systems/nebulanix/users.nix`
- [ ] Tag models with source (ours/claude's/near-zen)
- [ ] Add context window (65536) to all agentic models

### Phase 4: oll model Enhancement (MEDIUM PRIORITY)
- [ ] Add intent-based pulls:
  - `oll model pull claude's` - pulls claude's picks
  - `oll model pull near-zen` - pulls gpt-oss + glm4
  - `oll model pull reasoning` - pulls qwen3 variants
- [ ] Add `--fallback` flag to `oll connect`

### Phase 5: Plugin Integration (MEDIUM PRIORITY)
- [ ] Add `@azumag/opencode-rate-limit-fallback` to nebula plugins
- [ ] Create fallback config file
- [ ] Document dual local setup in `PLAN_OLLAMA_LOCAL_SWITCH.md`

---

## 5. Open Questions

1. **Spacehound**: Reduced model set (near-zen + fallback only)?
2. **Zen API key**: Set up for cloud fallback?

---

## Changelog

| Date       | Change                          | Author |
| ---------- | ------------------------------ | ------ |
| 2026-02-22 | Initial plan creation          | Prismo |
