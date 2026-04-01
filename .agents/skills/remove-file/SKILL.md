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
1. Check the current state of the original target path in `$HOME`.
2. If the target path is a symlink managed by this repo, run `./unlink <name>` and move the repo copy from `files/` back to its original location in `$HOME`.
3. If the target path is not a symlink managed by this repo, do not move the repo copy into `$HOME`; just remove the file from this repo.
4. Remove that file's manifest entry from `managed_target_specs()` in `scripts/lib.sh`.
5. Update `README.md` if the command list changed.

## Validation
- Confirm the symlink in `$HOME` is gone after unlinking, when the file was previously linked.
- Confirm `./link <name>` and `./unlink <name>` no longer advertise or accept the removed target.
- Confirm `./status` no longer reports the removed file.
- Confirm the final state of the original target path and say whether it exists, and if so whether it is a symlink or a regular file.

## Notes
- Follow the existing command naming and file ordering conventions when removing entries.
- `link`, `unlink`, `scripts/link-all.sh`, `scripts/unlink-all.sh`, and `scripts/status.sh` are manifest-driven through `scripts/lib.sh`.
- Do not leave dead references in the manifest or README.
- When reporting the result, be explicit about the original target path. Example: `zshrc` now exists as a non-symlinked file at `~/.zshrc`.
