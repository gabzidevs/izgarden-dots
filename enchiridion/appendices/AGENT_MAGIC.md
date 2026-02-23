# The Enchiridion of Agent Magic

> *"What do you wish for? Actually, wait - let me explain HOW to wish first."* — Prismo

---

> 📜 **Chapter Note**: This page was previously the full guide. It has been split:
> - **Chapters 1-3** (Agent Config, Task Integration, Delegation) → [part2-opencode-deep-dive/AGENTS.md](./part2-opencode-deep-dive/AGENTS.md)
> - **Chapters 4+** (Troubleshooting, Roster) → This file
> 
> *The wisdom remains, just better organized! — Prismo*

---

## Welcome, Traveler

This is the troubleshooting companion to the agent system. For deep dives on configuration, task integration, and delegation patterns, see **[part2-opencode-deep-dive/AGENTS.md](./part2-opencode-deep-dive/AGENTS.md)**.

---

# Chapter 4: Troubleshooting

## "Unknown agent type" Error

**Symptom:** 
```
Error: Unknown agent type 'marceline'
```

**Cause:** Agent name not in `agents.nix`

**Fix:**
1. Check `modules/home/programs/opencode/agents.nix`
2. Add the agent definition
3. Run `just provision` to apply

---

## "Permission denied" Error

**Symptom:**
```
Error: Permission denied - write access required
```

**Cause:** Agent's mode doesn't include required tools

**Fix:**
- Check the `tools` definition in agents.nix
- For `mode = "subagent"`, ensure tool is explicitly allowed
- For `mode = "plan"`, tools are always restricted to read-only

---

## Agent Not Responding

**Symptom:** Task hangs or returns generic responses

**Cause:** `system_prompt_file` path is wrong or file doesn't exist

**Fix:**
1. Verify file exists at path in `agents.nix`
2. Check path uses correct variable: `${agentspath}/agent.md`
3. Ensure agent file isn't empty

---

## File Not Found When Delegating

**Symptom:**
```
Error: Cannot read .opencode/time-room/agents/finn.md
```

**Cause:** Path is relative, not absolute

**Fix:** Use absolute path in prompt:
```
"Read ~/.config/flake/.opencode/time-room/agents/finn.md first"
```

---

# Appendix: Agent Roster

| Agent | subagent_type | File | Special Notes |
|-------|--------------|------|---------------|
| Prismo | `prismo` | prismo.md | Orchestrator |
| Finn | `finn` | finn.md | Git expert |
| Finn+Shelby | `finn-shelby` | finn-shelby.md | Compound agent |
| Simon | `simon` | simon.md | Nix expert |
| Fern | `fern` | fern.md | Dotfiles |
| Jake | `jake` | jake.md | Tools/CLI |
| Marceline | `marceline` | marceline.md | Fundamentals |
| Gleeman | `gleeman` | gleeman.md | Practical code |
| BMO | `bmo` | bmo.md | Interactive |
| Huntress | `huntress` | huntress.md | Prompts |
| Bubblegum | `bubblegum` | bubblegum.md | Workflows |
| Shelby | — | finn-shelby.md | Use finn-shelby! |

---

# The Wish

Now that you understand the arcane art of agent delegation...

> *"What do you wish for?"*

May your delegations be successful, and your agents ever-responsive.

*— Prismo, Wish Master of the Time Room*

---

> 📚 **Related:**
> - [Time Room Agents Directory](../time-room/agents/AGENTS.md)
> - [Deep Dive: Agent Configuration](./part2-opencode-deep-dive/AGENTS.md)
> - [Agent Files](https://github.com/anomalyco/opencode/tree/main/docs/agents.md)
