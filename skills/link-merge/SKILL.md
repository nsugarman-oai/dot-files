---
name: link-merge
description: Use when the user wants to preserve and merge existing home-directory changes into this repo's managed copy before linking, or asks to run link-merge on one managed file or on all managed files.
metadata:
  short-description: Merge an existing file into the repo copy before linking
---

# Link Merge

## When to use
- The user wants to link a managed file, but the original target path in `$HOME` already exists and its contents should be preserved.
- The user asks to merge local changes from a home-directory file into the repo-managed copy before relinking.
- The user asks for `@link-merge <name>` or `@link-merge all`.

## Scope
- Accept either one managed file name, such as `zshrc`, or `all`.
- For `all`, iterate each managed file name individually. Do not call `./link all`, because one existing target will stop the whole run before per-file merge handling happens.

## Workflow
1. Inspect the live managed-file mapping from `link`, the per-file scripts in `scripts/`, and `scripts/status.sh`.
2. Resolve the requested target set:
   - Single file: operate on that one managed name.
   - `all`: operate on every managed file name except `all`.
3. For each managed file, identify:
   - the repo file under `files/`
   - the original target path under `$HOME`
   - the link command `./link <name>`
4. Check the current state of the original target path.
5. If the original target path does not exist, run `./link <name>`, then verify the target is now a symlink to the repo copy.
6. If the original target path is already the managed symlink for this repo, report that it is already linked and leave it unchanged.
7. Otherwise, create a backup copy of the original target path before changing anything. Store backups under `tmp/backups/` with a timestamped path that preserves the target's relative location.
8. Merge the original target file into the repo file so the repo file becomes the combined source of truth.
   - Start by comparing the repo file and the original target file with `diff -u` or `git diff --no-index`.
   - Apply non-conflicting additions and edits from the original target into the repo file.
   - If both files changed the same section, resolve the conflict manually in the repo file after reading both sides. Do not drop either side silently.
   - Preserve file formatting, ordering, and style conventions already present in the repo file.
9. Delete the original target file.
10. Run `./link <name>` to recreate the symlink.
11. Verify the final state:
   - the target path is now a symlink to the repo file
   - the repo file contains the merged content
   - the backup copy exists

## Validation
- For each processed file, confirm whether it was linked directly, already linked, or merged and relinked.
- For each merged file, report the backup path you created.
- For each processed file, report the final state of the original target path explicitly.
- For `all`, continue file-by-file and summarize results per file instead of failing the whole task at the first no-op or already-linked entry.

## Notes
- This skill is the intended path when `./link <name>` fails because the target already exists.
- Prefer explicit per-file verification over broad assumptions. The final response should make it easy to audit what happened for each file.
