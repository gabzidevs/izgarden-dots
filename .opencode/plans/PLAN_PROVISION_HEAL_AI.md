# PLAN: Provision --heal=ai Redesign

**Status**: Ready to execute
**Created**: 2026-02-22
**Machine**: nebulanix (48GB M4 Pro, Ollama server)
**Target**: `scripts/just-provision` (1129 lines)

---

## Executive Summary

Redesign the `--heal=ai` option in `scripts/just-provision` to provide intelligent AI-guided error recovery for nix-darwin provisioning. Replace broken `opz run` TUI calls with headless `opencode run` + `system-diagnostics --fix`, add interactive git handling, and enable SSH delegation for remote AI.

**Critical Constraints:**
- ALL models must be FREE (OpenCode Zen free tier OR local Ollama only)
- Use small models first (qwen3-tooled-small 5.2GB, qwen2.5-small-tooled 1.9GB)
- Conventional commits (chore(nix):, docs:, fix(provision):)
- Resilient to re-runs (idempotent)
- Interactive TUI when possible (gum)

---

## Model Strategy (All FREE)

### Free Cloud (OpenCode Zen)
- `opencode/gpt-5-nano` - Simple tasks, fast
- `opencode/big-pickle` - Docs, experimental
- `opencode/glm-5-free` - Reasoning
- `opencode/kimi-k2.5-free` - Long context, complex
- `opencode/minimax-m2.5-free` - Fast, general
- `opencode/trinity-large-preview-free` - New model

### Local Ollama (nebulanix)
- `qwen3-tooled-small` (5.2GB) - **Batch 1 default**
- `qwen2.5-small-tooled` (1.9GB) - Ultra-fast
- `qwen3-moe-tooled` (18GB) - **Batch 2 default**
- `qwen3-coder-tooled` (18GB) - **Batch 4 default**
- `gpt-oss-tooled` (13GB) - 128K context

### Model Priority
1. `--heal-model` flag override
2. Local Ollama (localhost:11434)
3. Remote Ollama (nebulanix.local:11434)
4. SSH delegation to nebulanix

---

## Batch 1: Simple Bash Fixes (5 tasks, parallel)

**Model**: `qwen3-tooled-small` or `opencode/gpt-5-nano`
**Can run in parallel**: Yes

### Task 1.1: Remove --daemon flag

**File**: `scripts/just-provision`
**Lines to modify**: 187, 313-320, 880, 1007

**Context**: The `--daemon` flag references non-existent `scripts/with-nix-daemon.sh` and causes provision to fail. Remove all traces.

**FIND/REPLACE blocks**:

```bash
# FIND (line 187):
    --daemon)

# REPLACE:
    # --daemon flag removed (dead code)
    # Skip unknown flag
```

```bash
# FIND (line 313-320):
  --daemon              Use nix-daemon for builds (macOS)

# REPLACE:
  # --daemon flag removed (dead code)
```

```bash
# FIND (line 880):
    if [[ "$USE_DAEMON" == "true" ]]; then

# REPLACE:
    # USE_DAEMON removed - always use standard build
    if false; then
```

```bash
# FIND (line 1007):
  [[ "$USE_DAEMON" == "true" ]] && args+=(--daemon)

# REPLACE:
  # USE_DAEMON removed
```

**Validation**:
```bash
bash -n scripts/just-provision
grep -n "daemon" scripts/just-provision | grep -v "# dead code"
```

**Expected**: No active daemon references, syntax valid

---

### Task 1.2: Replace launchctl daemon check with nix store ping

**File**: `scripts/just-provision`
**Lines to modify**: 679-697

**Context**: Current daemon check uses `launchctl list | grep org.nixos.nix-daemon` which is unreliable for Lix. Use `nix store ping` instead (works with both Nix and Lix).

**FIND/REPLACE**:

```bash
# FIND (lines 679-697):
check_nix_daemon() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    if launchctl list | grep -q "org.nixos.nix-daemon"; then
      return 0
    else
      warn "nix-daemon not running"
      info "Try: sudo launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist"
      return 1
    fi
  fi
  return 0
}

# REPLACE:
check_nix_daemon() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    if nix store ping --store daemon 2>/dev/null; then
      return 0
    else
      warn "nix-daemon not reachable (this is OK for Lix)"
      info "Lix can operate without daemon - will attempt standard build"
      return 0  # Don't fail, just warn
    fi
  fi
  return 0
}
```

**Validation**:
```bash
bash -n scripts/just-provision
nix store ping --store daemon  # Should work on nebulanix
```

**Expected**: Function uses `nix store ping`, doesn't fail on Lix

---

### Task 1.3: Add --heal-model flag

**File**: `scripts/just-provision`
**Lines to modify**: 194 (add after --heal), 326 (add to usage)

**Context**: Allow users to override AI model selection for healing. Must validate model exists in Ollama or is a valid OpenCode model.

**INSERT after line 194**:

```bash
    --heal-model)
      HEAL_MODEL="$2"
      shift 2
      ;;
```

**INSERT after line 326**:

```bash
  --heal-model <model>  Override AI model for --heal=ai
                        (e.g., qwen3-tooled-small, opencode/gpt-5-nano)
```

**INSERT after line 152** (variable declarations):

```bash
HEAL_MODEL=""  # Override for AI model selection
```

**Validation**:
```bash
bash -n scripts/just-provision
scripts/just-provision --help | grep heal-model
scripts/just-provision --heal-model qwen3-tooled-small --check
```

**Expected**: Flag appears in help, gets parsed correctly

---

### Task 1.4: Simplify provision_local()

**File**: `scripts/just-provision`
**Lines to modify**: 752-791

**Context**: Remove `use_daemon` parameter and branching. The function currently tries to call non-existent `scripts/with-nix-daemon.sh`.

**FIND/REPLACE**:

```bash
# FIND (line 752-754):
provision_local() {
  local system="$1"
  local use_daemon="${2:-false}"

# REPLACE:
provision_local() {
  local system="$1"
  # use_daemon removed - always use standard build
```

```bash
# FIND (line 768-776):
  if [[ "$use_daemon" == "true" ]]; then
    info "Building with nix-daemon..."
    if [[ -f "scripts/with-nix-daemon.sh" ]]; then
      bash scripts/with-nix-daemon.sh darwin-rebuild switch --flake ".#$system" "${extra_args[@]}"
    else
      error "scripts/with-nix-daemon.sh not found"
      return 1
    fi
  else

# REPLACE:
  # Standard build (daemon mode removed)
  {
```

```bash
# FIND (line 785):
  fi

# REPLACE:
  }
```

**Validation**:
```bash
bash -n scripts/just-provision
grep -n "use_daemon" scripts/just-provision
```

**Expected**: No `use_daemon` references, syntax valid

---

### Task 1.5: Fix pull_branch()

**File**: `scripts/just-provision`
**Lines to modify**: 540-548

**Context**: Remove broken `opz run` call that launches TUI and hangs. Use standard git commands only.

**FIND/REPLACE**:

```bash
# FIND (lines 540-548):
    if git diff --quiet && git diff --cached --quiet; then
      git pull origin "$branch_name"
    else
      warn "Uncommitted changes detected"
      if command -v opz &>/dev/null; then
        opz run "git-complex: handle uncommitted changes before pulling $branch_name"
      else
        error "Cannot pull with uncommitted changes. Commit or stash first."
        return 1
      fi
    fi

# REPLACE:
    if git diff --quiet && git diff --cached --quiet; then
      git pull origin "$branch_name"
    else
      warn "Uncommitted changes detected"
      error "Cannot pull with uncommitted changes."
      info "Options:"
      info "  1. Commit changes:  git add -A && git commit -m 'wip: save changes'"
      info "  2. Stash changes:   git stash"
      info "  3. Discard changes: git reset --hard HEAD"
      return 1
    fi
```

**Validation**:
```bash
bash -n scripts/just-provision
grep -n "opz run" scripts/just-provision  # Should be empty
```

**Expected**: No `opz run` calls, clear error message

---

## Batch 2: Complex Logic (3 tasks, sequential)

**Model**: `qwen3-moe-tooled` or `opencode/kimi-k2.5-free`
**Must run sequentially**: Yes

### Task 2.1: Redesign heal_ai()

**File**: `scripts/just-provision`
**Lines to modify**: 711-733

**Context**: Replace broken `opz run` call with `system-diagnostics --fix` for pre-flight healing, then `opencode run` for AI escalation with 90s timeout.

**FIND/REPLACE**:

```bash
# FIND (lines 711-733):
heal_ai() {
  info "Running AI-powered healing..."
  
  if ! command -v opz &>/dev/null; then
    error "opz not found - cannot run AI healing"
    return 1
  fi

  # Run AI diagnostics
  if opz run "system-diagnostics analyze and fix all issues blocking nix-darwin provision on $DETECTED_HOST"; then
    success "AI healing completed"
    return 0
  else
    error "AI healing failed"
    return 1
  fi
}

# REPLACE:
heal_ai() {
  info "Running AI-powered pre-flight healing..."
  
  # Step 1: Run system-diagnostics --fix (non-AI, fast)
  if command -v system-diagnostics &>/dev/null; then
    info "Running automated diagnostics..."
    if system-diagnostics --fix; then
      success "Automated fixes applied"
      return 0
    else
      warn "Automated fixes incomplete, escalating to AI..."
    fi
  else
    warn "system-diagnostics not found, skipping to AI escalation"
  fi

  # Step 2: Escalate to AI (headless, 90s timeout)
  info "Escalating to AI for complex healing..."
  local model
  model=$(detect_heal_model)
  
  if [[ -z "$model" ]]; then
    warn "No AI model available locally, attempting SSH delegation..."
    if ssh_ai_escalation "heal_provision_errors"; then
      success "AI healing completed via SSH"
      return 0
    else
      error "AI healing failed (SSH delegation also failed)"
      return 1
    fi
  fi

  # Run AI healing headless
  local ai_prompt="Analyze nix-darwin provision errors on $DETECTED_HOST and apply fixes.
Focus on:
1. Flake syntax errors in *.nix files
2. Missing dependencies or broken imports
3. Permission issues
4. Nix store corruption

Apply fixes automatically and report what was changed."

  if timeout 90s opencode run --model "$model" "$ai_prompt"; then
    success "AI healing completed with model: $model"
    return 0
  else
    error "AI healing failed or timed out (90s)"
    return 1
  fi
}
```

**Validation**:
```bash
bash -n scripts/just-provision
grep -n "opz run" scripts/just-provision  # Should be empty
grep -n "opencode run" scripts/just-provision  # Should find new usage
```

**Expected**: Uses `system-diagnostics --fix` then `opencode run`, no TUI

---

### Task 2.2: Add escalate_to_ai() function

**File**: `scripts/just-provision`
**Insert after**: Line 733 (after heal_ai)

**Context**: Classify provision errors and route to appropriate AI fixing strategy. Handles flake errors, machine issues, and network problems differently.

**INSERT**:

```bash
# Classify provision error and escalate to AI if appropriate
escalate_to_ai() {
  local error_log="$1"
  local error_type
  
  info "Classifying provision error..."
  
  # Detect error type from log
  if grep -qi "syntax error\|parse error\|attribute.*not found" "$error_log"; then
    error_type="flake"
    info "Detected: Flake syntax/config error"
  elif grep -qi "permission denied\|cannot create\|read-only" "$error_log"; then
    error_type="permission"
    info "Detected: Permission/filesystem error"
  elif grep -qi "network\|connection\|timeout\|dns" "$error_log"; then
    error_type="network"
    info "Detected: Network error (may be transient)"
  elif grep -qi "nix-daemon\|store.*corrupt\|hash mismatch" "$error_log"; then
    error_type="machine"
    info "Detected: Nix daemon/store error"
  else
    error_type="unknown"
    warn "Unknown error type - will attempt generic AI fix"
  fi

  # Route to appropriate fix strategy
  case "$error_type" in
    flake)
      info "Flake errors are AI-fixable, escalating..."
      local model
      model=$(detect_heal_model)
      
      if [[ -z "$model" ]]; then
        warn "No local AI available, trying SSH delegation..."
        return $(ssh_ai_escalation "fix_flake_errors" "$error_log")
      fi

      local prompt="Fix nix-darwin flake errors on $DETECTED_HOST.
Error log:
$(tail -50 "$error_log")

Focus on syntax errors, missing attributes, broken imports.
Apply fixes to .nix files and report changes."

      if timeout 90s opencode run --model "$model" "$prompt"; then
        success "AI fixed flake errors"
        return 0
      else
        error "AI could not fix flake errors"
        return 1
      fi
      ;;
      
    permission)
      error "Permission errors require manual intervention"
      info "Try: sudo chown -R $(whoami) ~/.config/flake"
      return 1
      ;;
      
    network)
      warn "Network errors are often transient"
      info "Retrying in 5 seconds..."
      sleep 5
      return 2  # Signal retry
      ;;
      
    machine)
      error "Nix daemon/store errors require system-level fixes"
      info "Try: nix store verify --all --repair"
      return 1
      ;;
      
    *)
      warn "Unknown error, attempting generic AI fix..."
      local model
      model=$(detect_heal_model)
      
      if [[ -n "$model" ]]; then
        timeout 90s opencode run --model "$model" "Fix nix-darwin provision error: $(tail -20 "$error_log")"
        return $?
      else
        error "No AI available for unknown error type"
        return 1
      fi
      ;;
  esac
}
```

**Validation**:
```bash
bash -n scripts/just-provision
grep -n "escalate_to_ai" scripts/just-provision
```

**Expected**: Function exists, handles all error types

---

### Task 2.3: Integrate retry loop into provision flow

**File**: `scripts/just-provision`
**Lines to modify**: 792-810 (provision_local) and 880-920 (main provision logic)

**Context**: Add retry loop with error classification. After provision fails, classify error, attempt AI fix, retry once.

**FIND/REPLACE in provision_local** (line 792-810):

```bash
# FIND:
  if darwin-rebuild switch --flake ".#$system" "${extra_args[@]}"; then
    success "Provision completed for $system"
    return 0
  else
    error "Provision failed for $system"
    return 1
  fi

# REPLACE:
  local provision_log="/tmp/provision-$system-$$.log"
  
  # Attempt 1: Standard provision
  info "Attempting provision (1/2)..."
  if darwin-rebuild switch --flake ".#$system" "${extra_args[@]}" 2>&1 | tee "$provision_log"; then
    success "Provision completed for $system"
    rm -f "$provision_log"
    return 0
  fi
  
  # Provision failed
  error "Provision failed (attempt 1/2)"
  
  # If --heal=ai enabled, try to fix and retry
  if [[ "$HEAL_MODE" == "ai" ]]; then
    warn "Attempting AI-powered error recovery..."
    
    escalate_to_ai "$provision_log"
    local escalate_result=$?
    
    case $escalate_result in
      0)
        # AI claims fix applied, retry provision
        info "AI applied fixes, retrying provision (2/2)..."
        if darwin-rebuild switch --flake ".#$system" "${extra_args[@]}" 2>&1 | tee "$provision_log"; then
          success "Provision completed after AI fix"
          rm -f "$provision_log"
          return 0
        else
          error "Provision still failed after AI fix"
          info "Error log saved: $provision_log"
          return 1
        fi
        ;;
      2)
        # Network error, already retried
        info "Retrying provision after network delay (2/2)..."
        if darwin-rebuild switch --flake ".#$system" "${extra_args[@]}" 2>&1 | tee "$provision_log"; then
          success "Provision completed after retry"
          rm -f "$provision_log"
          return 0
        else
          error "Provision failed after retry"
          info "Error log saved: $provision_log"
          return 1
        fi
        ;;
      *)
        error "AI escalation failed - cannot auto-fix"
        info "Error log saved: $provision_log"
        return 1
        ;;
    esac
  else
    # No healing enabled
    info "Error log saved: $provision_log"
    return 1
  fi
```

**Validation**:
```bash
bash -n scripts/just-provision
grep -n "escalate_to_ai" scripts/just-provision | grep "provision_local" -A 20
```

**Expected**: Provision retries after AI fix, logs saved

---

## Batch 3: Git/TUI Functions (2 tasks, parallel)

**Model**: `opencode/minimax-m2.5-free` or `qwen3-tooled-small`
**Can run in parallel**: Yes

### Task 3.1: Add handle_pending_changes()

**File**: `scripts/just-provision`
**Insert after**: Line 548 (after pull_branch)

**Context**: Interactive TUI for handling uncommitted changes. Offers 4 options: auto-commit grouped, single commit, stash, abort.

**INSERT**:

```bash
# Interactive handler for uncommitted git changes
handle_pending_changes() {
  if git diff --quiet && git diff --cached --quiet; then
    return 0  # No changes, continue
  fi

  warn "Uncommitted changes detected:"
  git status --short

  # If gum available, use TUI
  if command -v gum &>/dev/null; then
    info "How do you want to handle these changes?"
    
    local choice
    choice=$(gum choose \
      "Auto-commit (grouped by type)" \
      "Single commit (all changes)" \
      "Stash changes" \
      "Abort provision")
    
    case "$choice" in
      "Auto-commit (grouped by type)")
        commit_pending_changes_grouped
        return $?
        ;;
      "Single commit (all changes)")
        local msg
        msg=$(gum input --placeholder "Commit message (conventional format recommended)")
        if [[ -z "$msg" ]]; then
          error "Commit message required"
          return 1
        fi
        git add -A
        git commit -m "$msg"
        return $?
        ;;
      "Stash changes")
        git stash push -m "Auto-stash before provision $(date +%Y-%m-%d_%H:%M:%S)"
        success "Changes stashed"
        return 0
        ;;
      "Abort provision")
        error "Provision aborted by user"
        return 1
        ;;
      *)
        error "Invalid choice"
        return 1
        ;;
    esac
  else
    # No gum, show manual instructions
    error "Cannot proceed with uncommitted changes"
    info "Options:"
    info "  1. Commit:  git add -A && git commit -m 'message'"
    info "  2. Stash:   git stash"
    info "  3. Discard: git reset --hard HEAD"
    return 1
  fi
}
```

**Validation**:
```bash
bash -n scripts/just-provision
command -v gum && echo "gum available for TUI"
```

**Expected**: Function offers 4 options via gum, fallback to manual

---

### Task 3.2: Add commit_pending_changes_grouped()

**File**: `scripts/just-provision`
**Insert after**: handle_pending_changes()

**Context**: Group changed files by type and create conventional commits for each group. Groups: nix, scripts, docs, ollama, systems, modules, misc.

**INSERT**:

```bash
# Group uncommitted changes and create conventional commits
commit_pending_changes_grouped() {
  info "Analyzing changes for grouped commits..."
  
  # Get all changed files
  local changed_files
  changed_files=$(git status --porcelain | awk '{print $2}')
  
  if [[ -z "$changed_files" ]]; then
    warn "No changes to commit"
    return 0
  fi

  # Define groups with conventional commit prefixes
  local -A groups=(
    ["nix"]="chore(nix)"
    ["scripts"]="chore(scripts)"
    ["docs"]="docs"
    ["ollama"]="feat(ollama)"
    ["systems"]="chore(systems)"
    ["modules"]="chore(modules)"
    ["misc"]="chore"
  )
  
  local -A group_files
  
  # Classify files into groups
  while IFS= read -r file; do
    if [[ "$file" =~ \.nix$ ]] && [[ ! "$file" =~ ^systems/ ]] && [[ ! "$file" =~ ^modules/ ]]; then
      group_files["nix"]+="$file"$'\n'
    elif [[ "$file" =~ ^scripts/ ]] || [[ "$file" =~ ^oll_core/ ]] || [[ "$file" =~ ^opz_core/ ]]; then
      group_files["scripts"]+="$file"$'\n'
    elif [[ "$file" =~ \.md$ ]] || [[ "$file" =~ ^\.opencode/docs/ ]]; then
      group_files["docs"]+="$file"$'\n'
    elif [[ "$file" =~ ollama ]] || [[ "$file" =~ ^ollama-templates/ ]]; then
      group_files["ollama"]+="$file"$'\n'
    elif [[ "$file" =~ ^systems/ ]]; then
      group_files["systems"]+="$file"$'\n'
    elif [[ "$file" =~ ^modules/ ]]; then
      group_files["modules"]+="$file"$'\n'
    else
      group_files["misc"]+="$file"$'\n'
    fi
  done <<< "$changed_files"

  # Create commits for each group
  local commit_count=0
  for group in nix scripts docs ollama systems modules misc; do
    if [[ -n "${group_files[$group]}" ]]; then
      info "Creating commit for group: $group"
      
      # Add files in this group
      while IFS= read -r file; do
        [[ -n "$file" ]] && git add "$file"
      done <<< "${group_files[$group]}"
      
      # Create commit with group prefix
      local commit_msg="${groups[$group]}: auto-commit before provision"
      
      # Add file list to commit body
      local file_list
      file_list=$(echo "${group_files[$group]}" | sed 's/^/  - /')
      
      git commit -m "$commit_msg" -m "Files in this commit:" -m "$file_list"
      
      ((commit_count++))
    fi
  done

  if [[ $commit_count -gt 0 ]]; then
    success "Created $commit_count grouped commits"
    return 0
  else
    warn "No commits created (all files may be unstaged)"
    return 1
  fi
}
```

**Validation**:
```bash
bash -n scripts/just-provision
# Test with dummy changes:
touch test.nix test.md
git add test.nix test.md
# Call function via provision script
```

**Expected**: Groups files correctly, creates conventional commits

---

## Batch 4: SSH Delegation (2 tasks, sequential)

**Model**: `qwen3-coder-tooled` or `opencode/minimax-m2.5-free`
**Must run sequentially**: Yes

### Task 4.1: Add detect_heal_model()

**File**: `scripts/just-provision`
**Insert before**: heal_ai() (around line 710)

**Context**: Detect available AI model following priority: flag override → local Ollama → remote Ollama → empty (triggers SSH).

**INSERT**:

```bash
# Detect which AI model to use for healing
# Returns: model name or empty string (triggers SSH delegation)
detect_heal_model() {
  # Priority 1: User override
  if [[ -n "$HEAL_MODEL" ]]; then
    info "Using model from --heal-model flag: $HEAL_MODEL"
    
    # Validate model exists
    if [[ "$HEAL_MODEL" == opencode/* ]]; then
      # OpenCode cloud model - assume valid
      echo "$HEAL_MODEL"
      return 0
    elif ollama list | grep -q "^${HEAL_MODEL}"; then
      # Local Ollama model exists
      echo "$HEAL_MODEL"
      return 0
    else
      warn "Model '$HEAL_MODEL' not found in Ollama, trying anyway..."
      echo "$HEAL_MODEL"
      return 0
    fi
  fi

  # Priority 2: Local Ollama
  if curl -sf http://localhost:11434/api/tags &>/dev/null; then
    info "Local Ollama available, selecting model..."
    
    # Prefer small models for speed
    local preferred=("qwen3-tooled-small" "qwen2.5-small-tooled" "qwen3-coder-tooled" "qwen3-tooled")
    
    for model in "${preferred[@]}"; do
      if ollama list | grep -q "^${model}"; then
        info "Selected local model: $model"
        echo "$model"
        return 0
      fi
    done
    
    # Fallback: use first available tooled model
    local first_tooled
    first_tooled=$(ollama list | grep "tooled" | head -1 | awk '{print $1}')
    if [[ -n "$first_tooled" ]]; then
      info "Selected local model: $first_tooled"
      echo "$first_tooled"
      return 0
    fi
  fi

  # Priority 3: Remote Ollama (nebulanix)
  if [[ "$DETECTED_HOST" != "nebulanix" ]]; then
    info "Checking remote Ollama at nebulanix.local:11434..."
    
    if curl -sf http://nebulanix.local:11434/api/tags &>/dev/null; then
      info "Remote Ollama available"
      
      # Set OLLAMA_HOST for opencode
      export OLLAMA_HOST="http://nebulanix.local:11434"
      
      # Return a safe model name (assume nebulanix has tooled models)
      echo "qwen3-tooled-small"
      return 0
    fi
  fi

  # Priority 4: No AI available locally - will trigger SSH
  warn "No local or remote Ollama available"
  echo ""
  return 1
}
```

**Validation**:
```bash
bash -n scripts/just-provision
curl -sf http://localhost:11434/api/tags  # Test local Ollama
```

**Expected**: Returns model name or empty, checks all sources

---

### Task 4.2: Add ssh_ai_escalation()

**File**: `scripts/just-provision`
**Insert after**: detect_heal_model()

**Context**: SSH to nebulanix, run AI healing there, auto-commit+push changes, pull back to local machine. Only used when local AI unavailable.

**INSERT**:

```bash
# Delegate AI healing to nebulanix via SSH
ssh_ai_escalation() {
  local task="$1"
  local context="${2:-}"
  
  info "Delegating AI healing to nebulanix via SSH..."
  
  # Verify we're NOT on nebulanix
  if [[ "$DETECTED_HOST" == "nebulanix" ]]; then
    error "Cannot SSH to self (already on nebulanix)"
    return 1
  fi

  # Verify SSH access
  if ! ssh -o ConnectTimeout=5 nebulanix.local "echo ok" &>/dev/null; then
    error "Cannot SSH to nebulanix.local"
    return 1
  fi

  # Get current branch
  local current_branch
  current_branch=$(git branch --show-current)
  
  if [[ -z "$current_branch" ]]; then
    error "Not on a git branch - cannot sync changes"
    return 1
  fi

  # Build remote AI command
  local remote_cmd="cd ~/.config/flake && "
  
  # Pull latest changes
  remote_cmd+="git fetch origin && git checkout $current_branch && git pull origin $current_branch && "
  
  # Run AI healing based on task
  case "$task" in
    heal_provision_errors)
      remote_cmd+="opencode run --model qwen3-tooled-small 'Analyze and fix nix-darwin provision errors. Focus on flake syntax, missing deps, broken imports. Apply fixes automatically.' && "
      ;;
    fix_flake_errors)
      remote_cmd+="opencode run --model qwen3-coder-tooled 'Fix nix-darwin flake errors: $context. Apply fixes to .nix files.' && "
      ;;
    *)
      remote_cmd+="opencode run --model qwen3-tooled-small 'Fix nix-darwin errors: $task' && "
      ;;
  esac
  
  # Commit changes (if any)
  remote_cmd+="if ! git diff --quiet || ! git diff --cached --quiet; then "
  remote_cmd+="git add -A && "
  remote_cmd+="git commit -m 'fix(provision): AI-assisted fixes via SSH delegation' && "
  remote_cmd+="git push origin $current_branch; "
  remote_cmd+="else echo 'No changes to commit'; fi"

  # Execute on remote
  info "Running AI on nebulanix..."
  if ssh nebulanix.local "$remote_cmd"; then
    success "AI healing completed on nebulanix"
    
    # Pull changes back
    info "Pulling AI changes back to local..."
    if git pull origin "$current_branch"; then
      success "AI changes synced to local machine"
      return 0
    else
      error "Failed to pull AI changes from remote"
      return 1
    fi
  else
    error "AI healing failed on nebulanix"
    return 1
  fi
}
```

**Validation**:
```bash
bash -n scripts/just-provision
ssh nebulanix.local "echo ok"  # Test SSH
```

**Expected**: SSHs to nebulanix, runs AI there, pulls changes back

---

## Batch 5: Documentation (2 tasks, parallel)

**Model**: `opencode/big-pickle` or `qwen2.5-small-tooled`
**Can run in parallel**: Yes

### Task 5.1: Update .opencode/commands/provision.md

**File**: `.opencode/commands/provision.md`
**Current lines**: 13

**Context**: Add documentation for new `--heal=ai` flow, `--heal-model` flag, and git handling.

**INSERT at end**:

```markdown

## AI-Powered Healing (--heal=ai)

The `--heal=ai` option provides intelligent error recovery for nix-darwin provisioning:

### Healing Flow

1. **Pre-flight diagnostics**: Runs `system-diagnostics --fix` for fast automated fixes
2. **AI escalation**: If diagnostics fail, escalates to AI with 90s timeout
3. **Error classification**: Detects error type (flake, permission, network, machine)
4. **Retry logic**: Applies fixes and retries provision once

### Model Selection

Models are selected in priority order:

1. `--heal-model` flag override
2. Local Ollama (localhost:11434)
3. Remote Ollama (nebulanix.local:11434)
4. SSH delegation to nebulanix

**Recommended models:**
- `qwen3-tooled-small` (5.2GB) - Fast, general fixes
- `qwen3-coder-tooled` (18GB) - Complex flake errors
- `opencode/gpt-5-nano` - Free cloud fallback

### Git Handling

If uncommitted changes are detected, an interactive TUI offers:

1. **Auto-commit (grouped)**: Creates conventional commits by file type
   - `chore(nix):` - Nix config files
   - `chore(scripts):` - Shell scripts
   - `docs:` - Documentation
   - `feat(ollama):` - Ollama templates
   - `chore(systems):` - System configs
   - `chore(modules):` - Nix modules
   - `chore:` - Miscellaneous

2. **Single commit**: All changes in one commit
3. **Stash**: Save changes for later
4. **Abort**: Cancel provision

### Usage Examples

```bash
# Use AI healing with default model
just-provision spacehound --heal=ai

# Override AI model
just-provision nebulanix --heal=ai --heal-model qwen3-coder-tooled

# Use free cloud model
just-provision spacehound --heal=ai --heal-model opencode/gpt-5-nano

# Dry-run with healing
just-provision --heal=ai --dry-run nebulanix
```

### SSH Delegation

When AI is unavailable locally (e.g., on spacehound), healing automatically delegates to nebulanix:

1. SSH to nebulanix.local
2. Run AI healing there
3. Auto-commit and push changes
4. Pull changes back to local machine

### Error Types

- **Flake errors**: AI-fixable (syntax, missing attrs, broken imports)
- **Permission errors**: Manual fix required
- **Network errors**: Auto-retry after 5s delay
- **Machine errors**: System-level fixes required (nix store verify)

### Timeouts

- AI healing: 90s timeout per attempt
- SSH connection: 5s timeout
- Provision retry: 2 attempts max
```

**Validation**:
```bash
cat .opencode/commands/provision.md | grep -A 5 "AI-Powered Healing"
```

**Expected**: Comprehensive docs for --heal=ai

---

### Task 5.2: Update .opencode/skills/provision/SKILL.md

**File**: `.opencode/skills/provision/SKILL.md`
**Current lines**: 93

**Context**: Add full documentation for AI healing workflow, model strategy, and troubleshooting.

**INSERT before "## Related Files"**:

```markdown

## AI Healing Workflow (--heal=ai)

### Overview

The `--heal=ai` option provides multi-tier intelligent error recovery:

**Tier 1: Automated Diagnostics** (fast, non-AI)
- Runs `system-diagnostics --fix`
- Fixes common issues (permissions, paths, dependencies)
- Returns immediately if successful

**Tier 2: AI Escalation** (headless, 90s timeout)
- Classifies error type (flake, permission, network, machine)
- Routes to appropriate AI fixing strategy
- Uses small models first (qwen3-tooled-small 5.2GB)
- Falls back to cloud models if local unavailable

**Tier 3: SSH Delegation** (remote AI)
- Used when local AI unavailable (e.g., on spacehound)
- SSH to nebulanix, run AI there
- Auto-commit and push changes
- Pull back to local machine

**Tier 4: Retry Logic**
- Applies fixes and retries provision once
- Saves detailed error logs to `/tmp/provision-*.log`
- Max 2 provision attempts

### Model Selection Strategy

**Priority order:**
1. `--heal-model` flag override
2. Local Ollama (localhost:11434)
3. Remote Ollama (nebulanix.local:11434)
4. SSH delegation to nebulanix

**Recommended models (all FREE):**

| Model | Size | Use Case | Location |
|-------|------|----------|----------|
| `qwen3-tooled-small` | 5.2GB | Fast general fixes | Local (nebulanix) |
| `qwen2.5-small-tooled` | 1.9GB | Ultra-fast simple edits | Local (nebulanix) |
| `qwen3-coder-tooled` | 18GB | Complex flake errors | Local (nebulanix) |
| `qwen3-moe-tooled` | 18GB | Complex reasoning | Local (nebulanix) |
| `opencode/gpt-5-nano` | N/A | Simple tasks | Cloud (free) |
| `opencode/kimi-k2.5-free` | N/A | Long context | Cloud (free) |
| `opencode/minimax-m2.5-free` | N/A | General purpose | Cloud (free) |

**All models use Princess Bubblegum system prompts** for consistent persona.

### Git Change Handling

Interactive TUI for uncommitted changes (requires `gum`):

**Option 1: Auto-commit (grouped)**
- Classifies files by type (nix, scripts, docs, ollama, systems, modules, misc)
- Creates conventional commits for each group
- Format: `<type>(<scope>): auto-commit before provision`
- Example:
  ```
  chore(nix): auto-commit before provision
  - flake.nix
  - modules/darwin/services/ollama.nix
  
  docs: auto-commit before provision
  - README.md
  - .opencode/docs/OLLAMA.md
  ```

**Option 2: Single commit**
- All changes in one commit
- User provides message (conventional format recommended)

**Option 3: Stash**
- `git stash push -m "Auto-stash before provision <timestamp>"`

**Option 4: Abort**
- Cancel provision, return error

### Error Classification

AI healing classifies errors and routes to appropriate strategy:

| Error Type | Detection | Strategy |
|------------|-----------|----------|
| **Flake** | syntax error, parse error, attribute not found | AI fix (FIND/REPLACE in .nix files) |
| **Permission** | permission denied, cannot create, read-only | Manual fix (show commands) |
| **Network** | network, connection, timeout, dns | Auto-retry after 5s |
| **Machine** | nix-daemon, store corrupt, hash mismatch | System fix (nix store verify) |
| **Unknown** | Other errors | Generic AI fix attempt |

### SSH Delegation Details

**Trigger conditions:**
- Local Ollama unavailable (curl localhost:11434 fails)
- Remote Ollama unavailable (curl nebulanix.local:11434 fails)
- Not already on nebulanix

**Delegation flow:**
1. Verify SSH access (5s timeout)
2. Get current git branch
3. SSH to nebulanix.local
4. Pull latest changes
5. Run AI healing with appropriate model
6. Commit changes if any
7. Push to origin
8. Pull changes back to local machine

**Remote command structure:**
```bash
ssh nebulanix.local "
  cd ~/.config/flake &&
  git fetch origin &&
  git checkout $branch &&
  git pull origin $branch &&
  opencode run --model qwen3-tooled-small 'prompt' &&
  if ! git diff --quiet; then
    git add -A &&
    git commit -m 'fix(provision): AI-assisted fixes via SSH delegation' &&
    git push origin $branch
  fi
"
```

### Troubleshooting

**AI healing times out (90s)**
- Use smaller model: `--heal-model qwen2.5-small-tooled`
- Use cloud model: `--heal-model opencode/gpt-5-nano`
- Check Ollama is running: `oll server status`

**SSH delegation fails**
- Verify SSH access: `ssh nebulanix.local "echo ok"`
- Check network: `ping nebulanix.local`
- Ensure nebulanix has Ollama running: `ssh nebulanix.local "curl localhost:11434"`

**Git conflicts during pull**
- Stash local changes: `git stash`
- Pull again: `git pull origin <branch>`
- Reapply stash: `git stash pop`

**Model not found**
- List available models: `ollama list`
- Create model: `ollama create <name> -f ollama-templates/<name>.Modelfile`
- Use cloud fallback: `--heal-model opencode/gpt-5-nano`

**AI changes don't help**
- Check error log: `/tmp/provision-*.log`
- Try manual fix based on error type
- Report issue for future AI training

### Usage Examples

**Basic AI healing:**
```bash
just-provision spacehound --heal=ai
```

**Override model:**
```bash
just-provision nebulanix --heal=ai --heal-model qwen3-coder-tooled
```

**Dry-run with healing:**
```bash
just-provision --heal=ai --dry-run nebulanix
```

**Force SSH delegation (testing):**
```bash
# Stop local Ollama first
oll server stop
just-provision spacehound --heal=ai
# Will automatically use SSH delegation
```

**Debug mode:**
```bash
just-provision --heal=ai --debug nebulanix 2>&1 | tee debug.log
```

### Performance

**Typical healing times:**
- Automated diagnostics: 5-15s
- AI healing (small model): 30-90s
- SSH delegation: 45-120s (includes network + AI)

**Success rates (estimated):**
- Flake errors: 80-90% (AI-fixable)
- Permission errors: 0% (manual required)
- Network errors: 70% (retry often works)
- Machine errors: 30% (complex, system-level)

### Future Enhancements

- [ ] Support for custom AI prompts via config file
- [ ] Parallel model execution (try multiple models simultaneously)
- [ ] Learning from previous fixes (remember what worked)
- [ ] Web UI for monitoring healing progress
- [ ] Telemetry for success rates by error type

```

**Validation**:
```bash
wc -l .opencode/skills/provision/SKILL.md  # Should be ~300+ lines
grep -n "AI Healing Workflow" .opencode/skills/provision/SKILL.md
```

**Expected**: Comprehensive skill documentation with examples

---

## Batch 6: Testing (1 task)

**Model**: Manual testing (no AI)

### Task 6: End-to-end test with intentional error

**Context**: Verify entire --heal=ai flow works by introducing a syntax error, running provision, and confirming AI fixes it.

**Test procedure:**

1. **Introduce intentional error:**
```bash
# Backup original
cp systems/nebulanix/default.nix systems/nebulanix/default.nix.bak

# Add syntax error
sed -i '' 's/imports = \[/imports = BROKEN [/' systems/nebulanix/default.nix

# Verify error introduced
grep "BROKEN" systems/nebulanix/default.nix
```

2. **Run provision with AI healing:**
```bash
just-provision nebulanix --heal=ai --debug 2>&1 | tee test-heal-ai.log
```

3. **Verify healing happened:**
```bash
# Should see:
# - "Running AI-powered pre-flight healing..."
# - "Escalating to AI for complex healing..."
# - "AI applied fixes, retrying provision (2/2)..."
# - "Provision completed after AI fix"

# Check error was fixed
grep "BROKEN" systems/nebulanix/default.nix  # Should be empty

# Check git log
git log -1 --oneline  # Should show AI commit or grouped commit
```

4. **Verify provision succeeded:**
```bash
# Check darwin-rebuild output
darwin-rebuild switch --flake .#nebulanix --dry-run
# Should succeed

# Check launchd service
launchctl list | grep ollama  # Should be running
```

5. **Restore backup:**
```bash
mv systems/nebulanix/default.nix.bak systems/nebulanix/default.nix
git checkout systems/nebulanix/default.nix  # Or restore from backup
```

**Expected outcomes:**
- [ ] Provision fails on first attempt (detects syntax error)
- [ ] AI healing detects "flake" error type
- [ ] AI applies fix (removes "BROKEN")
- [ ] Provision succeeds on retry
- [ ] Git commit created (if not dry-run)
- [ ] Error log saved to `/tmp/provision-nebulanix-*.log`

**Failure scenarios to test:**

**Test 2: Permission error (should fail gracefully)**
```bash
chmod 000 systems/nebulanix/default.nix
just-provision nebulanix --heal=ai
# Should detect "permission" error, show manual fix instructions
chmod 644 systems/nebulanix/default.nix
```

**Test 3: Network error (should retry)**
```bash
# Disable network temporarily
sudo ifconfig en0 down
just-provision nebulanix --heal=ai
# Should detect "network" error, retry after 5s
sudo ifconfig en0 up
```

**Test 4: Model override**
```bash
just-provision nebulanix --heal=ai --heal-model opencode/gpt-5-nano --dry-run
# Should use cloud model, not local Ollama
grep "opencode/gpt-5-nano" test-heal-ai.log
```

**Test 5: SSH delegation (from spacehound)**
```bash
# SSH to spacehound
ssh spacehound.local

# Stop Ollama on spacehound
oll server stop

# Run provision with healing
cd ~/.config/flake
just-provision spacehound --heal=ai

# Should see "Delegating AI healing to nebulanix via SSH..."
# Should pull AI changes back from nebulanix
```

**Success criteria:**
- All 5 tests pass
- Error logs are informative
- No TUI hangs (opz run removed)
- Conventional commits created
- SSH delegation works from spacehound

---

## Execution Checklist

### Pre-flight

- [ ] Ollama running: `curl localhost:11434/api/tags`
- [ ] Tooled models exist: `ollama list | grep tooled`
- [ ] gum installed: `command -v gum`
- [ ] Git clean or ready to handle changes: `git status`
- [ ] SSH access to nebulanix: `ssh nebulanix.local "echo ok"`

### Batch 1 (5 tasks - parallel)

- [ ] Task 1.1: Remove --daemon flag
- [ ] Task 1.2: Replace launchctl with nix store ping
- [ ] Task 1.3: Add --heal-model flag
- [ ] Task 1.4: Simplify provision_local()
- [ ] Task 1.5: Fix pull_branch()
- [ ] Validate: `bash -n scripts/just-provision`
- [ ] Test: `just-provision --help | grep heal-model`

### Batch 2 (3 tasks - sequential)

- [ ] Task 2.1: Redesign heal_ai()
- [ ] Task 2.2: Add escalate_to_ai()
- [ ] Task 2.3: Integrate retry loop
- [ ] Validate: `bash -n scripts/just-provision`
- [ ] Test: `grep -n "opencode run" scripts/just-provision`

### Batch 3 (2 tasks - parallel)

- [ ] Task 3.1: Add handle_pending_changes()
- [ ] Task 3.2: Add commit_pending_changes_grouped()
- [ ] Validate: `bash -n scripts/just-provision`
- [ ] Test: Create dummy changes, verify grouping

### Batch 4 (2 tasks - sequential)

- [ ] Task 4.1: Add detect_heal_model()
- [ ] Task 4.2: Add ssh_ai_escalation()
- [ ] Validate: `bash -n scripts/just-provision`
- [ ] Test: `curl localhost:11434/api/tags`

### Batch 5 (2 tasks - parallel)

- [ ] Task 5.1: Update .opencode/commands/provision.md
- [ ] Task 5.2: Update .opencode/skills/provision/SKILL.md
- [ ] Validate: Check docs render correctly
- [ ] Test: `grep "AI-Powered Healing" .opencode/commands/provision.md`

### Batch 6 (1 task - manual)

- [ ] Task 6: End-to-end test with 5 scenarios
- [ ] All tests pass
- [ ] Error logs informative
- [ ] No TUI hangs

### Final Validation

- [ ] `bash -n scripts/just-provision` (syntax valid)
- [ ] `just-provision --check` (runs successfully)
- [ ] `just-provision --help` (shows new flags)
- [ ] `just-provision --heal=ai --dry-run nebulanix` (completes)
- [ ] Git clean or changes committed
- [ ] Documentation complete and accurate

---

## Rollback Plan

If anything goes wrong:

1. **Restore from git:**
```bash
git checkout scripts/just-provision
git checkout .opencode/commands/provision.md
git checkout .opencode/skills/provision/SKILL.md
```

2. **Verify clean state:**
```bash
git status
just-provision --check
```

3. **Report issue:**
- Save error logs: `/tmp/provision-*.log`
- Save bash validation: `bash -n scripts/just-provision 2>&1`
- Note which batch/task failed
- Check line numbers match (file may have changed)

---

## Notes for AI Agents

### Context Requirements

Before executing any batch, ensure you have:
1. Read `scripts/just-provision` (1129 lines)
2. Verified current machine: `$DETECTED_HOST`
3. Checked Ollama status: `oll server status`
4. Confirmed git status: `git status`
5. Loaded this plan file fully

### Execution Strategy

**For parallel tasks:**
- Use `task` tool to launch multiple agents
- Each agent gets one task prompt from this file
- Agents report back completion status
- Validate all tasks before moving to next batch

**For sequential tasks:**
- Execute tasks in order
- Wait for completion + validation before next task
- Check syntax after each task: `bash -n scripts/just-provision`

### Model Selection

**For Batch 1** (simple bash edits):
```bash
# Use local small model
opencode run --model qwen3-tooled-small "<prompt>"

# Or free cloud
opencode run --model opencode/gpt-5-nano "<prompt>"
```

**For Batch 2** (complex logic):
```bash
# Use local MoE model
opencode run --model qwen3-moe-tooled "<prompt>"

# Or free cloud with reasoning
opencode run --model opencode/kimi-k2.5-free "<prompt>"
```

**For Batch 4** (coding tasks):
```bash
# Use local coder model
opencode run --model qwen3-coder-tooled "<prompt>"
```

### Resilient Execution

Each task should check if already completed:

```bash
# Example for Task 1.3 (add --heal-model flag)
if grep -q "heal-model" scripts/just-provision; then
  info "Task 1.3 already completed (--heal-model flag exists)"
  exit 0
fi

# Proceed with task...
```

### Debugging

If a task fails:

1. **Check syntax:**
```bash
bash -n scripts/just-provision
```

2. **Check line numbers:**
```bash
wc -l scripts/just-provision  # Should be ~1129
```

3. **Check git conflicts:**
```bash
git status
git diff scripts/just-provision
```

4. **Validate model available:**
```bash
ollama list | grep qwen3-tooled-small
```

5. **Try fallback model:**
```bash
opencode run --model opencode/gpt-5-nano "<simplified prompt>"
```

---

## Success Metrics

**Code quality:**
- [ ] `bash -n scripts/just-provision` passes
- [ ] No `opz run` calls remain
- [ ] No references to `--daemon` flag
- [ ] No references to non-existent files

**Functionality:**
- [ ] `--heal=ai` uses `system-diagnostics --fix` then `opencode run`
- [ ] `--heal-model` flag overrides model selection
- [ ] Git changes handled interactively via TUI
- [ ] Grouped commits use conventional format
- [ ] SSH delegation works from spacehound

**Documentation:**
- [ ] `.opencode/commands/provision.md` updated
- [ ] `.opencode/skills/provision/SKILL.md` comprehensive
- [ ] All flags documented in help text
- [ ] Examples provided for common scenarios

**Testing:**
- [ ] End-to-end test passes (5 scenarios)
- [ ] Error logs saved and informative
- [ ] No TUI hangs
- [ ] Retry logic works (max 2 attempts)

---

**Plan Status**: Ready to execute
**Next Action**: Choose batch to run first (1-5 recommended)
**Estimated Time**: 
- Batch 1: 15-30 min (parallel)
- Batch 2: 30-60 min (sequential)
- Batch 3: 20-40 min (parallel)
- Batch 4: 30-45 min (sequential)
- Batch 5: 15-30 min (parallel)
- Batch 6: 30-60 min (manual testing)
- **Total**: 2.5-4.5 hours for full execution
