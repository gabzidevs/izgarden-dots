# OpenCode Configuration Master Guide

Your `~/.config/opencode/opencode.json` is the control center for agent behavior.

## Minimal Config (Copy-Paste Starter)

```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "ollama/qwen3:8b",
  "small_model": "ollama/gemma3:4b"
}
```

That's it! Everything else is optional.

## Full Reference Config

```json
{
  "$schema": "https://opencode.ai/config.json",
  
  // ═══════════════════════════════════════
  // MODEL SETTINGS
  // ═══════════════════════════════════════
  
  "model": "ollama/qwen3:8b",
  "small_model": "ollama/gemma3:4b",
  "temperature": 0.7,
  "top_p": 0.9,
  "default_agent": "build",
  "steps": 50,
  
  // ═══════════════════════════════════════
  // GLOBAL PERMISSIONS
  // ═══════════════════════════════════════
  
  "permission": {
    // Default: ask before acting
    "*": "ask",
    
    // File operations
    "read": { 
      "*": "allow",
      "*.env": "deny",
      "*secret*": "deny"
    },
    
    // Editing
    "edit": { 
      "*": "ask",
      "*.md": "allow"
    },
    
    // Shell commands
    "bash": { 
      "*": "ask",
      "git *": "allow",
      "ls *": "allow",
      "cat *": "allow",
      "rm *": "deny",
      "sudo *": "deny"
    },
    
    // Web
    "webfetch": "allow",
    "websearch": "allow",
    
    // Subagents
    "task": "allow"
  },
  
  // ═══════════════════════════════════════
  // CUSTOM AGENTS
  // ═══════════════════════════════════════
  
  "agent": {
    "build": {
      "mode": "primary",
      "description": "Full development agent with all tools",
      "tools": {
        "write": true,
        "edit": true,
        "bash": true,
        "read": true,
        "grep": true,
        "glob": true
      }
    },
    
    "plan": {
      "mode": "primary",
      "description": "Read-only planning and analysis",
      "permission": {
        "edit": "deny",
        "bash": "deny",
        "write": "deny"
      }
    },
    
    "explorer": {
      "mode": "subagent",
      "description": "Fast codebase exploration",
      "model": "ollama/gemma3:4b",
      "temperature": 0.3,
      "tools": {
        "read": true,
        "grep": true,
        "glob": true,
        "bash": false,
        "edit": false
      }
    }
  },
  
  // ═══════════════════════════════════════
  // MCP SERVERS
  // ═══════════════════════════════════════
  
  "mcp": {
    "github": {
      "type": "local",
      "command": ["npx", "-y", "@github/github-mcp-server"],
      "enabled": false
    },
    
    "context7": {
      "type": "remote",
      "url": "https://mcp.context7.com/sse",
      "enabled": false
    }
  },
  
  // ═══════════════════════════════════════
  // CONTEXT MANAGEMENT
  // ═══════════════════════════════════════
  
  "compaction": {
    "auto": true,
    "prune": true,
    "reserved": 10000
  },
  
  // ═══════════════════════════════════════
  // CUSTOM TOOLS
  // ═══════════════════════════════════════
  
  "tools": [
    {
      "name": "run-tests",
      "description": "Run the test suite",
      "command": "npm test",
      "timeout": 120000
    }
  ]
}
```

## Permission System Deep Dive

### Levels

| Level | Behavior |
|-------|----------|
| `allow` | Execute without asking |
| `ask` | Prompt for confirmation |
| `deny` | Refuse and explain why |

### Pattern Matching

```json
{
  "bash": {
    "*": "ask",           // Default: ask for everything
    "git *": "allow",     // Allow any git command
    "git push *": "ask",  // Except git push (override above)
    "rm *": "deny",       // Never allow rm
    "rm -rf /": "deny"    // Definitely not this!
  }
}
```

**Glob patterns work:**
- `*` - Match anything
- `*.js` - All JavaScript files
- `src/**/*` - Anything in src/ directory
- `test/*test.js` - Test files

### Examples by Use Case

**Conservative (Recommended for beginners):**
```json
{
  "permission": {
    "*": "ask",
    "read": "allow",
    "grep": "allow",
    "glob": "allow"
  }
}
```

**Balanced (Good default):**
```json
{
  "permission": {
    "*": "ask",
    "read": "allow",
    "bash": { "*": "ask", "git *": "allow", "ls *": "allow" },
    "edit": { "*": "ask", "*.md": "allow" }
  }
}
```

**Power User (Know what you're doing):**
```json
{
  "permission": {
    "*": "allow",
    "bash": { "rm *": "ask", "sudo *": "deny" }
  }
}
```

## Agent Configuration

### Primary vs Subagent

**Primary Agents** (invoked with Tab key):
- Have UI presence
- Can switch between them
- Usually one active at a time

**Subagents** (invoked with @ mention):
- Called by primary agents
- Specialized tasks
- Created as child sessions

### Creating Custom Agents

```json
{
  "agent": {
    "my-coder": {
      "mode": "subagent",
      "description": "Specialized for TypeScript coding",
      "model": "ollama/qwen3-coder:30b",
      "temperature": 0.2,
      "system_prompt": "You are an expert TypeScript developer...",
      "tools": {
        "read": true,
        "edit": true,
        "write": true
      }
    }
  }
}
```

**Usage:**
```
@my-coder Refactor this function to use async/await
```

## MCP Servers

### What They Do

MCP (Model Context Protocol) servers extend OpenCode with external capabilities:
- GitHub: Create PRs, read issues
- Sentry: Error tracking
- Database: Query databases
- Custom: Anything you build

### Enabling MCP

```json
{
  "mcp": {
    "github": {
      "type": "local",
      "command": ["npx", "-y", "@github/github-mcp-server"],
      "env": {
        "GITHUB_TOKEN": "your-token"
      },
      "enabled": true
    }
  }
}
```

### Remote MCP

```json
{
  "mcp": {
    "context7": {
      "type": "remote",
      "url": "https://mcp.context7.com/sse",
      "headers": {
        "Authorization": "Bearer token"
      },
      "enabled": true
    }
  }
}
```

## Context Management

### Compaction Options

```json
{
  "compaction": {
    // Automatically summarize old context
    "auto": true,
    
    // Remove old messages when full
    "prune": true,
    
    // Reserve tokens for new messages
    "reserved": 10000
  }
}
```

### When Context Gets Full

1. **Auto mode**: Summarizes old conversation
2. **Prune mode**: Removes oldest messages
3. **Reserved**: Keeps space for new inputs

## Common Configurations

### Local-Only Setup

```json
{
  "model": "ollama/qwen3:8b",
  "small_model": "ollama/gemma3:4b",
  "permission": {
    "webfetch": "deny",
    "websearch": "deny"
  }
}
```

### Research-Heavy Setup

```json
{
  "model": "anthropic/claude-sonnet-4-5",
  "small_model": "ollama/gemma3:4b",
  "permission": {
    "websearch": "allow",
    "webfetch": "allow"
  },
  "steps": 100
}
```

### High-Security Setup

```json
{
  "permission": {
    "*": "ask",
    "read": { "*": "allow", "*.env": "deny" },
    "bash": { "*": "ask", "rm *": "deny", "sudo *": "deny" },
    "write": "ask",
    "edit": "ask"
  }
}
```

## Troubleshooting

### "Permission denied for bash"
Add to config:
```json
{ "bash": { "*": "ask" } }
```

### "Model not found"
Check model name:
```json
{ "model": "ollama/qwen3:8b" }  // Not just "qwen3:8b"
```

### "Config not loading"
1. Check file location: `~/.config/opencode/opencode.json`
2. Validate JSON syntax
3. Check `$schema` is correct

### "Agent not found"
Ensure agent has `"mode": "primary"` or `"mode": "subagent"`

## Validation

Test your config:
```bash
# Check JSON is valid
cat ~/.config/opencode/opencode.json | python3 -m json.tool > /dev/null && echo "Valid JSON"

# Or use jq if installed
cat ~/.config/opencode/opencode.json | jq empty && echo "Valid JSON"
```

## Best Practices

1. **Start restrictive**, loosen as needed
2. **Use small_model** for quick tasks (saves money/API calls)
3. **Set steps limit** to prevent runaway loops
4. **Enable compaction** for long sessions
5. **Version control** your config: `cp ~/.config/opencode/opencode.json ./opencode.json.backup`

---

*Next: [Understanding Tools](../part2-opencode-deep-dive/tools-overview.md)*
