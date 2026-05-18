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

alias ogh='oai_gh'

alias oc='oaicode'
alias ocf='oaicode -p flowkit --focus api/outerloop'

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

# Socket Firewall: add package-manager wrappers to PATH.
export PATH="/usr/local/bin/sfw:${PATH}"
# Socket Firewall: end package-manager wrappers PATH entry.
