# OpenAI shrc (if customising, comment out to prevent it getting readded)
for file in "/Users/nsugarman/.openai/shrc"/*; do
    source "$file"
done

. "$HOME/.local/bin/env"
export API_REPO_PATH="/Users/nsugarman/code/openai/api"
source ~/.api_shell_include
source /Users/nsugarman/code/openai/api/applied-devtools/completions/applied_completions.zsh


# aliases
alias a="applied"

alias gho='oai_gh'

alias ca='oaicode'
alias cf='oaicode -p flowkit --focus api/outerloop'
# Match Flowkit processes directly; the old lsof port sweep dominated latency.
kill_flow() {
  local matches pgids ports

  matches="$(
    ps eww -axo pgid=,command= | awk '
      function print_port(port) {
        if (port != "") {
          print "port:" port
        }
      }

      function extract_env_port(name,    i, parts) {
        for (i = 2; i <= NF; i++) {
          if ($i ~ ("^" name "=")) {
            split($i, parts, "=")
            return parts[2]
          }
        }

        return ""
      }

      /flowkit-localhost\/scripts\/start_flowkit_localhost\.sh/ ||
      /\/tilt up flowkit( --port [0-9]+)?([[:space:]]|$)/ ||
      /uvicorn flowkit\.asgi:application/ ||
      /api\/outerloop\/flowkit_ui\/.*vite\/bin\/vite\.js --port/ {
        backend_port = extract_env_port("FLOWKIT_BACKEND_PORT")
        ui_port = extract_env_port("FLOWKIT_UI_PORT")
        tilt_port = extract_env_port("TILT_PORT")

        gsub(/^[[:space:]]+/, "", $1)
        print "pgid:" $1

        if ($0 ~ /uvicorn flowkit\.asgi:application/) {
          print_port(backend_port)
        }

        if ($0 ~ /\/tilt up flowkit( --port [0-9]+)?([[:space:]]|$)/) {
          if (tilt_port != "") {
            print_port(tilt_port)
          } else if (match($0, /--port [0-9]+/)) {
            print_port(substr($0, RSTART + 7, RLENGTH - 7))
          }
        }

        if ($0 ~ /vite\/bin\/vite\.js --port/) {
          if (ui_port != "") {
            print_port(ui_port)
          } else if (match($0, /--port [0-9]+/)) {
            print_port(substr($0, RSTART + 7, RLENGTH - 7))
          }
        }
      }
    ' | sort -u
  )"

  pgids="$(printf '%s\n' "$matches" | awk -F: '/^pgid:/ { print $2 }')"
  [ -n "$pgids" ] || return 0

  ports="$(printf '%s\n' "$matches" | awk -F: '/^port:/ { print $2 }')"

  while IFS= read -r pgid; do
    [ -n "$pgid" ] || continue
    kill -KILL -- "-$pgid" 2>/dev/null || true
  done <<< "$pgids"

  if [ -n "$ports" ]; then
    printf 'killed flowkit ports:\n%s\n' "$ports"
  fi
}
alias kill-flow='kill_flow'

# openai flow install / pre 
#alias ofi="pnpm install --frozen-lockfile && pnpm pre"
#alias ofp="pnpm format:fix && pnpm lint --fix && pnpm types"

source ~/.zshrc-public

# Restore an interactive pager when the shell inherits the non-interactive
# Codex defaults. This keeps `git log` from dumping the entire monorepo
# history straight through `cat`.
if [[ -o interactive ]]; then
    if [[ "${PAGER:-}" == "cat" ]]; then
        export PAGER="less"
    fi
    if [[ -z "${LESS:-}" ]]; then
        export LESS="-FRX"
    fi
    if [[ "${GIT_PAGER:-}" == "cat" ]]; then
        unset GIT_PAGER
    fi
fi

# bun completions
[ -s "/Users/nsugarman/.bun/_bun" ] && source "/Users/nsugarman/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
