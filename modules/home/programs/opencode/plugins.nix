{
  phase1-priority = [
    # MCP lazy-load - reduce tool definitions by ~67k tokens
    "opencode-toolbox"
    # Memory systems
    "opencode-working-memory" # Four-tier memory: core + working + pressure monitoring + pruning
    # Disabled - causes errors
    # "@csuwl/opencode-memory-plugin"
    # Parallelism - disabled for now (package name unclear)
    # "pocket-universe"
    "opencode-worktree"
  ];

  phase2-foundation = [
    # "opencode-antigravity-auth"
    "@slkiser/opencode-quota"
    "@mohak34/opencode-notifier"
  ];

  phase3-efficiency = [
    "@nick-vi/opencode-type-inject"
    "opencode-snippets"
    "@franlol/opencode-md-table-formatter"
  ];

  phase4-integration = [
    # Disabled - requires additional setup
    # "opencode.nvim"
    # "opencode-zellij-namer"
  ];

  phase5-project-management = [
    # Disabled - unclear if these exist as npm packages
    # "micode"
    # "plannotator"
    # "opencode-roadmap"
  ];

  phase6-qol = [
    # Disabled - unclear if these exist
    # "opencode-pty"
    # "opencode-shell-strategy"
    # "opencode-wakatime"
  ];
}
