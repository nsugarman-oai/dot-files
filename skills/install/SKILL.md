---
name: install
description: Use when the user wants to install this dotfiles repo into their home directory, set up all managed files at once, or asks for an install workflow that preserves and merges existing local files before linking.
metadata:
  short-description: Install all managed dotfiles with merge-aware linking
---

# Install

## When to use
- The user asks to install this dotfiles repo.
- The user asks to set up all managed files at once.
- The user wants the equivalent of `@link-merge all`.

## Workflow
1. Use the same managed-file mapping and merge behavior defined in [`skills/link-merge/SKILL.md`](/Users/nsugarman/code/dot-files/skills/link-merge/SKILL.md).
2. Resolve the request as `@link-merge all`.
3. Process every managed file name individually, using the `link-merge` workflow for each one.
4. Report per-file results and the final state of each original target path.

## Notes
- This skill is intentionally just the install-oriented entry point for `link-merge all`.
- Do not call `./link all` directly when local files may already exist; use the merge-aware flow instead.
