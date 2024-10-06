# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git zsh-autosuggestions kubectl asdf gitignore poetry docker)

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
alias c="code ."
alias db64='echo "$(powershell.exe Get-Clipboard)" | base64 -d'
alias ktn="kubectl top node"
alias kdn="kubectl describe node"
alias gls="git add -A && git stash && git pull && git stash pop"

alias dt="generate_datetime.py"
alias oid="generate_objectid.py"

export CC=gcc
export CXX=g++
export CODEFLASH_API_KEY='cf-2YkVRLCTV6Q5TqzFZNIU9KxYMmWRqdp25seXbtaezPn0KOjOSLSLCDZR9Q-krO1s'
export HETZNER_TOKEN='5TMjCV4QLXbxHyaDtl118a4RvtIN5pmvUthX2BCXgs5xyDYcN46dXR0JuQOttiWZ'
export TF_VAR_hetzner_token="$HETZNER_TOKEN"

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

function scale() {
  kubectl scale ${3:=deployment} $1 --replicas=$2
}

function klfl() {
  kubectl get pods -l "$1" --field-selector=status.phase=Running -o jsonpath='{.items[*].metadata.name}' | xargs -n 1 kubectl logs
}

function rr() {
  # Get the last command
  last_command=$(fc -ln -1)

  # Expand aliases in the last command
  expanded_command=$(alias ${last_command%% *} | sed -e 's/alias \([^=]*\)=.*/\1/' -e 's/ '\''/ /g')

  # If the alias doesn't exist, use the original command
  if [ -z "$expanded_command" ]; then
    expanded_command=$last_command
  else
    expanded_command="$expanded_command ${last_command#* }"
  fi

  # Extract the command name and its arguments
  cmd_name=$(echo $expanded_command | awk '{print $1}')
  cmd_args=$(echo $expanded_command | awk '{$1=""; print $0}')

  # Reverse the order of the new arguments you pass to rr
  reversed_args=()
  for arg in "$@"; do
    reversed_args=("$arg" "${reversed_args[@]}")
  done

  # Run the command with the new arguments
  eval $cmd_name $cmd_args "${reversed_args[@]}"
}

function copy-secret() {
  if [ "$#" -ne 2 ]; then
    echo "Usage: copy-secret [namespace] [secret]"
    return 1
  fi

  local namespace=$1
  local secret=$2

  kubectl get secret "$secret" -n "$namespace" -o json | \
  jq 'del(.metadata["namespace"])' | \
  kubectl apply -f -
}

function patch-sa() {
  kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "dockerhub-palverdata"}]}'
}


# Function to switch to K3s configuration
function uk3s() {
  export KUBECONFIG=~/.kube/k3s.config
  echo "Switched to K3s configuration."
  kubectl config get-contexts
}

# Function to switch to GKE configuration
function ugke() {
  export KUBECONFIG=~/.kube/config
  echo "Switched to GKE configuration."
  kubectl config get-contexts
}


export PATH="$PATH:/home/gian/.local/bin:$(go env GOBIN):$(go env GOPATH)/bin:$HOME/.linkerd2/bin"
export EDITOR=nvim
export CLOUDSDK_PYTHON=python3.11
export AWS_ENDPOINT_URL=https://a151cac41de8d129e246200bf7005d56.r2.cloudflarestorage.com

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

# source "$HOME/.rye/env"

