#!/bin/bash

# Rebase failure recovery with conflict template
# Usage: git rebase --continue && ./rebase-recovery.sh

# Apply conflict template
find . -name "*.conflict" -exec sed -i 's/^<<<<<<< HEAD$/<<<<<<< HEAD\n<<<<<<< TEMPLATE/' {} \;

# Mark conflicts as resolved
find . -name "*.conflict" -exec touch {}.resolved \;

# Continue rebase
git add .
git rebase --continue
