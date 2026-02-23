---
name: agent-tasks
description: Run recurring subagent tasks for automation maintenance including git watch, mise maintenance, playbook reviews, and more
compatibility: opencode
---

# Skill: agent-tasks

## What I Do

Run recurring subagent tasks for automation maintenance. Manages the agent task system including git watch, mise maintenance, playbook reviews, and more.

## When to Use Me

Use this skill when you need to:
- Run daily/weekly automation tasks
- Check status of agent tasks
- View the automation dashboard
- Trigger specific agent checks

## Available Commands

### Run Specific Agent Tasks
```bash
agent-tasks finn      # Git commit watch
agent-tasks simon    # Playbook/Ollama review
agent-tasks jake     # Tool upgrades check
agent-tasks fern     # Mise maintenance
agent-tasks prismo   # Skill improvements
agent-tasks prisco   # Task tracking
```

### Run Combined Tasks
```bash
agent-tasks morning   # Daily check (finn + prisco)
agent-tasks weekly    # Full rotation (all agents)
```

### With AI Analysis
```bash
agent-tasks finn --ai     # AI-powered git analysis
agent-tasks weekly --ai  # Full AI-powered report
```

### View Dashboard
```bash
agent-tasks-dashboard        # Show status
agent-tasks-dashboard --logs # Show latest logs
```

## Schedule

| Time | Day | Agent | Task |
|------|-----|-------|------|
| 9:00 AM | Mon-Fri | Finn + Prisco | Morning check |
| 9:00 AM | Monday | Finn | Commit Watch |
| 9:00 AM | Tuesday | Simon | Playbook Review |
| 9:00 AM | Wednesday | Jake | Tool Upgrades |
| 9:00 AM | Thursday | Fern | Mise Maintenance |
| 9:00 AM | Friday | Prismo | Skill Improvements |
| 10:00 AM | Friday | ALL | Weekly Summary |

## Log Location

```
~/.local/share/agent-tasks/logs/
```

## Notes

- Requires scripts in `~/.local/bin/` or `~/.config/flake/scripts/`
- Logs are stored with date stamps for historical tracking
- The `--ai` flag triggers OpenCode CLI for AI-powered analysis
- Cron jobs run automatically on Nebulanix

## Related Skills

- `spawn-dashboard` - For monitoring Ollama/system status
- `migration-status` - For checking Nix migration status
