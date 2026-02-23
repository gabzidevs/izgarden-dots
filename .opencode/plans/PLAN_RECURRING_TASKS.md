# Recurring Tasks for Subagents

> Automated task assignments for continuous system improvement
> *"Everything stays right where you left it"* — Marceline

---

## Agent Health Checks (Weekly)

| Check | Agent | Description |
|-------|-------|-------------|
| **Agent Roster** | Prismo | Verify all AT agents are in `agents.nix` and callable via task tool |
| **Task Tool Test** | Prismo | Run quick test delegation to each agent to verify connectivity |
| **Config Sync** | Prismo | Check `agents.nix` matches agent files in `.opencode/time-room/agents/` |

### Health Check Workflow
```
1. Read agents.nix → get list of configured subagents
2. For each subagent: test delegation with minimal prompt
3. Log any "Unknown agent type" errors
4. Report missing agents or config drift
5. Suggest fixes if issues found
```

### Why This Matters

We learned the hard way:
- New agents added to `.opencode/time-room/agents/` but NOT in `agents.nix` → "Unknown agent type" errors
- Agent files deleted but config remains → broken references
- Missing agents discovered too late during actual delegation

---

## Agent: Finn (Git Operations)

### Recurring Tasks

| Task | Frequency | Description |
|------|-----------|-------------|
| **Commit Watch** | Daily | Check for uncommitted changes, present dashboard |
| **Commit Plan** | Weekly | Propose commit structure for pending changes |
| **Branch Cleanup** | Bi-weekly | Identify stale branches, propose cleanup |

### Workflow
```
1. Run: git status --short
2. Categorize changes (feat/fix/chore/docs)
3. Present options to user
4. On approval: commit + push to fork
```

---

## Agent: Fern (Dotfiles & Configs)

### Recurring Tasks

| Task | Frequency | Description |
|------|-----------|-------------|
| **Mise Maintenance** | Weekly | Check for version updates, regression checks |
| **System Re-provisioning** | Monthly | Test provisioning on target machines |
| **Config Drift Check** | Weekly | Compare flake outputs vs actual configs |

### Workflow
```
1. Check mise tool versions: mise outdated
2. Research changelogs for regressions
3. Update versions in mise.nix
4. Test provisioning: just provision <target>
```

---

## Agent: Simon (Nix/NixOS & Ollama)

### Recurring Tasks

| Task | Frequency | Description |
|------|-----------|-------------|
| **Playbook Review** | Weekly | Review and improve Ollama playbooks |
| **Model Updates** | Monthly | Check new Ollama releases, test models |
| **Performance Tuning** | Bi-weekly | Optimize ollama-optimize presets |

### Workflow
```
1. Check ollama version: ollama --version
2. Review PLAN_OLLAMA_LOCAL_SWITCH.md for improvements
3. Test model performance on nebulanix/spacehound
4. Update recommendations
```

---

## Agent: Jake (CLI Tools & TUI)

### Recurring Tasks

| Task | Frequency | Description |
|------|-----------|-------------|
| **Tool Upgrades** | Weekly | Check script/tool updates, propose improvements |
| **TUI Improvements** | Bi-weekly | Enhance existing TUIs, propose new ones |
| **Automation Review** | Monthly | Identify new automation opportunities |

### Workflow
```
1. List scripts in ~/bin or ~/.config/flake/scripts/
2. Check for new tool versions (gum, fzf, etc.)
3. Propose TUI enhancements (gum choose, fzf menus)
4. Present ideas to user
```

---

## Agent: Prismo (Orchestration)

### Recurring Tasks

| Task | Frequency | Description |
|------|-----------|-------------|
| **Skill Improvements** | Weekly | Review agent prompts, identify gaps |
| **Task Delegation** | Daily | Ensure tasks are properly delegated |
| **Agent Health Check** | Weekly | Verify agents have context/resources |

### Workflow
```
1. Review agent prompts in .opencode/time-room/agents/
2. Identify improvement areas
3. Create skill proposals
4. Update orchestration guidelines
```

---

## Agent: Prisco (Task Tracking)

### Recurring Tasks

| Task | Frequency | Description |
|------|-----------|-------------|
| **Task Status Review** | Daily | Update task status, identify blockers |
| **Followup Handling** | As needed | Handle user mid-task modifications |
| **Escalation** | Weekly | Report stuck tasks to Prismo |

---

## Current Recurring Schedule

| Day | Agent | Task |
|-----|-------|------|
| Monday | Finn | Commit Watch |
| Tuesday | Simon | Playbook Review |
| Wednesday | Jake | Tool Upgrades |
| Thursday | Fern | Mise Maintenance |
| Friday | Prismo | Skill Improvements |
| Daily | Prisco | Task Status |

---

## Task Templates

### Finn: Commit Watch Template
```bash
# Present dashboard
echo "=== UNCOMMITTED CHANGES ==="
git status --short
git diff --stat

# Categorize
echo "=== RECOMMENDATION ==="
# (feat/fix/chore/docs)

# Ask user
```

### Fern: Mise Maintenance Template
```bash
# Check outdated
mise outdated

# Research
# - Check release notes
# - Check known regressions

# Recommend
```

### Simon: Playbook Review Template
```bash
# Review playbook
# - Check for outdated commands
# - Identify redundant steps
# - Add new automation

# Test relevant scripts
```

### Jake: Tool Upgrade Template
```bash
# List tools
ls -la ~/.config/flake/scripts/

# Check versions
which gum && gum --version
which fzf && fzf --version

# Propose TUI improvements
```

### Prismo: Skill Improvement Template
```bash
# Review agents
ls -la .opencode/time-room/agents/

# Identify gaps
# - Missing capabilities
# - Outdated prompts
# - New tool integrations

# Create proposal
```

---

## Changelog

| Date | Change | Author |
|------|--------|--------|
| 2026-02-19 | Initial recurring task plan | Prismo |
