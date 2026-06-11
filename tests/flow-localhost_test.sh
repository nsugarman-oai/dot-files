#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
script_path="$repo_root/files/local/bin/flow-localhost"
tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/flow-localhost-test.XXXXXX")"

cleanup() {
  rm -rf "$tmp_dir"
}

trap cleanup EXIT

fake_repo="$tmp_dir/repo"
fake_bin="$tmp_dir/bin"
applied_env_file="$tmp_dir/applied-env"
secret_args_file="$tmp_dir/secret-args"

mkdir -p "$fake_repo/api/outerloop" "$fake_repo/api/tilt" "$fake_repo/.codex/environments" "$fake_bin"

cat >"$fake_repo/.codex/environments/monorepo_worktree_setup.sh" <<'EOF'
#!/usr/bin/env bash
return 0
EOF

cat >"$fake_bin/applied" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' "${OPENAI_API_KEY-}" >"$TEST_APPLIED_ENV_FILE"
EOF

cat >"$fake_bin/secret" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' "$*" >"$TEST_SECRET_ARGS_FILE"
printf 'staging-key\n'
EOF

cat >"$fake_bin/lsof" <<'EOF'
#!/usr/bin/env bash
exit 1
EOF

cat >"$fake_bin/ps" <<'EOF'
#!/usr/bin/env bash
exit 0
EOF

chmod +x "$fake_repo/.codex/environments/monorepo_worktree_setup.sh" "$fake_bin/applied" "$fake_bin/secret" "$fake_bin/lsof" "$fake_bin/ps"

(
  cd "$fake_repo"
  TEST_APPLIED_ENV_FILE="$applied_env_file" \
    TEST_SECRET_ARGS_FILE="$secret_args_file" \
    PATH="$fake_bin:$PATH" \
    "$script_path" --staging >/dev/null
)

[ "$(cat "$applied_env_file")" = "staging-key" ]
[ "$(cat "$secret_args_file")" = "get staging flowkit-chatgpt-service-account-key --value-only" ]
