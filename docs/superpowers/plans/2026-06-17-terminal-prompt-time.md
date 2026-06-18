# Terminal Prompt Time Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Show local prompt-render time after Starship's command-duration segment in 12-hour `h:mmam` or `h:mmpm` format.

**Architecture:** Enable Starship's built-in `time` module, which already appears after `cmd_duration` in the default prompt order. Add a shell regression test that renders the module through the installed Starship binary and validates its output shape.

**Tech Stack:** Starship TOML configuration, Bash test script

---

### Task 1: Add and verify the prompt time module

**Files:**
- Create: `tests/starship_test.sh`
- Modify: `files/config/starship.toml`

- [ ] **Step 1: Write the failing test**

```bash
#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
config_path="$repo_root/files/config/starship.toml"

output="$(NO_COLOR=1 STARSHIP_CONFIG="$config_path" starship module time)"
[[ "$output" =~ ^@\ ([1-9]|1[0-2]):[0-5][0-9](am|pm)\ $ ]]
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `./tests/starship_test.sh`

Expected: FAIL because the time module is currently disabled and renders no output.

- [ ] **Step 3: Enable and format the built-in time module**

Append to `files/config/starship.toml`:

```toml
[time]
disabled = false
format = '@ [$time]($style) '
time_format = '%-I:%M%P'
```

This uses local time by default, removes leading zeroes from the hour, omits seconds, and emits lowercase `am` or `pm`.

- [ ] **Step 4: Run focused and full verification**

Run:

```bash
./tests/starship_test.sh
for test_file in tests/*_test.sh; do "$test_file"; done
starship explain --path . >/dev/null
git diff --check
```

Expected: all commands exit 0 with no warnings or test failures.

- [ ] **Step 5: Commit the prompt change**

```bash
git add files/config/starship.toml tests/starship_test.sh docs/superpowers/plans/2026-06-17-terminal-prompt-time.md
git commit -m "Show local time in terminal prompt"
```
