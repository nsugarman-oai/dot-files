#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_BACKUP_STAMP="${DOTFILES_BACKUP_STAMP:-$(date '+%Y%m%d-%H%M%S')}"

"$SCRIPT_DIR/install-zshrc.sh"
"$SCRIPT_DIR/install-zshrc-public.sh"
"$SCRIPT_DIR/install-config-git-aliases.sh"
"$SCRIPT_DIR/install-config-starship.sh"
"$SCRIPT_DIR/install-gitconfig.sh"
"$SCRIPT_DIR/install-local-bin-git-alias.sh"

