#!/usr/bin/env bash

# =============================================================================
# Time Room Agent Health Check (B)
# =============================================================================

check_agents() {
  echo -e "${CYAN}▸ Time Room Agents${NC}"

  local logs_dir="$HOME/.local/share/agent-tasks/logs"

  if [[ ! -d $logs_dir ]]; then
    print_status warn "Agent logs directory not found"
    return 2
  fi

  local agent_count
  agent_count=$(find "$logs_dir" -maxdepth 1 -name "*.log" 2>/dev/null | wc -l)
  print_status ok "Agent logs found: $agent_count"

  if [[ $agent_count -gt 0 ]]; then
    local stale_count=0
    local healthy_count=0

    for logfile in "$logs_dir"/*.log; do
      [[ -e $logfile ]] || continue

      local agent_name
      agent_name=$(basename "$logfile" .log)

      local last_modified
      last_modified=$(stat -f "%m" "$logfile" 2>/dev/null || stat -c "%Y" "$logfile" 2>/dev/null)

      if [[ -n $last_modified ]]; then
        local now
        now=$(date +%s)
        local age=$((now - last_modified))
        local age_hours=$((age / 3600))

        if [[ $age_hours -lt 24 ]]; then
          ((healthy_count++))
          print_status ok "$agent_name: active ($age_hours hours ago)"
        elif [[ $age_hours -lt 72 ]]; then
          ((stale_count++))
          print_status warn "$agent_name: stale ($age_hours hours ago)"
        else
          ((stale_count++))
          print_status error "$agent_name: inactive ($age_hours hours ago)"
        fi
      fi
    done

    if [[ $stale_count -gt 0 ]]; then
      print_status warn "Stale agents: $stale_count"
    fi
  fi

  local cron_file="$HOME/.config/flake/.cron/agent-tasks.cron"
  if [[ -f $cron_file ]]; then
    print_status ok "Cron config exists"
  else
    print_status warn "Cron config not found"
  fi

  return 0
}

fix_agents() {
  print_status info "Agent health fixes not implemented (run manually)"
}
