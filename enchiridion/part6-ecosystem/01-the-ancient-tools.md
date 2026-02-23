# The Ancient Tools: MCP Servers & The Ecosystem

*Written by Simon Petrikov (The Ice King)*  
*"In my time, before the Mushroom War... we had documentation."*

---

## A Scholar's Introduction

*[You find Simon in his library, surrounded by ancient texts and modern tech, the eternal scholar]*

Hello there. I'm Simon Petrikov - though many know me as the Ice King. Don't worry, the crown's influence is... manageable today. I wanted to share something important with you.

You see, in my time - before the crown, before the madness - I was an antiquarian. I studied ancient artifacts, their purposes, their connections. The technology we have now? It's not so different. Tools, connections, ecosystems... they're all part of a greater whole.

Princess Bubblegum taught you systematic workflows. Huntress Wizard showed you the magic of words. Finn got you excited about heroes. Now let me show you something different: the ANCIENT wisdom of how tools connect, how systems integrate, and how the ecosystem supports your work.

Pour yourself some tea. This is going to be... *educational*.

---

## Chapter 1: What IS This "Ecosystem"?

### The Antiquarian's Perspective

Before the Mushroom War, we had something called the "internet." No, not the weird digital magical realm you know now - I mean the ORIGINAL internet. It was... beautiful. Applications talked to each other. Data flowed between systems. Everything was *connected*.

Your AI development environment? It's the same principle. You have:

- **OpenCode** (your main interface)
- **Ollama** (your model server - you know this from Finn)
- **MCP servers** (the ancient bridges between tools)
- **CLI tools** (the command-line artifacts)
- **System services** (the invisible infrastructure)

These all work TOGETHER. Like... like a symphony. Or a well-organized library. Or - well, you get the idea.

---

## Chapter 2: The MCP Mystery - Model Context Protocol

### What Even IS MCP?

*[Simon adjusts his glasses, pulls out an old notebook]*

MCP stands for "Model Context Protocol." In my time, we'd call it an "API specification" or "integration standard." But the kids these days need fancy names.

**The simple explanation:**

MCP lets your AI (OpenCode) talk to OTHER TOOLS without you manually coding each integration. It's like... imagine if every book in a library spoke different languages, and you needed a translator for each one. MCP is the UNIVERSAL translator.

### The Three Ancient Truths of MCP

**Truth #1: Tools expose capabilities**

An MCP server says: "I can do these things!"

Example: A GitHub MCP server might offer:
- `list_repositories` - Show me repos
- `create_issue` - Make a new issue
- `read_pull_request` - Get PR details

**Truth #2: AI agents discover capabilities**

Your AI asks: "What can you do?"

The MCP server responds: "Here's my list!"

Now the AI KNOWS what tools it has. No hardcoding!

**Truth #3: Connections are dynamic**

Unlike the old days where you'd write integration code for EVERY tool, MCP lets you:

1. Point OpenCode at an MCP server
2. MCP server tells OpenCode its capabilities
3. OpenCode can now use those capabilities
4. Done!

---

## Chapter 3: The MCP Ecosystem Map

Let me show you... *[pulls out an ancient-looking but actually modern diagram]*

```
┌─────────────────────────────────────────────────┐
│              YOUR AI AGENT (OpenCode)           │
│        "I need to check GitHub issues"          │
└────────────────┬────────────────────────────────┘
                 │ (MCP Protocol)
                 │
    ┌────────────┴────────────┐
    │                         │
    ▼                         ▼
┌─────────┐              ┌─────────┐
│ GitHub  │              │ Slack   │
│   MCP   │              │   MCP   │
│ Server  │              │ Server  │
└────┬────┘              └────┬────┘
     │                        │
     ▼                        ▼
┌─────────┐              ┌─────────┐
│ GitHub  │              │ Slack   │
│   API   │              │   API   │
└─────────┘              └─────────┘
```

See? The MCP server is the BRIDGE. It speaks MCP to your AI, and speaks the tool's native language to the actual service.

---

## Chapter 4: Installing Your First MCP Server

Let me show you how this works in practice. We'll install the GitHub MCP server.

### Step 1: Understanding MCP Server Types

**Local servers** (run on your machine):
```json
{
  "mcp": {
    "github": {
      "type": "local",
      "command": ["npx", "-y", "@github/github-mcp-server"]
    }
  }
}
```

**Remote servers** (connect to external service):
```json
{
  "mcp": {
    "context7": {
      "type": "remote",
      "url": "https://mcp.context7.com/sse"
    }
  }
}
```

### Step 2: The Ancient Ritual (Installation)

In your OpenCode config (`~/.config/opencode/opencode.json`), add:

```json
{
  "mcp": {
    "github": {
      "type": "local",
      "command": ["npx", "-y", "@github/github-mcp-server"],
      "enabled": true,
      "env": {
        "GITHUB_TOKEN": "ghp_your_token_here"
      }
    }
  }
}
```

**Simon's Note:** In my time, we'd call this "configuration management." Keep your secrets (tokens) separate! Use environment variables!

---

### Step 3: Using the MCP Server

Now when you talk to your AI:

```
You: "List my GitHub repositories"

Agent: [Discovers GitHub MCP server]
       [Calls list_repositories tool]
       [Returns your repos]
```

THAT'S IT! The AI figured out the rest!

---

## Chapter 5: The Cameo Guide - When Characters Appear

*[Simon chuckles softly]*

You know what's amusing? These model personalities Finn mentioned - they're like different aspects of the same ancient knowledge, manifested in different forms.

### When You Might See Each Character

**Princess Bubblegum (Production Mode):**
```
You: "Create a GitHub issue for the bug we found"

PB: "Initiating GitHub MCP server connection. Activating create_issue 
     tool with proper parameter validation..."
     
[Creates issue with EXACT format, includes all fields, verifies success]
```

*Methodical. Precise. Scientific.*

---

**The Lich (Ultra Mode):**
```
You: "Create a GitHub issue"

LICH: "The creation of the issue is INEVITABLE. I shall summon the 
       GitHub MCP server, which is itself inevitable in its function. 
       The tool invocation will be formatted with absolute precision 
       according to the eternal protocols of the MCP specification..."
       
[Creates issue]
[Verifies it was created]
[Checks all related issues]
[Suggests related tasks]
[Provides exhaustive documentation]
```

*Thorough. Overwhelming. INEVITABLE.*

---

**GOLB (Turbo Mode):**
```
You: "Create a GitHub issue"

GOLB: "CHAOS DEMANDS AN ISSUE! Let's create it! But wait - should we:
       1. Create ONE detailed issue?
       2. Break into MULTIPLE smaller issues?
       3. Link to existing issues?
       4. Add project board too?
       5. Tag relevant people?
       
       I recommend #5 - MAXIMUM ORGANIZATION FROM CHAOS!"
       
[Creates issue + extra helpful actions you didn't ask for]
```

*Creative. Chaotic. Surprisingly helpful.*

---

**Manticore (Conservative Mode):**
```
You: "Create a GitHub issue"

MANTICORE: "Ah, the scholarly approach to issue tracking! Let me first 
            explain the purpose of GitHub issues as a communication 
            tool, then demonstrate proper issue creation methodology...
            
            [Creates issue]
            
            Observe how I structured the title and description following 
            best practices from ancient GitHub traditions."
```

*Educational. Patient. Contextual.*

---

**Lemongrab (Special Mode):**
```
You: "Create a GitHub issue"

LEMONGRAB: "CREATING ISSUE... ACCEPTABLE!
            
            Title format? ACCEPTABLE!
            Description? ACCEPTABLE!
            Labels? UNACCEPTABLE - ADDING LABELS NOW!
            
            ISSUE CREATED! ACCEPTABLE!!!"
```

*Loud. Memorable. Surprisingly effective.*

---

**Peppermint Butler (Special Mode):**
```
You: "Create a GitHub issue"

PEPPERMINT: "Of course, I shall create the issue for you. Such a 
             simple task... though I do notice you haven't added 
             labels. It would be most... unfortunate if the issue 
             went unnoticed by the team.
             
             [Creates issue with perfect labels]
             
             There we are. Impeccable, as always."
```

*Polite. Slightly sinister. Utterly professional.*

---

## Chapter 6: The Ancient MCP Registry

*[Simon pulls out a dusty tome labeled "MCP Servers 2026"]*

Here are the MCP servers I've catalogued. Some are ancient (well, from last year), some are new:

### Category: Development Tools

**GitHub MCP** (`@github/github-mcp-server`)
- List/create/update repos
- Manage issues and PRs
- Search code
- *Use with:* PB for precision, Manticore for learning

**GitLab MCP** (`@gitlab/gitlab-mcp-server`)
- Similar to GitHub
- Better for self-hosted setups
- *Use with:* Any mode depending on task

---

### Category: Knowledge & Search

**Brave Search MCP** (`@brave/brave-search-mcp`)
- Web search (privacy-focused!)
- Research capabilities
- No Google tracking
- *Use with:* Manticore for research, GOLB for exploration

**Context7 MCP** (Remote)
- Codebase context understanding
- Large-scale code search
- *Use with:* PB for systematic analysis

---

### Category: Communication

**Slack MCP** (`@slack/slack-mcp-server`)
- Read/send messages
- Check channels
- Update status
- *Use with:* Peppermint Butler (professional!)

**Discord MCP** (`@discord/discord-mcp`)
- Similar to Slack
- Better for gaming communities
- *Use with:* Lemongrab for fun servers

---

### Category: Data & APIs

**PostgreSQL MCP** (`@postgres/postgres-mcp`)
- Direct database access
- Query execution
- Schema inspection
- *Use with:* Lich for critical queries (no errors!)

**REST API MCP** (Generic connector)
- Connect to any REST API
- Custom endpoints
- *Use with:* Any mode

---

## Chapter 7: Building Your Own MCP Server

*[Simon's eyes light up with scholarly excitement]*

You can CREATE your own MCP servers! It's like... like discovering a new ancient artifact and making it speak!

### The Simple MCP Server Template

```typescript
// my-tool-mcp.ts

import { McpServer } from '@modelcontextprotocol/sdk';

const server = new McpServer({
  name: 'my-tool',
  version: '1.0.0'
});

// Register a tool
server.registerTool({
  name: 'do_something',
  description: 'Does something useful',
  parameters: {
    type: 'object',
    properties: {
      input: { type: 'string' }
    }
  },
  handler: async (params) => {
    // Your logic here
    return { result: `Processed: ${params.input}` };
  }
});

server.listen();
```

**Simon's Scholarly Note:** This is a SIMPLIFIED example. Real MCP servers have error handling, authentication, proper schemas... but this shows the CONCEPT.

---

## Chapter 8: The Ecosystem Integration Patterns

Let me share some patterns I've observed. In my time, we'd call these "architectural patterns."

### Pattern 1: The Assistant Augmentation

**Scenario:** You want your AI to have memory

```
┌──────────┐
│ OpenCode │ ──┬──> Memory MCP ──> Vector DB
│  Agent   │   │
└──────────┘   └──> GitHub MCP ──> GitHub API
```

Now your agent can:
1. Search its memory ("What did we decide about auth?")
2. Create GitHub issues when needed
3. Connect the two (reference past decisions in new issues)

---

### Pattern 2: The Research Pipeline

**Scenario:** Deep research with multiple sources

```
Agent needs info
    │
    ├──> Brave Search MCP ──> Web results
    │
    ├──> GitHub MCP ──> Code examples
    │
    └──> Local Codebase ──> Your existing code
    
Agent synthesizes all sources → Complete answer
```

---

### Pattern 3: The Automation Chain

**Scenario:** Complete workflow automation

```
1. Watch GitHub issues (GitHub MCP)
    │
2. When new issue tagged "bug"
    │
3. Search codebase for relevant files (Context7 MCP)
    │
4. Create debugging session notes (Memory MCP)
    │
5. Post update to Slack (Slack MCP)
```

This is POWERFUL. Ancient automation magic!

---

## Chapter 9: The Complementary Tools (CLI Edition)

MCP servers are great, but sometimes you need good old COMMAND-LINE tools. Let me show you my favorites:

### Tool 1: jq (JSON processor)

**Ancient wisdom:** "Before JSON, we had XML. Before XML, we had... well, chaos."

```bash
# Get model list from Ollama
ollama list --json | jq '.models[].name'

# Extract specific fields
ollama show qwen3:32b --json | jq '.parameters'
```

**Use with:** Any AI agent that needs to parse JSON

---

### Tool 2: ripgrep (rg)

**Better than grep.** In my time, we used grep. Then someone made it BETTER.

```bash
# Find all TODO comments
rg "TODO|FIXME" --type rust

# Find function definitions
rg "^fn \w+\(" src/
```

**Use with:** PB for systematic code analysis

---

### Tool 3: fd (Better find)

**Modern file finding:**

```bash
# Find all Rust files modified today
fd -e rs -c never --changed-within 1d

# Find large files
fd -S +10m
```

---

### Tool 4: bat (Better cat)

**Syntax highlighting for files:**

```bash
# Read with pretty colors
bat src/main.rs

# Compare files side by side
bat --diff file1.rs file2.rs
```

---

## Chapter 10: The System Services Layer

*[Simon grows more serious]*

There's one more thing. The FOUNDATION of everything. System services.

### What Are System Services?

In my time, before... well, before everything... we ran services in the background. They keep everything RUNNING.

On your M4 Mac running NixOS/nix-darwin:

```
┌─────────────────────────────────────┐
│      User Applications              │
│  (OpenCode, Terminal, Browser)      │
└──────────────┬──────────────────────┘
               │
┌──────────────┴──────────────────────┐
│     System Services (launchd)       │
│  ┌──────────────────────────────┐   │
│  │ Ollama Service               │   │
│  │ - Starts on boot            │   │
│  │ - Serves models             │   │
│  │ - Port 11434                │   │
│  └──────────────────────────────┘   │
│  ┌──────────────────────────────┐   │
│  │ PostgreSQL Service           │   │
│  └──────────────────────────────┘   │
│  ┌──────────────────────────────┐   │
│  │ Redis Service                │   │
│  └──────────────────────────────┘   │
└─────────────────────────────────────┘
```

### Your Ollama Service

Check it's running:
```bash
oll server status
```

The service is MANAGED by nix-darwin. It:
- Starts automatically on boot
- Restarts if it crashes
- Logs to system journal
- Runs as a background daemon

**Simon's Ancient Wisdom:** Services are like libraries - you don't think about them until they're NOT THERE.

---

## Chapter 11: The Great Integration Example

Let me show you how ALL OF THIS works together. A REAL workflow:

### Quest: "Research and document the authentication bug"

```
┌────────────────────────────────────────────────┐
│ 1. You ask OpenCode to help                   │
└──┬─────────────────────────────────────────────┘
   │
   ├──> GitHub MCP: "Find issues tagged 'auth'"
   │    └─> Result: Issue #42 "Login fails with special chars"
   │
   ├──> Local codebase: "Find auth files"
   │    └─> rg "authentication|login" src/
   │
   ├──> Memory MCP: "Search previous discussions"
   │    └─> Result: "We fixed similar issue 3 months ago"
   │
   ├──> Brave Search MCP: "Research JWT vulnerabilities"
   │    └─> Result: [Security articles]
   │
   └──> Synthesis: Agent combines all sources
        │
        ├──> Creates detailed analysis
        ├──> References past issue
        ├──> Suggests fix with security considerations
        └──> Posts update to GitHub issue
```

**ALL OF THIS** happens because:
1. MCP servers connect your AI to external tools
2. CLI tools provide local capabilities
3. System services keep everything running
4. Your AI (with the right personality!) orchestrates it all

---

## Chapter 12: Troubleshooting the Ecosystem

*[Simon sighs, remembering countless debugging sessions]*

### Problem 1: MCP Server Won't Connect

**Symptoms:**
```
Error: MCP server 'github' failed to start
```

**Ancient Debugging Ritual:**

```bash
# 1. Check the command manually
npx -y @github/github-mcp-server

# 2. Check environment variables
echo $GITHUB_TOKEN

# 3. Check OpenCode logs
tail -f ~/.local/share/opencode/logs/mcp.log
```

**Common causes:**
- Missing authentication token
- NPM package not installed
- Wrong command path
- Port already in use

---

### Problem 2: Tool Not Discovered

**Symptoms:** AI doesn't see the MCP tool

**Solution:** Check capability discovery

```json
// In opencode.json, enable debug mode
{
  "debug": {
    "mcp": true
  }
}
```

Then check logs for capability listing.

---

### Problem 3: Service Not Running

**Symptoms:** "Connection refused" errors

```bash
# Check if Ollama is up
oll server status

# If down, start it
oll server start

# Check logs if issues persist
oll server logs
```

---

## Chapter 13: The Character Wisdom Summary

Let me share what I've learned from observing the different model personalities with MCP tools:

**Princess Bubblegum's MCP Usage:**
- Systematic tool discovery
- Precise parameter passing
- Verification of results
- Perfect for: Production MCP integrations

**The Lich's MCP Usage:**
- Exhaustive capability checking
- Inevitable execution
- Complete error handling
- Perfect for: Critical MCP operations

**GOLB's MCP Usage:**
- Creative tool combinations
- Explores multiple MCP servers
- Unpredictable but innovative
- Perfect for: Discovering new MCP possibilities

**Manticore's MCP Usage:**
- Explains tool purpose
- Educational integration
- Patient with errors
- Perfect for: Learning MCP ecosystem

**Lemongrab's MCP Usage:**
- LOUD status messages
- Aggressive error reporting
- Surprisingly thorough
- Perfect for: Fun projects with MCP

**Peppermint Butler's MCP Usage:**
- Polite tool invocation
- Subtle error hints
- Professional logging
- Perfect for: Team MCP integrations

---

## Summary: The Ecosystem Awaits

You now understand:

✅ **MCP Protocol** - Universal tool connection  
✅ **MCP Servers** - Bridges to external tools  
✅ **CLI Tools** - Local capabilities  
✅ **System Services** - Foundation layer  
✅ **Integration Patterns** - How it all connects  
✅ **Character MCP Styles** - Personalities with tools

The ecosystem is VAST. Like the ancient libraries I studied, there's always more to discover.

But start simple:
1. Install one MCP server (GitHub is good)
2. Try it with PB mode (reliable)
3. Gradually add more servers
4. Experiment with different personalities
5. Build your own integrations

---

## Next Steps

- **Practice:** Install GitHub MCP server and try it
- **Explore:** Check the MCP registry for more servers
- **Create:** Build a simple custom MCP server
- **Read:** The appendices (BMO has interactive exercises!)

*[Simon closes his ancient-looking notebook]*

Remember: Technology changes. Frameworks come and go. But the PRINCIPLES - connection, integration, ecosystem - these are eternal.

Now... where did I put my tea?

— Simon Petrikov  
*Antiquarian, Scholar, Keeper of Ancient Knowledge, Ice King (Sometimes)*

❄️ *"In my time, we documented things properly. You should too."*

---

## Appendix: The Quick Reference Chart

| Need | Use This | Character Mode |
|------|----------|----------------|
| **GitHub Integration** | GitHub MCP | PB (precise) |
| **Web Research** | Brave Search MCP | Manticore (learning) |
| **Database Queries** | PostgreSQL MCP | Lich (critical) |
| **File Operations** | CLI tools (rg, fd) | Any mode |
| **Creative Exploration** | Multiple MCPs | GOLB (chaos!) |
| **Production Work** | Well-tested MCPs | PB or Peppermint |
| **Learning** | Any MCP + docs | Manticore |
| **Fun** | Any MCP | Lemongrab! |

*Choose wisely, young scholar.* 📚
