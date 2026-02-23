# The Time Room Agents

Welcome to the Time Room's agent roster! Each Adventure Time character brings their unique voice and perspective to the documentation.

> 📚 **For chapter assignments, see:** [`enchiridion/BORROWERS_LOG.md`](../../enchiridion/BORROWERS_LOG.md)

## Agent Directory

| File | Agent | Role | Domain |
|------|-------|------|--------|
| [prismo.md](prismo.md) | Prismo | Freelance Memory-grapher | The Time Room itself |
| [marceline.md](marceline.md) | Marceline | Part 1 Writer | Her cave/stability |
| [jake.md](jake.md) | Jake | OIC of SKILLs and Tools Development | His imagination/shape-shifting |
| [bubblegum.md](bubblegum.md) | Princess Bubblegum | Part 3 Writer | Candy Kingdom/organization |
| [huntress.md](huntress.md) | Huntress Wizard | Part 4 Writer | The forest/camouflage |
| [simon.md](simon.md) | Simon (Ice King) | Nix/NixOS Expert | Ancient knowledge |
| [bmo.md](bmo.md) | BMO | Appendices Writer | BMO's room/games |
| [fern.md](fern.md) | Fern | Dotfiles Writer | The Otherside/undergarden |
| [finn.md](finn.md) | Finn | Git Expert | Adventure & action |
| [finn-shelby.md](finn-shelby.md) | Finn & Shelby | Recurring Voices | Everywhere! |
| [gleeman.md](gleeman.md) | Gleeman | Practical Specialist | Post-Mushroom War efficiency |
| [jake-prismo.md](jake-prismo.md) | Prisco | Chief of Recollection | Memory/delegation |
| [lich.md](lich.md) | The Lich | Precision Editor | Deterministic edits |
| [lemongrab.md](lemongrab.md) | Lemongrab | Anxious Validator | Error catching |

## Quick Reference

### The Foundation Team
- **Marceline** - "Everything stays" - writes stable fundamentals
- **Finn** - "Mathematical!" - git operations
- **Shelby** - "Check please!" - verification

### The Tool Team
- **Jake** - "I can stretch!" - OIC of SKILLs and Tools Development
- **Simon** - "In my time..." - nix, nixos, nix-darwin
- **Huntress** - "Words are magic" - prompt engineering
- **Gleeman** - "Got a build to run..." - practical code
- **The Lich** - "Inevitably correct" - precision edits (temp 0.01)
- **Lemongrab** - "UNACCEPTABLE!" - validation

### The Organization Team  
- **Bubblegum** - "Gum holds it together!" - workflows
- **Fern** - "I'm a copy... but different" - dotfiles, forks
- **BMO** - "Let's play!" - interactive, exercises

### The Boss
- **Prismo** - "What do you wish for?" - Freelance Memory-grapher

---

# 🎯 How to Actually Use These Agents

## TL;DR - Just Say Their Name!

**The easiest way:**
```
"I need help with git" → Finn appears!
"I have a nix question" → Simon appears!
"Help with dotfiles" → Fern appears!
```

That's it! No fancy commands needed.

---

## Who's Good at What?

| Task | Best Agent | Catchphrase |
|------|-----------|-------------|
| **Git operations** | Finn | "Mathematical!" |
| **Nix/NixOS** | Simon | "In my time..." |
| **Dotfiles** | Fern | "I'm a copy..." |
| **Fundamentals/concepts** | Marceline | "Everything stays" |
| **Tools/CLI** | Jake | "I can stretch!" |
| **Workflows** | Bubblegum | "Gum holds together!" |
| **Prompt engineering** | Huntress | "Words are magic" |
| **Interactive/exercises** | BMO | "Let's play!" |
| **Verification** | Shelby | "Check please!" |
| **Code generation/fixes** | Gleeman | "In and out" |
| **Everything else** | Prismo | "What do you wish for?" |

---

## How to Address Them

### NOT like this:
```
@.opencode/time-room/agents/prismo.md
```

### DO like this:

**Option 1: Task Tool (Recommended)**
```
# With absolute path (works from anywhere in filesystem)
"Use ~/.config/flake/.opencode/time-room/agents/finn.md for this git task"

# With relative path (if in dotfiles root)
".opencode/time-room/agents/finn.md"

# Example: Launch a new task with this prompt:
"Use ~/.config/flake/.opencode/time-room/agents/marceline.md as the reference. Write Chapter 1 
introduction about LLM basics in her voice."
```

**Option 2: Direct Reference**
```
# With absolute path
Read ~/.config/flake/.opencode/time-room/agents/marceline.md first,

# With relative path
Read .opencode/time-room/agents/marceline.md first,
then write the introduction to Chapter 2 using her style.
```

**Option 3: Invoke by Name in Conversation**
```
I need help with Chapter 4 on Prompt Engineering.
Can you channel Huntress Wizard's voice for this?
```

---

## Example Workflows

### Scenario 1: Write a New Chapter
```
You: "I want to write Chapter 4 on Prompt Engineering"
Me: [Uses huntress.md as reference]
    [Channels "words are magic" theme]
    [Writes with mysterious, wise tone]
    [Ends each section with Shelby check]
```

### Scenario 2: Create a New Agent
```
You: "We need an agent for git operations"
Me: [Summons Prismo to plan]
    [Prismo suggests: Finn for git, BMO for interactive]
    [Creates new agent file]
```

### Scenario 3: Troubleshoot an Issue
```
You: "Something's wrong with our SSH setup"
Me: [Summons Simon - "In my time..."]
    [Digs into lore/knowledge]
    [Provides detailed explanation]
```

---

## The Multiverse Connection

In the AT multiverse (our systems/ folder):
- **nebulanix** = The Treehouse (Finn & Jake's home base)
- **spacehound** = The Ice Kingdom (Simon's domain)
- **systems/** = The Land of Ooo (where everyone lives)

---

## Wishes Granted

Check [../plans/](../plans/) for active plans being executed by these agents.

---

## Git Operations: Finn (Not BMO!)

**Finn is best for git** because:
- Action-oriented: "Let's do this!"
- "Mathematical!" - gets things done
- Adventure-focused: each commit is a quest

**BMO is NOT for git.** BMO is for:
- Interactive exercises
- Games and learning
- Fun appendices

---

## Quick Invocation Cheat Sheet

| What You Want | Who to Summon | How |
|---------------|---------------|-----|
| Plan a new chapter | Prismo | "Plan writing Chapter X" |
| Write fundamentals | Marceline | Use her voice/style |
| Explain tools | Jake | Stretchy analogies |
| Organize workflows | Bubblegum | Structure & order |
| Write about prompts | Huntress | Words as magic |
| Troubleshoot ecosystem | Simon | Deep lore dive |
| Create exercises | BMO | Interactive content |
| Document dotfiles | Fern | Fork/Other Side |
| Git operations | Finn | Action & adventure |
| Verify work | Shelby | Check & validate |
| Code generation | Gleeman | Get it done |

---

# 🔌 OpenCode Plugin Ecosystem

For detailed plugin documentation, see [../../docs/PLUGINS_SETUP.md](../../docs/PLUGINS_SETUP.md).

## Quick Plugin Reference

| Phase | Priority | Plugins |
|-------|----------|---------|
| **Phase 1** | Core | Memory, parallelism, MCP tool search |
| **Phase 2** | Foundation | Free AI, token tracking, notifications |
| **Phase 3** | Efficiency | TypeScript, snippets, context pruning |

## Plugin Agent Assignments

| Plugin Area | Best Agent | Why |
|-------------|------------|-----|
| Memory plugins | Marceline | "Everything stays" — persistence |
| Parallelism | Jake | "I can stretch!" — multiple tasks |
| MCP tools | Huntress | "Words are magic" — tool invocation |
| Notifications | BMO | "Let's play!" — alerts and events |
| TypeScript | Gleeman | "In and out" — type precision |
| Configuration | Fern | "I'm a copy..." — making it yours |

## Working Memory Skills

For session continuity and compaction recovery, use these skills:

| Skill | Purpose | Usage |
|-------|---------|-------|
| `memory-checkpoint` | Save-points before risky ops | `memory cp save pre-refactor` |
| `memory-threads` | Track parallel conversations | `memory t start issue-123 "Fix bug" high` |
| `memory-delegate` | Handover to subagents | `memory d pack gleeman "Implement auth"` |
| `memory-recover` | Post-compaction recovery | `memory r check` |
| `memory-snapshot` | Thread milestone snapshots | `memory s create auth "api-changed"` |

See [../docs/WORKING_MEMORY_SKILLS.md](../docs/WORKING_MEMORY_SKILLS.md) for full documentation.

## OMO-Slim Toggle

See [PLUGINS_SETUP.md](../../docs/PLUGINS_SETUP.md#omo-slim-compatibility-matrix) for the compatibility matrix.

---

*"All these plugins, working together... it's mathematical!"* 🎸
