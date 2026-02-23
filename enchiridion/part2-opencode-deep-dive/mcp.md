# Chapter: MCP - Model Context Protocol

*"The protocol that connects everything to everything."*

— On the power of MCP

---

## What is MCP?

MCP (Model Context Protocol) is like a universal adapter. Just as USB-C connects any device to any other device, MCP connects AI models to any data source or tool.

Think of it this way:

```
Without MCP:
┌──────────┐     ┌──────────┐     ┌──────────┐
│   LLM    │ ←→  │  Hardcoded│ ←→  │   Tool   │
│          │     │  Routes   │     │          │
└──────────┘     └──────────┘     └──────────┘

With MCP:
┌──────────┐
│   LLM    │ ←→  ┌──────────┐
│          │     │    MCP    │ ←→ Any tool/data
└──────────┘     │   Client  │
                ──────────┘ └
                      │
              ┌───────┼───────┐
              ▼       ▼       ▼
          ┌──────┐ ┌─────┐ ┌──────┐
          │Files │ │Git  │ │APIs  │
          └──────┘ └─────┘ └──────┘
```

---

## Why MCP Matters

### The Problem

Before MCP, every integration was custom:

- Want GitHub integration? → Build custom API
- Want database access? → Build custom connector
- Want filesystem access? → Build custom handler

Each integration was:
- **Time-consuming** to build
- **Inconsistent** in behavior
- **Not reusable** across models

### The MCP Solution

MCP standardizes how models interact with tools:

- **One protocol** for all integrations
- **Client-server** architecture
- **Bidirectional** communication
- **Tool discovery** at runtime

---

## MCP Architecture

### Three Main Components

```
┌─────────────────────────────────────────────────┐
│                   Host                          │
│  (OpenCode, Cursor, Claude Desktop, etc.)      │
├─────────────────────────────────────────────────┤
│              MCP Client                          │
│  Connects to servers, manages sessions          │
├─────────────────────────────────────────────────┤
│              MCP Server                          │
│  Provides tools/resources                        │
├─────────────────────────────────────────────────┤
│              Local Resources                     │
│  Files, databases, git repos                    │
└─────────────────────────────────────────────────┘
```

### Communication Flow

```
1. Host starts MCP Client
2. Client connects to Server
3. Server advertises capabilities (tools, resources)
4. Host shows user available tools
5. User selects tool
6. Client sends request to Server
7. Server executes and returns result
8. Result goes back to LLM
```

---

## MCP in Practice

### What MCP Servers Provide

| Type | Example | What It Gives |
|------|---------|----------------|
| **Tools** | filesystem | read, write, edit files |
| **Resources** | git | commit history, diffs |
| **Prompts** | code-review | Reusable prompt templates |

### Example: Filesystem Server

```
MCP Server: Filesystem
├── Tools:
│   ├── read_file(path)
│   ├── write_file(path, content)
│   ├── list_directory(path)
│   └── search_files(pattern)
└── Resources:
    └── file://{path}
```

### Example: Git Server

```
MCP Server: Git
├── Tools:
│   ├── get_status(repo_path)
│   ├── get_diff(repo_path)
│   ├── get_log(repo_path, count)
│   └── commit(repo_path, message)
└── Resources:
    └── git://{repo}/commit/{sha}
```

---

## Using MCP with OpenCode

### Configuration

MCP servers are configured in your OpenCode config:

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/allowed"]
    },
    "git": {
      "command": "uvx",
      "args": ["mcp-server-git", "--repository", "/path/to/repo"]
    }
  }
}
```

### Available Servers

There are MCP servers for almost everything:

| Server | Purpose |
|--------|---------|
| filesystem | Read/write files |
| git | Git operations |
| github | GitHub API |
| postgres | Database queries |
| puppeteer | Browser automation |
| sequential-thinking | Chain reasoning |

### Finding Servers

Search for "MCP Server" on:
- GitHub
- npm (package: `@modelcontextprotocol/server-*`)
- Python (package: `mcp-server-*`)

---

## Building Custom MCP Servers

### Basic Structure

```python
from mcp.server import Server
from mcp.types import Tool
import asyncio

server = Server("my-custom-server")

@server.list_tools()
async def list_tools():
    return [
        Tool(
            name="my_tool",
            description="Does something useful",
            inputSchema={
                "type": "object",
                "properties": {
                    "param": {"type": "string"}
                }
            }
        )
    ]

@server.call_tool()
async def call_tool(name, arguments):
    if name == "my_tool":
        # Do something
        return result
```

### Registering Tools

```python
@server.list_tools()
async def list_tools():
    return [
        Tool(
            name="query_database",
            description="Run SQL query",
            inputSchema={
                "type": "object",
                "properties": {
                    "query": {"type": "string", "description": "SQL to run"}
                }
            }
        )
    ]
```

---

## MCP Best Practices

### Security

- **Scope permissions** - Don't give unlimited access
- **Validate inputs** - Sanitize all tool parameters  
- **Audit logging** - Track what tools are used

### Performance

- **Lazy loading** - Only load tools when needed
- **Caching** - Cache expensive operations
- **Batching** - Group related operations

### Error Handling

- **Graceful failures** - Return useful errors
- **Timeouts** - Don't hang forever
- **Retry logic** - Handle transient failures

---

## MCP vs Traditional Tools

| Aspect | Traditional Tools | MCP |
|--------|-----------------|-----|
| Discovery | Static list | Dynamic at runtime |
| Configuration | Hardcoded | Declarative |
| Standardization | None | MCP protocol |
| Reusability | Per-model | Cross-model |
| Extensibility | Fork to add | Add server |

---

## The Future of MCP

MCP is growing fast:

### Current State
- 100+ community servers
- Multiple host implementations
- Official spec from Anthropic

### Coming Soon
- More cloud integrations
- Better authentication
- Enhanced debugging
- Standardized UI components

*"This is how everything connects. The protocol is the glue."*

---

## Summary

**MCP (Model Context Protocol):**
- Standardizes tool/model communication
- Enables reusable integrations
- Client-server architecture
- Dynamic tool discovery

**Why use it:**
- Build once, use everywhere
- Share tools across models
- Standardized interface
- Growing ecosystem

**Next steps:**
1. Try existing MCP servers
2. Build custom servers for your needs
3. Join the MCP community

---

*Previous: [Tools Chapter](tools.md)*  
*Next: [Configuration Guide](configuration-guide.md)*
