# AGENTS.md

To add a new dotfile to this repo:

1. Move the file from `$HOME` into `files/`.
2. Keep root-level dotfiles as dotfiles, for example `files/.zshrc` and `files/.gitconfig`.
3. Store dot-directories without the leading dot inside `files/`, for example `$HOME/.config/...` becomes `files/config/...` and `$HOME/.local/...` becomes `files/local/...`.
4. Add one install script and one uninstall script in `scripts/` that call the shared helpers in `scripts/lib.sh` with both the repo source path and the home target path.
5. Register the new command name in `install` and `uninstall`.
6. Add the new install and uninstall scripts to `scripts/install-all.sh` and `scripts/uninstall-all.sh`.
7. Add the new file to `scripts/status.sh`.
8. Update `README.md` if the command list changed.
9. Run `./install <name>` for the new file, or run `./install all`, then verify the home path is a symlink to the repo copy.

To remove a dotfile from this repo:

1. Run `./uninstall <name>` to remove the managed symlink from `$HOME`.
2. Remove the repo copy from `files/`.
3. Remove that file's install and uninstall scripts from `scripts/`.
4. Remove the command name from `install` and `uninstall`.
5. Remove the file from `scripts/install-all.sh`, `scripts/uninstall-all.sh`, and `scripts/status.sh`.
6. Update `README.md` if the command list changed.
