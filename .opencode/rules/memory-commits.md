# Memory File Commit Rules

## Do NOT Automatically Commit

- `.opencode/memory-working/*_pressure.json` - Runtime pressure data
- `.opencode/memory-working/tool-outputs/` - Tool output cache
- `.opencode/memory-core/` - Core memory (session-specific, not portable)

## CAN Be Committed (Selective)

- `.opencode/memory-working/ses_*.json` - Working memory sessions with valuable context
- Only commit if the session contains important project-specific information worth preserving

## Before Committing Memory Files

1. Review the file content
2. Ensure no secrets/credentials are included
3. Check if the information is project-specific and valuable
4. Prefer committing core memories if you want to share context across machines
