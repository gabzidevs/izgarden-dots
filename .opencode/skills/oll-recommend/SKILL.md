---
name: oll-recommend
description: Recommend the right Ollama variant based on task type and requirements
license: MIT
compatibility: opencode
metadata:
  audience: agents
  workflow: ollama-recommendations
  script: ~/.config/flake/scripts/oll
---

## What I Do

Recommend the optimal Ollama variant based on:
- Task type (security, production, brainstorming, etc.)
- Priority (precision vs personality)
- Context (team, personal, client)

## When to Use Me

Use this skill when:
- You're unsure which variant to use
- Starting a new project or task
- Need to explain why a character fits

## Commands

### Recommend For Task (oll recommend for)
```bash
oll recommend for security-audit    # → The Lich
oll recommend for production        # → PB
oll recommend for brainstorming     # → GOLB
oll recommend for code-review       # → Manticore
oll recommend for client-demo       # → Peppermint
```

### Interactive Mode (oll recommend interactive)
```bash
oll recommend interactive           # Ask questions to narrow down
```

### Explain Character (oll recommend explain)
```bash
oll recommend explain pb            # Explain why PB fits
oll recommend explain golb           # Explain GOLB trade-offs
```

## Decision Matrix

| Task | 1st Choice | 2nd Choice | Avoid |
|------|------------|------------|-------|
| **Security Audit** | The Lich | Lemongrab | GOLB |
| **Production Code** | PB | Peppermint | Magic Man |
| **Architecture Design** | Manticore | PB | GOLB |
| **Brainstorming** | GOLB | Magic Man | The Lich |
| **Code Review** | Manticore | PB | GOLB |
| **Linting/Formatting** | Lemongrab | The Lich | GOLB |
| **Learning/Teaching** | PB | Magic Man | Lemongrab |
| **Client Demos** | Peppermint | PB | Lemongrab |
| **Personal Hacking** | Magic Man | GOLB | The Lich |
| **Compliance Check** | The Lich | Lemongrab | Magic Man |

## Priority Routing

### Priority = Precision
→ Use **The Lich** (temperature=0.01)
- Security audits
- Mission-critical code
- Production deployments

### Priority = Production
→ Use **Princess Bubblegum** (temperature=0.05)
- Daily development
- Team collaboration
- Tool calling

### Priority = Personality
→ Use **Magic Man** or **GOLB** (temperature=0.1-0.7)
- Personal projects
- Brainstorming
- Creative work

## Character Explanations

### Princess Bubblegum
> "Scientific precision with friendly tone. Best for daily production work."
- ✅ Clear instructions, professional tone
- ✅ AT flavor without being silly
- ✅ Optimal tool calling parameters
- ❌ Too formal for casual use

### The Lich
> "Zero error tolerance. Unavoidable correctness."
- ✅ Maximum precision, catches everything
- ✅ Security/mission-critical perfect
- ❌ Verbose (3x longer responses)
- ❌ Overkill for simple tasks

### GOLB
> "Chaotic creativity. Wild suggestions."
- ✅ Novel ideas, creative approaches
- ✅ Breaks creative blocks
- ❌ Unreliable tool calling
- ❌ NOT for production

### Manticore
> "Scholarly balance. Shows trade-offs."
- ✅ Great for architecture decisions
- ✅ Educational, shows alternatives
- ❌ More verbose than needed

### Lemongrab
> "SHOUTY compliance enforcement."
- ✅ Aggressive linting
- ✅ Catches ALL violations
- ❌ Too aggressive for teams
- ❌ ALL CAPS fatigue

### Peppermint Butler
> "Polite menace. Professional with edge."
- ✅ Client-ready
- ✅ AT flavor for teams
- ❌ Soft directives may miss

### Magic Man
> "Bro-culture technical accuracy."
- ✅ Casual, approachable
- ✅ Good for learning
- ❌ Not enterprise-ready

## Examples

### Interactive Session
```
$ oll recommend interactive

What's your priority? (precision/production/personality)
> precision

Is this for a team or personal project?
> team

For how many developers?
> 5

→ Recommendation: Princess Bubblegum
  Reason: Production balance with professional tone
  Alternative: Peppermint Butler (more formal)
```

### Task-Based
```
$ oll recommend for security-audit

→ The Lich
  Temperature: 0.01 (near-deterministic)
  Use case: Zero error tolerance
  Voice: "The fall of bugs is INEVITABLE."
  Trade-off: Very verbose (3x longer)
```

## Related Commands

| Command | Description |
| ------- | ----------- |
| `oll tune` | Apply parameter presets |
| `oll character` | Switch character voice |
| `oll test` | Test variant performance |
