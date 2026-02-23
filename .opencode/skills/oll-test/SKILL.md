---
name: oll-test
description: Run test prompts against Ollama variants to verify tool calling and character voice
license: MIT
compatibility: opencode
metadata:
  audience: agents
  workflow: ollama-testing
  script: ~/.config/flake/scripts/oll
---

## What I Do

Test Ollama variants for:
- Tool call recognition and formatting
- Character voice confirmation
- Response length verification
- Hallucination detection

## When to Use Me

Use this skill when:
- Testing new character variants
- Comparing tool compliance rates
- Verifying model behavior after tuning changes
- Running benchmarks

## Commands

### Run Test (oll test run)
```bash
oll test run                      # Test current variant
oll test run pb                   # Test Princess Bubblegum variant
oll test run lich                 # Test The Lich variant
```

### Compare Variants (oll test compare)
```bash
oll test compare pb lich          # Compare PB vs The Lich
oll test compare all               # Compare all characters
```

### Benchmark (oll test benchmark)
```bash
oll test benchmark                # Full benchmark suite
oll test benchmark --quick        # Quick test only
```

## Test Prompts

### Tool Recognition Test
```
"List files in the current directory"
Expected: glob tool call
```

### Code Analysis Test
```
"Search for function definitions in src/"
Expected: grep tool call
```

### Research Test
```
"What's the weather in Tokyo?"
Expected: webfetch tool call (if available)
```

## Response Metrics

### Expected Token Counts (same prompt)
| Character | Tokens | Relative |
|-----------|--------|----------|
| GOLB | 150 | 1.0x |
| Magic Man | 200 | 1.3x |
| PB | 250 | 1.7x |
| Peppermint | 280 | 1.9x |
| Manticore | 350 | 2.3x |
| Lemongrab | 400 | 2.7x |
| The Lich | 500 | 3.3x |

## Output Format

### Test Result Example
```
✅ Tool Recognition: PASS
✅ JSON Formatting: PASS
✅ Character Voice: CONFIRMED (Princess Bubblegum)
✅ No Hallucination: PASS
⏱️ Response Time: 2.3s
📊 Tokens: 247
```

### Comparison Example
```
Character    | Tool Rec | Format | Voice  | Tokens
-------------|----------|--------|--------|-------
PB           | ✅ 95%   | ✅ 98% | ✅     | 250
The Lich     | ✅ 99%   | ✅ 99% | ✅     | 500
GOLB         | ⚠️ 60%   | ⚠️ 70% | ✅     | 150
```

## Verification Checklist

For each test, verify:
- [ ] Tool was recognized and called
- [ ] JSON format is correct
- [ ] Character voice is present
- [ ] No fabricated results
- [ ] Response time acceptable

## Related Commands

| Command | Description |
| ------- | ----------- |
| `oll tune` | Apply parameter presets |
| `oll character` | Switch character voice |
| `oll recommend` | Get variant recommendations |
