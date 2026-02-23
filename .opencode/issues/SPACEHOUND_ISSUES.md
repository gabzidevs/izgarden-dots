# Spacehound Provision Issues

> **Note:** For general Ollama scripts roadmap and enhancements, see:  
> `docs/future/OLLAMA_OPTIMIZATION.md` → "Future Enhancements (Roadmap)" section

---

## Current Issues (2026-02-16)

### Issue 1: sudo Password Required

**Error:**
```
sudo: a terminal is required to read the password; either use the -S option to read from standard input or configure an askpass helper
sudo: a password is required
```

**Root Cause:** The `just provision spacehound` command runs `sudo -E nix run github:LnL7/nix-darwin -- switch ...` which requires password authentication. On spacehound (the target machine), there's no terminal available to prompt for password.

**Affected Lines in justfile:**
- Line 99: `sudo -E nix run github:LnL7/nix-darwin -- switch ...`
- Line 103: `sudo -E nix run github:LnL7/nix-darwin -- switch ...`

**Potential Solutions:**
1. Configure passwordless sudo for the nix-darwin command on spacehound
2. Use `sudo -n` (non-interactive) if passwordless sudo is configured
3. Run the provision command locally on spacehound with proper sudo access
4. Use SSH with passwordless sudo (via `ssh -t user@host sudo ...`)

---

### Issue 2: mise Not Installed

**Error:**
```
/var/folders/_r/g9jxslhx0p7fzyyw8s70b_gm0000gn/T/just-5llIak/provision: line 119: /Users/gabz/.local/bin/mise: No such file or directory
```

**Root Cause:** The provision script hardcodes the mise path as `/Users/gabz/.local/bin/mise`, but:
1. mise is not installed at that location
2. The nix-darwin rebuild failed (due to Issue 1), so mise wasn't installed via home-manager
3. mise should be available via the shims path (`~/.local/share/mise/shims/mise`) after activation

**Affected Lines in justfile:**
- Line 119: `if ! /Users/gabz/.local/bin/mise install; then`
- Line 122: `/Users/gabz/.local/bin/mise ls`

**Potential Solutions:**
1. Use `command -v mise` to detect mise location dynamically
2. Use the nix-provided mise path: `~/.local/share/mise/shims/mise`
3. Add mise to PATH in the provision script before calling it
4. Check if mise is available via home-manager activation

---

## Related Configuration

- **justfile:** `/Users/gabz/.config/flake/justfile` (lines 90-123)
- **mise config:** `/Users/gabz/.config/flake/home/gabz/core/system/mise.nix`
- **spacehound system:** `/Users/gabz/.config/flake/systems/spacehound/default.nix`

## Notes

- The provision script runs on the **target machine** (spacehound), not locally
- nix-darwin rebuild must succeed before mise can be installed
- The script needs to handle cases where nix-darwin fails gracefully
