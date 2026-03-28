# dot-files

Home dotfiles live in `files/` and get symlinked back into place.

## Commands

- `./status` reports whether each managed file is currently linked from this repo.
- `./link <file>` symlinks one managed file from `files/` into its home-directory location.
- `./unlink <file>` removes one managed symlink from its home-directory location.
- `./link all` symlinks every managed file into its home-directory location.
- `./unlink all` removes every managed symlink from its home-directory location.

## Agent Commands

You can ask agents to do the following (they will follow AGENTS.md):

- Remove <file>
- Add <file>

E.g. from repo root: `codex remove zshrc`

## Files

- `zshrc`
- `zshrc-public`
- `config-git-aliases`
- `config-starship`
- `gitconfig`
- `local-bin-git-alias`

If a link target already exists, it is moved into `tmp/backups/<timestamp>/...` before the symlink is created.
