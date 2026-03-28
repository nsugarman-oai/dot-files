---
name: remove-file
description: Use when the user asks to remove a managed file or dotfile from this repo, stop managing an existing target here, or remove a linkable target from the dotfiles commands.
metadata:
  short-description: Remove a managed file from this dotfiles repo
---

# Remove File

## When to use
- The user asks to remove a managed file or dotfile from this repo.
- The user asks to stop managing an existing file from this repo and restore it to `$HOME`.

## Workflow
1. Inspect the existing naming and helper pattern in `link`, `unlink`, `scripts/link-all.sh`, `scripts/unlink-all.sh`, `scripts/status.sh`, and the existing per-file scripts in `scripts/`.
2. Run `./unlink <name>` to remove the managed symlink from `$HOME`.
3. Move the repo copy from `files/` back to its original location in `$HOME`.
4. Remove that file's link and unlink scripts from `scripts/`.
5. Remove the command name from `link` and `unlink`.
6. Remove the file from `scripts/link-all.sh`, `scripts/unlink-all.sh`, and `scripts/status.sh`.
7. Update `README.md` if the command list changed.

## Validation
- Confirm the symlink in `$HOME` is gone after unlinking.
- Confirm `./link <name>` and `./unlink <name>` no longer advertise or accept the removed target.
- Confirm `./status` no longer reports the removed file.

## Notes
- Follow the existing command naming and file ordering conventions when removing entries.
- Do not leave dead references in the dispatch scripts or README.
