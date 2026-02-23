#!/usr/bin/env bash
# memory-recover - Compaction recovery using working-memory plugin

case "${1:-}" in
check)
  echo "=== Compaction Recovery Check ==="
  echo ""
  echo "--- Core Memory (Goal & Progress) ---"
  opencode --tool core_memory_read 2>/dev/null
  echo ""
  echo "--- Working Memory Items ---"
  opencode --tool core_memory_read 2>/dev/null | grep -v "^$" | head -50
  ;;

survived)
  echo "=== What Survived Compaction ==="
  opencode --tool core_memory_read 2>/dev/null
  ;;

gaps)
  echo "=== Gap Analysis ==="
  echo "Note: Manual check required"
  echo "- Review conversation history for untracked context"
  echo "- Check for files being edited"
  ;;

rebuild)
  shift
  if [[ -z $* ]]; then
    echo "Usage: memory-recover rebuild <description>"
    exit 1
  fi
  opencode --tool working_memory_add \
    "{\"content\":\"rebuild: $*\",\"category\":\"recovery\",\"metadata\":{\"type\":\"gap_filled\",\"timestamp\":\"$(date -Iseconds)\"}}" \
    2>/dev/null
  echo "✓ Added rebuild note: $*"
  ;;

save)
  echo "=== Emergency Save ==="
  current=$(opencode --tool core_memory_read 2>/dev/null)
  opencode --tool working_memory_add \
    "{\"content\":\"emergency_save: $(date -Iseconds)\",\"category\":\"checkpoint\",\"metadata\":{\"core_memory\":\"$current\"}}" \
    2>/dev/null
  echo "✓ Emergency save created"
  ;;

help | --help | -h | *)
  echo "memory-recover - Compaction recovery"
  echo ""
  echo "Commands:"
  echo "  check        Full recovery check"
  echo "  survived     Show what survived"
  echo "  gaps         Identify gaps"
  echo "  rebuild <n>  Rebuild context"
  echo "  save         Emergency save before compaction"
  ;;
esac
