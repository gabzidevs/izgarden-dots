# Migration Prompt for Other Machines

Use this prompt on any machine that needs to sync with the latest plugin configuration.

---

## Prompt

```
I need you to help me sync the OCX plugin configuration from my flake.

1. First, check if we have the latest flake:
   - cd ~/.config/flake
   - git pull origin gabz-v2

2. Run the provision with self-healing:
   - Run: just-provision <hostname> --heal
   - Where <hostname> is either nebulanix or spacehound

3. After provision completes, verify plugins are installed:
   - cd ~/.config/opencode
   - ocx search   # Should show available components
   - ls node_modules/ | grep working-memory   # Should show opencode-working-memory

4. If plugins don't install, check the activation output for errors

5. Report back what plugins are now installed
```

---

## What This Does

1. Pulls latest flake changes (includes OCX plugin fixes)
2. Runs nix-darwin provision with self-healing
3. Home-manager activation should install OCX plugins from inline profilePlugins
4. Verifies working-memory and other plugins are installed

## Known Issues Fixed

- Profile names changed from hostnames to shortcodes (`nebx`, `spchound`)
- External JSON profile loading disabled (now inline only)
- Activation script syntax fixed

## If It Still Fails

Check the home-manager activation output for:
- "expected a list but found a set" → means `plugins = []` missing
- "profile not found" → profile name mismatch
- "jq not available" → external profile loading fallback should kick in
