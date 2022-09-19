export PATH=/usr/local/bin:$PATH

export "TERM=xterm-256color"
[[ -z $TMUX ]] && exec tmux new-session -A -s main

#aliases
stty werase undef

# asdf-vm
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

# tfenv
export PATH="$HOME/.tfenv/bin:$PATH"

function upsearch () {
  found=$(test / == "$PWD" && return || test -e "$1" && echo "$PWD" && return || cd .. && upsearch "$1")
  echo $found
}

ack() {
  rg $@
}

alias k="kubectl"

alias rlp="source ~/.custom.sh"

# custom exports such as API keys
[[ -f $HOME/.exports ]] && . $HOME/.exports
