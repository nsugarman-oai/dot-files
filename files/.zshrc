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

# Match Workstreams listeners on the normal and +1 ports.
workstreams_kill() {
  local matches pgids ports port pids pid process_info cwd pgid

  matches="$(
    for port in 4010 4011 5203 5204; do
      pids="$(lsof -nP -tiTCP:"$port" -sTCP:LISTEN 2>/dev/null || true)"
      [ -n "$pids" ] || continue

      while IFS= read -r pid; do
        [ -n "$pid" ] || continue

        process_info="$(lsof -a -p "$pid" -d cwd -Fgn 2>/dev/null || true)"
        cwd="$(printf '%s\n' "$process_info" | awk '/^n/ { print substr($0, 2); exit }')"
        case "$cwd" in
          *work-streams*|*workstreams*)
            pgid="$(printf '%s\n' "$process_info" | awk '/^g/ { print substr($0, 2); exit }')"
            [ -n "$pgid" ] || continue
            printf 'pgid:%s\n' "$pgid"
            printf 'port:%s\n' "$port"
            ;;
        esac
      done <<< "$pids"
    done | sort -u
  )"

  pgids="$(printf '%s\n' "$matches" | awk -F: '/^pgid:/ { print $2 }')"
  [ -n "$pgids" ] || return 0

  ports="$(printf '%s\n' "$matches" | awk -F: '/^port:/ { print $2 }')"

  while IFS= read -r pgid; do
    [ -n "$pgid" ] || continue
    kill -KILL -- "-$pgid" 2>/dev/null || true
  done <<< "$pgids"

  if [ -n "$ports" ]; then
    printf 'killed workstreams ports:\n%s\n' "$ports"
  fi
}
alias workstreams-kill='workstreams_kill'

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
