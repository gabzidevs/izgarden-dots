# Working Memory Quick Reference for Agents

## Core Tools

| Tool | Usage |
|------|-------|
| `core_memory_update` | `{"goal": "...", "progress": "...", "context": "..."}` |
| `core_memory_read` | No params - returns all memory |
| `working_memory_add` | `{"content": "...", "category": "thread|checkpoint|todo|decision", "metadata": {...}}` |
| `working_memory_clear` | No params |
| `working_memory_remove` | `{"id": "..."}` |

## Agent Patterns

### Save-Point Before Risky Work
```
Use working_memory_add to remember: checkpoint_<name> - <description>
Use working_memory_add to remember: can_rollback_to: git <commit>
```

### Track Conversation Threads
```
Use core_memory_update to set goal: <main task>
Use working_memory_add to remember: thread_<id> - <summary>
Use working_memory_add to remember: thread_<id2> - <summary>
```

### Delegate to Subagent
```
# Parent:
Use core_memory_update to set goal: <task>
Use working_memory_add to remember: delegating to <agent> with constraints: <list>

# Subagent:
Use core_memory_read to understand current task
```

### Track Progress
```
Use core_memory_update to set progress: [x] step1 [ ] step2 [ ] step3
```

### Compaction Recovery
```
# After compaction:
Use core_memory_read to confirm goal survived
Use core_memory_read to find any active threads
```

## Health Check

```bash
./scripts/system-diagnostics/checks/working-memory.sh
```

Or quick test:
```
opencode --tool core_memory_update '{"goal":"test","progress":"","context":""}' \
  && opencode --tool core_memory_read | grep test && echo "OK"
```
