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
export PATH="$HOME/.tfenv/bin:$PATH"

function upsearch () {
  found=$(test / == "$PWD" && return || test -e "$1" && echo "$PWD" && return || cd .. && upsearch "$1")
  echo $found
}

alias pbcopy="xclip -sel clip"

ack() {
  rg $@
}

alias k="kubectl"
export PATH="$HOME/.krew/bin:$PATH"

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
  [[ ! -d $HOME/.age ]] && mkdir $HOME/.age
  [[ ! -f $HOME/.age/key ]] && age-plugin-yubikey -l --serial 11087061 --slot 1 | grep -v '^#' >$HOME/.age/key
}
