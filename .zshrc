# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git zsh-autosuggestions kubectl asdf autoswitch_virtualenv gitignore poetry docker)

# Alias
alias vimrc="nvim ~/.zshrc"
alias sourcerc="source ~/.zshrc"
alias dcd="docker-compose down"
alias dcu="docker-compose up -d --build"

alias giga2="ssh palver@10.20.0.2"
alias giga3="ssh palver@10.20.0.3"
alias personal="ssh gian@192.168.3.101"
alias hetzner="ssh root@5.78.93.95"
alias nv="nvim"
alias wakenote="wol 08:8f:c3:96:e9:97"
alias note="ssh gian@192.168.3.7"
alias dotcfg="nvim ~/.dotfiles"
alias kg="kubectl get"
alias kd="kubectl describe"
alias wkdp="watch -n 1 kubectl describe pod"
alias krrd="kubectl rollout restart deployment"
alias krrs="kubectl rollout restart statefulset"

alias dt="generate_datetime"
alias oid="generate_objectid"

function cns() {
  if [[ $# -eq 1 ]]; then
    namespace=$1
  else
    namespace=$(kubectl get namespace -o custom-columns=":metadata.name" | fzf)
  fi

  if [[ -z $namespace ]]; then
    exit 0
  fi

  kubectl config set-context --current --namespace $namespace
}

export PATH="$PATH:/home/gian/.local/bin:$(go env GOBIN):$(go env GOPATH)/bin"
export EDITOR=nvim
export CLOUDSDK_PYTHON=python3.11

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# source /home/gian/.oh-my-zsh/custom/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

source $ZSH/oh-my-zsh.sh

alias ls="exa"

function genpass() {
  tr -dc A-Za-z0-9 </dev/urandom | head -c ${1:-20} ; echo ''
}

# wsl2 path tracking
keep_current_path() {
  if ! command -v wslpath &> /dev/null; then
    return 1
  fi

  printf "\e]9;9;%s\e\\" "$(wslpath -w "$PWD")"
}
precmd_functions+=(keep_current_path)

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

if command -v github-copilot-cli &> /dev/null; then
  eval "$(github-copilot-cli alias -- "$0")"
fi

# pnpm
export PNPM_HOME="/home/gian/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# bun completions
[ -s "/home/gian/.bun/_bun" ] && source "/home/gian/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# add Pulumi to the PATH
export PATH=$PATH:$HOME/.pulumi/bin

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/gian/google-cloud-sdk/path.zsh.inc' ]; then . '/home/gian/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/gian/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/gian/google-cloud-sdk/completion.zsh.inc'; fi
