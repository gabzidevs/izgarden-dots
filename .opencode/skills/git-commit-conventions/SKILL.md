# Git Commit Conventions Skill

**Purpose:** Enforce semantic commit messages with apt context

---

## Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

| Type | Description |
|------|-------------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation changes |
| `style` | Formatting, no code change |
| `refactor` | Code restructure |
| `perf` | Performance improvement |
| `test` | Adding/updating tests |
| `chore` | Maintenance, deps, build |
| `ci` | CI/CD changes |
| `revert` | Reverting previous commit |

### Logical Group Prefixes

When multiple logical changes are in one commit or when splitting commits, **always append the logical group** in parentheses:

```
<type>(<logical-group>): <subject>
```

**Common logical groups:**
| Group | Example | Description |
|-------|---------|-------------|
| `ollama` | `feat(ollama):` | Ollama/LLM related |
| `connect-ollama` | `refactor(connect-ollama):` | Connect-ollama script |
| `mise` | `fix(mise):` | Mise tool manager |
| `agents` | `chore(agents):` | Agent configurations/memories |
| `opencode` | `feat(opencode):` | OpenCode config/plugins |
| `ocx` | `feat(ocx):` | OCX compatibility layer |
| `nix` | `refactor(nix):` | Nix modules |

**Examples:**
```
feat(ollama): add connect-ollama script
refactor(connect-ollama): rename opencode-switch to connect-ollama
fix(mise): enable auto_install for automatic tool installation
chore(agents): add OpenCode agent memory sessions
```

### Rules

1. **Subject line**: Max 50 chars, lowercase, no period
2. **Body**: Wrap at 72 chars, explain "what" and "why", not "how"
3. **Scope**: Optional, lowercase (e.g., `opencode`, `home`, `scripts`, `systems`)
4. **Breaking changes**: Start subject with `!`, add `BREAKING CHANGE:` in footer
5. **Issue references**: Use `Closes #123` or `Fixes #456` in footer

---

## Context Requirements

For each commit, include:
- **What** changed (clear subject)
- **Why** it changed (body explains motivation)
- **Context** for reviewers (link issues, explain impact)

---

## Examples

### Good
```
feat(opencode): add memory commit rules for agent guidance

- Add semantic commit conventions to agent workflows
- Enables better changelog generation
- Guides agents on writing contextual commits

Closes #42
```

### Good (with scope)
```
fix(home): resolve mise path not found error

The mise nix module was using a hardcoded path that
doesn't exist on macOS. Now uses proper XDG paths.
```

### Good (breaking change)
```
perf(ollama)!: switch to Nebulanix as default server

BREAKING CHANGE: Default OLLAMA_HOST changed from localhost:11434
to 192.168.1.10:11434. Update your config if using local.
```

### Bad (avoid)
```
fix: fixed stuff

- update
- more updates
```

---

## Workflow

1. **Analyze changes**: Group related files logically
2. **Determine type**: Choose appropriate commit type
3. **Write subject**: Clear, concise, action-oriented
4. **Add context**: Explain "why" in body
5. **Verify**: Ensure subject ≤50 chars, body wrapped at 72

---

## Common Groupings

| Files | Suggested Type |
|-------|----------------|
| `.opencode/docs/*`, `.opencode/time-room/*` | `docs` |
| `.opencode/plans/*` | `docs` or `chore` |
| `home/*` (home manager) | `feat` or `fix` |
| `modules/*`, `fix`, or `refactor` |
| `systems/*` | `feat` or `` | `featfix` |
| `scripts/*` | `feat` or `chore` |
| `scripts/README.md` | `docs` |

---

## Finn's Role

Finn should always:
- Analyze pending changes before committing
- Group files by logical concern
- Write descriptive commit messages with apt context
- Follow this convention strictly
- Remind others of these rules when needed
