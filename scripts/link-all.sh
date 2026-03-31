#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"
export DOTFILES_BACKUP_STAMP="${DOTFILES_BACKUP_STAMP:-$(date '+%Y%m%d-%H%M%S')}"

link_managed_target() {
  local name="$1"
  local source_rel="$2"
  local target_rel="$3"

  link_file "$source_rel" "$target_rel" "$name"
}

for_each_managed_target link_managed_target
