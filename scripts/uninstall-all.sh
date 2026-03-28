#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$SCRIPT_DIR/uninstall-zshrc.sh"
"$SCRIPT_DIR/uninstall-zshrc-public.sh"
"$SCRIPT_DIR/uninstall-config-git-aliases.sh"
"$SCRIPT_DIR/uninstall-config-starship.sh"
"$SCRIPT_DIR/uninstall-gitconfig.sh"
"$SCRIPT_DIR/uninstall-local-bin-git-alias.sh"

