#!/usr/bin/env bash
# memory-delegate - Delegation handover using working-memory plugin

DELEGATE_PREFIX="delegate_to:"

pack() {
  if [[ -z $1 || -z $2 ]]; then
    echo "Usage: memory-delegate pack <agent> <task_summary>"
    exit 1
  fi
  agent="$1"
  shift
  task="$*"

  # Store in core memory
  opencode --tool core_memory_update \
    "{\"goal\":\"Delegated to ${agent}: ${task}\",\"progress\":\"[ ] awaiting completion\",\"context\":\"delegation in progress\"}" \
    2>/dev/null

  # Store detailed package in working memory
  opencode --tool working_memory_add \
    "{\"content\":\"${DELEGATE_PREFIX}${agent} - ${task}\",\"category\":\"delegate\",\"metadata\":{\"task\":\"${task}\",\"constraints\":[],\"files\":[],\"created\":\"$(date -Iseconds)\"}}" \
    2>/dev/null

  echo "✓ Created delegation package for: $agent"
  echo "  Task: $task"
}

constrain() {
  if [[ -z $1 ]]; then
    echo "Usage: memory-delegate constrain <constraint>"
    exit 1
  fi

  constraint="$*"

  opencode --tool working_memory_add \
    "{\"content\":\"constraint: ${constraint}\",\"category\":\"delegate_constraint\",\"metadata\":{\"type\":\"constraint\",\"created\":\"$(date -Iseconds)\"}}" \
    2>/dev/null

  echo "✓ Added constraint: $constraint"
}

files() {
  if [[ -z $1 ]]; then
    echo "Usage: memory-delegate files <file1> [file2] ..."
    exit 1
  fi

  files_list="$*"

  opencode --tool working_memory_add \
    "{\"content\":\"delegate_files: ${files_list}\",\"category\":\"delegate_files\",\"metadata\":{\"files\":[\"${files_list// /\"\",\"\"}\"],\"created\":\"$(date -Iseconds)\"}}" \
    2>/dev/null

  echo "✓ Added files: $files_list"
}

show() {
  echo "=== Delegation Package ==="
  echo ""
  echo "--- Core Memory (Goal) ---"
  opencode --tool core_memory_read 2>/dev/null | grep -A3 "goal:"
  echo ""
  echo "--- Delegation Details ---"
  opencode --tool core_memory_read 2>/dev/null | grep -i "${DELEGATE_PREFIX}" || echo "(none)"
  opencode --tool core_memory_read 2>/dev/null | grep -i "constraint:" || echo ""
  echo ""
  echo "--- Files ---"
  opencode --tool core_memory_read 2>/dev/null | grep -i "delegate_files:" || echo "(none)"
}

clear() {
  opencode --tool working_memory_clear 2>/dev/null
  echo "✓ Cleared delegation package"
}

handover() {
  if [[ -z $1 || -z $2 ]]; then
    echo "Usage: memory-delegate handover <agent> <task_summary>"
    exit 1
  fi

  agent="$1"
  shift
  task="$*"

  pack "$agent" "$task"
  show

  echo ""
  echo "→ To handover, tell the subagent:"
  echo "  'Use core_memory_read to understand your task'"
}

case "${1:-}" in
pack)
  shift
  pack "$@"
  ;;
constrain)
  shift
  constrain "$@"
  ;;
files)
  shift
  files "$@"
  ;;
show) show ;;
clear) clear ;;
handover)
  shift
  handover "$@"
  ;;
help | --help | -h | *)
  echo "memory-delegate - Delegation handover"
  echo ""
  echo "Commands:"
  echo "  pack <agent> <task>       Create delegation package"
  echo "  constrain <rule>          Add constraint"
  echo "  files <f1> [f2]...        Add files"
  echo "  show                      Display package"
  echo "  clear                     Clear package"
  echo "  handover <agent> <task>  Quick pack + show"
  ;;
esac
