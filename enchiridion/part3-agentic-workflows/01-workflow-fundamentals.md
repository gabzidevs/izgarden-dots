# Agentic Workflow Fundamentals

*Written by Princess Bubblegum*  
*"Science requires METHOD. Workflows are just... systematic science."*

---

## Introduction: The Laboratory Protocols

Greetings, adventurer-developer. I am Princess Bubblegum, ruler of the Candy Kingdom and head scientist of... well, everything that requires precision.

You've mastered the fundamentals (thank you, Marceline) and understand your tools (Jake did well there). Now it's time to discuss **workflows** - the systematic application of your knowledge.

Think of this as my laboratory. In science, we don't just throw chemicals together and hope for the best. We follow PROTOCOLS. Your AI agents are no different.

---

## What IS an Agentic Workflow?

### The Scientific Definition

An **agentic workflow** is a structured sequence of AI-powered tasks where:

1. **Agents make decisions** (not just execute predefined steps)
2. **Tools are invoked dynamically** (based on context, not hardcoded)
3. **Outcomes inform next steps** (adaptive, not linear)
4. **Human oversight is minimal** (but checkpoints exist)

### The Candy Kingdom Analogy

Imagine organizing the Candy Ball:

**Traditional workflow** (rigid):
```
1. Send invitations
2. Prepare hall
3. Bake cake
4. Host event
```

**Agentic workflow** (adaptive):
```
1. Agent checks guest list → decides invitation method (email vs carrier pigeon)
2. Agent inspects hall → determines if repairs needed → calls repair tool OR proceeds
3. Agent evaluates cake inventory → bakes if needed OR orders from bakery
4. Agent monitors event → adjusts music/lighting based on crowd energy
```

See the difference? The **agent** decides. The **workflow** adapts.

---

## The Three Types of Workflows

### Type 1: Exploration (Reconnaissance)

**Purpose:** Gather information about unknown territory

**Example:** "Explore this codebase and tell me how it works"

**Scientific parallel:** Lab analysis before experiments

**Agent behavior:**
- Uses `read`, `grep`, `glob` tools extensively
- Builds mental model through multiple small queries
- Synthesizes findings into report
- NO modifications (read-only mode)

**When to use:**
- New codebase onboarding
- Bug investigation
- Architecture analysis
- Technical debt assessment

**Code pattern:**
```markdown
User: "Explore the API layer and explain authentication flow"

Agent workflow:
1. glob **/*auth* → find relevant files
2. grep "authentication\|login\|session" → locate logic
3. read identified files → understand implementation
4. read test files → verify understanding
5. Synthesize: "The authentication uses JWT tokens..."
```

---

### Type 2: Planning (Strategic)

**Purpose:** Design approach before execution

**Example:** "Plan how to refactor the database layer"

**Scientific parallel:** Experimental design

**Agent behavior:**
- Analyzes current state (exploration sub-phase)
- Proposes multiple approaches
- Evaluates trade-offs
- Creates step-by-step plan
- NO execution yet (planning only)

**When to use:**
- Large refactors
- Architecture changes
- Migration planning
- Complex feature implementation

**Code pattern:**
```markdown
User: "Plan migrating from REST to GraphQL"

Agent workflow:
1. Read current REST implementation
2. Identify dependencies and coupling
3. Research GraphQL best practices (webfetch)
4. Propose phased migration:
   Phase 1: Add GraphQL alongside REST
   Phase 2: Migrate read operations
   Phase 3: Migrate write operations
   Phase 4: Deprecate REST endpoints
5. Estimate effort and risks
```

---

### Type 3: Execution (Implementation)

**Purpose:** Actually DO the thing

**Example:** "Implement user authentication with JWT"

**Scientific parallel:** Running the experiment

**Agent behavior:**
- Uses `write`, `edit`, `bash` tools
- Makes real changes to codebase
- Runs tests to verify
- Iterates on failures
- Commits when successful

**When to use:**
- Feature development
- Bug fixes
- Automated refactoring
- Code generation

**Code pattern:**
```markdown
User: "Add rate limiting to the API"

Agent workflow:
1. read existing middleware → understand structure
2. write rate-limiter.js → create new middleware
3. edit app.js → integrate middleware
4. bash npm test → verify tests pass
5. bash npm run lint → check code quality
6. (If tests fail) → edit rate-limiter.js → retry
7. (If tests pass) → Done! Report success
```

---

## The Workflow Design Matrix

Use this to choose your approach:

| Scenario | Exploration | Planning | Execution |
|----------|-------------|----------|-----------|
| **Unknown codebase** | ✅ START HERE | Then plan | Then execute |
| **Clear task, known code** | Skip | Skip | ✅ DIRECT |
| **Complex refactor** | ✅ First | ✅ THEN THIS | Then execute |
| **Simple bug fix** | Maybe quick scan | Skip | ✅ DIRECT |
| **New feature** | ✅ Understand context | ✅ DESIGN FIRST | Then execute |

**Lab Rule #1:** When in doubt, explore BEFORE you execute.

---

## Workflow Patterns: The Bubblegum Protocols

### Protocol 1: Read-Think-Act (RTA)

**Best for:** Most standard tasks

```
1. READ: Gather context
2. THINK: Analyze options
3. ACT: Execute chosen approach
```

**Example:**
```markdown
"Fix the login bug"

READ: Check login code, error logs, related tests
THINK: Bug is in token expiration logic (not validation)
ACT: Edit token handler, add expiration check, run tests
```

---

### Protocol 2: Breadth-First-Search (BFS)

**Best for:** Large unknown codebases

```
1. Survey high-level structure (directories)
2. Identify key modules
3. Dive into specific areas
4. Build mental dependency graph
```

**Example:**
```markdown
"Understand this microservices architecture"

Level 1: List services (find */service.yaml)
Level 2: Map service communication (grep "http\|grpc")
Level 3: Identify shared libraries (check imports)
Level 4: Understand data flow
```

---

### Protocol 3: Test-Driven-Development (TDD)

**Best for:** New features requiring verification

```
1. READ: Understand existing tests
2. WRITE: Add test for new feature (it fails)
3. IMPLEMENT: Write code to make test pass
4. VERIFY: Run tests
5. REFACTOR: Clean up code
6. VERIFY: Tests still pass
```

**Example:**
```markdown
"Add user profile picture upload"

1. write tests/upload.test.js → test upload endpoint (fails - endpoint doesn't exist)
2. write routes/upload.js → create endpoint
3. bash npm test → verify test passes
4. edit routes/upload.js → add validation
5. bash npm test → still passes
```

---

### Protocol 4: Dependency-First (DF)

**Best for:** Complex tasks with prerequisites

```
1. IDENTIFY: What needs to exist first?
2. BUILD: Create dependencies bottom-up
3. INTEGRATE: Connect pieces
4. VERIFY: Test integration
```

**Example:**
```markdown
"Build admin dashboard with auth"

Dependencies:
├─ Database schema (needs to exist first)
├─ Auth middleware (depends on DB)
├─ Dashboard routes (depends on auth)
└─ Frontend components (depends on routes)

Workflow:
1. write schema.sql
2. write auth-middleware.js
3. write dashboard-routes.js  
4. write dashboard.jsx
5. bash npm run dev → test integration
```

---

## Common Workflow Antipatterns

### ❌ Antipattern 1: Execute Without Context

```markdown
BAD:
"Add pagination to the user list"

[Agent immediately writes code without reading existing implementation]
[Breaks existing UI, doesn't match current patterns]
```

**Fix:** Always `read` before `write`

---

### ❌ Antipattern 2: Analysis Paralysis

```markdown
BAD:
"Fix this simple typo"

[Agent reads 50 files]
[Agent analyzes architecture]
[Agent writes 3-page report]
[Never fixes the typo]
```

**Fix:** Match workflow complexity to task complexity

---

### ❌ Antipattern 3: No Verification

```markdown
BAD:
"Refactor the API layer"

[Agent edits 10 files]
[Never runs tests]
[Breaks production]
```

**Fix:** ALWAYS run tests after changes

---

### ❌ Antipattern 4: Tool Overuse

```markdown
BAD:
"What does this function do?"

[Agent uses bash to run code]
[Triggers side effects]
[Corrupts database]
```

**Fix:** Exploration should be READ-ONLY

---

## Checkpoint System: The Royal Approval Process

In the Candy Kingdom, important decisions need royal approval. Your workflows should have checkpoints too.

### Automatic Checkpoints (Agent-Driven)

```markdown
After exploration → "Here's what I found. Proceed with plan?"
After planning → "Here's the approach. Execute?"
After execution → "Changes complete. Run tests?"
After tests fail → "Tests failed. Debug or revert?"
```

### Manual Checkpoints (User-Driven)

```markdown
You: "Before modifying any files, show me the plan"
Agent: [Creates plan, waits for approval]
You: "Approved. Execute."
Agent: [Proceeds]
```

---

## Workflow Orchestration: Multi-Agent Coordination

Sometimes one agent isn't enough. Here's how to coordinate:

### Pattern 1: Sequential Delegation

```markdown
Main Agent: "I need to explore the codebase. Delegating to Explorer agent."
Explorer Agent: [Does read-only analysis]
Explorer Agent: "Here's what I found: [report]"
Main Agent: "Thank you. Now delegating to Planner agent."
Planner Agent: [Creates implementation plan]
Planner Agent: "Here's the plan: [steps]"
Main Agent: "Executing plan myself..."
```

**When to use:** Complex tasks with distinct phases

---

### Pattern 2: Parallel Execution

```markdown
Main Agent: "Launching 3 explorers in parallel"
├─ Explorer A: "Check frontend codebase"
├─ Explorer B: "Check backend codebase"  
└─ Explorer C: "Check database schema"

[All run simultaneously]

Main Agent: "Synthesizing findings from all 3 explorers..."
```

**When to use:** Independent subtasks that can run concurrently

---

### Pattern 3: Specialist Consultation

```markdown
Main Agent: "I need git expertise. Calling Finn..."
Finn: "Mathematical! I'll handle the rebase."
Main Agent: "Thanks! Now I need Nix help. Calling Simon..."
Simon: "In my time, we handled Nix like this..."
```

**When to use:** Task requires domain-specific knowledge

---

## Practical Exercise: Design Your First Workflow

**Scenario:** You need to add a "forgot password" feature to an existing app.

**Your task:** Design the workflow using Bubblegum Protocols.

<details>
<summary>Click to see the Princess Bubblegum Approved Solution</summary>

**Workflow Type:** Execution (with exploration first)

**Protocol:** Read-Think-Act + Test-Driven

**Steps:**

1. **EXPLORATION PHASE** (Read-only)
   ```
   - glob **/auth* → find auth-related files
   - read existing authentication code
   - grep "password\|reset\|email" → find related logic
   - read email configuration (if exists)
   ```

2. **PLANNING PHASE** (No code changes)
   ```
   - Design reset token system (JWT or random string?)
   - Plan database schema addition (reset_tokens table)
   - Design email template
   - Plan security measures (rate limiting, expiration)
   ```

3. **EXECUTION PHASE** (TDD approach)
   ```
   Step 1: Write tests first
   - write tests/password-reset.test.js
   - Test: request reset email
   - Test: verify token
   - Test: reset password with valid token
   - Test: reject expired token
   
   Step 2: Implement
   - write migrations/add-reset-tokens.sql
   - bash npm run migrate
   - write routes/password-reset.js
   - edit email/templates.js (add reset template)
   - bash npm test → verify
   
   Step 3: Add security
   - edit middleware/rate-limit.js
   - bash npm test → verify
   
   Step 4: Integration test
   - bash npm run test:integration
   ```

4. **VERIFICATION CHECKPOINT**
   ```
   - Run full test suite
   - Manual test in dev environment
   - Security review (rate limits work?)
   - User experience review (email looks good?)
   ```

**Estimated steps:** 15-20 tool calls  
**Estimated time:** 10-15 minutes (with agent)  
**Risk level:** Medium (involves auth, be careful!)

</details>

---

## Advanced: Adaptive Workflows

The BEST workflows adapt based on outcomes.

### Example: Self-Healing Test Runner

```markdown
Agent: "Running tests..."
bash npm test

IF tests pass:
  → Done! Report success.

IF tests fail:
  → Read test output
  → Identify failure type
  
  IF "module not found":
    → bash npm install
    → Retry tests
  
  IF "type error":
    → Read failed test file
    → Edit code to fix types
    → Retry tests
  
  IF "assertion failed":
    → Read test + implementation
    → Determine if test is wrong OR code is wrong
    → Fix the incorrect one
    → Retry tests
  
  IF still failing after 3 attempts:
    → Report to human: "I need help"
```

This is ADAPTIVE. The workflow changes based on what happens.

---

## Workflow Performance Metrics

In the lab, we measure everything. Same for workflows:

| Metric | Good | Needs Improvement |
|--------|------|-------------------|
| **Tool Efficiency** | <20 tools/task | >50 tools/task |
| **Exploration Ratio** | 30-40% of tools | >60% (too much reading) |
| **First-Try Success** | >80% | <50% (poor planning) |
| **Verification Rate** | 100% (always test) | <80% (risky!) |
| **Human Intervention** | <10% checkpoints | >30% (too much babysitting) |

**Lab Rule #2:** If your agent needs constant supervision, your workflow design needs work.

---

## Summary: The Royal Decree on Workflows

**Princess Bubblegum's Laws of Agentic Workflows:**

1. **Explore before you execute** (know the lab before running experiments)
2. **Match workflow to task complexity** (don't overcomplicate simple things)
3. **Always verify changes** (tests are mandatory, not optional)
4. **Use checkpoints strategically** (approval for risky operations)
5. **Adapt based on outcomes** (rigid workflows are brittle workflows)
6. **Delegate to specialists** (use the right agent for the job)
7. **Measure and improve** (track metrics, optimize over time)

---

## Next Steps

Now that you understand workflow fundamentals, let's practice:

- **Next chapter:** Advanced delegation patterns
- **Practice:** Try the "forgot password" exercise above
- **Lab assignment:** Design a workflow for your current project

Remember: Science is about METHODOLOGY. Master the method, and the results will follow.

*This concludes our laboratory session. You may now proceed to Advanced Workflows.*

— Princess Bubblegum  
*Ruler of the Candy Kingdom, Head Scientist, Workflow Architect*

🔬 *"Everything is better with SCIENCE!"*
