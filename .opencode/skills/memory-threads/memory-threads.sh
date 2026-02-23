#!/usr/bin/env bash
# memory-threads - Conversation thread tracking using working-memory plugin

THREAD_PREFIX="thread_"
PRIORITY_EMOJI=("🔴" "🟡" "🟢")
PRIORITY_MAP=(["high"]=0 ["medium"]=1 ["low"]=2)

get_priority_emoji() {
  local priority="${1:-medium}"
  local idx="${PRIORITY_MAP[$priority]:-1}"
  echo "${PRIORITY_EMOJI[$idx]:-🟡}"
}

case "${1:-}" in
start)
  if [[ -z $2 || -z $3 ]]; then
    echo "Usage: memory-threads start <thread_id> <summary> [priority]"
    exit 1
  fi
  thread_id="$2"
  summary="$3"
  priority="${4:-medium}"
  emoji=$(get_priority_emoji "$priority")

  opencode --tool working_memory_add \
    "{\"content\":\"${THREAD_PREFIX}${thread_id} - ${summary}\",\"category\":\"thread\",\"metadata\":{\"status\":\"active\",\"priority\":\"${priority}\",\"created\":\"$(date -Iseconds)\",\"updated\":\"$(date -Iseconds)\"}}" \
    2>/dev/null

  # Set as current in core memory
  opencode --tool core_memory_update \
    "{\"goal\":\"Thread: ${thread_id}\",\"progress\":\"${summary}\",\"context\":\"priority: ${priority}\"}" \
    2>/dev/null

  echo "✓ Started thread: $emoji $thread_id"
  echo "  $summary"
  ;;

switch)
  if [[ -z $2 ]]; then
    echo "Usage: memory-threads switch <thread_id>"
    exit 1
  fi
  thread_id="$2"

  # Read thread info
  thread_info=$(opencode --tool core_memory_read 2>/dev/null | grep -i "${THREAD_PREFIX}${thread_id}" || echo "")

  if [[ -z $thread_info ]]; then
    echo "Thread not found: $thread_id"
    exit 1
  fi

  # Update core memory
  opencode --tool core_memory_update \
    "{\"goal\":\"Thread: ${thread_id}\",\"progress\":\"${thread_info}\",\"context\":\"switched from previous\"}" \
    2>/dev/null

  echo "✓ Switched to thread: $thread_id"
  ;;

list)
  echo "=== Active Threads ==="
  opencode --tool core_memory_read 2>/dev/null | grep -i "${THREAD_PREFIX}" | while read line; do
    # Extract priority from line
    if echo "$line" | grep -qi "high"; then
      echo "🔴 $line"
    elif echo "$line" | grep -qi "low"; then
      echo "🟢 $line"
    else
      echo "🟡 $line"
    fi
  done
  ;;

current)
  echo "=== Current Thread ==="
  opencode --tool core_memory_read 2>/dev/null | grep -A1 "goal:"
  ;;

status)
  if [[ -z $2 || -z $3 ]]; then
    echo "Usage: memory-threads status <thread_id> <status>"
    exit 1
  fi
  thread_id="$2"
  status="$3"

  echo "Note: Status update requires re-adding thread with new metadata"
  echo "  Current: $thread_id → $status"
  echo ""
  echo "Use: memory-threads note $thread_id 'status changed to $status'"
  ;;

note)
  if [[ -z $2 || -z $3 ]]; then
    echo "Usage: memory-threads note <thread_id> <note>"
    exit 1
  fi
  thread_id="$2"
  shift 2
  note="$*"

  timestamp=$(date -Iseconds)
  opencode --tool working_memory_add \
    "{\"content\":\"${THREAD_PREFIX}${thread_id}_note - ${note}\",\"category\":\"thread_note\",\"metadata\":{\"thread\":\"${thread_id}\",\"timestamp\":\"${timestamp}\"}}" \
    2>/dev/null

  echo "✓ Added note to thread: $thread_id"
  ;;

archive)
  if [[ -z $2 ]]; then
    echo "Usage: memory-threads archive <thread_id>"
    exit 1
  fi
  thread_id="$2"

  opencode --tool working_memory_remove "{\"id\":\"${THREAD_PREFIX}${thread_id}\"}" 2>/dev/null || true
  echo "✓ Archived thread: $thread_id"
  ;;

help | --help | -h | *)
  echo "memory-threads - Conversation thread tracking"
  echo ""
  echo "Commands:"
  echo "  start <id> <summary> [pri]   Start new thread"
  echo "  switch <id>                   Switch to thread"
  echo "  list                          List all threads"
  echo "  current                       Show current thread"
  echo "  status <id> <status>          Update status"
  echo "  note <id> <note>              Add note"
  echo "  archive <id>                  Archive thread"
  ;;
esac
