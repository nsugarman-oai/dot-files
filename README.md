# dot-files

Home dotfiles live in `files/` and get symlinked back into place.

## Install

Clone the git repo and ask Codex to `@install`.

This will 

1. Merge your existing dot-files into this repo
2. Replace your dot-files with symlinks from this repo
3. You can then view the dot-file changes via git and make changes as needed

Note: your original dot-files are backed up in this repo under `tmp/backups/`

## Usage

### Agent Skills

- `@install` runs the merge-aware install flow for all managed files, equivalent to `@link-merge all`
- `@link-merge <file|all>` merges an existing home-directory file into the repo copy, removes the original file, and then recreates the symlink
- `@add-file <file>` adds a file to this repo, replacing the original file with a symlink
- `@remove-file <file>` removes a file from this repo, restoring the original file (if it was symlinked)

Note: use these skills from the codex app (using `codex -e "..."` causes a sandbox permission error)

### CLI Commands

- `./status` reports whether each managed file is currently linked from this repo.
- `./link <file>` symlinks one managed file from `files/` into its home-directory location (if empty).
- `./unlink <file>` removes one managed symlink from its home-directory location.
- `./link all` symlinks every managed file into its home-directory location.
- `./unlink all` removes every managed symlink from its home-directory location.

## Managed Files

- `zshrc`
- `zshrc-public`
- `config-git-aliases`
- `config-starship`
- `gitconfig`
- `local-bin-git-alias`
