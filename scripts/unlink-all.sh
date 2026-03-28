#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$SCRIPT_DIR/unlink-zshrc.sh"
"$SCRIPT_DIR/unlink-zshrc-public.sh"
"$SCRIPT_DIR/unlink-config-git-aliases.sh"
"$SCRIPT_DIR/unlink-config-starship.sh"
"$SCRIPT_DIR/unlink-gitconfig.sh"
"$SCRIPT_DIR/unlink-local-bin-git-alias.sh"
