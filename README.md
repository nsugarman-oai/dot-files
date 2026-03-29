# dot-files

Home dotfiles live in `files/` and get symlinked back into place.

## CLI Commands

- `./status` reports whether each managed file is currently linked from this repo.
- `./link <file>` symlinks one managed file from `files/` into its home-directory location.
- `./unlink <file>` removes one managed symlink from its home-directory location.
- `./link all` symlinks every managed file into its home-directory location.
- `./unlink all` removes every managed symlink from its home-directory location.

## Agent Skills

- `@add-file <file>` adds a file to this repo, replacing the original file with a symlink
- `@remove-file <file>` removes a file from this repo, restoring the original file (if it was symlinked)
- `@link-merge <file|all>` merges an existing home-directory file into the repo copy, removes the original file, and then recreates the symlink

Use these skills from the codex app (using `codex -e "..."` causes a sandbox error)

## Files

- `zshrc`
- `zshrc-public`
- `config-git-aliases`
- `config-starship`
- `gitconfig`
- `local-bin-git-alias`

If a link target already exists, `./link <file>` now fails and recommends `@link-merge`, which is the path that preserves and merges the existing file before linking.
