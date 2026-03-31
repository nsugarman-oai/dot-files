#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd)"
HOME_DIR="${HOME:?HOME must be set}"
BACKUP_ROOT="$REPO_ROOT/tmp/backups"

source_path() {
  printf '%s/%s' "$REPO_ROOT" "$1"
}

target_path() {
  printf '%s/%s' "$HOME_DIR" "$1"
}

# Single source of truth for managed command names and their source/target paths.
managed_target_specs() {
  cat <<'EOF'
zshrc|files/.zshrc|.zshrc
zshrc-public|files/.zshrc-public|.zshrc-public
config-git-aliases|files/config/git/aliases.conf|.config/git/aliases.conf
config-starship|files/config/starship.toml|.config/starship.toml
gitconfig|files/.gitconfig|.gitconfig
local-bin-git-alias|files/local/bin/git-alias|.local/bin/git-alias
EOF
}

print_managed_target_names() {
  managed_target_specs | cut -d'|' -f1
}

resolve_managed_target() {
  local requested_name="$1"
  local name source_rel target_rel

  while IFS='|' read -r name source_rel target_rel; do
    [ -n "$name" ] || continue

    if [ "$name" = "$requested_name" ]; then
      printf '%s|%s\n' "$source_rel" "$target_rel"
      return 0
    fi
  done < <(managed_target_specs)

  return 1
}

for_each_managed_target() {
  local callback="$1"
  local name source_rel target_rel

  while IFS='|' read -r name source_rel target_rel; do
    [ -n "$name" ] || continue
    "$callback" "$name" "$source_rel" "$target_rel"
  done < <(managed_target_specs)
}

backup_stamp() {
  if [ -n "${DOTFILES_BACKUP_STAMP:-}" ]; then
    printf '%s' "$DOTFILES_BACKUP_STAMP"
    return
  fi

  date '+%Y%m%d-%H%M%S'
}

backup_target() {
  local rel_path="$1"
  local target="$2"
  local backup_dir backup_path rel_dir

  rel_dir="$(dirname "$rel_path")"
  backup_dir="$BACKUP_ROOT/$(backup_stamp)"
  if [ "$rel_dir" != "." ]; then
    backup_dir="$backup_dir/$rel_dir"
  fi
  backup_path="$backup_dir/$(basename "$rel_path")"

  mkdir -p "$backup_dir"

  if [ -e "$backup_path" ] || [ -L "$backup_path" ]; then
    backup_path="${backup_path}.$(date '+%Y%m%d-%H%M%S')"
  fi

  mv "$target" "$backup_path"
  printf 'Backed up existing %s to %s\n' "$target" "$backup_path"
}

link_file() {
  local source_rel="$1"
  local target_rel="$2"
  local command_name="${3:-}"
  local source target link_target

  source="$(source_path "$source_rel")"
  target="$(target_path "$target_rel")"

  if [ ! -e "$source" ]; then
    printf 'Source file missing: %s\n' "$source" >&2
    exit 1
  fi

  mkdir -p "$(dirname "$target")"

  if [ -L "$target" ]; then
    link_target="$(readlink "$target")"
    if [ "$link_target" = "$source" ]; then
      printf 'Already linked: %s -> %s\n' "$target" "$source"
      return 0
    fi
  fi

  if [ -L "$target" ] || [ -e "$target" ]; then
    printf 'Target already exists: %s\n' "$target" >&2
    if [ -n "$command_name" ]; then
      printf 'Use @link-merge %s in the Codex app to merge the existing file into the repo copy before linking.\n' "$command_name" >&2
    else
      printf 'Use @link-merge in the Codex app to merge the existing file into the repo copy before linking.\n' >&2
    fi
    exit 1
  fi

  ln -s "$source" "$target"
  printf 'Linked %s -> %s\n' "$target" "$source"
}

unlink_file() {
  local source_rel="$1"
  local target_rel="$2"
  local source target link_target

  source="$(source_path "$source_rel")"
  target="$(target_path "$target_rel")"

  if [ -L "$target" ]; then
    link_target="$(readlink "$target")"
    if [ "$link_target" = "$source" ]; then
      rm "$target"
      printf 'Removed symlink %s\n' "$target"
      return 0
    fi

    printf 'Skipping %s: symlink points to %s, not %s\n' "$target" "$link_target" "$source"
    return 0
  fi

  if [ -e "$target" ]; then
    printf 'Skipping %s: not a symlink managed by this repo\n' "$target"
    return 0
  fi

  printf 'Already absent: %s\n' "$target"
}

file_status() {
  local source_rel="$1"
  local target_rel="$2"
  local source target link_target

  source="$(source_path "$source_rel")"
  target="$(target_path "$target_rel")"

  if [ ! -e "$source" ]; then
    printf 'not linked'
    return
  fi

  if [ ! -L "$target" ]; then
    printf 'not linked'
    return
  fi

  link_target="$(readlink "$target")"
  if [ "$link_target" = "$source" ]; then
    printf 'linked'
    return
  fi

  printf 'not linked'
}
