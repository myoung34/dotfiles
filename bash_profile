export PATH=/usr/local/bin:$PATH

# Tmux
SESSION_TYPE=local
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  SESSION_TYPE=ssh
else
  case $(ps -o comm= -p $PPID) in
    sshd|*/sshd) SESSION_TYPE=ssh;;
  esac
fi
if [[ "${SESSION_TYPE}" == "local" ]]; then
  [[ $(which powerline-daemon) ]] && powerline-daemon -q
  if command -v tmux>/dev/null; then
    export "TERM=xterm-256color"
    [[ -z $TMUX ]] && exec tmux new-session -A -s main
  fi
fi

# golang
if command -v go >/dev/null; then
  export GOPATH=$HOME/.go
  export PATH="$HOME/.go/bin:$PATH"
fi

#aliases
if [[ $(uname) == "Darwin" ]]; then
  [[ $(which gotty) ]] || [[ $(which go) ]] && go get github.com/yudai/gotty
  stty werase undef
  bind '\C-w:unix-filename-rubout' # Fix ctrl+w to not clear whole word but separators
fi
[[ -f $HOME/.bash_aliases ]] && source $HOME/.bash_aliases

#completion
[[ -f $HOME/.bash_history ]] && complete -W "$(echo `cat $HOME/.bash_history | egrep '^ssh ' | sort | uniq | sed 's/^ssh //'`;)" ssh
[[ -n "$(which brew 2>/dev/null)" && -h $(brew --prefix)/etc/bash_completion ]] && . $(brew --prefix)/etc/bash_completion
[[ -f $HOME/.git-completion.sh ]] || ( curl --silent https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash > $HOME/.git-completion.sh && chmod +x $HOME/.git-completion.sh)
. $HOME/.git-completion.sh
if [[ ! -f $HOME/.docker-compose-completion.bash ]]; then
  if [[ $(which docker-compose 2>/dev/null) ]]; then
    curl --silent -L https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/bash/docker-compose > $HOME/.docker-compose-completion.bash && chmod +x $HOME/.docker-compose-completion.bash
    . $HOME/.docker-compose-completion.bash
    [[ -f $HOME/.docker-completion.bash ]] || ( curl --silent -L https://raw.githubusercontent.com/docker/docker/master/contrib/completion/bash/docker > $HOME/.docker-completion.bash && chmod +x $HOME/.docker-completion.bash )
    . $HOME/.docker-completion.bash
  fi
fi

# custom exports such as API keys
[[ -f $HOME/.exports ]] && . $HOME/.exports

# enhancd
if [[ -d $HOME/.enhancd ]]; then
  . $HOME/.enhancd/init.sh
  export ENHANCD_DISABLE_HOME=0
  export ENHANCD_DISABLE_HYPHEN=0
  export ENHANCD_DISABLE_DOT=1
fi

# fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Run twolfson/sexy-bash-prompt
. ~/.bash_prompt

[[ $(uname -r | grep Microsoft) ]] && cd ~

# asdf-vm
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

# tfenv
export PATH="$HOME/.tfenv/bin:$PATH"

# i3wm background fix
[[ ! $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx && xsetroot -gray
