export PATH=/usr/local/bin:$PATH

export "TERM=xterm-256color"
[[ -z $TMUX ]] && exec tmux new-session -A -s main

#aliases
stty werase undef
[[ -f $HOME/.bash_aliases ]] && source $HOME/.bash_aliases

# custom exports such as API keys
[[ -f $HOME/.exports ]] && . $HOME/.exports

# asdf-vm
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

# tfenv
export PATH="$HOME/.tfenv/bin:$PATH"
