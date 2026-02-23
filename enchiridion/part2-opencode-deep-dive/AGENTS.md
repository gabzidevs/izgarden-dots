# OpenCode Deep Dive: Agents

> *"Ah, you've come seeking deeper knowledge. Excellent. Let me illuminate the path."* — Prismo

---

# Chapter 1: Agent Configuration

## Where Agents Live

Agents are defined in a mystical Nix file:

```
modules/home/programs/opencode/agents.nix
```

This file is the **bridge** between the ethereal agent files (in `.opencode/time-room/agents/`) and the OpenCode tool that invokes them.

## The Agent Definition Spell

Each agent requires three mystical attributes:

```nix
agent_name = {
  mode = "subagent";          # primary | subagent | plan
  description = "What they do";  # Shown in listings
  system_prompt_file = "${path}/agent.md";  # Their soul
};
```

### The Three Modes

| Mode | Purpose | Tools Available |
|------|---------|------------------|
| `primary` | Full orchestrator | Everything |
| `subagent` | Specialized helper | Limited (defined in `tools`) |
| `plan` | Read-only planner | Only read tools |

### The Tools Configuration

When `mode = "primary"`, you must define what tools they wield:

```nix
tools = {
  write = true;   # Can create files
  edit = true;    # Can modify files  
  read = true;    # Can read files
  grep = true;    # Can search
  glob = true;    # Can find files
  bash = true;    # Can run commands
  task = true;    # Can delegate to other agents
  webfetch = true;  # Can fetch URLs
  websearch = true; # Can search the web
};
```

For `mode = "subagent"`, tools are restricted to keep them focused.

### The `system_prompt_file` Path

**Critical:** This must point to an actual agent file in `.opencode/time-room/agents/`. Without it, the agent has no personality!

```nix
system_prompt_file = "${agentspath}/finn.md";
```

---

## How to Add a New Agent

### Step 1: Create the Agent File

Create `.opencode/time-room/agents/newagent.md`:

```markdown
# New Agent Name

**Role:** What they do
**Voice:** Their catchphrase

---

## Expertise
- Area 1
- Area 2

## How to Work With Me
Instructions...
```

### Step 2: Register in agents.nix

```nix
newagent = {
  mode = "subagent";
  description = "What they do - their tagline";
  system_prompt_file = "${agentspath}/newagent.md";
};
```

### Step 3: Rebuild

Run `just provision` to apply changes.

---

# Chapter 2: Task Tool Integration

## The Two Paths

There are **two ways** to invoke an agent:

| Method | Syntax | What Happens |
|--------|--------|--------------|
| `subagent_type` | `task(..., subagent_type="finn")` | Direct invocation via config |
| File reference | `task(..., prompt="Read .opencode/time-room/agents/finn.md")` | Uses file as context |

## Why This Matters

**`subagent_type`** is the **built-in** mechanism. It looks up the agent in `agents.nix` by name. If the name isn't there → "Unknown agent type" error.

**File reference** just reads a file as context. The agent file becomes part of your prompt, but OpenCode doesn't know it's an "agent."

### The Common Mistake

```
❌ BAD: "Use subagent_type='marceline' for this"
   → ERROR: Unknown agent type (if not in agents.nix)

❌ BAD: "Delegate to the marceline agent file"
   → The file is read, but no delegation happens!
```

### The Correct Pattern

```
✅ GOOD: subagent_type="general" + file reference
   task(prompt="Use .opencode/time-room/agents/marceline.md as reference...", 
        subagent_type="general")

✅ GOOD: subagent_type="finn" (if finn is in agents.nix)
   task(prompt="Do git things", subagent_type="finn")
```

**Rule:** If you want `subagent_type` to work, the agent MUST be in `agents.nix`. If it's not, use the file reference pattern with `subagent_type="general"`.

---

# Chapter 3: Delegation Best Practices

## The Golden Rules

1. **Check agents.nix first** — Is the agent registered?
2. **Use the right subagent_type** — Name must match exactly
3. **For unregistered agents** — Use `subagent_type="general"` + file reference

## The Shelby Special Case

Shelby the worm is **special**. She's verification-focused, but she's not meant for standalone delegation. Instead, we use a **compound agent**: `finn-shelby`.

```nix
finn-shelby = {
  mode = "subagent";
  description = "Finn delegating verification to Shelby - Action + Check";
  system_prompt_file = "${agentspath}/finn-shelby.md";
};
```

This agent combines:
- **Finn's** action-oriented git expertise
- **Shelby's** verification checklist style

### When to Use finn-shelby

```
✅ GOOD: subagent_type="finn-shelby" for git verification tasks
❌ BAD: subagent_type="shelby" (will fail - Shelby isn't standalone)
```

---

## Correct vs Incorrect Delegation

### ✅ Correct: Registered Agent

```python
task(
    prompt="Rebase this branch onto main",
    subagent_type="finn"  # Finn is in agents.nix ✓
)
```

### ✅ Correct: Unregistered Agent (via File)

```python
task(
    prompt="""Read .opencode/time-room/agents/gleeman.md first.
              Then help me fix this build error.""",
    subagent_type="general"  # Fallback to general agent
)
```

### ❌ Incorrect: Missing Agent

```python
task(
    prompt="Help with this",
    subagent_type="marceline"  # ERROR if not in agents.nix!
)
```

---

> *"The details have been revealed. Now you hold the keys to delegation."*

*— Prismo, Wish Master of the Time Room*
