#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

linked_count=0
not_linked_count=0

report_file() {
  local name="$1"
  local source_rel="$2"
  local target_rel="$3"
  local status target

  status="$(file_status "$source_rel" "$target_rel")"
  target="$(target_path "$target_rel")"

  if [ "$status" = "linked" ]; then
    linked_count=$((linked_count + 1))
    printf 'linked         %s -> %s\n' "$name" "$target"
    return
  fi

  not_linked_count=$((not_linked_count + 1))
  printf 'not linked     %s -> %s\n' "$name" "$target"
}

for_each_managed_target report_file

printf '\nSummary: %d linked, %d not linked\n' "$linked_count" "$not_linked_count"
