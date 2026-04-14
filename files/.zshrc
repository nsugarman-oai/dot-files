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
alias kill-flow='{
  ps -axo pid=,pgid=,command= | awk "
    /flowkit-localhost\/scripts\/start_flowkit_localhost\.sh/ ||
    /uvicorn flowkit\.asgi:application/ ||
    /api\/outerloop\/flowkit_ui\/.*vite\/bin\/vite\.js --port/ { print \$2 }
  "
  for port in $(seq 8081 8101) $(seq 5173 5193); do
    lsof -tiTCP:$port -sTCP:LISTEN 2>/dev/null | while read -r pid; do
      ps -o pgid= -p "$pid"
    done
  done
} | tr -d " " | sort -u | while read -r pgid; do
  kill -9 -- "-$pgid"
done'

# openai flow install / pre 
alias ofi="pnpm install --frozen-lockfile && pnpm pre"
alias ofp="pnpm format:fix && pnpm lint --fix && pnpm types"

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
