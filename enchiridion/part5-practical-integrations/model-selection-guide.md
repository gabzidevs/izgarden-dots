# Model Selection Guide for Nebulanix

Your 48GB M4 Pro is a powerful AI workstation. Here's how to choose the right model for the right job.

## Quick Reference

| Model | Size | RAM Needed | Best For | Speed |
|-------|------|------------|----------|-------|
| **qwen3:8b** | ~5.2GB | ~8GB | Daily driver, balanced | Fast |
| **qwen3-coder:30b** | ~19GB | ~24GB | Coding, complex tasks | Medium |
| **deepseek-r1:8b** | ~5.2GB | ~8GB | Reasoning, math, logic | Fast |
| **gemma3:4b** | ~3.3GB | ~6GB | Quick tasks, vision | Very Fast |
| **devstral:24b** | ~14GB | ~18GB | Agentic coding | Medium |
| **deepseek-r1:14b** | ~9GB | ~12GB | Stronger reasoning | Medium |

## The Essential Set (~32.7GB)

These four models should handle 90% of your workflows:

### 1. qwen3:8b - "The Daily Driver"
```bash
ollama pull qwen3:8b
```
- **Use when**: General coding questions, documentation, brainstorming
- **Context**: 64K tokens
- **Why**: Best balance of speed and capability
- **Alternative**: Use for most OpenCode tasks

### 2. qwen3-coder:30b - "The Specialist"
```bash
ollama pull qwen3-coder:30b
```
- **Use when**: Complex code generation, large refactors, architecture decisions
- **Context**: 256K tokens (massive!)
- **Why**: Agentic capabilities, handles large codebases
- **Note**: Use for heavy lifting, not quick queries

### 3. deepseek-r1:8b - "The Thinker"
```bash
ollama pull deepseek-r1:8b
```
- **Use when**: Debugging, reasoning tasks, math problems
- **Context**: 64K tokens
- **Why**: Distilled reasoning model, shows its "thinking"
- **Best for**: Logic puzzles, algorithm design

### 4. gemma3:4b - "The Speedster"
```bash
ollama pull gemma3:4b
```
- **Use when**: Quick edits, simple questions, vision tasks
- **Context**: 32K tokens
- **Why**: Lightning fast, has vision capabilities
- **Use as**: Your "fast" model in OpenCode

## Extended Library

Pull these as needed:

### devstral:24b - "The Agent"
```bash
ollama pull devstral:24b
```
- **Use when**: Agentic workflows, multi-step tasks
- **Why**: #1 on SWE-Bench (46.8%)
- **Size**: ~14GB

### deepseek-r1:14b - "The Heavy Thinker"
```bash
ollama pull deepseek-r1:14b
```
- **Use when**: The 8B version isn't enough
- **Why**: Stronger reasoning capabilities
- **Trade-off**: Slower but smarter

## Configuration for OpenCode

Edit `~/.config/opencode/opencode.json`:

```json
{
  "model": "ollama/qwen3:8b",
  "small_model": "ollama/gemma3:4b",
  "agent": {
    "build": {
      "model": "ollama/qwen3:8b"
    },
    "plan": {
      "model": "ollama/gemma3:4b"
    }
  }
}
```

## Context Window Guide

More context = more memory usage. Here's the trade-off:

| Context | Memory Multiplier | Use Case |
|---------|------------------|----------|
| 4K | 1x | Quick queries |
| 16K | 2x | Small code review |
| 32K | 3x | Medium files |
| 64K | 4x | Large files |
| 128K | 6x | Entire codebases |

**Rule of thumb**: Start with default, increase only when needed.

## RAM Usage Formula

```
Total RAM = Model Size × 1.5 (loading overhead) + Context × 0.002 (per token)
```

Example: qwen3-coder:30b with 32K context
```
19GB × 1.5 + 32000 × 0.002 = 28.5GB + 64MB ≈ 29GB
```

## Optimization Tips

1. **One model at a time**: Ollama unloads unused models
2. **Context sharing**: Use same context for related queries
3. **Quantization**: Use q4_0 or q8_0 KV cache to save RAM
4. **VRAM override**: Your 45GB setting should handle any single model

## Troubleshooting

### "Out of memory"
- Reduce context length
- Close other applications
- Use smaller model

### "Model loading slowly"
- Check disk speed (SSD recommended)
- Pre-load: `ollama run model_name` then Ctrl+C

### "Poor quality outputs"
- Try larger model
- Increase context window
- Use specialized model (coder vs general)

## When to Use Cloud Models

Even with great local hardware, sometimes cloud is better:

| Scenario | Recommendation |
|----------|---------------|
| Deep research | Claude/GPT-4 (larger knowledge base) |
| Production code review | Cloud (more conservative) |
| Learning new tech | Cloud (up-to-date training) |
| Daily coding | Local (faster, private, cheaper) |
| Sensitive code | Local (privacy) |

## Cost Comparison

**Local (one-time)**:
- Mac Studio: ~$2000
- Power usage: ~$0.10/hour
- **Effective**: After ~500 hours of API usage

**Cloud (ongoing)**:
- Claude API: ~$0.03-0.15 per request
- 500 hours ≈ $500-2000

**Verdict**: Local pays for itself quickly if you use AI daily.

---

*Next: [First Agentic Workflow](first-workflow.md)*
