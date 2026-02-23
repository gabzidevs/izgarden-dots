# ✨ Prismo's Time Room Dashboard ✨

> *"Welcome to the Time Room, friend! Everything's chill in here."*

---

## 📺 THE TV

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░   ║
║   ░░░░░░░░░░░░░░░░ OLLAMA STATUS ░░░░░░░░░░░░░░░░░░░░░░░░░░░░   ║
║   ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░   ║
║                                                                  ║
║   🌌 Server: [ nebunanix / local ]     Status: [ ● / ○ ]        ║
║                                                                  ║
║   🤖 Active Model: [ _____________ ]                            ║
║                                                                  ║
║   📡 Remote: [ ○ Connected ]  Local: [ ○ Standby ]              ║
║                                                                  ║
║   💫 Last Wish: [ _________________________ ]                   ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

**Quick Check:**
```bash
oll status             # What's on the TV?
oll tune balanced      # Tune the cosmic frequency
```

---

## 🎭 AGENT ROSTER

| Agent | Status | Location | Current Quest |
|-------|--------|----------|---------------|
| 🔮 Prismo | `ACTIVE` | Time Room | Monitoring wishes |
| 🐕 Cosmo | `_____` | _________ | ______________ |
| 🌙 Luna | `_____` | _________ | ______________ |
| ⭐ ___ | `_____` | _________ | ______________ |

**Status Legend:**
- `ACTIVE` 🟢 - On task
- `RESTING` 🟡 - Idle
- `AWAY` 🔴 - Offline
- `ON_MISSION` 🟣 - Deep work

---

## 🖥️ SYSTEMS

### Nebulanix (nebulanix.local) - The Powerhouse
```
┌─────────────────────────────────────┐
│  🌐 48GB M4 Pro - Ollama Server     │
│  ─────────────────────────────────  │
│  CPU: [____]  RAM: [____]  GPU: [____] │
│  Uptime: ___________                │
│  Models: [ count ] loaded           │
└─────────────────────────────────────┘
```
> **IP Fallback:** `192.168.1.10` (may change - dynamic IP network)

### Spacehound - The Scout
```
┌─────────────────────────────────────┐
│  🔭 18GB M3 - Client + Fallback     │
│  ─────────────────────────────────  │
│  Remote: [ ● / ○ ]  Local: [ ● / ○ ] │
│  Last sync: ___________             │
└─────────────────────────────────────┘
```

---

## 📋 ACTIVE PLANS

*Pulled from `.opencode/plans/`*

| Plan | Status | Priority | Updated |
|------|--------|----------|---------|
| [ ] _______________ | `IN_PROGRESS` | 🔴 High | ___ |
| [ ] _______________ | `PLANNING` | 🟡 Medium | ___ |
| [ ] _______________ | `BLOCKED` | 🟠 Blocked | ___ |

**Plan Files:**
- `PLAN_HOME_CLEANUP.md`
- `PLAN_UPSTREAM_SYNC.md`

---

## ⚡ QUICK ACTIONS

```bash
# 🎬 Start Everything
oll server start && oll tune balanced

# 🔄 Switch Model
oll connect qwen3:8b

# 🧪 Test Connection
oll status

# 📦 Model Management
oll model list
oll model pull <model>
oll model rm <model>

# 🚀 Provision Systems
just provision spacehound
just provision nebulanix
```

---

## 🌈 COSMIC NOTES

> *"A wish can be a dangerous thing, buddy. That's why I gotta be careful."*

- Remote server preferred when available
- Local fallback for offline scenarios
- Check `.opencode/docs/scripts/OLLAMA_OPTIMIZATION.md` for deep dives
- Issues tracked in `.opencode/issues/`

---

*Last updated: _____________ by _____________*

```
    ✨ Have a good time in the Time Room! ✨
              🌟🌊💫🔮🌊🌟
```
