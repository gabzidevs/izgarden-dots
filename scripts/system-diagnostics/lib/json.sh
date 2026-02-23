#!/usr/bin/env bash

# =============================================================================
# JSON Output Helpers
# =============================================================================

output_json() {
  local total=$1
  local passed=$2
  local failed=$3
  local warnings=$4

  local checks_json="["
  local first=true

  for check in "${!CHECK_RESULTS[@]}"; do
    local result=${CHECK_RESULTS[$check]}
    local status
    case $result in
    0) status="pass" ;;
    1) status="fail" ;;
    2) status="warn" ;;
    *) status="unknown" ;;
    esac

    if [[ $first == "true" ]]; then
      first=false
    else
      checks_json+=","
    fi

    checks_json+="{\"name\":\"$check\",\"status\":\"$status\"}"
  done

  checks_json+="]"

  cat <<EOF
{
  "total": $total,
  "passed": $passed,
  "failed": $failed,
  "warnings": $warnings,
  "checks": $checks_json,
  "machine": "$(detect_machine)",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
}

json_escape() {
  local str="$1"
  echo "$str" | sed 's/\\/\\\\/g; s/"/\\"/g; s/\n/\\n/g'
}
