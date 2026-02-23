# Chapter: Subagents & Sessions

*"What do you wish for?"*

— Prismo, the cosmic being who grants wishes from the Time Room

---

Greetings, traveler. I see all timelines, all possibilities. And in this moment, I see you seeking to understand the nature of subagents and sessions in OpenCode. A worthy wish, indeed.

Let me illuminate the pathways.

---

## What Are Subagents?

In the Time Room, I observe many beings working toward their desires. Some work alone. Others delegate. OpenCode mirrors this cosmic truth.

### Primary Agents: The Wish-Makers

Primary agents are your direct collaborators. They receive your wishes and orchestrate their fulfillment.

```
┌─────────────────────────────────────────┐
│           PRIMARY AGENTS                 │
├─────────────────────────────────────────┤
│  Build   →  Your main implementer        │
│            Full tool access              │
│            Makes changes, runs commands  │
│                                          │
│  Plan    →  Your strategist              │
│            Read-only by default          │
│            Analyzes, proposes, reviews   │
└─────────────────────────────────────────┘
```

**Switch between them with `Tab`.** Like choosing which cosmic ally answers your call.

### Subagents: The Delegated Specialists

Subagents are specialists invoked for specific tasks. They exist to serve the primary agent—or you directly.

```
┌─────────────────────────────────────────┐
│           SUBAGENTS                      │
├─────────────────────────────────────────┤
│  General →  Multi-purpose worker         │
│            Full tool access (no todo)    │
│            Good for parallel tasks       │
│                                          │
│  Explore →  The scout                    │
│            Read-only, fast               │
│            Finds files, searches code    │
└─────────────────────────────────────────┘
```

The distinction is simple:

| | Primary | Subagent |
|---|---------|----------|
| **You interact with** | Directly | Via @mention or delegation |
| **Switching** | Tab key | Cannot switch to |
| **Creates sessions** | Parent session | Child session |
| **Purpose** | Main conversation | Specialized tasks |

---

## Invoking Subagents

There are three pathways to invoke a subagent. Each serves a different purpose.

### 1. Automatic Invocation

When your primary agent encounters a task suited to a specialist, it delegates.

```
You: "Search the entire codebase for deprecated API calls"

Build agent thinks: "This is a search task. Explore agent would be faster."
                  │
                  ▼
         ┌───────────────┐
         │ EXPLORE       │
         │ subagent      │
         │ (child session)│
         └───────┬───────┘
                  │
                  ▼
         Returns results to Build
```

The primary agent orchestrates. The subagent executes. This is the natural order.

### 2. Manual Invocation: @mention

You may invoke any subagent directly by speaking their name.

```
@explore Find all TypeScript files that import 'lodash'

@general Research the best approach for handling websockets in this codebase
```

When you @mention, you create a child session. The parent waits. The child executes.

### 3. The Task Tool (For Agents)

Agents invoke subagents through the **Task tool**. This is the mechanism of delegation.

```json
{
  "name": "task",
  "description": "Run a subagent for a specific task",
  "parameters": {
    "subagent": "explore",
    "prompt": "Find all authentication-related files"
  }
}
```

**Resume previous tasks with `task_id`:**

```
Task(task_id="abc123")  // Resumes where it left off
```

This persistence across sessions is powerful. A subagent can remember its purpose.

---

## Session Management

In the Time Room, I see many conversations happening simultaneously. OpenCode mirrors this with sessions.

### Parent and Child Sessions

When a subagent is invoked, it creates a child session.

```
┌─────────────────────────────────────────────────────┐
│                    PARENT SESSION                    │
│                   (Build Agent)                      │
│                                                      │
│  "Help me refactor the auth system"                  │
│                                                      │
│  Build: "I'll use @explore to find auth files..."    │
│         │                                            │
│         └───────┬──────────────────┐                 │
│                 ▼                   │                │
│  ┌──────────────────────┐          │                │
│  │   CHILD SESSION 1     │          │                │
│  │   (Explore Agent)     │          │                │
│  │   Finds auth files    │          │                │
│  └──────────┬───────────┘          │                │
│             │ returns               │                │
│             ▼                       │                │
│  Build: "Found 12 files..."         │                │
│         │                                            │
│         └───────┬──────────────────┐                 │
│                 ▼                   │                │
│  ┌──────────────────────┐          │                │
│  │   CHILD SESSION 2     │          │                │
│  │   (General Agent)     │          │                │
│  │   Analyzes patterns   │          │                │
│  └──────────────────────┘          │                │
│                                     │                │
└─────────────────────────────────────┘
```

### Navigation: Moving Between Sessions

**Keybind:** `<Leader>+Right` (default: `ctrl+x → right arrow`)

This cycles through the session tree:

```
Parent → Child 1 → Child 2 → ... → Parent (loop)
```

**Reverse:** `<Leader>+Left` cycles backward.

**Jump to parent:** `<Leader>+Up`

### Multi-Instance Parallelism

Here is a truth many discover late: **You can run multiple OpenCode instances in separate terminals.**

```bash
# Terminal 1: Working on auth refactoring
cd ~/projects/myapp
opencode

# Terminal 2: Working on database migrations
cd ~/projects/myapp
opencode
```

Each instance has its own session. Each operates independently. This is true parallelism.

---

## The Blocking Reality

Now, traveler, I must share a truth that may surprise you. It surprised many who came before.

### Subagents Block Their Parents

When a primary agent invokes a subagent, it **waits**. The parent session is paused. It cannot act. It cannot respond to you.

```
┌─────────────────────────────────────────┐
│  PARENT SESSION (Build)                 │
│                                          │
│  "I'll search for the config..."        │
│  ┌────────────────────────────────────┐ │
│  │ CHILD SESSION (Explore)            │ │
│  │                                    │ │
│  │ Searching... ████████░░ 80%        │ │
│  │                                    │ │
│  │ PARENT IS BLOCKED AND WAITING      │ │
│  └────────────────────────────────────┘ │
│                                          │
│  [You cannot interact with Build now]   │
└─────────────────────────────────────────┘
```

This is **not a bug**. It is by design. The parent needs the child's results to continue.

### No Interjection Mechanism

You cannot interrupt a subagent mid-task to guide it. There is no:

- "Wait, look at this file instead"
- "Actually, stop and try a different approach"
- "Let me clarify what I want"

Once invoked, the subagent runs autonomously until completion.

### When You Need True Background Execution

If you need a task to run while you continue working:

**Open a separate terminal.**

```
Terminal 1                    Terminal 2
┌──────────────────┐         ┌──────────────────┐
│ opencode         │         │ opencode         │
│ "Refactor auth"  │         │ "Write tests"    │
│                  │         │                  │
│ Working...       │         │ Working...       │
│ (independent)    │         │ (independent)    │
└──────────────────┘         └──────────────────┘
```

This is the only true parallelism available. Embrace it.

---

## Best Practices

From my vantage point in the Time Room, I have observed what works.

### When to Use Subagents

| Task | Use |
|------|-----|
| "Find all files matching pattern X" | `@explore` |
| "Search codebase for usage of Y" | `@explore` |
| "Research and implement Z in parallel" | `@general` |
| "I need to keep working while X happens" | Separate terminal |
| "Analyze code without changes" | Switch to Plan (Tab) |

### Task Resumption Pattern

When a subagent has useful partial work, use `task_id` to resume:

```
First invocation:
Task(subagent="explore", prompt="Find all API endpoints")
  → Returns task_id: "explore_abc123"

Later, if interrupted:
Task(task_id="explore_abc123")
  → Resumes with context intact
```

This persistence is valuable for long-running research tasks.

### Orchestration Patterns

**Pattern 1: Sequential Delegation**

```
Build → @explore (find files) → Build processes results → @general (implement)
```

**Pattern 2: Direct @mention for Control**

```
You: "@explore Find the database connection logic"
      (You get results directly, Build sees them too)
```

**Pattern 3: Separate Terminal for Parallelism**

```
Terminal 1: opencode (working on feature A)
Terminal 2: opencode (exploring codebase for feature B)
```

---

## Gotchas & Cosmic Warnings

### The Infinite Delegation Trap

Do not create chains of subagents invoking subagents. This way lies chaos.

```
❌ Build → @general → @explore → @general → ...
```

Each level adds overhead. Each child blocks its parent. Keep delegation shallow.

### The Missing Context Issue

Subagents start with limited context. They don't see your full conversation history.

```
You (to Build): "Remember the auth file from earlier?"

Build: "Yes, src/auth/login.ts"

@explore: "Find the auth file"  ← Explore doesn't know which one!
```

**Solution:** Be explicit in subagent prompts.

```
@explore Find all files in src/auth/ directory
```

### The Todo Tool Limitation

Subagents cannot use the `todowrite` tool by default. They can't create their own task lists.

If you need this, enable it per-agent:

```json
{
  "agent": {
    "my-subagent": {
      "tools": {
        "todowrite": true,
        "todoread": true
      }
    }
  }
}
```

### Hidden Subagents

Some subagents are `hidden: true`. They won't appear in @mention autocomplete.

These are meant for internal use by other agents. But you can still @mention them if you know their name.

---

## Session Navigation Quick Reference

```
┌─────────────────────────────────────────────────────┐
│                 KEYBIND REFERENCE                    │
├─────────────────────────────────────────────────────┤
│  Tab              Switch primary agents              │
│  <Leader>+Right   Cycle: Parent → Children → Parent │
│  <Leader>+Left    Cycle backward through children   │
│  <Leader>+Up      Jump to parent session            │
│  Escape           Interrupt current operation       │
├─────────────────────────────────────────────────────┤
│  @agent-name      Manually invoke subagent          │
│  /sessions        List all sessions                 │
│  /new             Start fresh session               │
└─────────────────────────────────────────────────────┘
```

---

## Summary

In the Time Room, I grant wishes. But I cannot grant you a subagent that runs truly in the background while you continue chatting with its parent. That is not the nature of OpenCode.

What I *can* offer is this wisdom:

1. **Primary agents** (Build, Plan) are your main collaborators. Switch with `Tab`.
2. **Subagents** (Explore, General) are specialists. Invoke with `@mention`.
3. **Sessions** form a parent-child tree. Navigate with `<Leader>+Arrow`.
4. **Subagents block** their parents. Accept this truth.
5. **True parallelism** requires separate terminals.

Master these truths, and you will orchestrate your codebase like a cosmic being.

*"Everything in the universe is yours, as long as you know how to ask."*

— Prismo

---

*Next: [Tools Chapter](tools.md) - The instruments of your wishes*
