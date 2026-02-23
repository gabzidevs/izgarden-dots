# 📚 The Enchiridion - Borrower's Log

> *"Welcome to the library! Here's who's writing what."*

This is the **borrower's record** - tracking which Adventure Time character is working on which chapter.

---

## Library Status

| Item | Status | Last Updated |
|------|--------|-------------|
| Location | `enchiridion/` (root!) | 2026-02-17 |
| Status | In Progress | - |
| Writers | 9 Agents | - |

---

## Writer Assignments

| Chapter | Writer | Status | Notes |
|---------|--------|--------|-------|
| **Part 1: AI Fundamentals** | Marceline | ✅ Done | All chapters complete! |
| → 01-what-is-an-ai-agent | Marceline | ✅ Done | |
| → 02-llm-basics | Marceline | ✅ Done | |
| → 03-nebulanix-stack | Marceline | ✅ Done | |
| **Part 2: OpenCode Deep Dive** | Jake | ✅ Done | All chapters complete! |
| → Architecture | Jake | ✅ Done | |
| → Tools | Jake | ✅ Done | |
| → MCP | Jake | ✅ Done | |
| → Config | Jake | ✅ Done | Already written! |
| **Part 3: Workflows** | Bubblegum | ✅ Done | |
| → 01-workflow-fundamentals | Bubblegum | ✅ Done | |
| **Part 4: Prompt Engineering** | Huntress | ✅ Done | |
| → 01-words-are-magic | Huntress | ✅ Done | |
| **Part 5: Integrations** | Finn | ✅ Done | Action-oriented! |
| → 01-local-llm-setup | Finn | ✅ Done | |
| → 02-local-llm-adventures | Finn | ✅ Done | Character cameos! |
| **Part 6: Ecosystem** | Simon | ✅ Done | |
| → 01-the-ancient-tools | Simon | ✅ Done | MCP chapter! |
| **Appendices** | BMO | ✅ Done | Interactive! |
| → 01-bmo-interactive-exercises | BMO | ✅ Done | All 6 exercises! |

---

## Delegation Plans & Possibilities

| Delegation Type | Description | Status | Notes |
|----------------|-------------|--------|-------|
| **Multi-agent tasks** | When one agent can call another | 🔮 Possible | BMO → Finn for git examples |
| **Chained writing** | Agent A writes, Agent B reviews | 🔮 Possible | Marceline → Shelby for verification |
| **Domain routing** | Auto-delegate based on keywords | 🔮 Possible | "git" → Finn, "nix" → Simon |
| **Prismo orchestration** | Complex tasks involve multiple agents | 🔮 Future | Complex chapters need coordination |

---

## How It Works

1. **Check out a chapter** - Claim it in this log
2. **Write in your voice** - Use your AT persona
3. **Add .notes.md** - Capture insights for future
4. **Check back in** - Update status when done

---

## The .notes.md System

Each chapter has a hidden `.notes.md` file for:

- 📝 **Conversation capture** - Insights from discussions
- 🔮 **Future ideas** - Things to add in next edition
- 📚 **References** - Links and resources
- 💡 **Inspiration** - Random ideas

**Example `.notes.md`:**
```markdown
# Notes for Part 1

## 2026-02-17 - Discussion with Finn
- Need to add more adventure metaphors
- Finn suggested: "Every variable is a sword!"

## Future Edition Ideas
- Add chapter on AI agents in cybersecurity
- Consider BMO for interactive exercises

## References
- https://promptingguide.ai/
```

---

## Adding New Chapters

When adding new content:

1. Create directory: `partX-topic/`
2. Add content: `01-intro.md`, etc.
3. Create `.notes.md` template:
   ```markdown
   # Notes for [Chapter Name]
   
   ## Discussion Log
   -
   
   ## Future Ideas
   -
   
   ## References
   -
   ```
4. Update this BORROWERS_LOG.md

---

## Pruning Caution ⚠️

**Before editing or deleting:**
- Check `.notes.md` files for saved insights
- Update this log if removing chapters
- Archive rather than delete when possible

---

## Related Documentation

- **Agents**: `.opencode/time-room/agents/`
- **Portability**: `.opencode/time-room/docs/PORTABILITY.md`
- **Undergarden**: `.opencode/docs/systems/UNDERGARDEN.md`
- **Claude's Box**: `.opencode/time-room/docs/CLAUDE_BOX.md` - Experimental ideas & variants

---

## Recent Contributions

### 2026-02-22 - Claude (AI Assistant) - Session 1

**Topic:** Qwen Model Optimization for Tool Calling

**What was added:**
- Documented Adventure Time-themed system prompts for Ollama Modelfiles
- Researched parameter tuning spectrum (Conservative → Medium → Ultra)
- Created reference guide for future Qwen template variants
- Explained decision framework for choosing prompt styles

**Location:** `.opencode/time-room/docs/CLAUDE_BOX.md`

**Key insight:** Princess Bubblegum's scientific precision makes a perfect system prompt for deterministic tool calling. Also, Lemongrab yelling "UNACCEPTABLE" at incorrect tool usage is hilarious but might actually work.

**Status:** Reference material for ongoing Ollama template optimization

---

### 2026-02-22 - Claude (AI Assistant) - Session 2

**Topic:** Enchiridion Chapter Completion & Model Creation

**What was added:**
- **Part 3** - Princess Bubblegum's Workflow Fundamentals chapter (`part3-agentic-workflows/01-workflow-fundamentals.md`)
- **Part 4** - Huntress Wizard's Prompt Engineering chapter (`part4-prompt-engineering/01-words-are-magic.md`)
- **Part 5** - Finn's Local LLM Adventures chapter with ALL character cameos (`part5-practical-integrations/02-local-llm-adventures.md`)
- **Part 6** - Simon's Ancient Tools (MCP) chapter (`part6-ecosystem/01-the-ancient-tools.md`)
- **Appendices** - BMO's Interactive Playground with 6 complete exercises (`appendices/01-bmo-interactive-exercises.md`)
- Created actual Ollama models: `qwen2.5-coder-tooled` and `qwen3-tooled`
- Built `oll template` command for easy model management

**Location:** `enchiridion/` (multiple chapters completed)

**Key insight:** Writing in character voices makes technical documentation genuinely fun to read! Each character's personality matches their technical domain perfectly - PB for workflows, Huntress for words, Finn for action, Simon for history, BMO for play.

**Status:** Major Enchiridion completion milestone - 4 new chapters + appendices (6,000+ lines)

---

*Borrowers log updated: 2026-02-22* 📚
