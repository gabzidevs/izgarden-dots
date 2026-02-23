# BATCH 04 CHRONICLE: SSH Delegation & Chaos Edge Cases

**Date:** 2026-02-23
**Actors:** The Lich + GOLB
**Theme:** Chaos Edge Cases - Remote AI Healing

---

## Summary

Batch 4 conquered the chaos edge cases of healing - what happens when the local machine lacks AI capabilities? The answer: SSH delegation to nebulanix, the 48GB M4 Pro server with full Ollama power.

---

## Tasks Completed

| Task | Description | Actor | Result |
|------|-------------|-------|--------|
| 4.1 | Add `detect_heal_model()` | Direct Edit (Lich-style) | ✓ Detects local/remote AI model priority |
| 4.2 | Add `ssh_ai_escalation()` | Direct Edit (GOLB-inspired) | ✓ Delegates AI healing via SSH to nebulanix |

---

## Key Features Added

### `detect_heal_model()` - Model Detection

Priority order for finding an available AI model:

1. **User override** (`--heal-model` flag) - explicit user choice
2. **Local Ollama** (`localhost:11434`) - check local first
3. **Remote Ollama** (`nebulanix.local:11434`) - fallback to server
4. **Empty result** → triggers SSH delegation to nebulanix

```bash
detect_heal_model() {
    # Returns model URL or empty string
    # Empty = no local AI available, escalate to SSH
}
```

### `ssh_ai_escalation()` - Remote AI Healing

Full SSH workflow for delegating AI-assisted healing:

1. **Verify not on nebulanix** - skip if already there
2. **Check SSH access** - confirm connectivity
3. **Pull current branch** - sync state
4. **Run AI healing on remote** - leverage nebulanix's Ollama
5. **Commit and push changes** - preserve healing results
6. **Pull changes back to local** - complete the cycle

```bash
ssh_ai_escalation() {
    # Orchestrates remote AI healing
    # Returns success/failure of remote healing
}
```

---

## Code Impact

- **Lines Changed:** +144 lines
- **File Size:** 1393 → 1537 lines
- **File:** `scripts/oll_core/lib/heal.sh`

---

## Architecture Notes

### Machine Roles

| Machine | RAM | Role | AI Capability |
|---------|-----|------|---------------|
| nebulanix | 48GB M4 Pro | Ollama Server | Full local models |
| spacehound | 18GB M3 | Client | Fallback to remote |

### Healing Escalation Path

```
Local Healing Attempt
    ↓ (fails/no AI)
detect_heal_model()
    ↓ (returns empty)
ssh_ai_escalation()
    ↓
SSH to nebulanix
    ↓
AI healing on server
    ↓
Commit & push
    ↓
Pull back to local
```

---

## Lemongrab Verdict

> "ACCEPTABLE! SSH delegation is ready!"

The chaos edge cases are now handled. When a lesser machine needs AI healing but lacks local models, the power of nebulanix is summoned through SSH.

---

## Next Steps

Batch 5 will focus on:
- Integration testing of SSH delegation
- Error handling for network failures
- Healing progress tracking across machines

---

*Chronicle Entry #4 - The Lich & GOLB Strike*
