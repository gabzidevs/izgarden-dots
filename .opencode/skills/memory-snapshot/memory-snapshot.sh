#!/usr/bin/env bash
# memory-snapshot - Thread traversal and snapshotting using working-memory plugin

SNAPSHOT_PREFIX="snapshot:"

create() {
  if [[ -z $1 || -z $2 ]]; then
    echo "Usage: memory-snapshot create <thread_id> <label> [description]"
    exit 1
  fi
  thread_id="$1"
  label="$2"
  shift 2
  description="${*:-snapshot of ${thread_id}}"

  opencode --tool working_memory_add \
    "{\"content\":\"${SNAPSHOT_PREFIX}${thread_id}:${label} - ${description}\",\"category\":\"snapshot\",\"metadata\":{\"thread_id\":\"${thread_id}\",\"label\":\"${label}\",\"description\":\"${description}\",\"created\":\"$(date -Iseconds)\",\"expires\":\"$(date -Iseconds -d '+7 days')\"}}" \
    2>/dev/null

  echo "✓ Created snapshot: $thread_id:$label"
  echo "  $description"
}

list() {
  echo "=== Snapshots ==="
  if [[ -n $1 ]]; then
    opencode --tool core_memory_read 2>/dev/null | grep -i "${SNAPSHOT_PREFIX}$1" || echo "No snapshots for thread: $1"
  else
    opencode --tool core_memory_read 2>/dev/null | grep -i "${SNAPSHOT_PREFIX}" || echo "No snapshots found"
  fi
}

show() {
  if [[ -z $1 ]]; then
    echo "Usage: memory-snapshot show <snapshot_id>"
    exit 1
  fi

  snapshot=$(opencode --tool core_memory_read 2>/dev/null | grep -i "${SNAPSHOT_PREFIX}.*$1" | head -1)

  if [[ -z $snapshot ]]; then
    echo "Snapshot not found: $1"
    exit 1
  fi

  echo "=== Snapshot: $1 ==="
  echo "$snapshot"
}

diff() {
  if [[ -z $1 || -z $2 ]]; then
    echo "Usage: memory-snapshot diff <snap1> <snap2>"
    exit 1
  fi

  snap1=$(opencode --tool core_memory_read 2>/dev/null | grep -i "${SNAPSHOT_PREFIX}.*$1" | head -1)
  snap2=$(opencode --tool core_memory_read 2>/dev/null | grep -i "${SNAPSHOT_PREFIX}.*$2" | head -1)

  echo "=== Comparison: $1 vs $2 ==="
  echo ""
  echo "--- $1 ---"
  echo "$snap1"
  echo ""
  echo "--- $2 ---"
  echo "$snap2"
}

delete() {
  if [[ -z $1 ]]; then
    echo "Usage: memory-snapshot delete <snapshot_id>"
    exit 1
  fi

  opencode --tool working_memory_remove "{\"id\":\"${SNAPSHOT_PREFIX}$1\"}" 2>/dev/null || true
  echo "✓ Deleted snapshot: $1"
}

export_snapshot() {
  if [[ -z $1 ]]; then
    echo "Usage: memory-snapshot export <snapshot_id> [--markdown]"
    exit 1
  fi

  snapshot=$(opencode --tool core_memory_read 2>/dev/null | grep -i "${SNAPSHOT_PREFIX}.*$1" | head -1)

  if [[ $2 == "--markdown" ]]; then
    echo "## Snapshot: $1"
    echo ""
    echo "Created: $(date)"
    echo ""
    echo '```'
    echo "$snapshot"
    echo '```'
  else
    echo "$snapshot"
  fi
}

case "${1:-}" in
create)
  shift
  create "$@"
  ;;
list)
  shift
  list "$@"
  ;;
show)
  shift
  show "$@"
  ;;
diff)
  shift
  diff "$@"
  ;;
delete)
  shift
  delete "$@"
  ;;
export)
  shift
  export_snapshot "$@"
  ;;
help | --help | -h | *)
  echo "memory-snapshot - Thread traversal and snapshots"
  echo ""
  echo "Commands:"
  echo "  create <thread> <label> [desc]  Create snapshot"
  echo "  list [thread]                    List snapshots"
  echo "  show <id>                        Show snapshot"
  echo "  diff <snap1> <snap2>             Compare snapshots"
  echo "  delete <id>                     Delete snapshot"
  echo "  export <id> [--markdown]        Export snapshot"
  ;;
esac
