# Ollama Custom Model Templates

Custom Modelfiles for optimizing local models with OpenCode tool calling.

## Purpose

These templates enhance Qwen models with:
- **ChatML format** (`<|im_start|>` / `<|im_end|>`) for proper message formatting
- **Adventure Time-themed system prompts** (Princess Bubblegum's scientific precision!)
- **Medium-crank parameters** for deterministic tool calling (temp 0.05, mirostat 2)

## Available Templates

| Template | Base Model | Use Case |
|----------|------------|----------|
| `qwen2.5-coder-tooled` | qwen2.5-coder:32b-instruct-q4_K_M | Coding tasks with tools |
| `qwen3-tooled` | qwen3:32b-q4_K_M | General reasoning with tools |
| `qwen3-moe-tooled` | qwen3:30b-a3b-q4_K_M | Fast MoE with tools |

## Usage

```bash
# Create all custom models
oll template apply

# Create specific model
oll template create qwen2.5-coder-tooled

# List available templates
oll template list

# Use in OpenCode
oll connect qwen3-tooled && opz
```

## Template Structure

Each Modelfile includes:
1. **FROM** - Base model reference
2. **SYSTEM** - Princess Bubblegum's Laboratory Protocol (AT-themed!)
3. **TEMPLATE** - ChatML format with tool injection
4. **PARAMETER** - Medium-crank settings (see `.opencode/time-room/docs/CLAUDE_BOX.md` for variants)

## Testing

After creating models, test with:
```bash
/Users/gabz/.config/flake/scripts/test-qwen-tools.sh
```

## Notes

- Original models remain unchanged (fallbacks)
- Medium-crank parameters (temp 0.05, mirostat 2) for max precision
- ChatML format matches Qwen's training data
- Princess Bubblegum theme chosen for scientific precision vibe
- See `.opencode/time-room/docs/CLAUDE_BOX.md` for alternative prompts (Lemongrab, Peppermint Butler, Magic Man)
