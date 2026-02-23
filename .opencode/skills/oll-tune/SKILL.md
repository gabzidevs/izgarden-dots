---
name: oll-tune
description: Apply parameter presets for different use cases (conservative/medium/ultra/turbo)
license: MIT
compatibility: opencode
metadata:
  audience: agents
  workflow: ollama-tuning
  script: ~/.config/flake/scripts/oll
---

## What I Do

Apply parameter tuning presets based on the CLAUDE_BOX.md spectrum:
- **Conservative** - Safe baseline (temperature=0.1)
- **Medium** - Optimal tool calling (temperature=0.05, recommended)
- **Ultra** - Maximum precision for security/production (temperature=0.01)
- **Turbo** - Creative brainstorming (temperature=0.7)

## When to Use Me

Use this skill when:
- You need deterministic tool calling behavior
- Running security audits (use Ultra)
- Production code generation (use Medium)
- Brainstorming creative solutions (use Turbo)
- Testing new configurations (use Conservative)

## Commands

### List Presets (oll tune list)
```bash
oll tune list                    # Show all available presets
oll tune show medium             # Show Medium preset details
```

### Apply Preset (oll tune apply)
```bash
oll tune apply medium            # Apply Medium preset (recommended)
oll tune apply ultra             # Apply Ultra (The Lich mode)
oll tune apply turbo             # Apply Turbo (GOLB mode)
oll tune apply conservative      # Apply Conservative baseline
```

## Preset Details

| Preset | Character | Temperature | Use Case |
|--------|-----------|-------------|----------|
| conservative | Manticore | 0.1 | Testing, safe baseline |
| medium ✅ | Princess Bubblegum | 0.05 | Production, tool calling |
| ultra | The Lich | 0.01 | Security, audits |
| turbo | GOLB | 0.7 | Brainstorming |

### Medium (Recommended)
```modelfile
PARAMETER temperature 0.05
PARAMETER top_p 0.9
PARAMETER top_k 20
PARAMETER repeat_penalty 1.1
PARAMETER presence_penalty 0.3
PARAMETER frequency_penalty 0.3
PARAMETER num_predict 4096
PARAMETER mirostat 2
PARAMETER mirostat_tau 3.0
PARAMETER mirostat_eta 0.1
```

### Ultra (The Lich Mode)
```modelfile
PARAMETER temperature 0.01
PARAMETER top_p 0.70
PARAMETER top_k 5
PARAMETER repeat_penalty 1.05
PARAMETER num_ctx 32768
PARAMETER num_predict -1
```

### Turbo (GOLB Mode)
```modelfile
PARAMETER temperature 0.7
PARAMETER top_p 0.95
PARAMETER top_k 100
PARAMETER repeat_penalty 1.0
PARAMETER num_predict 2048
```

## Parameter Glossary

| Parameter | Range | Tool Calling Impact |
|-----------|-------|---------------------|
| temperature | 0.0-2.0 | Lower = more deterministic |
| top_p | 0.0-1.0 | Lower = more focused |
| top_k | 1-100 | Lower = less variety |
| mirostat | 0,1,2 | 2 = best consistency |

## Examples

```bash
# For production work
oll tune apply medium

# For security audit
oll tune apply ultra

# For creative brainstorming
oll tune apply turbo
```

## Related Commands

| Command | Description |
| ------- | ----------- |
| `oll character` | Switch character voice |
| `oll recommend` | Get variant recommendations |
| `oll test` | Test variant performance |
