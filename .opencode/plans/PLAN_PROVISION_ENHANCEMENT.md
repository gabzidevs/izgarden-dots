# Plan: just-provision Enhancement

**Status**: Phase 1–5 COMPLETE. Phase 6 (future) pending.

---

## Goal

Transform `just-provision` into a powerful, modular provisioning tool:
- Absorb `remote-provision` SSH logic (deleted)
- Follow `oll_core` patterns (modular, TUI-first, host-aware)
- Add `-b/--branch` for git branch management before provisioning
- Add `--heal=ai` for AI-guided healing via `opz`
- Foundation for future parallel remote provisioning

---

## Design Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| `remote-provision` fate | Delete entirely | Absorbed into `just-provision` |
| Auto-detection default | Auto-detect current host | No manual spec needed for local |
| opz fallback | Auto-fallback to git if opz fails | Resilient, works without Claude Code |
| Conflict handling | Let opz handle, error out afterward | Needs human attention |
| Structure | Single file (not `just_provision_core/`) | Single-purpose, simpler to maintain |

---

## Completed Phases

### Phase 1: Preparation ✅
- Deleted `scripts/remote-provision`
- Extracted SSH logic into `just-provision`

### Phase 2: Core Refactoring ✅
- UI helpers: `has_gum()`, `print_status()` matching `oll_core` patterns
- Enhanced `detect_machine()` (SSH-aware, case-insensitive)
- mDNS + IP fallback in `resolve_ssh_target()`

### Phase 3: Git Branch Management ✅
- `pull_branch()` function — opz first, git fallback
- `-b` = pull current branch; `-b <name>` = pull specific branch
- Branch pull is FIRST operation before anything else

### Phase 4: Remote Provisioning ✅
- `provision_remote()` passes branch flag through SSH
- `--local` flag prevents recursion on remote host
- Full flow: local parse → pull branch → SSH → `--local` provision

### Phase 5: AI-Guided Healing ✅
- `--heal=ai` runs standard heal + `opz run` AI healing
- `AGENTS.md` updated with new provisioning docs

---

## Pending: Phase 6 (Future)

These are documented intentions, not active work:

- **`-ro/--remotes-only`**: Skip current host, provision all remotes in parallel
  - TUI: `gum choose` pre-selecting remote systems
  - Parallel execution with prefixed logs
  - Warn + skip on failure, prompt to continue
- **Parallel provisioning**: investigate `mise run --parallel` or `xargs -P`
- **When Ghostty 1.2.0 releases**: update `shell-integration-features` to add `ssh-env,ssh-terminfo`, remove SSH `SetEnv` overrides in `ssh.nix`

---

## Archive Pattern (Future Deprecations)

When decommissioning scripts, consider `scripts/.archived/<script-name>` with a `DEPRECATED.md` explaining what replaced it. Useful for historical reference.

---

## Key Files

| File | Status |
|------|--------|
| `scripts/just-provision` | Enhanced (single source of truth) |
| `scripts/remote-provision` | Deleted |
| `AGENTS.md` | Updated provisioning section |

---

## Usage Reference

```bash
just-provision                         # Auto-detect & provision current host
just-provision -b                      # Pull current branch, then provision
just-provision -b gabz-v2             # Pull gabz-v2, then provision
just-provision spacehound              # Remote provision spacehound
just-provision -b gabz-v2 spacehound  # Pull branch, then remote provision
just-provision --heal                  # Heal + provision
just-provision --heal=ai               # AI-guided heal + provision
just-provision --check                 # Check prerequisites only
```
