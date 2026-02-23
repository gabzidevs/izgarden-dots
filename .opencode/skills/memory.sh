#!/usr/bin/env bash
# memory - Unified working-memory skills launcher

SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"

case "${1:-}" in
checkpoint | checkpt | cp)
  exec "$SCRIPT_DIR/memory-checkpoint/memory-checkpoint.sh" "${@:2}"
  ;;
threads | thread | t)
  exec "$SCRIPT_DIR/memory-threads/memory-threads.sh" "${@:2}"
  ;;
delegate | del | d)
  exec "$SCRIPT_DIR/memory-delegate/memory-delegate.sh" "${@:2}"
  ;;
recover | rec | r)
  exec "$SCRIPT_DIR/memory-recover/memory-recover.sh" "${@:2}"
  ;;
snapshot | snap | s)
  exec "$SCRIPT_DIR/memory-snapshot/memory-snapshot.sh" "${@:2}"
  ;;
health | check)
  echo "Running health check..."
  opencode --tool core_memory_update '{"goal":"health-check","progress":"","context":""}' 2>/dev/null &&
    opencode --tool core_memory_read 2>/dev/null | grep -q health-check &&
    echo "✓ Working memory operational" || echo "✗ Check failed"
  ;;
list)
  echo "=== All Working Memory Items ==="
  opencode --tool core_memory_read 2>/dev/null
  ;;
help | --help | -h | "")
  echo "memory - Working Memory Skills"
  echo ""
  echo "Usage: memory <command> [options]"
  echo ""
  echo "Commands:"
  echo "  checkpoint, cp   Save-point management"
  echo "  threads, t       Conversation thread tracking"
  echo "  delegate, d      Delegation handover"
  echo "  recover, r       Compaction recovery"
  echo "  snapshot, s      Thread snapshots"
  echo "  health           Quick health check"
  echo "  list             Show all memory items"
  echo ""
  echo "Examples:"
  echo "  memory cp save pre-refactor"
  echo "  memory t start ollama-investigation 'Memory leak' high"
  echo "  memory d pack gleeman 'Implement auth'"
  echo "  memory r check"
  echo "  memory s create auth 'api-changed' 'Updated to v2'"
  ;;
esac
