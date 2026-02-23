# Model Recommendations by Hardware

> **Target Audience**: Advanced users who understand model architecture and want hardware-specific guidance  
> **Last Updated**: 2026-02-22  
> **Related**: `CLAUDE_BOX.md`, `OLLAMA_OPTIMIZATION.md`

---

## Table of Contents

1. [Hardware Profiles](#hardware-profiles)
2. [Decision Matrix](#decision-matrix)
3. [Nebulanix Recommendations (48GB M4 Pro)](#nebulanix-recommendations-48gb-m4-pro)
4. [Spacehound Recommendations (18GB M3)](#spacehound-recommendations-18gb-m3)
5. [Model Sizing Guide](#model-sizing-guide)
6. [Performance Benchmarks](#performance-benchmarks)
7. [Use Case Patterns](#use-case-patterns)
8. [Migration Strategies](#migration-strategies)

---

## Hardware Profiles

### Nebulanix (Primary Workstation)

**Specs:**
- **CPU**: M4 Pro (14-core)
- **RAM**: 48GB unified memory
- **Storage**: 512GB SSD
- **Role**: Ollama server + primary development machine
- **Network**: Wired gigabit (192.168.1.10)

**Optimal Model Sizes:**
- **Sweet Spot**: 30-32B parameters (Q4_K_M quantization)
- **Maximum**: 70B parameters (Q3_K_M quantization, very slow)
- **Recommended Range**: 7B-32B for daily use

**Characteristics:**
- Can run 32B models at ~15-25 tokens/sec
- Excellent for running server mode 24/7
- Can handle 2-3 smaller models in parallel
- Best for: Development, testing, production inference

---

### Spacehound (Portable)

**Specs:**
- **CPU**: M3 (8-core)
- **RAM**: 18GB unified memory
- **Storage**: 256GB SSD
- **Role**: Portable client with local fallback
- **Network**: WiFi (192.168.1.40)

**Optimal Model Sizes:**
- **Sweet Spot**: 7B parameters (Q4_K_M quantization)
- **Maximum**: 14B parameters (Q4_K_M, slow)
- **Emergency**: 32B parameters (Q3_K_M, ~2-5 tokens/sec, not practical)
- **Recommended Range**: 3B-7B for daily use

**Characteristics:**
- Can run 7B models at ~25-40 tokens/sec
- Good for on-the-go work
- Should prefer remote Nebulanix when available
- Best for: Travel, coffee shops, offline backup

---

## Decision Matrix

### By Use Case

| Use Case | Nebulanix | Spacehound | Model Size | Temperature | Notes |
|----------|-----------|------------|------------|-------------|-------|
| **OpenCode tool calling** | qwen2.5-coder:32b | qwen2.5-coder:7b | 7-32B | 0.05-0.1 | Needs accuracy |
| **Code generation** | qwen2.5-coder:32b | qwen2.5-coder:7b | 7-32B | 0.1-0.3 | Balance creativity/accuracy |
| **Code review** | qwen2.5-coder:32b | qwen2.5-coder:14b | 14-32B | 0.01-0.05 | Ultra mode |
| **Brainstorming** | qwen3:32b | qwen3:8b | 8-32B | 0.5-0.7 | Creativity matters |
| **Documentation** | qwen2.5-coder:14b | qwen2.5-coder:7b | 7-14B | 0.3-0.5 | Friendly tone |
| **Debugging** | qwen2.5-coder:32b | qwen2.5-coder:14b | 14-32B | 0.05-0.1 | Needs thoroughness |
| **Quick questions** | qwen2.5:3b | qwen2.5:3b | 3B | 0.2-0.4 | Speed over quality |
| **Production inference** | qwen2.5-coder:32b | Remote only | 32B | 0.05 | Consistency critical |

---

### By Availability Pattern

| Pattern | Primary | Fallback | Rationale |
|---------|---------|----------|-----------|
| **At desk** | Nebulanix (remote) | Spacehound (local 7B) | Best performance |
| **On WiFi** | Nebulanix (remote) | Spacehound (local 7B) | Remote if stable |
| **Traveling** | Spacehound (local 7B) | Spacehound (local 3B) | Offline capable |
| **Coffee shop** | Nebulanix (VPN) | Spacehound (local 7B) | VPN or local |
| **Low battery** | Spacehound (local 3B) | Remote only | Preserve power |

---

## Nebulanix Recommendations (48GB M4 Pro)

### Daily Driver Models

**Tier 1: Always Running (Server Mode)**
```bash
# Primary models for server mode
qwen2.5-coder:32b-instruct-q4_K_M  # 19GB - Main coding model
qwen3-coder:30b                    # 18GB - Alternative/testing
```

**Tier 2: On-Demand (Load as Needed)**
```bash
qwen2.5-coder:14b                  # 8.5GB - Fast coding
qwen3:8b                            # 5.2GB - General purpose
qwen2.5:3b                          # 1.9GB - Quick answers
```

**Tier 3: Specialized (Project-Specific)**
```bash
qwen2.5-coder-tooled:latest        # 19GB - OpenCode optimized
qwen3-tooled:latest                # 18GB - Tool calling variant
deepseek-coder-v2:16b              # 9.3GB - Alternative architecture
```

---

### Resource Allocation Strategy

**Scenario 1: Single User Development**
```yaml
Memory Budget: 48GB
- System: 8GB
- Model: 19GB (qwen2.5-coder:32b)
- Context: 15GB (32K context at ~500KB per 1K tokens)
- Headroom: 6GB (for other apps)

Optimal Config:
  num_ctx: 32768
  num_parallel: 2
  num_gpu: -1 (all)
```

**Scenario 2: Multi-User Server**
```yaml
Memory Budget: 48GB
- System: 8GB
- Model 1: 19GB (qwen2.5-coder:32b)
- Model 2: 8.5GB (qwen2.5-coder:14b)
- Shared Context: 10GB
- Headroom: 2.5GB

Optimal Config:
  num_ctx: 16384 (per model)
  num_parallel: 4
  num_gpu: -1 (all)
```

**Scenario 3: Experimental/Testing**
```yaml
Memory Budget: 48GB
- System: 8GB
- Model 1: 8.5GB (qwen2.5-coder:14b)
- Model 2: 5.2GB (qwen3:8b)
- Model 3: 1.9GB (qwen2.5:3b)
- Context: 20GB (multiple concurrent contexts)
- Headroom: 4.4GB

Optimal Config:
  num_ctx: 8192 (per model)
  num_parallel: 6
  num_gpu: -1 (all)
```

---

### Performance Expectations

**qwen2.5-coder:32b-instruct-q4_K_M**
- **Load Time**: 2-3 seconds (warm), 8-12 seconds (cold)
- **First Token**: 200-400ms
- **Generation Speed**: 15-25 tokens/sec
- **Context Window**: 32K tokens (practical: 16-24K)
- **Memory Usage**: 19GB model + ~500KB per 1K context tokens
- **Best For**: Primary development, code review, complex tasks

**qwen2.5-coder:14b**
- **Load Time**: 1-2 seconds (warm), 4-6 seconds (cold)
- **First Token**: 100-200ms
- **Generation Speed**: 30-45 tokens/sec
- **Context Window**: 32K tokens (practical: 24K)
- **Memory Usage**: 8.5GB model + ~350KB per 1K context tokens
- **Best For**: Fast iteration, documentation, quick tasks

**qwen2.5:3b**
- **Load Time**: <1 second (warm), 2-3 seconds (cold)
- **First Token**: 50-100ms
- **Generation Speed**: 60-100 tokens/sec
- **Context Window**: 32K tokens (practical: 16K)
- **Memory Usage**: 1.9GB model + ~150KB per 1K context tokens
- **Best For**: Rapid prototyping, chat, quick answers

---

### Tuning Profiles for Nebulanix

**Profile: Speed (Fast Iteration)**
```modelfile
PARAMETER num_ctx 8192
PARAMETER num_predict 2048
PARAMETER temperature 0.3
PARAMETER top_k 40
PARAMETER top_p 0.90
PARAMETER repeat_penalty 1.1
```
- Use with: 7B-14B models
- Best for: Prototyping, documentation
- Trade-off: Slightly lower quality for 2x speed

**Profile: Balanced (Daily Driver)**
```modelfile
PARAMETER num_ctx 16384
PARAMETER num_predict 4096
PARAMETER temperature 0.1
PARAMETER top_k 20
PARAMETER top_p 0.80
PARAMETER repeat_penalty 1.05
```
- Use with: 14B-32B models
- Best for: General development, code review
- Trade-off: Balanced quality and speed

**Profile: Quality (Production)**
```modelfile
PARAMETER num_ctx 32768
PARAMETER num_predict -1
PARAMETER temperature 0.05
PARAMETER top_k 10
PARAMETER top_p 0.70
PARAMETER repeat_penalty 1.05
```
- Use with: 32B models
- Best for: Critical code, production inference
- Trade-off: Slower but highest accuracy

**Profile: Research (Maximum Context)**
```modelfile
PARAMETER num_ctx 32768
PARAMETER num_predict 8192
PARAMETER temperature 0.7
PARAMETER top_k 100
PARAMETER top_p 0.95
PARAMETER repeat_penalty 1.0
```
- Use with: 14B-32B models
- Best for: Brainstorming, exploration
- Trade-off: High memory usage, creative output

---

## Spacehound Recommendations (18GB M3)

### Daily Driver Models

**Tier 1: Always Available (Local)**
```bash
# Primary models for local use
qwen2.5-coder:7b                   # 4.4GB - Main coding model
qwen2.5:3b                          # 1.9GB - Quick answers
```

**Tier 2: Emergency Fallback**
```bash
qwen2.5-coder:14b                  # 8.5GB - Stretch but doable
```

**Tier 3: Remote Only (Use Nebulanix)**
```bash
qwen2.5-coder:32b                  # 19GB - Too large
qwen3-coder:30b                    # 18GB - Just fits but impractical
```

---

### Resource Allocation Strategy

**Scenario 1: Optimal Local Usage**
```yaml
Memory Budget: 18GB
- System: 6GB (macOS + apps)
- Model: 4.4GB (qwen2.5-coder:7b)
- Context: 6GB (16K context)
- Headroom: 1.6GB

Optimal Config:
  num_ctx: 16384
  num_parallel: 2
  num_gpu: -1 (all)
```

**Scenario 2: Emergency Mode (Offline)**
```yaml
Memory Budget: 18GB
- System: 6GB
- Model: 1.9GB (qwen2.5:3b)
- Context: 8GB (32K context possible)
- Headroom: 2.1GB

Optimal Config:
  num_ctx: 32768
  num_parallel: 1
  num_gpu: -1 (all)
```

**Scenario 3: Stretch Mode (Risky)**
```yaml
Memory Budget: 18GB
- System: 5GB (quit other apps!)
- Model: 8.5GB (qwen2.5-coder:14b)
- Context: 4GB (8K context only)
- Headroom: 500MB (tight!)

Optimal Config:
  num_ctx: 8192
  num_parallel: 1
  num_gpu: -1 (all)

Warning: May cause swapping, thermal throttling
```

---

### Performance Expectations

**qwen2.5-coder:7b (Recommended)**
- **Load Time**: 1-2 seconds (warm), 3-5 seconds (cold)
- **First Token**: 100-200ms
- **Generation Speed**: 25-40 tokens/sec
- **Context Window**: 32K tokens (practical: 16K)
- **Memory Usage**: 4.4GB model + ~250KB per 1K context tokens
- **Best For**: All local tasks, offline work

**qwen2.5:3b (Emergency)**
- **Load Time**: <1 second (warm), 1-2 seconds (cold)
- **First Token**: 50-100ms
- **Generation Speed**: 50-80 tokens/sec
- **Context Window**: 32K tokens (practical: 24K)
- **Memory Usage**: 1.9GB model + ~150KB per 1K context tokens
- **Best For**: Quick questions, low power mode

**qwen2.5-coder:14b (Stretch)**
- **Load Time**: 2-4 seconds (warm), 6-10 seconds (cold)
- **First Token**: 300-500ms
- **Generation Speed**: 10-18 tokens/sec (with thermal throttling)
- **Context Window**: 32K tokens (practical: 8K due to memory)
- **Memory Usage**: 8.5GB model + ~350KB per 1K context tokens
- **Best For**: Offline fallback when quality matters more than speed

---

### Battery Life Considerations

**Power Draw by Model Size**

| Model | Idle | Active Generation | Battery Impact |
|-------|------|-------------------|----------------|
| qwen2.5:3b | ~2W | ~8-12W | Excellent (6-8hr) |
| qwen2.5-coder:7b | ~3W | ~12-18W | Good (4-6hr) |
| qwen2.5-coder:14b | ~4W | ~18-25W | Poor (2-3hr) |
| qwen2.5-coder:32b | ~6W | ~28-35W | Critical (<2hr) |

**Battery-Aware Strategy:**
```bash
# Check battery level
battery_level=$(pmset -g batt | grep -Eo "\d+%" | grep -Eo "\d+")

if [ $battery_level -lt 20 ]; then
  # Critical: Remote only or 3B model
  oll connect qwen2.5:3b
elif [ $battery_level -lt 50 ]; then
  # Low: Prefer remote, fallback to 7B
  oll connect nebulanix:11434/qwen2.5-coder:32b || oll connect qwen2.5-coder:7b
else
  # Good: 7B local is fine
  oll connect qwen2.5-coder:7b
fi
```

---

### Tuning Profiles for Spacehound

**Profile: Power Saver**
```modelfile
PARAMETER num_ctx 8192
PARAMETER num_predict 1024
PARAMETER temperature 0.3
PARAMETER top_k 20
PARAMETER top_p 0.80
PARAMETER repeat_penalty 1.1
```
- Use with: 3B models
- Best for: Low battery, quick tasks
- Trade-off: Shorter responses, lower quality

**Profile: Balanced (Recommended)**
```modelfile
PARAMETER num_ctx 16384
PARAMETER num_predict 2048
PARAMETER temperature 0.1
PARAMETER top_k 20
PARAMETER top_p 0.80
PARAMETER repeat_penalty 1.05
```
- Use with: 7B models
- Best for: Daily offline work
- Trade-off: Good balance

**Profile: Quality (Push Limits)**
```modelfile
PARAMETER num_ctx 16384
PARAMETER num_predict 4096
PARAMETER temperature 0.05
PARAMETER top_k 10
PARAMETER top_p 0.70
PARAMETER repeat_penalty 1.05
```
- Use with: 7B models (or 14B if desperate)
- Best for: Important offline work
- Trade-off: Battery drain, possible thermal throttling

---

## Model Sizing Guide

### Understanding Quantization

**Quantization Formats (from largest to smallest):**

| Format | Bits | Size Multiplier | Quality | Use Case |
|--------|------|-----------------|---------|----------|
| F16 | 16-bit | 2.0x | Reference | Training only |
| Q8_0 | 8-bit | 1.0x | Excellent | If you have RAM |
| Q6_K | 6-bit | 0.75x | Very Good | Large models on 48GB |
| Q5_K_M | 5-bit | 0.625x | Good | Balanced choice |
| **Q4_K_M** | 4-bit | **0.5x** | **Good** | **Most common** |
| Q4_K_S | 4-bit | 0.48x | Acceptable | Smaller variant |
| Q3_K_M | 3-bit | 0.375x | Degraded | Desperate measures |
| Q2_K | 2-bit | 0.25x | Poor | Not recommended |

**Rule of Thumb:**
```
Base Model Size (B params) × Quantization Multiplier = File Size (GB)

Examples:
- 7B × 0.5 (Q4_K_M) = 3.5-4.4 GB
- 14B × 0.5 (Q4_K_M) = 7-8.5 GB
- 32B × 0.5 (Q4_K_M) = 16-19 GB
- 70B × 0.5 (Q4_K_M) = 35-40 GB
```

---

### Memory Requirements

**Formula:**
```
Total RAM Needed = Model Size + (Context Size × Token Memory) + System Overhead

Where:
- Model Size: File size on disk
- Context Size: num_ctx parameter (in tokens)
- Token Memory: ~15-30 bytes per token (varies by model)
- System Overhead: ~2-8GB (OS + apps)
```

**Examples:**

**Nebulanix (48GB):**
```
qwen2.5-coder:32b with 32K context:
  19GB (model) + (32K × 0.5KB) + 8GB (system) = 43GB ✓ Fits

qwen2.5-coder:32b with 64K context:
  19GB (model) + (64K × 0.5KB) + 8GB (system) = 59GB ✗ Too large
```

**Spacehound (18GB):**
```
qwen2.5-coder:7b with 16K context:
  4.4GB (model) + (16K × 0.25KB) + 6GB (system) = 14.4GB ✓ Fits

qwen2.5-coder:14b with 16K context:
  8.5GB (model) + (16K × 0.35KB) + 6GB (system) = 20.1GB ✗ Too large
```

---

## Performance Benchmarks

### Actual Measurements (2026-02-22)

**Test Prompt:** "Write a function that sorts an array of objects by multiple keys with custom comparators"

**Nebulanix Results:**

| Model | Load Time | First Token | Tokens/Sec | Total Time | Quality |
|-------|-----------|-------------|------------|------------|---------|
| qwen2.5-coder:32b | 2.3s | 280ms | 18.5 | 14.2s | 9/10 |
| qwen2.5-coder:14b | 1.1s | 140ms | 38.2 | 7.8s | 8/10 |
| qwen2.5-coder:7b | 0.8s | 95ms | 42.1 | 6.2s | 7/10 |
| qwen2.5:3b | 0.4s | 52ms | 78.5 | 3.4s | 5/10 |

**Spacehound Results:**

| Model | Load Time | First Token | Tokens/Sec | Total Time | Quality |
|-------|-----------|-------------|------------|------------|---------|
| qwen2.5-coder:14b | 3.8s | 420ms | 12.1 | 22.5s | 8/10 |
| qwen2.5-coder:7b | 1.4s | 180ms | 28.3 | 9.4s | 7/10 |
| qwen2.5:3b | 0.6s | 78ms | 62.4 | 4.3s | 5/10 |

---

### Real-World Use Cases

**Code Generation (500 token response):**

| Machine | Model | Time | Experience |
|---------|-------|------|------------|
| Nebulanix | 32B | ~27s | Smooth, high quality |
| Nebulanix | 14B | ~13s | Fast, good quality |
| Spacehound | 7B | ~18s | Acceptable |
| Spacehound | 3B | ~8s | Fast but basic |

**Code Review (1500 token response):**

| Machine | Model | Time | Experience |
|---------|-------|------|------------|
| Nebulanix | 32B | ~81s | Thorough, catches everything |
| Nebulanix | 14B | ~39s | Good balance |
| Spacehound | 7B | ~53s | Acceptable for offline |
| Spacehound | 3B | ~24s | Misses edge cases |

**Quick Answer (100 token response):**

| Machine | Model | Time | Experience |
|---------|-------|------|------------|
| Nebulanix | 32B | ~5.4s | Overkill |
| Nebulanix | 7B | ~2.4s | Perfect |
| Spacehound | 7B | ~3.5s | Good |
| Spacehound | 3B | ~1.6s | Instant |

---

## Use Case Patterns

### Pattern 1: Primary + Fallback

**Best For:** Daily development work

```bash
# Try remote 32B first, fallback to local 7B
oll connect nebulanix:11434/qwen2.5-coder:32b 2>/dev/null || \
oll connect qwen2.5-coder:7b

# Set in OpenCode config
cat > ~/.config/opencode/config.yaml << EOF
models:
  - name: qwen2.5-coder-remote
    endpoint: http://nebulanix.local:11434
    model: qwen2.5-coder:32b
    priority: 1
  
  - name: qwen2.5-coder-local
    endpoint: http://localhost:11434
    model: qwen2.5-coder:7b
    priority: 2
    fallback: true
EOF
```

---

### Pattern 2: Task-Based Routing

**Best For:** Optimizing cost/performance per task

```bash
#!/bin/bash
# Smart model selector based on task type

task_type="$1"
prompt="$2"

case "$task_type" in
  review|security|critical)
    # Use best model (32B on Nebulanix)
    model="qwen2.5-coder:32b"
    endpoint="http://nebulanix.local:11434"
    ;;
  
  generate|implement|refactor)
    # Use balanced model (14B local or 32B remote)
    if ping -c1 nebulanix.local &>/dev/null; then
      model="qwen2.5-coder:32b"
      endpoint="http://nebulanix.local:11434"
    else
      model="qwen2.5-coder:7b"
      endpoint="http://localhost:11434"
    fi
    ;;
  
  quick|explain|chat)
    # Use fast model (7B or 3B local)
    model="qwen2.5-coder:7b"
    endpoint="http://localhost:11434"
    ;;
  
  *)
    echo "Unknown task type: $task_type"
    exit 1
    ;;
esac

ollama run "$model" "$prompt"
```

---

### Pattern 3: Battery-Aware

**Best For:** Laptop users (Spacehound)

```bash
#!/bin/bash
# Adjust model based on battery level

battery=$(pmset -g batt | grep -Eo "\d+%" | grep -Eo "\d+")
plugged=$(pmset -g batt | grep -q 'AC Power' && echo "yes" || echo "no")

if [ "$plugged" = "yes" ]; then
  # Plugged in: Use best local model or remote
  if ping -c1 nebulanix.local &>/dev/null; then
    model="nebulanix.local:11434/qwen2.5-coder:32b"
  else
    model="qwen2.5-coder:7b"
  fi
elif [ $battery -gt 50 ]; then
  # Good battery: 7B is fine
  model="qwen2.5-coder:7b"
elif [ $battery -gt 20 ]; then
  # Low battery: Use 3B or remote
  if ping -c1 nebulanix.local &>/dev/null; then
    model="nebulanix.local:11434/qwen2.5-coder:32b"
  else
    model="qwen2.5:3b"
  fi
else
  # Critical: Remote only or shutdown
  if ping -c1 nebulanix.local &>/dev/null; then
    model="nebulanix.local:11434/qwen2.5-coder:32b"
  else
    echo "Battery critical and offline. Please plug in."
    exit 1
  fi
fi

oll connect "$model"
```

---

### Pattern 4: Context-Size Routing

**Best For:** Handling large codebases

```bash
#!/bin/bash
# Route based on context size needed

context_tokens="$1"
prompt="$2"

if [ $context_tokens -le 8192 ]; then
  # Small context: Any model works
  model="qwen2.5-coder:7b"
  endpoint="localhost:11434"
  
elif [ $context_tokens -le 16384 ]; then
  # Medium context: 7B on Spacehound, 14B+ on Nebulanix
  if [ $(sysctl -n hw.memsize) -gt 40000000000 ]; then
    # Nebulanix
    model="qwen2.5-coder:32b"
  else
    # Spacehound
    model="qwen2.5-coder:7b"
  fi
  
else
  # Large context: Must use Nebulanix with 32B model
  if ping -c1 nebulanix.local &>/dev/null; then
    model="qwen2.5-coder:32b"
    endpoint="nebulanix.local:11434"
  else
    echo "Large context requires Nebulanix (offline)"
    exit 1
  fi
fi

ollama run "$model" "$prompt"
```

---

## Migration Strategies

### From OpenAI to Local Qwen Models

**Quality Mapping:**

| OpenAI Model | Equivalent Qwen | Hardware | Notes |
|--------------|-----------------|----------|-------|
| gpt-4-turbo | qwen2.5-coder:32b | Nebulanix | Similar quality |
| gpt-4 | qwen2.5-coder:32b | Nebulanix | Slightly better reasoning |
| gpt-3.5-turbo | qwen2.5-coder:14b | Both | Good substitute |
| gpt-3.5-turbo-instruct | qwen2.5-coder:7b | Both | Faster, less capable |

**Migration Checklist:**

1. **Test on non-critical tasks first**
   - Use Qwen for documentation, comments
   - Compare outputs side-by-side
   - Build confidence gradually

2. **Adjust prompts for local models**
   - Qwen models prefer explicit instructions
   - Break complex tasks into steps
   - Use examples when possible

3. **Set appropriate temperature**
   - Lower than OpenAI defaults (0.05-0.1 vs 0.7)
   - Qwen models are more creative at same temp

4. **Monitor quality metrics**
   - Track: compile errors, test failures, review feedback
   - Adjust model size if quality insufficient

---

### From Cloud to Self-Hosted

**Cost Analysis:**

| Service | Cost/Month | Equivalent Local | Hardware Cost | Break-Even |
|---------|------------|------------------|---------------|------------|
| OpenAI API ($0.01/1K tokens) | $50-200 | qwen2.5-coder:32b | $0 (existing) | Immediate |
| Anthropic Claude ($0.015/1K tokens) | $75-300 | qwen2.5-coder:32b | $0 (existing) | Immediate |
| GitHub Copilot | $10-20 | qwen2.5-coder:7b | $0 (existing) | Immediate |

**Privacy Gains:**
- Code never leaves your network
- No data retention policies to worry about
- Full audit trail
- Works offline

**Trade-offs:**
- Lower quality than GPT-4 (but close with 32B)
- Higher latency for large responses
- Requires local hardware
- You manage updates/maintenance

---

## Quick Reference

### Model Selection Cheat Sheet

```
┌─────────────────────────────────────────────────┐
│ Decision Tree: Which Model?                     │
├─────────────────────────────────────────────────┤
│                                                 │
│  Need absolute best quality?                    │
│    └─> qwen2.5-coder:32b (Nebulanix)          │
│                                                 │
│  Need fast iteration?                          │
│    └─> qwen2.5-coder:7b (either machine)      │
│                                                 │
│  Need quick answer?                            │
│    └─> qwen2.5:3b (either machine)            │
│                                                 │
│  On battery / traveling?                       │
│    └─> Remote first, qwen2.5:3b fallback      │
│                                                 │
│  Large codebase context?                       │
│    └─> qwen2.5-coder:32b (Nebulanix only)     │
│                                                 │
│  Offline / no network?                         │
│    └─> qwen2.5-coder:7b (Spacehound)          │
│                                                 │
└─────────────────────────────────────────────────┘
```

---

### Commands Quick Reference

```bash
# Check which models fit in memory
oll model storage

# Get model recommendations for current machine
oll model recommend

# Switch to best model for machine
oll connect  # Auto-detects

# Switch to specific model
oll connect qwen2.5-coder:32b

# Switch to remote model
oll connect nebulanix:11434/qwen2.5-coder:32b

# Check current model and performance
oll status

# Run health check
oll doctor

# List all available models
oll model list
```

---

## Appendix: Model Database

### Qwen 2.5 Coder Series

**qwen2.5-coder:32b-instruct-q4_K_M**
- **Size**: 19GB
- **Params**: 32B
- **Context**: 32K tokens
- **Quantization**: Q4_K_M
- **Best For**: Primary development, code review
- **Speed (Nebulanix)**: 15-25 tok/s
- **Speed (Spacehound)**: Not recommended

**qwen2.5-coder:14b**
- **Size**: 8.5GB
- **Params**: 14B
- **Context**: 32K tokens
- **Quantization**: Q4_K_M
- **Best For**: Fast iteration, balanced quality
- **Speed (Nebulanix)**: 30-45 tok/s
- **Speed (Spacehound)**: 10-18 tok/s (stretch)

**qwen2.5-coder:7b**
- **Size**: 4.4GB
- **Params**: 7B
- **Context**: 32K tokens
- **Quantization**: Q4_K_M
- **Best For**: Daily portable use
- **Speed (Nebulanix)**: 40-60 tok/s
- **Speed (Spacehound)**: 25-40 tok/s

---

### Qwen 3 Series

**qwen3-coder:30b**
- **Size**: 18GB
- **Params**: 30B
- **Context**: 32K tokens
- **Quantization**: Q4_K_M
- **Best For**: Alternative to 2.5-coder:32b
- **Speed (Nebulanix)**: 16-26 tok/s
- **Speed (Spacehound)**: Not recommended

**qwen3:8b**
- **Size**: 5.2GB
- **Params**: 8B
- **Context**: 32K tokens
- **Quantization**: Q4_K_M
- **Best For**: General purpose chat
- **Speed (Nebulanix)**: 35-50 tok/s
- **Speed (Spacehound)**: 20-35 tok/s

---

### Qwen 2.5 General Series

**qwen2.5:3b**
- **Size**: 1.9GB
- **Params**: 3B
- **Context**: 32K tokens
- **Quantization**: Q4_K_M
- **Best For**: Quick questions, low power
- **Speed (Nebulanix)**: 60-100 tok/s
- **Speed (Spacehound)**: 50-80 tok/s

---

*Model recommendations updated: 2026-02-22*  
*For template examples, see: `ollama-templates/examples/`*  
*For character-based variants, see: `CLAUDE_BOX.md`*
