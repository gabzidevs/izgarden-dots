# Model Variant Reliability Tracker

> **Purpose:** Determine optimal parameters for local LLM agents in professional settings.
> **Goal:** Document what works, what fails, and why - NOT to make everything work.

---

## Test Results Summary

### Magic Man / Normal Man Variants

| Variant | Size | Temp | Test Task | Result | Root Cause |
|---------|------|------|-----------|--------|------------|
| `qwen2.5-3b-magicman` | 1.9GB | 0.1 | Simple edit (add comment) | ✓ PASS | Single-line replacement |
| `qwen2.5-3b-magicman` | 1.9GB | 0.1 | Complex edit (replace function) | ✗ FAIL | Truncated file to 1 line |
| `qwen2.5-coder-magicman` | 19GB | 0.1 | Via `ollama run` CLI | ✗ FAIL | No real tool access in CLI mode |
| `qwen2.5-coder-magicman` | 19GB | 0.1 | Via `task()` as Normal Man | ⚠ PARTIAL | Called tool but didn't apply edit |

**Key Findings:**
- The `ollama run` CLI doesn't provide tool access even with tool-calling template
- Real tool access requires API/framework integration (like OpenCode's `task()` delegation)
- 32B Normal Man is BETTER than 3B Magic Man (didn't truncate) but still didn't complete the edit
- Both models struggle with complex multi-line FIND/REPLACE operations

### The Lich Variants

| Variant | Size | Temp | Test Task | Result | Root Cause |
|---------|------|------|-----------|--------|------------|
| `qwen2.5-3b-lich` | 1.9GB | 0.01 | Read tool | ✓ PASS | Tool calling works |
| `qwen2.5-3b-lich` | 1.9GB | 0.01 | Grep tool | ✓ PASS | Tool calling works |
| `qwen3-8b-lich` | 5.2GB | 0.01 | Tool calling | ✓ PASS | Tested in earlier session |

### Lemongrab Variants

| Variant | Size | Temp | Test Task | Result | Root Cause |
|---------|------|------|-----------|--------|------------|
| `qwen2.5-3b-lemongrab` | 1.9GB | 0.1 | Grep tool | ✓ PASS | Tool calling works |
| `qwen2.5-3b-lemongrab` | 1.9GB | 0.1 | Bash syntax check | ✓ PASS | Validates correctly |

### GOLB Variants

| Variant | Size | Temp | Test Task | Result | Root Cause |
|---------|------|------|-----------|--------|------------|
| `qwen2.5-3b-golb` | 1.9GB | 0.7 | Read tool | ✓ PASS | Tool calling works |

---

## Original Parameter Design

### Character Parameter Matrix

| Character | Base Model | Temp | top_k | top_p | repeat_penalty | num_ctx | Purpose |
|-----------|------------|------|-------|-------|----------------|---------|---------|
| **The Lich** | qwen2.5:3b / qwen3:8b | **0.01** | **5** | **0.15** | 1.05 | 32768 | Ultra-precision edits |
| **Lemongrab** | qwen2.5:3b | **0.1** | 20 | 0.80 | 1.1 | 32768 | Anxious validation |
| **Lemongrab** | qwen3:8b | **0.05** | 20 | 0.80 | 1.1 | 32768 | Anxious validation (8B) |
| **Magic Man** | qwen2.5:3b / qwen3:8b | **0.1** | **40** | **0.90** | 1.05 | 32768 | Casual complexity |
| **GOLB** | qwen2.5:3b / qwen3:8b | **0.7** | **100** | **0.95** | 1.0 | 32768 | Creative chaos |
| **PB** | qwen2.5:3b / qwen3:8b | **0.05** | 20 | 0.9 | 1.1 | - | Professional work |
| **Peppermint** | qwen2.5:3b / qwen3:8b | **0.05** | 20 | 0.80 | 1.05 | 32768 | Polite menace |
| **Manticore** | qwen2.5:3b / qwen3:8b | **0.1** | 30 | 0.85 | 1.05 | 32768 | Balanced scholar |

### Parameter Philosophy

| Parameter | Lich (Ultra-Precise) | PB/Peppermint (Professional) | Magic Man (Casual) | GOLB (Chaos) |
|-----------|---------------------|------------------------------|-------------------|--------------|
| **temp** | 0.01 (deterministic) | 0.05 (low variance) | 0.1 (some variety) | 0.7 (creative) |
| **top_k** | 5 (very limited) | 20 (focused) | 40 (moderate) | 100 (wide) |
| **top_p** | 0.15 (strict) | 0.80-0.9 (balanced) | 0.90 (relaxed) | 0.95 (permissive) |
| **repeat_penalty** | 1.05 | 1.05-1.1 | 1.05 | 1.0 (no penalty) |

### Parameter-Task Fit

| Parameter Range | Best For | Risk Level |
|-----------------|----------|------------|
| temp 0.01-0.05, top_k 5-20, top_p 0.15-0.80 | Precision edits, validation, production code | Low |
| temp 0.05-0.1, top_k 20-40, top_p 0.80-0.90 | General development, refactoring | Medium |
| temp 0.1-0.3, top_k 40-60, top_p 0.90-0.95 | Creative solutions, brainstorming | Medium-High |
| temp 0.5+, top_k 80+, top_p 0.95+ | Chaos mode, edge case discovery | High (intentional) |

---

## Key Findings

### Critical Discovery: Template vs Parameters

**The tool-calling template was the real fix, NOT parameter tuning.**

| Issue | Root Cause | Solution |
|-------|------------|----------|
| Tools not working | Missing `{{ .Tools }}` section in TEMPLATE | Added tool-calling template |
| Truncation on complex edits | 3B model size limitation | Use larger model OR simpler tasks |

**Verdict:** Parameters were designed correctly. The template fix was essential.

### Size vs Complexity

| Model Size | Simple Edits | Complex Edits | Tool Calling | Recommendation |
|------------|--------------|---------------|--------------|----------------|
| **3B (1.9GB)** | ✓ Works | ✗ Risky | ✓ Works | Simple tasks only |
| **8B (5.2GB)** | ✓ Works | ? Untested | ✓ Works | Medium complexity |
| **32B (19GB)** | ✓ Works | ? Untested | ✓ Works | Complex tasks (theoretically) |

### Temperature Impact

| Temp | Behavior | Best For | Risk |
|------|----------|----------|------|
| **0.01** | Ultra-deterministic | The Lich (precision edits) | Low variation, may miss creative solutions |
| **0.05** | Near-deterministic | PB, Peppermint (professional) | Reliable for production |
| **0.1** | Low randomness | Magic Man, Manticore | Good balance for development |
| **0.7** | High creativity | GOLB (brainstorming) | Unpredictable outputs |

---

## Professional Setting Recommendations

### Safe Bets (High Reliability)

| Task Type | Recommended Model | Why |
|-----------|-------------------|-----|
| Simple FIND/REPLACE | Any 3B variant | Works consistently |
| Validation/grep | `qwen2.5-3b-lemongrab` | Proven in Batch 1 |
| Precision edits | `qwen2.5-3b-lich` (temp 0.01) | Zero-error tolerance works |

### Caution Required

| Task Type | Risk | Mitigation |
|-----------|------|------------|
| Multi-line replacements with 3B | File truncation | Use `git checkout` ready, test on non-critical files |
| Complex refactors with 3B | Incomplete/incorrect edits | Use larger model or direct edit |

### Needs More Testing

| Model | Untested | Priority | Status |
|-------|----------|----------|--------|
| `qwen2.5-coder-magicman` (Normal Man) | ~~Complex multi-line edits via `task()`~~ | ~~HIGH~~ | ⚠ TESTED - Partial success |
| `qwen3-8b-lich` | Complex edits | MEDIUM | - |
| GOLB variants | Any edit task | LOW | Chaos is expected |

**Normal Man Test Result:** Called Edit tool correctly but edit was not applied to file. Better than 3B (no truncation) but still unreliable for complex multi-line edits.

---

## Testing Methodology Findings

### Tool Access Requirements

| Method | Tool Access | Result |
|--------|-------------|--------|
| `ollama run <model>` CLI | ✗ NONE | Model outputs tool-call-like text but can't execute |
| OpenCode `task()` delegation | ✓ FULL | Tools are executed by framework |
| Ollama API with tool bindings | ✓ FULL | Requires framework integration |

**Conclusion:** Testing model tool-calling capability requires API/framework integration. The `ollama run` CLI cannot test actual tool execution.

---

## Lessons Learned

### From Batch 1 (Lich + Lemongrab)
- ✓ 3B models handle single-purpose tasks well
- ✓ Tandem workflow (edit → validate) catches errors
- ✓ Temperature 0.01 is reliable for precision

### From Batch 2 (Magic Man + GOLB)
- ✗ 3B models fail at complex multi-line replacements
- ✓ Simple edits work fine
- ✓ Always have `git checkout` ready for volatile agents
- ⚡ Emergency protocol: restore file, edit directly

### From Post-Batch Fix
- ⚠ **CRITICAL**: `opencode --print` is for logs, NOT headless mode
- ✓ Correct headless usage: `opencode run --model <model> "prompt"`
- ✓ `opz` wrapper only needed for TUI mode (auto-detects profile)
- ✓ Profile is set by Nix via `home.sessionVariables`

### Parameter Insights
- **Temperature 0.1** at 3B size is NOT deterministic enough for complex edits
- **Model size matters more than temperature** for edit complexity
- **Tool-calling template is ESSENTIAL** - without it, no tools work

---

## Next Tests Needed

1. **32B Magic Man complex edit test** - Will the larger model handle multi-line replacements?
2. **8B Lich complex edit test** - Is 8B the sweet spot?
3. **GOLB creative task test** - Does temp 0.7 add value or just chaos?

---

## Conclusion

**For professional settings:**
- Use 3B models for simple, well-defined tasks
- Reserve complex edits for larger models (8B+) or direct editing
- Always validate with a second agent (tandem pattern)
- Model size matters more than temperature for edit complexity

**Reliability Rating:**
- 3B models: ★★★☆☆ (simple tasks only, risky for complex edits)
- 8B models: ★★★★☆ (likely good, needs more testing)
- 32B models: ★★★☆☆ (better than 3B but still unreliable for complex edits)

---

## Pending Verdict

| Question | Status | Notes |
|----------|--------|-------|
| Template fix necessary? | ✓ CONFIRMED | Tool-calling template was essential |
| Parameters correct? | ✓ CONFIRMED | Design philosophy holds |
| 32B better for complex edits? | ⚠ PARTIAL | Normal Man called tool correctly but edit not applied - better than 3B (no truncation) |
| 8B sweet spot? | ⏳ NEEDS TEST | qwen3-8b variants available |
| GOLB useful or just chaos? | ⏳ NEEDS TEST | Creative tasks untested |

**Normal Man (32B) Verdict:** Better than Magic Man (3B) - no file truncation. Tool calling works but complex multi-line FIND/REPLACE still unreliable. Use for single-purpose tasks or validation, not complex refactors.

---

*Last updated: 2026-02-23 after Batch 3 + Normal Man test*
