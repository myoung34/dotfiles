[[ -n $SKIP_TMUX ]] && exit 0

export PATH=/usr/local/bin:$PATH

export "TERM=xterm-256color"

#aliases
stty werase undef

function kubepug() {
  kustomize build --enable-helm >temp.yaml
  kubeconform --ignore-missing-schemas \
  --kubernetes-version "$1" \
  --strict \
  --summary "temp.yaml"
  kubent --exit-error \
  --filename "temp.yaml" \
  --helm3=false \
  --cluster=false \
  --target-version="$1"
  rm temp.yaml
}

# asdf-vm
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

# tfenv

function upsearch () {
  found=$(test / == "$PWD" && return || test -e "$1" && echo "$PWD" && return || cd .. && upsearch "$1")
  echo $found
}

alias pbcopy="xclip -sel clip"

ack() {
  rg $@
}

alias k="/home/myoung/.asdf/shims/kubectl"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH="$HOME/.tfenv/bin:$PATH"

alias rlp="source ~/.custom.sh"

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
[[ $(asdf which rustc) ]] && sh $(dirname `asdf which rustc`)/../env


# custom exports such as API keys
[[ -f $HOME/.exports ]] && . $HOME/.exports

# reddit stuff
eval $(ssh-agent -s) >/dev/null 2>&1
ssh-add >/dev/null 2>&1
ssh-add ~/.ssh/gh_reddit >/dev/null 2>&1 #for github.snooguts

function phage() {
  mkdir -p $HOME/.age || :
  [[ ! -f $HOME/.age/recipient ]] && age-plugin-yubikey -l --serial 11087061 --slot 1 | grep -v '^#' >$HOME/.age/recipient
  [[ ! -f $HOME/.age/identity ]] && age-plugin-yubikey -i >$HOME/.age/identity
  filename=$(basename -- "$1")
  extension="${filename##*.}"

  if [[ ${extension} == "age" ]]; then 
    filename="${filename%.*}"
    echo Decrypting ${filename}.age to ${filename}
    age -d -i ~/.age/identity -o ${filename} ${filename}.age
  else
    echo Encrypting ${filename} to ${filename}.age
    age -R "${HOME}/.age/recipient" -o ${filename}.age ${filename}
  fi
}

function funs() {
  NAMESPACE=$1
  kubectl proxy &
  kubectl get namespace $NAMESPACE -o json |jq '.spec = {"finalizers":[]}' >temp.json
  curl -k -H "Content-Type: application/json" -X PUT --data-binary @temp.json 127.0.0.1:8001/api/v1/namespaces/$NAMESPACE/finalize
}

[[ $(uname -r) == *"microsoft"* ]] && export BROWSER="powershell.exe /C start"
[[ $(uname -r) == *"microsoft"* ]] && cd ~
