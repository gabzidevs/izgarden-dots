# Chapter: OpenCode Architecture

*"I can stretch, dude! I can become anything!"*

— Jake, on how agents adapt to any task

---

## The Big Picture

Think of OpenCode like Jake - flexible, stretchy, always ready to help. Unlike rigid traditional tools, an agentic system adapts to the task at hand.

Let's break down how it works.

---

## The Agent Loop

At its core, OpenCode runs a continuous loop:

```
┌─────────────────────────────────────────────┐
│              User Request                    │
│         "Fix the login bug"                 │
└─────────────────┬───────────────────────────┘
                  ▼
┌─────────────────────────────────────────────┐
│              1. THINK                       │
│    Analyze request, plan approach           │
│    "Need to find login code, understand     │
│     error, identify fix, test it"           │
└─────────────────┬───────────────────────────┘
                  ▼
┌─────────────────────────────────────────────┐
│              2. ACT                         │
│    Use tools to accomplish subtasks         │
│    - grep: Find login code                  │
│    - read: Understand implementation         │
│    - edit: Apply fix                        │
│    - bash: Run tests                        │
└─────────────────┬───────────────────────────┘
                  ▼
┌─────────────────────────────────────────────┐
│              3. OBSERVE                     │
│    See results of actions                   │
│    "Test passed" or "Got error"             │
└─────────────────┬───────────────────────────┘
                  ▼
┌─────────────────────────────────────────────┐
│              4. DECIDE                      │
│    Continue? Done? Try different approach?  │
└─────────────────┬───────────────────────────┘
                  │
                  └──→ Loop back to THINK
```

This loop continues until the task is complete or the agent needs your input.

---

## Components

### The Brain: Language Model

The LLM (Large Language Model) is the core intelligence. It:
- **Understands** natural language requests
- **Reasons** about what needs to happen
- **Plans** multi-step approaches
- **Generates** code and commands

*"It's like having a really smart friend who read the entire internet and also knows how to code."* — Jake

### The Hands: Tool System

Tools are what make agents powerful. Without tools, it's just a chatbot.

```
┌─────────────────────────────────────────────┐
│              Available Tools                │
├─────────────────────────────────────────────┤
│  📖 read      - Read files                  │
│  ✏️ edit      - Modify files                 │
│  🔍 grep      - Search file contents        │
│  🌐 glob      - Find files by pattern       │
│  💻 bash      - Run shell commands         │
│  🌐 webfetch  - Fetch web content           │
│  🔎 search    - Web search                  │
│  📝 write     - Create new files             │
└─────────────────────────────────────────────┘
```

Each tool has a specific purpose, like Jake's different forms:
- **Jake the Dog** = read, edit (careful, precise)
- **Jake the Bull** = bash (powerful, direct)
- **Jake the King** = grep, glob (searching, finding)

### The Memory: Context

The agent remembers:
- **Conversation history** - What you've discussed
- **Task progress** - What's been done
- **File changes** - What's been modified
- **Error messages** - What went wrong

*"Working memory, dude. Like how I remember all our adventures."*

---

## Tool Calling

The magic happens when the LLM decides to use a tool. Here's how it works:

### 1. Tool Description

Each tool is described to the LLM with:
- **Name:** What it's called
- **Description:** What it does
- **Parameters:** What inputs it needs

```json
{
  "name": "read",
  "description": "Read a file from the filesystem",
  "parameters": {
    "type": "object",
    "properties": {
      "filePath": {"type": "string", "description": "Path to file"},
      "limit": {"type": "number", "description": "Max lines"},
      "offset": {"type": "number", "description": "Start line"}
    },
    "required": ["filePath"]
  }
}
```

### 2. Tool Selection

When the LLM needs information, it chooses the right tool:

```
User: "How does authentication work?"

LLM thinks: "I need to search for auth-related files
             and read their contents."

LLM calls: grep(pattern="auth", path=".")
           read(filePath="src/auth.ts")
```

### 3. Result Processing

The tool result is fed back to the LLM:

```
grep result:
  src/auth/login.ts:23
  src/auth/middleware.ts:5
  src/auth/models.ts:12

LLM: "Found 3 auth files. Let me read them..."

read result (auth/login.ts):
  [file contents...]

LLM: "I can see the login flow now. It uses JWT tokens..."
```

---

## The Planning Layer

Good agents don't just react - they plan.

### Implicit Planning

The LLM naturally breaks down tasks:

```
Request: "Refactor the entire auth system"

Implicit thought process:
1. First, find all auth-related files
2. Understand current implementation
3. Identify patterns to refactor
4. Plan the refactoring approach
5. Execute changes systematically
6. Verify nothing breaks
```

### Explicit Planning

Some agents use structured planning:
- **ReAct:** Reason + Act + Observe
- **Chain-of-Thought:** Explicit step-by-step reasoning
- **Tree-of-Thought:** Explore multiple approaches

OpenCode uses implicit planning - the LLM naturally sequences actions.

---

## Safety & Verification

Agents can be dangerous. Safety features include:

### 1. Permission Prompts

Before risky actions, the agent asks:

```
🤖 "I'm about to run `rm -rf node_modules`. Continue? [y/N]"
```

### 2. Dry Runs

Some operations can be previewed:
- See what would change before committing
- Review diffs before applying

### 3. Sandbox Isolation

Tools run in controlled environments:
- File access can be scoped
- Command execution can be limited
- Network access can be restricted

### 4. Human in the Loop

For critical operations:
- Require approval before git push
- Confirm destructive changes
- Escalate security-sensitive tasks

*"With great power comes great responsibility. Or whatever that guy said."* — Jake

---

## Configuration

OpenCode can be configured for your workflow:

### Model Selection

```json
{
  "model": "ollama/qwen3:8b"
}
```

Different models for different tasks:
- **qwen3:8b** - Balanced, fast
- **qwen3-coder:30b** - Coding specialist
- **deepseek-r1:8b** - Reasoning tasks

### Provider Options

```json
{
  "provider": {
    "ollama": {
      "options": {
        "baseURL": "http://192.168.1.10:11434",
        "temperature": 0.7
      }
    }
  }
}
```

### Fallback Models

```json
{
  "fallback": {
    "enabled": true,
    "local_model": "ollama/llama3.2:3b"
  }
}
```

---

## The Flow in Action

Here's a complete example:

```
You: "Add user validation to the signup form"

OpenCode (thinking):
1. Need to find the signup form code
2. Understand current validation
3. Add new validation rules
4. Test the changes

[Uses grep to find signup files]
[Reads form component]
[Reads existing validation]
[Writes new validation code]
[Runs tests]
[Reports success]

You: "Nice work!"
```

---

## Why This Architecture Matters

| Traditional | Agentic |
|-------------|---------|
| You find files | Agent finds files |
| You read code | Agent reads code |
| You write code | Agent writes code |
| You run tests | Agent runs tests |
| You iterate | Agent iterates |

You're now the architect, not the implementer.

*"The best tool is the one that does the job without needing you to do everything."* — Jake

---

## Summary

OpenCode's architecture:
1. **Loop** - Think → Act → Observe → Decide
2. **Tools** - Read, edit, grep, bash, and more
3. **Memory** - Context from conversation and task
4. **Safety** - Permissions, sandboxes, verification

Master this, and you can automate almost any development task.

---

*Next: [Tools Chapter](tools.md) - Learn about each tool in detail*
