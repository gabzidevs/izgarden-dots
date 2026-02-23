# Exploration Plans

> Tools and configurations to explore in the future

## Low Priority Explorations

### 1. LazyVim with Mise

**Status**: Super low priority, but interesting

**Current State**:
- You're using mise-provided neovim
- `home/gabz/tui/neovim.nix` is disabled (imports izvim - Isabel's config)

**Exploration Idea**:
Create a `home/gabz/dev/lazyvim.nix` that:
- Uses mise to manage LazyVim
- Or use nix to install LazyVim as a distro
- Keeps your neovim config separate from Isabel's izvim

**Reference Files**:
- Current: `home/gabz/tui/neovim.nix` (currently disabled)
- Isabel's config: Uses `inputs.izvim.homeModules.default`

**When to Explore**:
- When you have time to experiment
- After home/gabz cleanup is complete
- When you want to customize neovim beyond mise defaults

---

### 2. Atuin - Shell History Sync

**Status**: Archived, revisit later

**What it does**:
- Syncs shell history across machines
- Provides better history search (fuzzy finding)
- Optional: cloud sync or self-hosted

**Current File**: `home/gabz/cli/atuin.nix` (will be archived)

**Why Archive**:
- Still learning the basics
- Not immediately necessary
- Can add complexity

**When to Revisit**:
- When you have multiple machines and want synced history
- When you're comfortable with your current setup
- After reading: https://github.com/atuinsh/atuin

**Quick Test Later**:
```bash
# To try it out without nix:
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

# Or with nix:
nix shell nixpkgs#atuin
```

---

### 3. Jujutsu (jj) - Alternative Version Control

**Status**: Archived, revisit later

**What it does**:
- Alternative to git
- Better UX for complex workflows
- Works with git repos (drop-in compatible)

**Current File**: `home/gabz/cli/jj.nix` (will be archived)

**Why Archive**:
- Still learning git deeply
- Adds cognitive overhead
- Not necessary for current workflow

**When to Revisit**:
- When you're comfortable with advanced git
- When you encounter git pain points
- After reading: https://github.com/martinvonz/jj

**Learning Resources**:
- Docs: https://martinvonz.github.io/jj/latest/
- Comparison with git: https://martinvonz.github.io/jj/latest/git-comparison/

**Quick Test Later**:
```bash
# With nix:
nix shell nixpkgs#jujutsu

# Try it on a test repo:
jj git clone https://github.com/example/repo
cd repo
jj log
```

---

### 4. Notes Application

**Status**: Disabled, need to decide

**Current File**: `home/gabz/gui/notes.nix`

**Question**: Do you use a notes app? If so, which one?

**Options**:
- Obsidian (currently used by Isabel)
- Logseq
- Notion
- Plain markdown files
- Other?

**When to Decide**:
- If you don't use any notes app, delete the file
- If you do, configure it properly

---

### 5. WezTerm Lua Configs

**Status**: Partially used (spacehound only)

**Current State**:
- `home/gabz/gui/wezterm/` contains Lua configs
- Used on spacehound but not nebulanix
- Ghostty is primary on nebulanix

**Exploration Ideas**:
- Move wezterm/ to spacehound-specific location?
- Or keep shared but disable on nebulanix?
- Compare Ghostty vs WezTerm features

**Files**:
- `home/gabz/gui/wezterm/bar.lua`
- `home/gabz/gui/wezterm/keybinds.lua`
- `home/gabz/gui/wezterm/theme.lua`
- `home/gabz/gui/wezterm/utils.lua`
- `home/gabz/gui/wezterm/wezterm.lua`

---

### 6. RSS Reader (izrss)

**Status**: Disabled, need to decide

**Current File**: `home/gabz/tui/izrss.nix`

**What it is**:
- TUI RSS feed reader
- Isabel's personal tool

**Question**: Do you use RSS feeds? If so:
- What feeds do you follow?
- Would a TUI reader be useful?

**Alternative**: Newsboat (more established)

**When to Decide**:
- If you don't use RSS, delete it
- If you do, test izrss vs newsboat

---

## Quick Reference Table

| Tool | Status | Priority | Archive Location | Revisit When... |
|------|--------|----------|------------------|-----------------|
| LazyVim | Idea | Low | N/A (not yet created) | Want custom neovim |
| Atuin | Archived | Low | `.archived/unexplored/atuin.nix` | Multi-machine history |
| Jujutsu | Archived | Low | `.archived/unexplored/jj.nix` | Git frustrations |
| Notes | Undecided | - | Keep for now | You decide on workflow |
| WezTerm Lua | Partial | Low | Keep in terminals/ | Spacehound needs it |
| izrss | Disabled | Low | `.archived/` or delete | You use RSS |

---

## How to Revisit Later

When you're ready to explore one of these:

1. **Check this document** - Quick reminder of what it does
2. **Read the official docs** - Links provided above
3. **Test manually first** - Try with `nix shell` before adding to config
4. **Check HOME_CLEANUP.md** - See where to add it in the new structure
5. **Create a branch** - `git checkout -b explore-atuin`
6. **Implement** - Move from `.archived/` to active location
7. **Test** - `just check && just switch`
8. **Evaluate** - Use it for a week, decide if it stays

---

## Questions to Future Self

- [ ] Do I need shell history sync now? (atuin)
- [ ] Am I hitting git limitations? (jj)
- [ ] Do I want a custom neovim setup? (LazyVim)
- [ ] Do I follow RSS feeds? (izrss)
- [ ] Should I standardize on one terminal? (wezterm vs ghostty)

---

*Part of the Home/gabz cleanup initiative*  
*See also: HOME_CLEANUP.md for the main cleanup plan*
