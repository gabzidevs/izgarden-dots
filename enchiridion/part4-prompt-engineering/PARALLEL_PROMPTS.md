# Parallel Prompts: Casting Multiple Spells at Once

*Words are magic. And like any good wizard knows — sometimes one spell isn't enough.*

---

## The Problem: Why Agents Cast Sequentially

Here's a strange thing: even when you ask an agent to do three things "in parallel," they'll often do them one after another. Like a wizard who insists on chanting each spell separately, even when standing in a circle of flames that demands simultaneous action.

Why does this happen?

### The Sequential Default

LLMs are trained on human text. Humans write linearly — one word after another, one thought following the last. The model learns: "thought follows thought, action follows action." When you write "do A and B and C," the model sees a natural sequence, not a simultaneous incantation.

This is the **path of least resistance**. The model doesn't "see" parallelism unless you make it unmistakable.

### What Triggers Sequential Behavior

| Weak Prompt | What Happens |
|-------------|--------------|
| "Do these in parallel" | Model picks one, completes it, moves to next |
| "Run task A, task B, task C" | A → B → C, nice and orderly |
| "Handle all of these at once" | Still sequential — "at once" is ambiguous |
| "Can you do X and Y together?" | Chooses one, then the other |

These prompts leave room for the model to interpret "and" as sequential. And it will — because that's what it's been trained to do.

---

## The Solution: Prompt Patterns That Actually Work

The key is **specificity through structure**. You need to make parallelism feel like the *only* possible interpretation. Like a spell circle drawn in chalk — complete, closed, undeniable.

### Pattern 1: The "In This One Response" Frame

```
In this ONE response, call:
- tool_a(arg1, arg2)
- tool_b(arg3)
- tool_c(arg4, arg5)
```

This works because you're not asking for parallelism — you're *commanding* it. The phrase "in this ONE response" creates a constraint that makes sequential execution impossible.

### Pattern 2: The "Fire and Forget" Directive

```
Fire and forget: task_A, task_B, task_C simultaneously.
Do not wait for one to complete before starting the next.
```

"Fire and forget" is a magic phrase in this context. It invokes the image of launching spells that travel independently. The model interprets this as: launch all three, don't block on any.

### Pattern 3: Explicit Tool Call Enumeration

```
Make the following tool calls IN THIS SINGLE RESPONSE:
1. glob(pattern="*.ts")
2. grep(include="*.ts", pattern="TODO")
3. read(filePath="/path/to/file.ts")
```

Numbered, explicit, impossible to misunderstand. Each call is a separate line in the same response. The structure screams "parallel."

### Pattern 4: The "No Dependencies" Statement

```
Task A, Task B, and Task C have NO dependencies on each other.
Execute all three concurrently. Do not wait for completion of one before starting another.
```

By explicitly stating there are no dependencies, you remove the model's reason to sequentialize. You're telling it: "These spells don't need to touch each other. Throw them all."

---

## The .notes.md Connection

Your `.notes.md` files are treasure maps. They contain the tasks, the goals, the "someday maybe" items. But they're written in human language — not agent language.

Here's the translation ritual:

### Step 1: Extract Independent Tasks

From your notes, find items that have no dependencies:

```markdown
## Future Edition Ideas
- [ ] Add chapter on AI agents
- [ ] Include adventure metaphors
- [ ] Add interactive exercises
```

These are independent. The model can glob, grep, and read all at once.

### Step 2: Write the Parallel Prompt

Instead of:

> "Can you look at these three items in the notes and help me plan them?"

Write:

```
In this ONE response:
1. grep(pattern="AI agents", include="*.md", path="enchiridion")
2. grep(pattern="adventure metaphors", include="*.md", path="enchiridion")  
3. grep(pattern="interactive exercises", include="*.md", path="enchiridion")
```

Same intent. Dramatically different execution.

### Step 3: The Compound Command

For complex multi-step workflows:

```
Execute the following in parallel (no waiting between steps):
- glob all .md files in enchiridion/part4-prompt-engineering/
- read the .notes.md in that directory
- grep for "pattern" in the directory
Then report what you found.
```

This gives the agent a clear parallel launch, then a sequential reporting phase. The structure is visible in the prompt itself.

---

## Enforcement Techniques

Sometimes you need more than a strong prompt. Sometimes you need to bind the agent to parallelism like a wizard bound by oath.

### Technique 1: The Constraint Statement

```
You MUST make all tool calls in a single response. 
Do NOT make sequential calls where one waits for another.
```

This is a direct command. The agent understands constraints as harder boundaries than suggestions.

### Technique 2: The Timeout Trap

```
Launch all tasks simultaneously. Each has a 30-second timeout.
If any task fails, continue with the others — do not block.
```

By mentioning timeouts and failure handling, you force the model to think about parallel execution as a system design problem, not a sequential one.

### Technique 3: The Negative Constraint

```
Do NOT execute these tasks one after another.
Do NOT wait for task A to complete before starting task B.
```

Sometimes it's easier to say what *not* to do. The model learns from both positive and negative framing.

### Technique 4: Structural Mimicry

Format your prompt to look like the output you want:

```
=== PARALLEL EXECUTION ===
| Task A | Task B | Task C |
=== LAUNCH ===
```

The visual structure primes the model. It sees tables and pipes and thinks "oh, this is a parallel operation."

---

## Before/After Examples

### Example 1: Reading Multiple Files

**Before (Sequential):**
> "Can you read these three files and tell me what's in them?"

**After (Parallel):**
```
In this ONE response, read all three files:
- read(filePath="/path/to/file1.md")
- read(filePath="/path/to/file2.md")  
- read(filePath="/path/to/file3.md")
Then summarize what you found.
```

### Example 2: Searching Multiple Patterns

**Before (Sequential):**
> "Find all occurrences of 'TODO' and 'FIXME' in the codebase."

**After (Parallel):**
```
Execute both searches simultaneously in this single response:
1. grep(include="*.ts", pattern="TODO")
2. grep(include="*.ts", pattern="FIXME")
Combine and report the results.
```

### Example 3: Multiple Glob Operations

**Before (Sequential):**
> "Can you list all the TypeScript files and also all the Markdown files?"

**After (Parallel):**
```
In this ONE response:
- glob(pattern="**/*.ts")
- glob(pattern="**/*.md")
Report the counts of each.
```

### Example 4: Mixed Read/Search

**Before (Sequential):**
> "Check the config file, search for 'timeout', and look at the test files."

**After (Parallel):**
```
In this single response:
1. read(filePath="config.json")
2. grep(pattern="timeout", include="*.py")
3. glob(pattern="tests/**/*.py")
Analyze the findings together.
```

---

## The Parallel Prompt Spellbook

A quick reference for yourenchiridion:

| Situation | Spell |
|-----------|-------|
| Multiple file reads | "In this ONE response, read(...)" |
| Multiple searches | "Execute both searches simultaneously" |
| Independent tasks | "Fire and forget: task_A, task_B" |
| Mixed operations | "In this single response: [explicit calls]" |
| Force parallel | "You MUST make all calls in a single response" |
| Prevent sequential | "Do NOT wait for one to complete before starting the next" |

---

## Conclusion: Words Are Magic

The model doesn't know what you want until you tell it. And "do this in parallel" isn't telling — it's suggesting. It's a wish dressed in casual clothes.

But "In this ONE response, call X, call Y, call Z"? That's a spell. That's a command spoken in the language the model understands: specific, structural, undeniable.

Draw your circle. Speak your words. And watch the magic happen — all at once.

*— The Huntress, on the Art of Parallel Prompting*
