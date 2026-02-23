# Plan: Local Agent Task Automation

> Automating recurring subagent tasks without ZeroClaw

---

## Overview

Automated recurring tasks for subagents using local cron scheduling on **Nebulanix**.

---

## Machine Selection

| Factor | Nebulanix (M4 Pro) | Spacehound (M3) |
|--------|-------------------|-----------------|
| RAM | 48GB | 18GB |
| Availability | Always-on (Ollama server) | Sleeps |
| Decision | **Selected** | - |

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    NEBULANIX (Primary)                      │
├─────────────────────────────────────────────────────────────┤
│  Layer 1: Cron Scheduler                                    │
│  └── Triggers ~/.local/bin/agent-tasks at scheduled times  │
│                                                             │
│  Layer 2: agent-tasks Script                                │
│  └── Parses arguments, runs appropriate agent check        │
│                                                             │
│  Layer 3: Output Handling                                   │
│  └── Logs to ~/.local/share/agent-tasks/logs/              │
└─────────────────────────────────────────────────────────────┘
```

---

## Files Created

| File | Purpose |
|------|---------|
| `~/.local/bin/agent-tasks` | Main script |
| `~/.local/share/agent-tasks/logs/` | Log output directory |
| Crontab entries | Scheduled runs |

---

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

---

## Usage

```bash
# Run specific agent
agent-tasks finn
agent-tasks simon
agent-tasks jake
agent-tasks fern
agent-tasks prismo
agent-tasks prisco

# Run combinations
agent-tasks morning    # finn + prisco
agent-tasks weekly     # all agents

# View logs
ls -la ~/.local/share/agent-tasks/logs/
```

---

## Future Enhancements

| Enhancement | Description |
|-------------|-------------|
| **OpenCode CLI Trigger** | Run actual AI analysis instead of just scripts |
| **Better Notifications** | macOS notifications on completion |
| **Web Dashboard** | Simple HTML page showing last run results |
| **Slack/Discord Hook** | Post results to messaging |

---

## ZeroClaw Future

When ZeroClaw is ready:
1. Remove cron entries
2. Install ZeroClaw: `brew install zeroclaw`
3. Configure as daemon: `zeroclaw serve`
4. Use built-in scheduling and memory

---

## Changelog

| Date | Change | Author |
|------|--------|--------|
| 2026-02-19 | Initial implementation | Prismo |
| 2026-02-19 | Added cron scheduling | Prismo |
