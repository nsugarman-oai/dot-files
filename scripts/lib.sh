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

install_file() {
  local source_rel="$1"
  local target_rel="$2"
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
      printf 'Already installed: %s -> %s\n' "$target" "$source"
      return 0
    fi
    backup_target "$target_rel" "$target"
  elif [ -e "$target" ]; then
    backup_target "$target_rel" "$target"
  fi

  ln -s "$source" "$target"
  printf 'Linked %s -> %s\n' "$target" "$source"
}

uninstall_file() {
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
    printf 'not installed'
    return
  fi

  if [ ! -L "$target" ]; then
    printf 'not installed'
    return
  fi

  link_target="$(readlink "$target")"
  if [ "$link_target" = "$source" ]; then
    printf 'installed'
    return
  fi

  printf 'not installed'
}
