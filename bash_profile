export PATH=/usr/local/bin:$PATH

# Tmux
[[ $(which powerline-daemon) ]] && powerline-daemon -q
if command -v tmux>/dev/null; then
  export "TERM=xterm-256color"
  [[ -z $TMUX ]] && exec tmux new-session -A -s main
fi

# python
export PYENV_ROOT="$HOME/.pyenv"
if [[ -d "${PYENV_ROOT}" ]]; then
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
  export PATH=$PATH:$(pyenv which pip | sed 's/pip$//g')
fi

# golang
if command -v go >/dev/null; then
  export GOPATH=$HOME/.go
  export PATH="$HOME/.go/bin:$PATH"
fi

#aliases
if [[ $(uname | grep -E -i '^Cygwin') ]]; then
  source $HOME/.cygaliases
elif [[ $(uname) == "Darwin" ]]; then
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

# RVM
if [[ -d "$HOME/.rvm" ]]; then
  [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
  export PATH="$PATH:$HOME/.rvm/bin:$GEM_HOME/bin" # Add RVM to PATH for scripting
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
[[ ! -f ~/.bash_prompt ]] && (cd /tmp && rm -rf sexy-bash-prompt  && git clone --depth 1 --config core.autocrlf=false https://github.com/twolfson/sexy-bash-prompt && cd sexy-bash-prompt && make install)
. ~/.bash_prompt
cd ~

export PATH="$HOME/.tfenv/bin:$PATH"
