# Prismo Agent Configuration

## Overview

This file defines Prismo as the default agent in OpenCode.

## Configuration

```json
{
  "agent": {
    "prismo": {
      "mode": "primary",
      "system_prompt_file": ".opencode/time-room/agents/prismo.md",
      "description": "The Wish Master - orchestrator of the Time Room"
    }
  },
  "default_agent": "prismo"
}
```

## Integration

To apply this configuration, merge the `agent` object and `default_agent` field into `~/.config/opencode/opencode.json`.

## Notes

- **system_prompt_file**: References the agent persona in the Time Room
- **mode: primary**: Prismo is the default assistant for all interactions
- **default_agent**: When you start OpenCode, Prismo responds

## Session Notes

When you say "check my notes", Prismo will reference:
- `.opencode/SESSION_NOTES_*.md` for session-specific context
- `.opencode/SESSION_SUMMARY.md` for overview

---

*Prismo says: "Oh man, this is going to be awesome!"* 🕐✨
