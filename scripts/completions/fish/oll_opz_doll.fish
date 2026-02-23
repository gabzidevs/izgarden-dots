# =============================================================================
# Fish Completions for oll, opz, doll
# =============================================================================

# oll completions
complete -c oll -f -n '__fish_use_subcommand' -a 'help' -d 'Show help'
complete -c oll -f -n '__fish_use_subcommand' -a 'connect' -d 'Switch model (alias: c)'
complete -c oll -f -n '__fish_use_subcommand' -a 'c' -d 'Switch model'
complete -c oll -f -n '__fish_use_subcommand' -a 'server' -d 'Server control (alias: s)'
complete -c oll -f -n '__fish_use_subcommand' -a 's' -d 'Server control'
complete -c oll -f -n '__fish_use_subcommand' -a 'model' -d 'Model management (alias: m)'
complete -c oll -f -n '__fish_use_subcommand' -a 'm' -d 'Model management'
complete -c oll -f -n '__fish_use_subcommand' -a 'tune' -d 'Performance tuning (alias: t)'
complete -c oll -f -n '__fish_use_subcommand' -a 't' -d 'Performance tuning'
complete -c oll -f -n '__fish_use_subcommand' -a 'sys' -d 'System optimizations (alias: y)'
complete -c oll -f -n '__fish_use_subcommand' -a 'y' -d 'System optimizations'
complete -c oll -f -n '__fish_use_subcommand' -a 'profile' -d 'OCX profile management'
complete -c oll -f -n '__fish_use_subcommand' -a 'test' -d 'Run integration test'
complete -c oll -f -n '__fish_use_subcommand' -a 'doctor' -d 'Run diagnostics'
complete -c oll -f -n '__fish_use_subcommand' -a 'status' -d 'Quick status check'

# oll server completions
complete -c oll -f -n '__fish_seen_subcommand_from server s' -a 'start' -d 'Start server'
complete -c oll -f -n '__fish_seen_subcommand_from server s' -a 'stop' -d 'Stop server'
complete -c oll -f -n '__fish_seen_subcommand_from server s' -a 'restart' -d 'Restart server'
complete -c oll -f -n '__fish_seen_subcommand_from server s' -a 'status' -d 'Check status'
complete -c oll -f -n '__fish_seen_subcommand_from server s' -a 'health' -d 'Health check'
complete -c oll -f -n '__fish_seen_subcommand_from server s' -a 'logs' -d 'Show logs'
complete -c oll -f -n '__fish_seen_subcommand_from server s' -a 'list' -d 'List models'

# oll model completions
complete -c oll -f -n '__fish_seen_subcommand_from model m' -a 'list' -d 'List models'
complete -c oll -f -n '__fish_seen_subcommand_from model m' -a 'pull' -d 'Pull model'
complete -c oll -f -n '__fish_seen_subcommand_from model m' -a 'rm' -d 'Remove model'
complete -c oll -f -n '__fish_seen_subcommand_from model m' -a 'purge' -d 'Purge models'
complete -c oll -f -n '__fish_seen_subcommand_from model m' -a 'storage' -d 'Storage usage'
complete -c oll -f -n '__fish_seen_subcommand_from model m' -a 'recommend' -d 'Recommendations'

# oll tune completions
complete -c oll -f -n '__fish_seen_subcommand_from tune t' -a 'speed' -d 'Speed preset (4k context)'
complete -c oll -f -n '__fish_seen_subcommand_from tune t' -a 'balanced' -d 'Balanced preset (16k context)'
complete -c oll -f -n '__fish_seen_subcommand_from tune t' -a 'power' -d 'Power preset (32k context)'
complete -c oll -f -n '__fish_seen_subcommand_from tune t' -a 'research' -d 'Research preset (64k context)'

# oll sys completions
complete -c oll -f -n '__fish_seen_subcommand_from sys y' -a 'apply' -d 'Apply optimization'
complete -c oll -f -n '__fish_seen_subcommand_from sys y' -a 'revert' -d 'Revert changes'
complete -c oll -f -n '__fish_seen_subcommand_from sys y' -a 'status' -d 'System status'
complete -c oll -f -n '__fish_seen_subcommand_from sys y' -a 'vram' -d 'VRAM info'

# oll profile completions
complete -c oll -f -n '__fish_seen_subcommand_from profile' -a 'show' -d 'Show current profile'
complete -c oll -f -n '__fish_seen_subcommand_from profile' -a 'list' -d 'List available profiles'
complete -c oll -f -n '__fish_seen_subcommand_from profile' -a 'set' -d 'Set profile'

# opz completions
complete -c opz -f -n '__fish_use_subcommand' -a '-p' -d 'Set profile'
complete -c opz -f -n '__fish_use_subcommand' -a '--profile' -d 'Set profile'
complete -c opz -f -n '__fish_use_subcommand' -a '-m' -d 'Switch model first'
complete -c opz -f -n '__fish_use_subcommand' -a '--model' -d 'Switch model first'
complete -c opz -f -n '__fish_use_subcommand' -a '-l' -d 'List profiles'
complete -c opz -f -n '__fish_use_subcommand' -a '--list' -d 'List profiles'
complete -c opz -f -n '__fish_use_subcommand' -a '-s' -d 'Show status'
complete -c opz -f -n '__fish_use_subcommand' -a '--status' -d 'Show status'
complete -c opz -f -n '__fish_use_subcommand' -a '-t' -d 'Force TUI mode'
complete -c opz -f -n '__fish_use_subcommand' -a '--tui' -d 'Force TUI mode'
complete -c opz -f -n '__fish_use_subcommand' -a '-h' -d 'Show help'
complete -c opz -f -n '__fish_use_subcommand' -a '--help' -d 'Show help'

# doll completions (no subcommands, just options)
complete -c doll -f -n '__fish_use_subcommand' -a '-h' -d 'Show help'
complete -c doll -f -n '__fish_use_subcommand' -a '--help' -d 'Show help'

# =============================================================================
# Additional Completions (just-provision, agent-tasks, ocx-update, system-diagnostics)
# =============================================================================

# just-provision completions
complete -c just-provision -f -n '__fish_use_subcommand' -a 'nebulanix' -d 'Provision nebulanix'
complete -c just-provision -f -n '__fish_use_subcommand' -a 'spacehound' -d 'Provision spacehound'
complete -c just-provision -f -n '__fish_use_subcommand' -a '-b' -d 'Pull branch first'
complete -c just-provision -f -n '__fish_use_subcommand' -a '--branch' -d 'Pull branch first'
complete -c just-provision -f -n '__fish_use_subcommand' -a '--heal' -d 'Run self-healing'
complete -c just-provision -f -n '__fish_use_subcommand' -a '--heal=ai' -d 'AI-guided healing'
complete -c just-provision -f -n '__fish_use_subcommand' -a '--daemon' -d 'Use nix-daemon'
complete -c just-provision -f -n '__fish_use_subcommand' -a '--check' -d 'Check prerequisites'
complete -c just-provision -f -n '__fish_use_subcommand' -a '--local' -d 'Force local provision'

# agent-tasks completions
complete -c agent-tasks -f -n '__fish_use_subcommand' -a 'finn' -d 'Git commit watch'
complete -c agent-tasks -f -n '__fish_use_subcommand' -a 'simon' -d 'Playbook/Ollama review'
complete -c agent-tasks -f -n '__fish_use_subcommand' -a 'jake' -d 'Tool upgrades check'
complete -c agent-tasks -f -n '__fish_use_subcommand' -a 'fern' -d 'Mise maintenance'
complete -c agent-tasks -f -n '__fish_use_subcommand' -a 'prismo' -d 'Skill improvements'
complete -c agent-tasks -f -n '__fish_use_subcommand' -a 'prisco' -d 'Task tracking'
complete -c agent-tasks -f -n '__fish_use_subcommand' -a 'morning' -d 'Daily check'
complete -c agent-tasks -f -n '__fish_use_subcommand' -a 'weekly' -d 'Full rotation'

# ocx-update completions
complete -c ocx-update -f -n '__fish_use_subcommand' -a '--list' -d 'List plugins'
complete -c ocx-update -f -n '__fish_use_subcommand' -a '--add' -d 'Add plugin'
complete -c ocx-update -f -n '__fish_use_subcommand' -a '--remove' -d 'Remove plugin'
complete -c ocx-update -f -n '__fish_use_subcommand' -a '--update' -d 'Update plugins'
complete -c ocx-update -f -n '__fish_use_subcommand' -a '-u' -d 'Update plugins'

# system-diagnostics completions
complete -c system-diagnostics -f -n '__fish_use_subcommand' -a '--check' -d 'Run checks only'
complete -c system-diagnostics -f -n '__fish_use_subcommand' -a '--fix' -d 'Attempt fixes'
complete -c system-diagnostics -f -n '__fish_use_subcommand' -a '--json' -d 'JSON output'
complete -c system-diagnostics -f -n '__fish_use_subcommand' -a '--interactive' -d 'TUI mode'
