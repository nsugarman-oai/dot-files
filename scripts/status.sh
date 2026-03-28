#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

installed_count=0
not_installed_count=0

report_file() {
  local name="$1"
  local source_rel="$2"
  local target_rel="$3"
  local status target

  status="$(file_status "$source_rel" "$target_rel")"
  target="$(target_path "$target_rel")"

  if [ "$status" = "installed" ]; then
    installed_count=$((installed_count + 1))
    printf 'installed      %s -> %s\n' "$name" "$target"
    return
  fi

  not_installed_count=$((not_installed_count + 1))
  printf 'not installed  %s -> %s\n' "$name" "$target"
}

report_file "zshrc" "files/.zshrc" ".zshrc"
report_file "zshrc-public" "files/.zshrc-public" ".zshrc-public"
report_file "config-git-aliases" "files/config/git/aliases.conf" ".config/git/aliases.conf"
report_file "config-starship" "files/config/starship.toml" ".config/starship.toml"
report_file "gitconfig" "files/.gitconfig" ".gitconfig"
report_file "local-bin-git-alias" "files/local/bin/git-alias" ".local/bin/git-alias"

printf '\nSummary: %d installed, %d not installed\n' "$installed_count" "$not_installed_count"

