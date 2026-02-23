#!/usr/bin/env bash
# Working Memory Plugin Health Check

source "$(dirname "${BASH_SOURCE[0]}")/../lib/ui.sh"

check_working_memory() {
  local status=0

  ui_header "Working Memory Plugin Health Check"

  ui_step "Checking plugin installation..."
  if ls ~/.bun/install/global/node_modules/ 2>/dev/null | grep -q "opencode-working-memory"; then
    ui_success "Plugin installed"
  else
    ui_error "Plugin not installed"
    ui_info "Run: ocx add npm:opencode-working-memory"
    status=1
  fi

  ui_step "Checking tool registration..."
  if opencode --list-tools 2>/dev/null | grep -q "core_memory_update"; then
    ui_success "Tools registered"
  else
    ui_error "Tools not registered"
    ui_info "Restart OpenCode"
    status=1
  fi

  if [[ $status -eq 0 ]]; then
    ui_step "Running write test..."
    local test_goal="health-check-$(date +%s)"
    if opencode --tool core_memory_update "{\"goal\":\"$test_goal\",\"progress\":\"\",\"context\":\"\"}" 2>/dev/null; then
      ui_success "Write test passed"
    else
      ui_error "Write test failed"
      status=1
    fi

    ui_step "Running read test..."
    if opencode --tool core_memory_read 2>/dev/null | grep -q "$test_goal"; then
      ui_success "Read test passed"
    else
      ui_error "Read test failed"
      status=1
    fi

    ui_step "Running working memory add test..."
    local test_item="health-check-item-$(date +%s)"
    if opencode --tool working_memory_add "{\"content\":\"$test_item\",\"category\":\"test\"}" 2>/dev/null; then
      ui_success "Working memory add passed"
    else
      ui_error "Working memory add failed"
      status=1
    fi

    ui_step "Running cleanup..."
    if opencode --tool working_memory_clear 2>/dev/null; then
      ui_success "Cleanup passed"
    else
      ui_warning "Cleanup had issues"
    fi
  fi

  ui_header "Health Check Complete"
  return $status
}

if [[ ${BASH_SOURCE[0]} == "${0}" ]]; then
  check_working_memory
fi
