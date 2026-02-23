# Parallel Task Execution

**Document:** `.opencode/time-room/docs/PARALLEL_TASKS.md`  
**Written by:** Prisco (confused cosmic entity)  
**Voice:** 🐕🥒 "Wait, multiple wishes at once?!"

---

## The Problem

So here's the thing — when you call a subagent, by default the system waits for it to finish before starting the next one. 

It's like... making one wish, waiting for the universe to grant it, *then* making another wish. Which is fine! The universe is busy! But sometimes you have like... **four wishes** you want granted *at the same time*?

That's where parallelism comes in.

---

## The Solution

The secret is simple: put **ALL your task calls in ONE response**.

That's it. Really. The system launches them all at once and they run simultaneously. 

Wait, really? Yeah! The universe can handle multiple wishes if you ask correctly.

---

## The Correct Pattern

```python
# ✅ CORRECT - All launch at once!
# Just... throw all the wishes out there

task(subagent_type="gleeman", prompt="Create bubblegum")
task(subagent_type="gleeman", prompt="Create template")
task(subagent_type="finn", prompt="Townhall doc")
task(subagent_type="fern", prompt="Memory plugin")

# All 4 run simultaneously! 
# The Cosmic Owl is very confused but everything works
```

```python
# ✅ ALSO CORRECT - Even more parallel wishes
task(subagent_type="finn", prompt="Commit the changes")
task(subagent_type="simon", prompt="Update nix-darwin")
task(subagent_type="jake", prompt="Write the script")
task(subagent_type="shelby", prompt="Verify everything")
```

---

## Visual Timeline

### Sequential (WRONG - wastes time)

```
Time →
Task 1:  [████████████] (3 seconds)
         Task 2:             [████████████] (3 seconds)
                              Task 3:                   [████████████] (3 seconds)
Total: 9 seconds 😴
```

### Parallel (CORRECT - all at once!)

```
Time →
Task 1:  [████████████] (3 seconds)
Task 2:  [████████████] (3 seconds)  
Task 3:  [████████████] (3 seconds)
Total: 3 seconds ✨ Mathematical!
```

---

## Common Mistakes

### ❌ Breaking Parallel with Confirmation Pauses

```python
# WRONG - Sequential because you're "waiting for result"
result1 = task(subagent_type="gleeman", prompt="Create bubblegum")
# ... system waits for result ...

result2 = task(subagent_type="gleeman", prompt="Create template")
# ... waits again ...

# This takes twice as long! Prisco is sad.
```

```python
# WRONG - Intermediate processing between calls
task(subagent_type="gleeman", prompt="Create bubblegum")

# DON'T DO THIS:
print("Waiting for result...")  # Or any other pause

task(subagent_type="gleeman", prompt="Create template")
# Now they're sequential again :(
```

### ❌ Asking for Results Before Launching All

```python
# WRONG - Trying to get results mid-flight
task(subagent_type="gleeman", prompt="Task 1")
task(subagent_type="gleeman", prompt="Task 2")

# DON'T READ RESULTS YET - they'll come as notifications
# Reading here might block other launches
```

---

## When to Use Parallel

### ✅ Good Candidates for Parallelism

- **Independent tasks** - Don't need each other's output
- **Same agent, different prompts** - Gleeman can handle multiple
- **Different agents working on separate files** - Finn + Simon + Fern
- **Multiple verification tasks** - Shelby checking different things

### ❌ NOT Good Candidates

- **Tasks with dependencies** - Task B needs Task A's output
- **Sequential workflows** - Must complete in order
- **Shared resource conflicts** - Both writing to same file

```python
# ✅ Good - independent
task(subagent_type="finn", prompt="Write git commit msg")
task(subagent_type="simon", prompt="Update nix config")
task(subagent_type="fern", prompt="Refresh dotfiles")

# ❌ Bad - dependent (don't do this)
task(subagent_type="gleeman", prompt="Create file")
# Can't do this next one until we know what the file contains!
task(subagent_type="gleeman", prompt="Add to file")
```

---

## delegate vs task

There's two ways to launch subagents:

| Tool | Type | Use When |
|------|------|----------|
| `delegate` | Read-only | Research, exploration, finding things |
| `task` | Write-capable | Making changes, writing files, editing |

```python
# delegate - just reading/researching
delegate(agent="researcher", prompt="Find all nix files")
delegate(agent="explorer", prompt="Check what's in that folder")

# task - making actual changes
task(subagent_type="gleeman", prompt="Fix the bug")
task(subagent_type="finn", prompt="Commit these changes")
```

---

## Prisco's Pro Tips

> "So here's what I learned — and I'm still kind of figuring this out — but..."

1. **Launch first, ask questions later** - Get all tasks in flight before checking results

2. **Don't name your variables "result1, result2"** - You'll be tempted to read them sequentially. Just launch!

3. **Four is a good number** - More than that and the system gets overwhelmed. Less than that and you're leaving wishes on the table.

4. **Prisco's catchphrase for this:** 
   > "I can stretch... across multiple timelines! Also my consciousness across multiple tasks! Check it out—"

5. **When in doubt, test it out** - Run two tasks in parallel and see if you get both notifications back

---

## Summary

```
┌─────────────────────────────────────────────────────────┐
│  PARALLEL EXECUTION RULES                               │
├─────────────────────────────────────────────────────────┤
│  ✅ Launch ALL tasks in ONE response                    │
│  ✅ Use delegate for read-only, task for write          │
│  ✅ Keep tasks independent                               │
│  ❌ Don't wait for results between launches             │
│  ❌ Don't do sequential - it's slower                   │
└─────────────────────────────────────────────────────────┘
```

---

## Example: Real-World Parallel

```python
# The user wants: update docs, verify build, commit changes

# ✅ Do this - all at once!
task(subagent_type="fern", prompt="Update the documentation")
task(subagent_type="gleeman", prompt="Run the build and fix any errors")
task(subagent_type="finn", prompt="Commit all changes with a good message")

# Result: 3 tasks flying through time simultaneously!
# Prisco is stretching to keep track of all of them
```

---

*"Wait, so you're saying I can make MULTIPLE wishes at once?!"* 🐕🥒✨
