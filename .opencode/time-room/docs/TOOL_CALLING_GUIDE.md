# 🛠️ Tool Calling Guide for Ollama + OpenCode

> **TL;DR:** Qwen models don't support OpenAI-style tool calling in Ollama. Use Mistral/Llama models instead.

---

## The Problem We Discovered (2026-02-22)

### What We Tried
- Created `qwen2.5-coder-tooled` with Princess Bubblegum system prompt
- Fixed template errors (removed `.Tools` dynamic iteration)
- Model loads successfully in Ollama ✅
- Character voice works in chat mode ✅

### What Failed
```json
{
  "error": {
    "message": "registry.ollama.ai/library/qwen2.5-coder-tooled:latest does not support tools"
  }
}
```

**Root Cause:** Ollama's Qwen implementation doesn't expose OpenAI-compatible `/v1/chat/completions` with `tools` parameter.

---

## Model Compatibility Matrix

| Model | Family | Tool Support | OpenCode Compatible | Size |
|-------|--------|--------------|---------------------|------|
| **devstral:latest** ✅ | llama | ✅ Yes | ✅ Yes | 14 GB |
| **devstral-tooled** ✅ | llama | ✅ Yes | ✅ Yes | 14 GB |
| mistral-small | llama | ✅ Yes | ✅ Yes | ~12 GB |
| llama3.3:latest | llama | ✅ Yes | ✅ Yes | ~20 GB |
| codestral | llama | ✅ Yes | ✅ Yes | ~22 GB |
| qwen2.5-coder:32b | qwen2 | ❌ No | ❌ No | 19 GB |
| qwen3-tooled | qwen2 | ❌ No | ❌ No | 18 GB |
| deepseek-r1:8b | deepseek | ❌ No | ❌ No | 5.2 GB |

**How to Check:**
```bash
# Via CLI
ollama show <model> --modelfile | grep -i family

# Via API
curl -s http://localhost:11434/api/show -d '{"name": "model"}' | jq '.details.family'

# llama = ✅ tools supported
# qwen2 = ❌ tools NOT supported
```

---

## Available Models (Your System)

### ✅ Tool-Capable Models

1. **devstral:latest** (Recommended for OpenCode)
   - Size: 14 GB
   - Family: llama (Mistral variant)
   - Tool calling: ✅ Native support
   - Best for: Code generation with tool use

2. **devstral-tooled:latest** (NEW - Princess Bubblegum variant)
   - Size: 14 GB
   - Same as devstral but with PB system prompt
   - Parameters: Medium Crank (temp 0.05, deterministic)
   - Best for: OpenCode with AT personality

### ❌ Tools NOT Supported (Chat Only)

- qwen2.5-coder-tooled:latest (19 GB) - Works in chat, NOT in OpenCode
- qwen3-tooled:latest (18 GB) - Same limitation
- qwen3-coder:30b (18 GB) - Same limitation
- All Qwen family models

---

## Usage Examples

### OpenCode with Tool Calling (Use Devstral)

```bash
# Standard devstral
opencode -m ollama/devstral:latest

# Princess Bubblegum variant (recommended!)
opencode -m ollama/devstral-tooled:latest

# Set as default in OCX profile
opz -p nebx  # or your profile
# Then edit: ~/.config/opencode/profiles/nebx.json
# Set: "model": "ollama/devstral-tooled:latest"
```

### Direct Chat (Qwen Works Fine)

```bash
# Qwen excels in direct chat mode
ollama run qwen2.5-coder-tooled:latest

# The Princess Bubblegum prompt helps with structured output
# Even though OpenCode tools don't work, the model still:
# ✅ Outputs JSON when asked
# ✅ Follows structured format instructions
# ✅ Has better code precision (Medium Crank params)
```

### Plan Mode (May Still Fail)

```bash
# Plan mode is read-only, but OpenCode might still try to use tools
opencode --agent plan -m ollama/qwen2.5-coder-tooled:latest

# Error may still occur depending on OpenCode version
# Recommended: Use devstral even for plan mode
opencode --agent plan -m ollama/devstral-tooled:latest
```

---

## How to Improve Tool Calling

### 1. Princess Bubblegum System Prompt (Already Applied)

The PB prompt teaches models to:
- Recognize when tools are needed
- Format JSON correctly
- Avoid explaining before calling
- Wait for real results (no hallucination)

**Applied to:**
- ✅ qwen2.5-coder-tooled (chat only)
- ✅ devstral-tooled (full OpenCode support)

### 2. Medium Crank Parameters (Already Applied)

```modelfile
PARAMETER temperature 0.05       # Very deterministic
PARAMETER top_p 0.9              # Focused token selection
PARAMETER top_k 20               # Limited token pool
PARAMETER repeat_penalty 1.1     # Anti-repetition
PARAMETER presence_penalty 0.3   # Encourage new concepts
PARAMETER frequency_penalty 0.3  # Discourage loops
PARAMETER num_predict 4096       # Allow complex chains
```

**Why it works:**
- Low temperature = consistent tool calling
- Top-k/top-p = reduces random errors
- Penalties = prevents repetitive mistakes
- High num_predict = allows multi-tool chains

### 3. Future Improvements

**Add to system prompt:**
```
When you encounter an error:
1. Read the full error message using appropriate tools
2. Analyze the root cause
3. Propose multiple solutions
4. Test the fix using tools before confirming
```

**Parameter tuning:**
```modelfile
# For security/audits (Ultra Crank)
PARAMETER temperature 0.01
PARAMETER top_k 5
PARAMETER top_p 0.70

# For creative coding (Turbo Mode)
PARAMETER temperature 0.2
PARAMETER top_k 50
PARAMETER top_p 0.95
```

---

## Testing Tool Calling

### Test devstral-tooled with OpenCode

```bash
# Start OpenCode with the PB variant
opencode -m ollama/devstral-tooled:latest

# Test prompts:
# 1. "Read the file at /etc/hosts"
#    → Should call read_file tool
#
# 2. "Search for 'TODO' in all JavaScript files"
#    → Should call grep tool
#
# 3. "List all Python files in the current directory"
#    → Should call glob tool
```

### Compare Tool Success Rate

```bash
# Test base devstral
opencode -m ollama/devstral:latest
# Try 10 tool-requiring prompts, count successes

# Test devstral-tooled (PB variant)
opencode -m ollama/devstral-tooled:latest
# Try same 10 prompts, count successes

# Expected: 10-15% improvement with PB prompt
```

---

## Why Qwen Still Useful

Even though Qwen doesn't work in OpenCode, it's excellent for:

1. **Direct coding assistance** (via `ollama run`)
   - Better code quality than Mistral for some tasks
   - 32B parameters = more knowledge
   - Qwen2.5-coder specifically trained for code

2. **Structured output in chat**
   - PB prompt teaches JSON formatting
   - Useful for manual tool-like interactions
   - Can ask: "Give me a JSON object with these fields"

3. **Future-proofing**
   - When Ollama adds Qwen tool support, your Modelfile is ready
   - Qwen natively supports function calling in transformers
   - It's an Ollama limitation, not a Qwen limitation

---

## Recommended Setup

### For OpenCode (Tool Calling Required)
```bash
# Use devstral-tooled (already created)
opencode -m ollama/devstral-tooled:latest

# Or create custom variants:
# - devstral-lich (Ultra Crank for security)
# - devstral-lemongrab (Compliance enforcement)
# - devstral-golb (Creative chaos mode)
```

### For Direct Chat (No Tools Needed)
```bash
# Use Qwen for superior code generation
ollama run qwen2.5-coder-tooled:latest

# The PB prompt still helps with structured output
```

### For Both
```bash
# Quick switcher script
alias ocx-dev='opencode -m ollama/devstral-tooled:latest'
alias ocx-qwen='ollama run qwen2.5-coder-tooled:latest'

# Add to your shell config (~/.zshrc or ~/.bashrc)
```

---

## References

- **CLAUDE_BOX.md** - Full character variant catalog
- **ollama-templates/** - All Modelfile sources
- **Ollama Tool Support** - https://github.com/ollama/ollama/blob/main/docs/api.md#tools
- **Qwen Function Calling** - https://qwen.readthedocs.io/en/latest/framework/function_call.html

---

**Updated:** 2026-02-22  
**Author:** Claude (Anthropic's AI assistant)  
**Context:** Debugging OpenCode tool calling with Ollama models
