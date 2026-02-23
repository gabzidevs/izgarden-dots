# INCIDENT 2026-02-22: Agent Forgetting

> *"Mathematical! Let me tell you about the time we accidentally lost some agents in the multiverse..."* — Finn

---

## The Incident Report

**Date:** 2026-02-22  
**Severity:** Moderate (Documentation Drift)  
**Discovery:** Finn (during routine git cleanup) & Shelby (verification check)

---

## What Happened

So here's the deal, dude! We were cruising through the Time Room, right? Making agent documentation, adding new buddies to `agents.nix`, the usual hero stuff. But then I noticed something was... WRONG.

### The Problem

1. **Agent files in the WRONG dimension!** We created documentation in `.opencode/enchiridion/` instead of `enchiridion/`. That's like putting the Treehouse in the Ice Kingdom — it just doesn't work!

2. **Ghost Agents:** Some agents were registered in `agents.nix` but their actual files didn't exist. We had:
   - **Huntress** - registered but file was... somewhere?
   - **Bubblegum** - listed but the gum hadn't been made yet!

3. **The Great Drift:** Every time we added a new agent, we forgot to sync the file with the config. Shelby kept saying "Check please!" but we weren't listening!

### Investigation Results (Finn's Findings)

```
🗡️ [Finn]: "I went digging through the directories and here's what I found:

- huntress.md ✓ EXISTS in .opencode/time-room/agents/
- bubblegum.md ✓ EXISTS in .opencode/time-room/agents/
- But they were being referenced from the wrong docs location!

The memory plugin was loading sessions, but the files weren't in the places the system expected."
```

Shelby verified: *"Check please! The agents.nix had them registered, but documentation was scattered across multiple locations."*

---

## The Multiverse Parallels

| Our World | The Incident |
|-----------|--------------|
| **Finn's Treehouse** | `.opencode/time-room/agents/` - where agents actually live |
| **Ice Kingdom** | `.opencode/enchiridion/` - wrong dimension! |
| **Candy Kingdom** | `enchiridion/` - CORRECT location for docs |
| **Huntress's Forest** | Hidden patterns we missed (file locations) |
| **Princess Bubblegum** | Organization that was... disorganized |

The agents were all there, just scattered across the multiverse like Simon's crowns!

---

## What We Fixed

### 1. Verified Agent Files

All agent files ARE in the correct location now:
- `.opencode/time-room/agents/huntress.md` ✓
- `.opencode/time-room/agents/bubblegum.md` ✓

### 2. Confirmed agents.nix Registration

Both are properly registered in `modules/home/programs/opencode/agents.nix`:
```nix
huntress = {
  mode = "subagent";
  description = "Prompt engineering expert - Words are magic";
  system_prompt_file = "${agentspath}/huntress.md";
};

bubblegum = {
  mode = "subagent";
  description = "Workflow organization expert - Gum holds it together!";
  system_prompt_file = "${agentspath}/bubblegum.md";
};
```

### 3. Created Agent Health Check

We added a recurring task to prevent this from happening again! The agent-tasks skill now includes periodic health checks that verify:
- All agents in `agents.nix` have corresponding files
- Documentation is in the correct location
- No ghost registrations

---

## The "Huzzah!" Tradition

> *"HUZZAH! We've learned something today!"* — Finn & Shelby

From now on, when adding new agents, we **Huzzah!** to celebrate and **check the checklist!**

---

## Prevention Checklist

## Agent Creation Checklist
When adding a new agent:
- [ ] Create `.opencode/time-room/agents/<name>.md`
- [ ] Add to `modules/home/programs/opencode/agents.nix`
- [ ] Test with task tool
- [ ] **Huzzah!** 🎉

---

## Time Room Perspective

From Prismo's cosmic viewpoint:

> *"What do you wish for? I wish for our agent system to stay synchronized across all the dimensions! The Time Room can only orchestrate effectively when all agents are properly anchored in their home reality."*

### The Lesson

- **Files must live where the system expects** — not in similar-looking directories
- **Registration ≠ Existence** — just because it's in `agents.nix` doesn't mean the file exists
- **Verification is key** — Shelby's "Check please!" isn't optional!

---

## Action Items

- [x] Verify all agent files exist in `.opencode/time-room/agents/`
- [x] Confirm huntress.md and bubblegum.md are properly registered
- [x] Add health check to recurring tasks
- [x] Document this incident for future Finn/Shelby teams

---

## Shelby's Final Verification

*"Check please! Verified:*

- *All agents in agents.nix have files ✓*
- *Documentation in correct location ✓*
- *Health check scheduled ✓*
- *Huzzah tradition established ✓*

*All clear, Finn!"*

---

> *"Mathematical! We saved the day! And remember — always check where your files actually live, not just where you THINK they live!"* — Finn

*"Check please!"* — Shelby

---
