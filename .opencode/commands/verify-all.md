---
description: Multi-perspective verification in parallel
subtask: true
parallel:
  - /verify-tests
  - /verify-types
  - /verify-lint
return: Consolidate all verification results. Report any failures with fixes.
---
Run comprehensive verification on $ARGUMENTS
