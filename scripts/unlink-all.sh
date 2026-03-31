#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

unlink_managed_target() {
  local _name="$1"
  local source_rel="$2"
  local target_rel="$3"

  unlink_file "$source_rel" "$target_rel"
}

for_each_managed_target unlink_managed_target
