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
alias vimrc="vim ~/.zshrc"
alias sourcerc="source ~/.zshrc"
alias dcd="docker-compose down"
alias dcu="docker-compose up -d --build"

alias giga2="ssh palver@10.20.0.2"
alias giga3="ssh palver@10.20.0.3"

export PATH="$PATH:/home/gian/.local/bin:$(go env GOBIN):$(go env GOPATH)/bin"
export EDITOR=vim

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/gian/google-cloud-sdk/path.zsh.inc' ]; then . '/home/gian/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/gian/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/gian/google-cloud-sdk/completion.zsh.inc'; fi

# source /home/gian/.oh-my-zsh/custom/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

source $ZSH/oh-my-zsh.sh

alias ls="exa"

function genpass() {
  tr -dc A-Za-z0-9 </dev/urandom | head -c ${1:-20} ; echo ''
}

# wsl2 path tracking
keep_current_path() {
  printf "\e]9;9;%s\e\\" "$(wslpath -w "$PWD")"
}
precmd_functions+=(keep_current_path)

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

eval "$(github-copilot-cli alias -- "$0")"

# pnpm
export PNPM_HOME="/home/gian/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end