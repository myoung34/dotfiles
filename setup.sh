#!/bin/sh

##
# Configuration
##
CONFIG_FILES=( bash_aliases bash_profile gitaliases gitconfig gitignore_default vimrc tmux.conf Xresources )
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
OPERATION=0
SOURCE_DIR="$HOME/Source"

for arg in "$@"; do
  case $arg in
    -i|--install)             OPERATION=$INSTALL ;;
    -u|--uninstall)           OPERATION=$UNINSTALL ;;
    *)
      echo "Invalid param: $arg"
      exit
    ;;
  esac
done

function install_brew() {
  if [[ $BREW_EXISTS ]]; then
    echo "Brew already installed."
  else
    if [[ $RUBY_EXISTS ]]; then
      echo "Installing brew..."
    
      ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
      
      BREW_EXISTS=$(type -p brew 2>/dev/null)
    else
      echo "Could not find ruby"
    fi
  fi
}


function install_sexy_bash_prompt() {
  [[ ! -f ~/.bash_prompt ]] && (cd /tmp && rm -rf sexy-bash-prompt  && git clone --depth 1 --config core.autocrlf=false https://github.com/twolfson/sexy-bash-prompt && cd sexy-bash-prompt && make install)
}

function install_tfenv() {
  export TFENV_ROOT="$HOME/.tfenv"
  [[ ! -d "${TFENV_ROOT}" ]] && git clone https://github.com/kamatama41/tfenv.git ${TFENV_ROOT}
}

function install_asdf() {
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.6.2
}

function install_vault() {
  asdf plugin-add vault
  asdf install vault 0.11.5
  asdf global vault 0.11.5
}

function install_python() {
  asdf plugin-add python
  asdf install python 3.6.2
  asdf global python 3.6.2
  asdf reshim python
  pip install virtualenv
}

function install_configuration() {
  echo "Installing configuration..."
  
  [[ -d "$HOME/.config/i3/" ]] && cp $DIR/i3config $HOME/.config/i3/config 

  for config_file in "${CONFIG_FILES[@]}"; do
    local SOURCE="$DIR/$config_file"
    local DESTINATION="$HOME/.$config_file"
  
    if [ -f $SOURCE ]; then
      if [ -h $DESTINATION ]; then
        echo "Replacing existing sym-link for $DESTINATION."

        unlink $DESTINATION
        ln -s $SOURCE $DESTINATION
      elif [ -f $DESTINATION ]; then
        echo "$DESTINATION is a file and will not be sym-linked."
      else
        echo "Adding sym-link for $SOURCE to $DESTINATION"

        ln -s $SOURCE $DESTINATION
      fi
    fi
  done

  if [[ ! -h "$HOME/.bashrc" ]]; then
    echo "Adding sym-link for .bash_profile to .bashrc"
    ln -s $DIR/bash_profile $HOME/.bashrc
  fi
  
}

function install_tmux() {
  PREFIX=""
  [[ -x $(command -v yum) ]] && PREFIX="yum install -y "
  [[ -x $(command -v apt-get) ]] && PREFIX="apt-get install -y "
  [[ -x $(command -v pacman) ]] && PREFIX="pacman -Syu "
  sudo $PREFIX tmux
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  git clone https://github.com/erikw/tmux-powerline.git ~/.tmux_powerline
}

function install_neobundle() {
  echo "Installing neobundle..."
  
  local NEOBUNDLE_PATH="$HOME/.vim/bundle"
  local NEOBUNDLE_NAME='neobundle.vim'
  
  if [[ -d "$NEOBUNDLE_PATH/$NEOBUNDLE_NAME" ]]; then
    echo "NeoBundle already installed."
  else
    mkdir -p $NEOBUNDLE_PATH

    if [[ -d $NEOBUNDLE_PATH ]]; then
      git clone git://github.com/Shougo/$NEOBUNDLE_NAME $NEOBUNDLE_PATH/$NEOBUNDLE_NAME
    else
      echo "Could not find $NEOBUNDLE_PATH"
    fi
  fi
}


function install_powerline() {
  pip install powerline-status
  dir=$(mktemp -d)
  pushd . >/dev/null
  cd $dir
  git clone https://github.com/powerline/fonts
  cd fonts
  ./install.sh
  popd >/dev/null
  [[ ! -d "$HOME/.tmux_powerline" ]] && git clone https://github.com/erikw/tmux-powerline.git $HOME/.tmux_powerline
  if [[ $(uname) = "Darwin" ]]; then
    brew tap homebrew/dupes
    brew install homebrew/dupes/grep
  elif [[ $(command -v pacman >/dev/null 2>&1) ]]; then
    sudo pacman -Syu powerline
  fi

}

function install_enhancd() {
  if [[ -d ~/.enhancd ]]; then
    echo "enhancd already installed."
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
    pip install percol
  fi
}

function install_urxvt {
  sudo cp urxvt/pasta /usr/lib/urxvt/perl/
  sudo cp urxvt/xkr-clipboard /usr/lib/urxvt/perl/
}

function install() {
  install_configuration
  install_asdf
  install_python
  install_vault
  install_enhancd
  install_powerline
  install_neobundle
  install_tmux
  install_sexy_bash_prompt
  install_tfenv
  install_urxvt
}

##
# Uninstall methods
##
function uninstall_configuration() {
  echo "Uninstalling configuration..."
  
  for config_file in "${CONFIG_FILES[@]}"; do
    local DESTINATION="$HOME/.$config_file"
  
    if [[ -f $DESTINATION || -d $DESTINATION ]]; then
      echo "Removing existing sym-link for $DESTINATION."
      unlink $DESTINATION
    fi

  done

  if [[ -h $HOME/.bashrc ]]; then
    echo "Removing existing sym-link for bashrc."
    unlink $HOME/.bashrc
  fi

}

function uninstall() {
  uninstall_configuration
}

case $OPERATION in
  # Install operations
  $INSTALL)                install ;;
  # Uninstall operations
  $UNINSTALL)                uninstall ;;  
  # Manual
  *)
    echo "usage: ./setup.sh [-i|--install|-u|--uninstall]"
    echo
    echo "Options:"
    echo "  -i --install           Install configuration plus any specified includes"
    echo "  -u --uninstall         Uninstall configuration"
  ;;
esac
