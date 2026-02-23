# 🚀 Portability Guide: Bringing the Time Room to Any Project

> *"Hello! Welcome to the Time Room. I'm Prismo."*  
> *"But wait... you want to take this show on the road?"*

---

## TL;DR - Quick Setup

1. **Copy** `time-room/agents/` to your project
2. **Reference** agents in conversation
3. **Done!** The Time Room travels with you!

---

## What is Portability?

The Time Room isn't tied to just this flake! You can bring our **Adventure Time agent personas** to ANY project:

- Your work projects
- Personal side projects  
- Open source contributions
- Anywhere you want AI help!

---

## Minimal Files Needed

To bring the Time Room to a new project, you only need:

```
time-room/agents/
├── prismo.md        # 🥒 The Wish Master (orchestrator)
├── AGENTS.md        # 📋 Index of all agents
├── finn.md         # ⚔️ Git operations
├── [other agents as needed]
```

**That's it!** 2-4 files, not the whole structure.

---

## Three Ways to Port

### Option 1: Copy (Recommended for Starters)

```bash
# Copy agents to your project (use absolute path from dotfiles)
cp -r ~/.config/flake/.opencode/time-room/agents ./my-project/time-room-agents/

# That's it! Reference them with absolute path:
# "Use ~/my-project/time-room-agents/finn.md for this git task"

# Or reference from original location:
# "Use ~/.config/flake/.opencode/time-room/agents/finn.md"
```

**Pros:** Easy, full control  
**Cons:** Manual updates needed

---

### Option 2: Symlink (For Dotfiles Users)

```bash
# If your project is in ~/projects/
ln -s ~/.config/flake/.opencode/time-room/agents ~/projects/my-project/time-room-agents
```

**Pros:** Always in sync  
**Cons:** Path issues if folder moves

---

### Option 3: Git Submodule (For Advanced)

```bash
# Add as submodule
git submodule add https://github.com/gabzidevs/izgarden-dots time-room-agents
```

**Pros:** Version controlled  
**Cons:** More setup, learning curve

---

## How Each Tool Uses It

### OpenCode

```bash
# Reference in Task tool
"Use finn.md as the reference, help me with this git rebase"
```

### Crush (Charmbracelet AI)

```bash
# In conversation
"I've got finn.md in my project, can you help with git?"
```

### Claude Code

```bash
# Copy agent files, then prompt
# "Act as Finn from Adventure Time. Use the finn.md 
#  file I copied as your reference..."
```

### Obsidian / Note-Taking

```bash
# Link agent files as knowledge base
# [[time-room-agents/finn]] for git operations
```

---

## Agent Routing by Context

Here's how Prismo routes tasks across projects:

| Task Context | Agent | Why |
|-------------|-------|-----|
| "commit", "push", "PR" | Finn | "Mathematical!" - action |
| "nix", "flake", "NixOS" | Simon | Ancient knowledge |
| "config", "dotfiles", "setup" | Fern | Fork/Other Side |
| "explain", "learn", "fundamental" | Marceline | "Everything stays" |
| "tools", "CLI", "shell" | Jake | Stretchy, flexible |
| "prompt", "writing", "create" | Huntress | Words as magic |
| "verify", "check", "review" | Shelby | "Check please!" |
| "interactive", "exercise", "game" | BMO | "Let's play!" |

---

## Example Workflows

### Example 1: New Work Project

```bash
# 1. Copy agents (using absolute path)
cp -r ~/.config/flake/.opencode/time-room/agents ./work-project/time-room/

# 2. In OpenCode:
# "Use ./work-project/time-room/finn.md to help me create a good commit message"

# Or reference directly from dotfiles:
# "Use ~/.config/flake/.opencode/time-room/agents/finn.md"

# 3. Finn (in his voice):
# "Oh man, this is gonna be great! Let's make this commit 
#  mathematical! Here's what I'd do..."
```

### Example 2: Open Source Contribution

```bash
# 1. Symlink (using absolute path)
ln -s ~/.config/flake/.opencode/time-room/agents ./oss-project/.time-room-agents

# 2. "Use ~/.config/flake/.opencode/time-room/agents/simon.md to explain this NixOS module"
# (Simon: "In my time... this was called differently...")
```

### Example 3: Personal Dotfiles

```bash
# Already here! This IS your dotfiles
# Just reference: .opencode/time-room/agents/
```

---

## Troubleshooting

### "Agent not found"
Make sure you're referencing the correct path:
```bash
# Wrong - relative path from unknown location
"Use finn.md"

# Right - absolute path (works from anywhere)
"Use ~/.config/flake/.opencode/time-room/agents/finn.md"

# Or relative from dotfiles root
"Use .opencode/time-room/agents/finn.md"
```

### "Voice not matching"
Check you copied the right agent file - each has specific guidelines.

### "How do I update?"
Re-copy from main source, or if symlinked, just pull the latest!

---

## The Cosmic Connection

Remember: **The Time Room exists outside of normal git history.**

When you bring agents to a new project:
- They're still connected to the original Time Room
- Your "wishes" (tasks) get granted wherever you are
- The cosmic energy flows with you!

---

## What's Next?

Now that you can port the Time Room:
1. **Try it!** Pick a project, copy agents
2. **Experiment!** Different projects, different agents
3. **Share!** Tell others about the Adventure Time workflow

---

*"So... what do you wish for in your new project?"* 🕐✨

**Remember:**  
- Finn says: *"Mathematical!"*  
- Shelby says: *"Check please!"*  
- And everything... stays. 🎸
