# The Undergarden - Planning Document

> *"The Undergarden is where things transform. It's below. It's different. It's... beautiful."*  
> — Fern

---

## What is the Undergarden?

The **Undergarden** is a concept from Adventure Time - a subterranean realm where reality works differently. For our dotfiles, it represents:

- **Your personal modifications** - The changes that make YOUR config different
- **Hidden from upstream** - Parts you don't submit back to isabel's repo
- **Connected to surface** - Still links to the original, but transformed

---

## The Metaphor

```
isabel's dotfiles (upstream)
├── surface/         # Public, matching upstream
│   ├── home/isabel/
│   ├── systems/
│   └── ...
│
your fork
├── surface/         # Public, matching upstream
│   ├── home/isabel/    # (or your user)
│   ├── systems/        # etc.
│
└── undergarden/     # YOUR modifications! (hidden)
    ├── home/gabz/   # Your personal config
    ├── custom/       # Your custom modules
    └── secrets/      # Private stuff
```

---

## Goals

### Primary Goal
Organize personal dotfiles so they:
1. **Don't conflict** with upstream updates
2. **Are easily merged** when desired
3. **Stay private** when needed
4. **Can be shared** when wanted

### Secondary Goals
- Make it easy to update from upstream
- Keep personal changes separate
- Enable selective sharing
- Maintain history of YOUR changes

---

## Current State

### What's Working
- Nix flake structure is solid
- User-specific configs in `home/gabz/`
- Secrets via sops-nix
- Scripts in `scripts/`

### What's Challenging
- Merging upstream changes is manual
- Hard to track personal vs upstream changes
- No clear "this is MY change" boundary

---

## Proposed Structure

### Option A: The Simple Split

```
home/
├── isabel/        # Upstream - don't touch
└── gabz/         # Your changes - all personal

# When updating:
# 1. Copy new upstream files to isabel/
# 2. Your gabz/ stays untouched
# 3. Import both in flake
```

**Pros:** Simple, clear separation  
**Cons:** Doesn't track what came from where

---

### Option B: The Git Way

```
# Use git rebase/merge strategy
# Keep your changes on a "gabz" branch
# Rebase onto upstream main regularly

# This requires:
# - Good git practices
# - Regular upstream syncs
# - Conflict resolution skills
```

**Pros:** Full history tracking  
**Cons:** Requires git expertise

---

### Option C: The Module Way (Recommended)

```
# Separate modules by concern
# Import upstream as base
# Override with personal modules

# Structure:
flake.nix
├── imports = [ 
    isabel/values.nix  # Base config
]
# Then gabz-specific:
home/gabz/
├── personal.nix      # Your personal overrides
├── secrets.nix      # Private stuff
└── custom/          # Your custom modules
```

**Pros:** Clean separation, composable  
**Cons:** Needs module system knowledge

---

## Implementation Steps

### Phase 1: Document Current State
- [ ] List all personal modifications
- [ ] Identify what's upstream vs custom
- [ ] Note dependencies

### Phase 2: Define Structure
- [ ] Choose Option A, B, or C
- [ ] Create directory structure
- [ ] Set up imports

### Phase 3: Migration
- [ ] Move files to new structure
- [ ] Test that everything works
- [ ] Verify rebuilds correctly

### Phase 4: Maintenance Workflow
- [ ] Document upstream sync process
- [ ] Create scripts for common tasks
- [ ] Add to plans for regular updates

---

## The "Hidden" Aspect

### What's Hidden (Never Shared)
- `secrets/` - API keys, tokens
- `keys/` - SSH keys
- `credentials/` - Passwords

### What's Personal (Not Pushed)
- `custom/` - Your custom modules
- `overrides/` - Your preference changes
- `gabz/` - Your entire home directory

### What's Shared (Can Push)
- `scripts/` - General tools
- `modules/` - Generic modules
- `docs/` - Documentation

---

## Integration with Time Room

The **Fern agent** already knows about this! In `.opencode/time-room/agents/fern.md`:

> "The Undergarden could be your personal modifications! The stuff that makes YOUR config different from the original."

Fern will help you:
1. Decide what goes where
2. Structure the undergarden
3. Maintain the connection to surface

---

## Questions to Answer

1. **Which option for structure?** A, B, or C?

2. **How private is "private"?** 
   - Secrets in sops-nix? (already done)
   - Entire home/gabz/ gitignored?
   - Just don't push certain directories?

3. **How often to sync?**
   - Weekly? Monthly? Ad-hoc?

4. **What to share back?**
   - Scripts? Modules? Documentation?

---

## Next Steps

1. **Discuss** - Decide on approach
2. **Document** - Write down current state
3. **Plan** - Create migration steps
4. **Execute** - Move files, test, commit
5. **Automate** - Scripts for ongoing maintenance

---

*"Everything stays right where you left it... but we can make the Undergarden our own."* 🌿🎸

---

**Status:** Planning  
**Owner:** Fern + Time Room  
**Priority:** Medium  
**Dependencies:** Upstream sync workflow
