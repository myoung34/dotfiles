#!/bin/sh

##
# Colorization
##
NORMAL=""
[[ -x $(command -v tput) ]] && NORMAL=$(tput sgr0)


function info() {
  local GREEN=""
  [[ -x $(command -v tput) ]] && GREEN=$(tput setaf 2; tput bold)


  local TEXT='INFO'
  
  echo "[$GREEN$TEXT$NORMAL]: $*"
}

function notice() {
  local TEXT='NOTICE'
  local YELLOW=""
  [[ -x $(command -v tput) ]] && YELLOW=$(tput setaf 3)
  
  echo "[$YELLOW$TEXT$NORMAL]: $*"
}

function warning() {
  local RED=""
  [[ -x $(command -v tput) ]] && RED=$(tput setaf 1)
  local TEXT='WARNING'
  
  echo "[$RED$TEXT$NORMAL]: $*"
}

##
# Configuration
##
CONFIG_FILES=( cygaliases bash_aliases bash_profile gitaliases gitconfig gitignore_default vimrc tmux.conf)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
INCLUDES=()
OPERATION=0
SOURCE_DIR="$HOME/Source"

##
# Program checks
##
BREW_EXISTS=$(type -p brew 2>/dev/null)
RUBY_EXISTS=$(type -p ruby 2>/dev/null)
PYENV_EXISTS=$([[ -d ~/.pyenv ]])
GO_EXISTS=$(type -p go 2>/dev/null)
NVM_EXISTS=$(test -d ~/.nvm)
POWERLINE_EXISTS=$(type -p powerline 2>/dev/null)
TMUX_EXISTS=$(type -p tmux 2>/dev/null)

##
# Local program checks
##
LOCAL_BREW_EXISTS=$(type -p /usr/local/bin/brew 2>/dev/null)
LOCAL_RUBY_EXISTS=$(type -p /usr/local/bin/ruby 2>/dev/null)
LOCAL_GO_EXISTS=$(type -p /usr/local/bin/go 2>/dev/null)
LOCAL_NVM_EXISTS=$NVM_EXISTS
LOCAL_POWERLINE_EXISTS=$POWERLINE_EXISTS
LOCAL_TMUX_EXISTS=false

##
# Actions
##
INSTALL=1
UNINSTALL=2
INSTALL_BREW_ONLY=3
INSTALL_ENHANCD_ONLY=4
INSTALL_NEOBUNDLE_ONLY=5
INSTALL_RUBY_ONLY=6
INSTALL_PYTHON_ONLY=7
INSTALL_GO_ONLY=8
INSTALL_NVM_ONLY=9
INSTALL_POWERLINE_ONLY=10
INSTALL_TMUX_ONLY=11
INSTALL_JAVA_ONLY=12
UNINSTALL_NEOBUNDLE_ONLY=13

##
# Parse arguments
##
for arg in "$@"; do
  case $arg in
    # Install arguments
    -i|--install)             OPERATION=$INSTALL ;;
    --install-brew-only)      OPERATION=$INSTALL_BREW_ONLY ;;
    --install-neobundle-only) OPERATION=$INSTALL_NEOBUNDLE_ONLY ;;
    --install-ruby-only)      OPERATION=$INSTALL_RUBY_ONLY ;;
    --install-python-only)    OPERATION=$INSTALL_PYTHON_ONLY ;;
    --install-go-only)        OPERATION=$INSTALL_GO_ONLY ;;
    --install-nvm-only)       OPERATION=$INSTALL_NVM_ONLY ;;
    --install-powerline-only) OPERATION=$INSTALL_POWERLINE_ONLY ;;
    --install-tmux-only)      OPERATION=$INSTALL_TMUX_ONLY ;;
    --install-enhancd-only)   OPERATION=$INSTALL_ENHANCD_ONLY ;;
    --install-java-only)      OPERATION=$INSTALL_JAVA_ONLY ;;

    # Uninstall arguments
    -u|--uninstall)             OPERATION=$UNINSTALL ;;
    --uninstall-neobundle-only) OPERATION=$UNINSTALL_NEOBUNDLE_ONLY ;;
    
    # Includes arguments
    -a|--all)             INCLUDES=('brew' 'git' 'neobundle' 'ruby' 'python' 'go' 'nvm' 'powerline' 'tmux' 'enhancd' 'java') ;;
    -b|--brew)            INCLUDES=("${INCLUDES[@]}" 'brew') ;;
    -j|--java)            INCLUDES=("${INCLUDES[@]}" 'brew') ;;
    -g|--git)             INCLUDES=("${INCLUDES[@]}" 'git') ;;
    -n|--neobundle)       INCLUDES=("${INCLUDES[@]}" 'neobundle') ;;
    -r|--ruby)            INCLUDES=("${INCLUDES[@]}" 'ruby') ;;
    -p|--python)          INCLUDES=("${INCLUDES[@]}" 'python') ;;
    -go|--go)             INCLUDES=("${INCLUDES[@]}" 'go') ;;
    -nvm|--nvm)           INCLUDES=("${INCLUDES[@]}" 'nvm') ;;
    -power|--powerline)   INCLUDES=("${INCLUDES[@]}" 'powerline') ;;
    -t|--tmux)            INCLUDES=("${INCLUDES[@]}" 'tmux') ;;
    -e|--enhancd)         INCLUDES=("${INCLUDES[@]}" 'enhancd') ;;
    
    *)
      echo "Invalid param: $arg"
      exit
    ;;
  esac
done

##
# Installation methods
##
function install_java() {
  [[ ! -d "$HOME/.jenv" ]] && git clone https://github.com/gcuisinier/jenv.git $HOME/.jenv
}

function install_brew() {
  if [[ $BREW_EXISTS ]]; then
    notice "Brew already installed."
  else
    if [[ $RUBY_EXISTS ]]; then
      info "Installing brew..."
    
      ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
      
      BREW_EXISTS=$(type -p brew 2>/dev/null)
    else
      warning "Could not find ruby"
    fi
  fi
}

function install_configuration() {
  info "Installing configuration..."
  
  for config_file in "${CONFIG_FILES[@]}"; do
    local SOURCE="$DIR/$config_file"
    local DESTINATION="$HOME/.$config_file"
  
    if [ -f $SOURCE ]; then
      if [ -h $DESTINATION ]; then
        notice "Replacing existing sym-link for $DESTINATION."

        unlink $DESTINATION
        ln -s $SOURCE $DESTINATION
      elif [ -f $DESTINATION ]; then
        warning "$DESTINATION is a file and will not be sym-linked."
      else
        info "Adding sym-link for $SOURCE to $DESTINATION"

        ln -s $SOURCE $DESTINATION
      fi
    fi
  done

  if [[ ! -h "$HOME/.bashrc" ]]; then
    info "Adding sym-link for .bash_profile to .bashrc"
    ln -s $DIR/bash_profile $HOME/.bashrc
  fi
  
}

function install_tmux() {
  if [[ ! $LOCAL_TMUX_EXISTS ]]; then
    notice "tmux already installed."
  else
    if [[ $(uname) = "Darwin" ]]; then
      if [[ !$BREW_EXISTS ]]; then
        install_brew
      fi

      brew update
      brew install tmux reattach-to-user-namespace

    elif [[ $(uname) = "Linux" ]]; then
      PREFIX=""
      [[ -x $(command -v yum) ]] && PREFIX="yum"
      [[ -x $(command -v apt-get) ]] && PREFIX="apt-get"
      tempdir=$(mktemp)
      pushd . >/dev/null
      cd $tempdir
      curl -OL https://github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz
      tar -xvzf libevent-2.0.21-stable.tar.gz
      cd libevent-2.0.21-stable
      ./configure --prefix=/usr/local
      make
      sudo make install
      cd ..
      
      # DOWNLOAD SOURCES FOR TMUX AND MAKE AND INSTALL
      curl -OL https://github.com/tmux/tmux/releases/download/2.4/tmux-2.4.tar.gz
      tar -xvzf tmux-2.4.tar.gz
      cd tmux-2.4
      LDFLAGS="-L/usr/local/lib -Wl,-rpath=/usr/local/lib" ./configure --prefix=/usr/local
      make
      sudo make install
      cd ..
      popd >/dev/null

    elif [[ $(uname) =~ CYGWIN.*$ ]]; then
      apt-cyg install tmux
    else 
      warning "$(uname) is not supported"
    fi

    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    git clone https://github.com/erikw/tmux-powerline.git ~/.tmux_powerline
  fi
}

function install_includes() {
  info "Installing includes..."
  
  for include in "${INCLUDES[@]}"; do
    case $include in
      'brew')      install_brew ;;
      'neobundle') install_neobundle ;;
      'enhancd')   install_enhancd ;;
      'nvm')       install_nvm ;;
      'ruby')      install_ruby ;;
      'python')    install_python ;;
      'powerline') install_powerline ;;
      'go')        install_go ;;
      'tmux')      install_tmux ;;
      'java')      install_java ;;
      *) ;;
    esac
  done
}

function install_neobundle() {
  info "Installing neobundle..."
  
  local NEOBUNDLE_PATH="$HOME/.vim/bundle"
  local NEOBUNDLE_NAME='neobundle.vim'
  
  if [[ -d "$NEOBUNDLE_PATH/$NEOBUNDLE_NAME" ]]; then
    notice "NeoBundle already installed."
  else
    mkdir -p $NEOBUNDLE_PATH

    if [[ -d $NEOBUNDLE_PATH ]]; then
      git clone git://github.com/Shougo/$NEOBUNDLE_NAME $NEOBUNDLE_PATH/$NEOBUNDLE_NAME
    else
      warning "Could not find $NEOBUNDLE_PATH"
    fi
  fi
}

function install_go() {
  if [[ $LOCAL_GO_EXISTS ]]; then
    notice "GO already installed."
  else

    if [[ $(uname) = "Darwin" ]]; then
      if [[ !$BREW_EXISTS ]]; then
        install_brew
      fi
    
      brew update
      brew install go
    elif [[ $(uname) = "Linux" ]]; then
      PREFIX=""
      [[ -x $(command -v yum) ]] && PREFIX="yum --nogpgcheck"
      [[ -x $(command -v apt-get) ]] && PREFIX=apt-get
      sudo add-apt-repository ppa:longsleep/golang-backports
      sudo $PREFIX update
      sudo $PREFIX -y install golang-go
    else 
      warning "$(uname) is not supported"
    fi

    [[ ! -d $HOME/.go ]] && for i in bin src; do mkdir -p $HOME/.go/$i; done
    curl https://glide.sh/get | sh

    GO_EXISTS=$(type -p go 2>/dev/null)
    LOCAL_GO_EXISTS=$(type -p /usr/local/bin/go 2>/dev/null)
    export GOPATH=$HOME/.go
    export PATH="$HOME/.go/bin:$PATH"
  fi
}

function install_python() {
  if [[ $PYENV_EXISTS ]]; then
    notice "pyenv already installed."
  else

    if [[ $(uname) = "Darwin" ]]; then
      if [[ !$BREW_EXISTS ]]; then
        install_brew
      fi
    
      brew update
      brew install python pyenv pipenv
    elif [[ $(uname) = "Linux" ]]; then
      PREFIX=""
      [[ -x $(command -v yum) ]] && PREFIX="yum --nogpgcheck"
      [[ -x $(command -v apt-get) ]] && PREFIX=apt-get
      sudo $PREFIX -y install \
        python python-pip

    elif [[ $(uname) =~ CYGWIN.*$ ]]; then
      apt-cyg install python python-pip

    else 
      warning "$(uname) is not supported"
    fi
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    pyenv install 2.7.12
    pyenv global 2.7.12
    pip install pipenv
  fi
}

function install_powerline() {
  sudo pip install powerline-status
  [[ ! -d "$HOME/.tmux_powerline" ]] && git clone https://github.com/erikw/tmux-powerline.git $HOME/.tmux_powerline
  if [[ $(uname) = "Darwin" ]]; then
    brew tap homebrew/dupes
    brew install homebrew/dupes/grep
  else 
    warning "$(uname) is not supported"
  fi

  POWERLINE_EXISTS=$(type -p powerline 2>/dev/null)
  LOCAL_POWERLINE_EXISTS=$POWERLINE_EXISTS
}

function install_nvm() {
  if [[ $LOCAL_NODE_EXISTS ]]; then
    notice "Node already installed."
  else

    if [[ $(uname) = "Darwin" ]]; then
      if [[ !$BREW_EXISTS ]]; then
        install_brew
      fi
    
      brew update
      brew install nvm
    elif [[ $(uname) = "Linux" ]]; then
      if [[ -x $(command -v apt-get) ]]; then
        sudo apt-get install -y build-essential libssl-dev
      fi

      curl https://raw.githubusercontent.com/creationix/nvm/v0.30.2/install.sh | bash

    else 
      warning "$(uname) is not supported"
    fi

    mkdir $HOME/.nvm

    NODE_EXISTS=$(test -d ~/.nvm 2>/dev/null)
    LOCAL_NODE_EXISTS=$NODE_EXISTS
  fi
}

function install_enhancd() {
  echo a
  if [[ -d ~/.enhancd ]]; then
    notice "enhancd already installed."
  else
    git clone https://github.com/b4b4r07/enhancd $HOME/.enhancd
    #fzy
    if [[ ! -f /usr/local/bin/fzy ]]; then
      fzy_dir=$(mktemp)
      rm -rf $fzy_dir
      git clone --depth 1 https://github.com/jhawthorn/fzy $fzy_dir
      cd $fzy_dir
      make
      sudo make install
    fi
    #fzf
    if [[ ! -d ~/.fzf ]]; then 
      git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
      ~/.fzf/install
    fi
    #percol
    if [[ !$PYENV_EXISTS ]]; then
      install_python
    fi
    sudo pip install percol

  fi
}

function install_ruby() {
  if [[ $LOCAL_RUBY_EXISTS ]]; then
    notice "Ruby already installed."
  else

    if [[ $(uname) = "Darwin" ]]; then
      if [[ !$BREW_EXISTS ]]; then
        install_brew
      fi
    
      brew update
      brew install gnupg
    fi

    if [[ $(uname) = "Darwin" || $(uname) = 'Linux' ]]; then
      gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
      \curl -sSL https://get.rvm.io | bash -s stable

    elif [[ $(uname) =~ CYGWIN.*$ ]]; then
      apt-cyg install ruby ruby-devel
    else 
      warning "$(uname) is not supported"
    fi

    RUBY_EXISTS=$(type -p ruby 2>/dev/null)
    LOCAL_RUBY_EXISTS=$(type -p /usr/local/bin/ruby 2>/dev/null)
  fi
}

function install() {
  install_configuration
  
  if [[ ${#INCLUDES[@]} > 0 ]]; then
    install_includes
  fi
}

##
# Uninstall methods
##
function uninstall_configuration() {
  warning "Uninstalling configuration..."
  
  for config_file in "${CONFIG_FILES[@]}"; do
    local DESTINATION="$HOME/.$config_file"
  
    if [[ -f $DESTINATION || -d $DESTINATION ]]; then
      warning "Removing existing sym-link for $DESTINATION."
      unlink $DESTINATION
    fi

  done

  if [[ -h $HOME/.bashrc ]]; then
    warning "Removing existing sym-link for bashrc."
    unlink $HOME/.bashrc
  fi

}

function uninstall_nebundle() {
  warning "Uninstalling NeoBundle..."
  
  if [ -d $HOME/.vim/bundle/neobundle.vim ]; then
    rm -rf $HOME/.vim/bundle/neobundle.vim
  fi
}

function uninstall() {
  uninstall_configuration
}

case $OPERATION in
  # Install operations
  $INSTALL)                install ;;
  $INSTALL_BREW_ONLY)      install_brew ;;
  $INSTALL_NEOBUNDLE_ONLY) install_neobundle ;;
  $INSTALL_RUBY_ONLY)      install_ruby ;;
  $INSTALL_NVM_ONLY)       install_nvm ;;
  $INSTALL_PYTHON_ONLY)    install_python ;;
  $INSTALL_JAVA_ONLY)      install_java ;;
  $INSTALL_GO_ONLY)        install_go ;;
  $INSTALL_POWERLINE_ONLY) install_powerline ;;
  $INSTALL_TMUX_ONLY)      install_tmux ;;
  $INSTALL_ENHANCD_ONLY)   install_enhancd ;;
  
  # Uninstall operations
  $UNINSTALL)                uninstall ;;  
  $UNINSTALL_NEOBUNDLE_ONLY) uninstall_neobundle ;;
  
  # Manual
  *)
    echo "usage: ./setup.sh [-i|--install|--install-brew-only|--install-git-only|--install-neobundle-only|--install-python-only|--install-go-only|"
    echo "  --uninstall-neobundle-only][-a|--all][-b|--brew][-g|--git][-n|--neobundle][-r|--ruby][-g|--go]"
    echo
    echo "Options:"
    echo "  -i --install                Install configuration plus any specified includes"
    echo "  --install-brew-only         Install Homebrew only"
    echo "  --install-git-only          Install Git (requires Homebrew)"
    echo "  --install-go-only           Install only GoLang"
    echo "  --install-enhancd-only      Install only enhancd"
    echo "  --install-neobundle-only    Install only NeoBundle"
    echo "  --install-python-only       Install only Python"
    echo "  --install-ruby-only         Install only Ruby"
    echo "  --install-java-only         Install only Java"
    echo "  -u      --uninstall         Uninstall configuration"
    echo "  --uninstall-neobundle-only  Uninstall only NeoBundle"
    echo "  -a      --all               Include all includes (see --install)"
    echo "  -b      --brew              Include Homebrew (see --install)"
    echo "  -g      --git               Include Git (see --install; requires brew)"
    echo "  -go     --go                Include GoLang (see --install; requires brew)"
    echo "  -e      --enhancd           Include enhancd (see --install)"
    echo "  -j      --java              Include java (see --install)"
    echo "  -n      --neobundle         Include NeoBundle (see --install; requires git)"
    echo "  -r      --ruby              Include Ruby (see --install; requires brew)"
    echo "  -p      --python            Include Python (see --install; requires brew)"
    echo "  -power  --powerline         Include Powerline (see --install; requires python)"
    echo "  -nvm    --nvm               Include NVM (see --install; requires python)"
    echo "  -t      --tmux              Include TMUX (see --install; requires brew)"
  ;;
esac
