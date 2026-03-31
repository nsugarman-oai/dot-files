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

# openai flow install / pre 
alias ofi="pnpm install --frozen-lockfile && pnpm pre"
alias ofp="pnpm format:fix && pnpm lint --fix && pnpm types"

source ~/.zshrc-public
# bun completions
[ -s "/Users/nsugarman/.bun/_bun" ] && source "/Users/nsugarman/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
