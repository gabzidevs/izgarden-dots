#!/usr/bin/env bash

# =============================================================================
# System Resources Check (CPU, Memory, Disk)
# =============================================================================

check_system() {
  echo -e "${CYAN}▸ System Resources${NC}"

  local cpu_load
  cpu_load=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | tr -d ',')
  print_status ok "Load: $cpu_load"

  local mem_info
  mem_info=$(sysctl -n hw.memsize 2>/dev/null)
  if [[ -n $mem_info ]]; then
    local mem_gb=$((mem_info / 1024 / 1024 / 1024))
    print_status ok "RAM: ${mem_gb}GB"
  fi

  local disk_usage
  disk_usage=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
  if [[ $disk_usage -lt 80 ]]; then
    print_status ok "Disk: ${disk_usage}% used"
  elif [[ $disk_usage -lt 90 ]]; then
    print_status warn "Disk: ${disk_usage}% used"
  else
    print_status error "Disk: ${disk_usage}% used"
  fi

  local swap_used
  swap_used=$(sysctl -n vm.swapusage 2>/dev/null | awk '{print $3}' | tr -d 'M')
  if [[ -n $swap_used && $swap_used != "0" ]]; then
    local swap_num=${swap_used%.*}
    if [[ $swap_num -gt 1000 ]]; then
      print_status warn "Swap: ${swap_used}M used"
    fi
  fi

  return 0
}

fix_system() {
  print_status info "System fixes not implemented (manual intervention required)"
}
