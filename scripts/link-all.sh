#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_BACKUP_STAMP="${DOTFILES_BACKUP_STAMP:-$(date '+%Y%m%d-%H%M%S')}"

"$SCRIPT_DIR/link-zshrc.sh"
"$SCRIPT_DIR/link-zshrc-public.sh"
"$SCRIPT_DIR/link-config-git-aliases.sh"
"$SCRIPT_DIR/link-config-starship.sh"
"$SCRIPT_DIR/link-gitconfig.sh"
"$SCRIPT_DIR/link-local-bin-git-alias.sh"
