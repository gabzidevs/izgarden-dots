#!/usr/bin/env bash
# Backup strategy: Snapshot daily config state
# Save to external drive or cloud storage

# Backup home directory
rsync -avh --exclude='/.config/flake' ~ /path/to/backup/

# Backup flake config
rsync -avh ~/.config/flake /path/to/backup/

# Backup system state (optional)
# system-backup.sh # Add custom system backup commands here
