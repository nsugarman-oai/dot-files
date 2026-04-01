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
1. Move the file from `$HOME` into `files/`.
2. Keep root-level dotfiles as dotfiles, for example `files/.zshrc` and `files/.gitconfig`.
3. Store dot-directories without the leading dot inside `files/`, for example `$HOME/.config/...` becomes `files/config/...` and `$HOME/.local/...` becomes `files/local/...`.
4. Add one manifest entry to `managed_target_specs()` in `scripts/lib.sh` with the command name, repo source path, and home target path.
5. Keep the new entry ordered consistently with the existing manifest and README list.
6. Update `README.md` if the command list changed.
7. Run `./link <name>` for the new file, or run `./link all`, then verify the home path is a symlink to the repo copy.

## Validation
- Confirm the new `./link <name>` and `./unlink <name>` entries are advertised and resolve to the expected paths.
- Confirm `./status` reports the new file.
- Confirm the home path is a symlink to the repo copy after linking.

## Notes
- Follow the current command naming and file ordering conventions instead of inventing a new pattern.
- `link`, `unlink`, `scripts/link-all.sh`, `scripts/unlink-all.sh`, and `scripts/status.sh` are manifest-driven through `scripts/lib.sh`; do not add per-file shell scripts.
