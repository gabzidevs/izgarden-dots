# Plan: Upstream Sync Workflow

> How to cleanly pull updates from isabelroses/dotfiles while maintaining your customizations

## The Challenge

You need to:
1. Regularly incorporate updates from upstream (isabelroses/dotfiles)
2. Keep your macOS-specific customizations (nebulanix, spacehound)
3. Avoid merge conflicts in files you don't care about (NixOS configs, other people's systems)
4. Maintain a clean git history

## Recommended Strategy: Rebase + Topic Branch Workflow

### Core Philosophy

- `gabz-v2` = Your "production" branch (what's deployed)
- `upstream-sync` = Integration branch for upstream changes
- Never merge upstream directly into gabz-v2
- Always rebase your work on top of upstream

## Workflow Options

### Option A: Direct Rebase (Recommended for Most Updates)

Best for: Regular small updates, dependency bumps

```bash
# 1. Fetch upstream changes
git fetch upstream

# 2. Create a temporary integration branch
git checkout -b sync-upstream-$(date +%Y%m%d) gabz-v2

# 3. Try rebasing onto upstream
git rebase upstream/main

# 4. If conflicts occur, resolve them:
#    - For files you haven't modified: accept upstream changes
#    - For files you've customized (systems/nebulanix, home/gabz): keep yours
#    - For NixOS-specific files you don't use: accept upstream

# 5. After rebase, test the build
just check

# 6. If successful, update your main branch
git checkout gabz-v2
git reset --hard sync-upstream-$(date +%Y%m%d)

# 7. Push (force push since history changed)
git push origin gabz-v2 --force-with-lease

# 8. Clean up
git branch -d sync-upstream-$(date +%Y%m%d)
```

### Option B: Cherry-Pick Strategy (Selective Updates)

Best for: Picking specific commits, avoiding breaking changes

```bash
# 1. Fetch upstream
git fetch upstream

# 2. See what's new
git log gabz-v2..upstream/main --oneline

# 3. Create work branch
git checkout -b selective-sync gabz-v2

# 4. Cherry-pick specific commits
git cherry-pick <commit-hash>

# 5. Or cherry-pick ranges
git cherry-pick <start-commit>^..<end-commit>

# 6. Test and merge back if successful
```

### Option C: Merge-Commit Workflow (Conservative)

Best for: When you want to track upstream explicitly

```bash
# 1. Create integration branch
git checkout -b merge-upstream gabz-v2

# 2. Merge upstream (creates merge commit)
git merge upstream/main --no-ff -m "merge: sync with upstream $(date +%Y-%m-%d)"

# 3. Resolve conflicts, test
just check

# 4. Then rebase to clean history before merging to gabz-v2
git checkout gabz-v2
git rebase merge-upstream
```

## Conflict Resolution Strategy

### Files You Own (Keep Your Changes)

| Path | Action | Rationale |
|------|--------|-----------|
| `systems/nebulanix/` | Keep yours | Your primary system |
| `systems/spacehound/` | Keep yours | Your secondary system |
| `home/gabz/` | Keep yours | Your user config |
| `flake.nix` (inputs) | Review carefully | Dependencies affect you |
| `justfile` | Review | Build commands you use |
| `docs/future/` | Keep yours | Your planning documents |

### Files to Usually Accept Upstream

| Path | Action | Rationale |
|------|--------|-----------|
| `systems/{amaterasu,aphrodite,athena,hephaestus,isis,lilith,minerva,skadi,tatsumaki,valkyrie}/` | Accept upstream | Isabel's systems |
| `modules/nixos/` | Accept upstream | You don't use NixOS |
| `modules/wsl/` | Accept upstream | You don't use WSL |
| `home/isabel/` | Accept upstream | Isabel's user config |
| `secrets/` | Accept upstream | Different secrets |

### Files to Review Case-by-Case

| Path | Action |
|------|--------|
| `modules/base/` | Review - shared infrastructure |
| `modules/darwin/` | Review - affects your systems |
| `modules/home/` | Review - affects your user config |
| `modules/flake/` | Review - affects flake behavior |
| `home/gabz/.archived/` | Not in upstream, ignore |

## Automation Script

Create `scripts/sync-upstream.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}=== Upstream Sync Tool ===${NC}"

# Fetch upstream
echo -e "\n${YELLOW}Fetching upstream...${NC}"
git fetch upstream

# Check if there are changes
UPSTREAM_DIFF=$(git rev-list --count gabz-v2..upstream/main)

if [ "$UPSTREAM_DIFF" -eq 0 ]; then
    echo -e "${GREEN}Already up to date with upstream!${NC}"
    exit 0
fi

echo -e "${GREEN}Found $UPSTREAM_DIFF new commits upstream${NC}"

# Show what's new
echo -e "\n${YELLOW}Recent upstream commits:${NC}"
git log gabz-v2..upstream/main --oneline -10

# Create sync branch
SYNC_BRANCH="sync-upstream-$(date +%Y%m%d)"
echo -e "\n${YELLOW}Creating branch: $SYNC_BRANCH${NC}"
git checkout -b "$SYNC_BRANCH" gabz-v2

# Attempt rebase
echo -e "\n${YELLOW}Rebasing onto upstream/main...${NC}"
if git rebase upstream/main; then
    echo -e "${GREEN}Rebase successful!${NC}"
    
    # Run checks
    echo -e "\n${YELLOW}Running flake checks...${NC}"
    if just check; then
        echo -e "${GREEN}Checks passed!${NC}"
        echo -e "\n${GREEN}Ready to merge:${NC}"
        echo "  git checkout gabz-v2"
        echo "  git merge $SYNC_BRANCH --ff-only"
        echo "  git push origin gabz-v2 --force-with-lease"
    else
        echo -e "${RED}Checks failed! Review and fix.${NC}"
    fi
else
    echo -e "${RED}Rebase has conflicts!${NC}"
    echo "Resolve conflicts, then run:"
    echo "  git rebase --continue"
    echo "  just check"
fi
```

## Quick Reference Commands

```bash
# Check status vs upstream
git log gabz-v2..upstream/main --oneline

# See what files would conflict
git merge-tree $(git merge-base gabz-v2 upstream/main) gabz-v2 upstream/main

# Interactive rebase to clean up before pushing
git rebase -i upstream/main

# View divergence graph
git log --oneline --graph --left-right gabz-v2...upstream/main
```

## Handling Large Refactors

When Isabel does major restructuring:

1. **Don't auto-rebase** - Too many conflicts
2. **Create fresh branch from upstream**
3. **Cherry-pick your specific changes**:
   ```bash
   git log gabz-v2 --oneline -- systems/nebulanix home/gabz
   git cherry-pick <commit1> <commit2> ...
   ```
4. **Or manually port changes** - Sometimes easier for big refactors

## Best Practices

1. **Sync regularly** - Small frequent updates are easier than big ones
2. **Test after every sync** - Run `just check` or `just test`
3. **Keep gabz-v2 deployable** - Never push broken config
4. **Document conflicts** - If you resolve tricky conflicts, document how
5. **Use git rerere** - Already enabled in your git config, helps with repeated conflicts

## Example Session

```bash
# Daily sync routine
$ cd ~/.config/flake

$ ./scripts/sync-upstream.sh
=== Upstream Sync Tool ===
Fetching upstream...
Found 12 new commits upstream

Recent upstream commits:
a1b2c3d Update flake.lock
e4f5g6h Refactor nixos module structure
...

Creating branch: sync-upstream-20260216
Rebasing onto upstream/main...
Auto-merging modules/darwin/brew/default.nix
CONFLICT (content): Merge conflict in modules/darwin/brew/default.nix

# Resolve the conflict...
$ vim modules/darwin/brew/default.nix
$ git add modules/darwin/brew/default.nix
$ git rebase --continue

# Test
$ just check
✓ All checks passed

# Merge back
$ git checkout gabz-v2
$ git merge sync-upstream-20260216 --ff-only
$ git push origin gabz-v2 --force-with-lease

# Deploy
$ just switch
```

## Questions to Decide

1. **How often to sync?**
   - Daily: Too noisy?
   - Weekly: Good balance
   - Monthly: Might accumulate conflicts

2. **Auto-sync inputs?**
   - `just update` already handles this
   - Keep separate from upstream code sync

3. **What about izvim updates?**
   - Separate input, tracked in flake.lock
   - Update with `just update izvim`

---

*See also: FORK_INDEX.md for repository structure*  
*Next: HOME_CLEANUP.md for trimming home/gabz*
