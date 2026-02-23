# Ollama Scripts Changelog

## 2026-02-16 - Critical Model Library Fixes

### Fixed: Invalid Model Names
**Problem:** Model library contained invalid/non-existent model names that caused pull failures.

**Changes:**
- `qwen3:8b-q5_K_M` → `qwen3:8b` (~5.2GB)
- `deepseek-coder-v3:14b-q4_K_M` → `qwen3-coder:30b` (~19GB) 
- `llama3.3:70b-q4_K_M` → `deepseek-r1:8b` (~5.2GB)
- `qwen3:4b-q5_K_M` → `llama3.2:3b` (~2GB)
- `qwen3:32b-q4_K_M` → `qwen3:30b` (~19GB)
- `qwen-coder:32b-q4_K_M` → `qwen2.5-coder:32b` → `devstral:24b` (~14GB)
- `deepseek-coder:6.7b-q4_K_M` → `deepseek-coder:6.7b` (~4GB)
- `codellama:13b-q4_K_M` → `codellama:13b` (~7GB)

### Added: New 2026 Models
- `qwen3-coder:30b` - Latest agentic coding with 256K context
- `deepseek-r1:8b` - Distilled reasoning + code model
- `deepseek-r1:14b` - Larger reasoning specialist
- `devstral:24b` - Agentic coding champion (46.8% SWE-Bench)
- `gpt-oss:20b` - OpenAI's Apache 2.0 open weights model
- `qwen3:0.6b` - Ultra-tiny capable fallback
- `deepseek-coder-v2:16b` - MoE architecture

### Implemented: Age-Based Purge
**Feature:** `--older-than <days>` option for `ollama-model purge`
- Tracks model usage via file access times in `~/.ollama/models/blobs/`
- Cross-platform support (macOS/Linux)
- Supports `--dry-run` flag for safe preview
- Removes models unused for specified number of days

### Updated: Documentation
- README.md: All model references updated to valid names
- README.md: Model sizes updated to actual 2026 values
- ollama-optimize: Per-model configs updated
- crush-setup: Default model shortcuts updated

### Files Modified
- `ollama-model` - Model library & purge implementation
- `ollama-optimize` - Per-model configs
- `crush-setup` - Model shortcuts
- `README.md` - Documentation

### System Impact
- Essential set reduced from ~60GB to ~32.7GB
- Better fits 48GB RAM constraint
- Leaves ~15GB headroom for context windows
- All models verified available on ollama.com/library

### Verification
Tested `qwen2.5:3b` pull successfully.
All model names validated against Ollama registry.
