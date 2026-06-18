#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
script_path="$repo_root/files/local/bin/git-alias"
tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/git-alias-test.XXXXXX")"

cleanup() {
  rm -rf "$tmp_dir"
}

trap cleanup EXIT

repo="$tmp_dir/repo"
fake_bin="$tmp_dir/bin"

mkdir -p "$fake_bin"

git init -b main "$repo" >/dev/null
git -C "$repo" config user.name Test
git -C "$repo" config user.email test@example.com

touch "$repo/base.txt"
git -C "$repo" add base.txt
git -C "$repo" commit -m base >/dev/null
base_sha="$(git -C "$repo" rev-parse HEAD)"
git -C "$repo" update-ref refs/remotes/origin/main "$base_sha"

git -C "$repo" switch -c feature >/dev/null 2>&1
printf 'feature\n' >"$repo/feature.txt"
git -C "$repo" add feature.txt
git -C "$repo" commit -m feature >/dev/null

git -C "$repo" switch -c target main >/dev/null 2>&1
printf 'target\n' >"$repo/target.txt"
git -C "$repo" add target.txt
git -C "$repo" commit -m target >/dev/null

printf '%s\n' '#!/bin/sh' 'printf '\''master\n'\''' >"$fake_bin/git-default-branch"
chmod +x "$fake_bin/git-default-branch"

(
  cd "$repo"
  PATH="$fake_bin:$PATH" "$script_path" test-force feature >/dev/null 2>&1
)

[ "$(git -C "$repo" log -1 --format=%s)" = feature ]
[ "$(git -C "$repo" rev-parse HEAD^)" = "$base_sha" ]
[ -f "$repo/feature.txt" ]
[ ! -e "$repo/target.txt" ]
