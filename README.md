# dot-files

Home dotfiles live in `files/` and get symlinked back into place.

## Commands

- `./status` reports whether each managed file is currently installed from this repo.
- `./install <file>` symlinks one managed file from `files/` into its home-directory location.
- `./uninstall <file>` removes one managed symlink from its home-directory location.
- `./install all` symlinks every managed file into its home-directory location.
- `./uninstall all` removes every managed symlink from its home-directory location.

## Files

- `zshrc`
- `zshrc-public`
- `config-git-aliases`
- `config-starship`
- `gitconfig`
- `local-bin-git-alias`

If an install target already exists, it is moved into `tmp/backups/<timestamp>/...` before the symlink is created.
