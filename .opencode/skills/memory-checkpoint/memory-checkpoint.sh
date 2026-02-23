#!/usr/bin/env bash
# memory-checkpoint - Save-point management using working-memory plugin

CHECKPOINT_PREFIX="checkpoint_"

case "${1:-}" in
save)
  if [[ -z $2 ]]; then
    echo "Usage: memory-checkpoint save <name> [description]"
    exit 1
  fi
  name="$2"
  shift 2
  description="${*:-checkpoint created at $(date)}"

  opencode --tool working_memory_add \
    "{\"content\":\"${CHECKPOINT_PREFIX}${name} - ${description}\",\"category\":\"checkpoint\",\"metadata\":{\"timestamp\":\"$(date -Iseconds)\"}}" \
    2>/dev/null

  echo "✓ Saved checkpoint: $name"
  echo "  $description"
  ;;

list)
  echo "=== Active Checkpoints ==="
  opencode --tool core_memory_read 2>/dev/null | grep -i "${CHECKPOINT_PREFIX}" || echo "No checkpoints found"
  ;;

info)
  if [[ -z $2 ]]; then
    echo "Usage: memory-checkpoint info <name>"
    exit 1
  fi
  echo "=== Checkpoint: $2 ==="
  opencode --tool core_memory_read 2>/dev/null | grep -i "${CHECKPOINT_PREFIX}$2" || echo "Not found"
  ;;

delete)
  if [[ -z $2 ]]; then
    echo "Usage: memory-checkpoint delete <name>"
    exit 1
  fi
  opencode --tool working_memory_remove "{\"id\":\"${CHECKPOINT_PREFIX}$2\"}" 2>/dev/null
  echo "✓ Deleted checkpoint: $2"
  ;;

verify)
  echo "=== Post-Compaction Verification ==="
  echo ""
  echo "--- Core Memory ---"
  opencode --tool core_memory_read 2>/dev/null
  echo ""
  echo "--- Checkpoints ---"
  opencode --tool core_memory_read 2>/dev/null | grep -i "${CHECKPOINT_PREFIX}" || echo "No checkpoints"
  ;;

help | --help | -h | *)
  echo "memory-checkpoint - Save-point management"
  echo ""
  echo "Commands:"
  echo "  save <name> [description]  Create a save-point"
  echo "  list                        List all checkpoints"
  echo "  info <name>                 Show checkpoint details"
  echo "  delete <name>               Remove a checkpoint"
  echo "  verify                      Verify state after compaction"
  ;;
esac
