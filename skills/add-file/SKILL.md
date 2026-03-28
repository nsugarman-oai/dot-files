---
name: add-file
description: Use when the user asks to add a new managed file or dotfile to this repo, start managing a home-directory file here, or add a new linkable target to the dotfiles commands.
metadata:
  short-description: Add a managed file to this dotfiles repo
---

# Add File

## When to use
- The user asks to add a new managed file or dotfile to this repo.
- The user asks to move an existing file from `$HOME` into this repo and manage it with `./link`.

## Workflow
1. Inspect the existing naming and helper pattern in `link`, `unlink`, `scripts/link-all.sh`, `scripts/unlink-all.sh`, `scripts/status.sh`, and neighboring scripts in `scripts/`.
2. Move the file from `$HOME` into `files/`.
3. Keep root-level dotfiles as dotfiles, for example `files/.zshrc` and `files/.gitconfig`.
4. Store dot-directories without the leading dot inside `files/`, for example `$HOME/.config/...` becomes `files/config/...` and `$HOME/.local/...` becomes `files/local/...`.
5. Add one link script and one unlink script in `scripts/` that source `scripts/lib.sh` and call the shared helpers with both the repo source path and the home target path.
6. Register the new command name in `link` and `unlink`.
7. Add the new link and unlink scripts to `scripts/link-all.sh` and `scripts/unlink-all.sh`.
8. Add the new file to `scripts/status.sh`.
9. Update `README.md` if the command list changed.
10. Run `./link <name>` for the new file, or run `./link all`, then verify the home path is a symlink to the repo copy.

## Validation
- Confirm the new `./link <name>` and `./unlink <name>` entries resolve to the expected scripts.
- Confirm `./status` reports the new file.
- Confirm the home path is a symlink to the repo copy after linking.

## Notes
- Follow the current command naming and file ordering conventions instead of inventing a new pattern.
- Reuse the shared `link_file` and `unlink_file` helpers in `scripts/lib.sh`; do not duplicate that logic in new scripts.
