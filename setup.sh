#!/bin/sh

##
# Configuration
##
CONFIG_FILES=( custom.sh gitaliases gitconfig gitignore_default vimrc tmux.conf )
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


function install_oh_my_zsh() {
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  rm ~/.zshrc
  ln -s ${DIR}/zshrc ~/.zshrc
}

function install_tfenv() {
  export TFENV_ROOT="$HOME/.tfenv"
  [[ ! -d "${TFENV_ROOT}" ]] && git clone https://github.com/kamatama41/tfenv.git ${TFENV_ROOT}
}

function install_brew() {
 [[ ! -d /home/linuxbrew/.linuxbrew/bin/brew ]] && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

function install_krew() {
  (
    set -x; cd "$(mktemp -d)" &&
    OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
    ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
    KREW="krew-${OS}_${ARCH}" &&
    curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
    tar zxvf "${KREW}.tar.gz" &&
    ./"${KREW}" install krew
  )
  export PATH="$HOME/.krew/bin:$PATH"
  kubectl krew install deprecations
}

function install_asdf() {
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch master
  . ~/.asdf/asdf.sh
}

function install_from_brew() {
  brew install "$1"
}

function install_from_asdf() {
  plugin="$1"
  version="$2"
  asdf plugin-add "${plugin}"
  asdf install "${plugin}" "${version}"
  asdf global "${plugin}" "${version}"
}

function install_configuration() {
  echo "Installing configuration..."
  
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
}

function install_tmux() {
  $PREFIX tmux
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
      git clone https://github.com/Shougo/$NEOBUNDLE_NAME $NEOBUNDLE_PATH/$NEOBUNDLE_NAME
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
      bash ~/.fzf/install
    fi
    #percol
    pip install percol
  fi
}

function install() {
  PREFIX=""
  [[ -x $(command -v yum) ]] && PREFIX="sudo yum install -y "
  [[ -x $(command -v brew) ]] && PREFIX="brew install "
  [[ -x $(command -v apt-get) ]] && PREFIX="sudo apt-get install -y "
  [[ -x $(command -v pacman) ]] && PREFIX="sudo pacman -Syu "
  export PREFIX
  $PREFIX curl vim git build-essential zlib1g-dev unzip libffi-dev libssl-dev libbz2-dev ncurses-dev libreadline-dev tk-dev lzma-dev tree ripgrep vim
  install_configuration
  install_asdf
  install_from_asdf python 3.8.9
  install_from_asdf ruby 3.1.0
  install_from_asdf vault 0.11.5
  install_enhancd
  install_powerline
  install_neobundle
  install_tmux
  install_oh_my_zsh
  install_tfenv
  install_brew
  install_from_asdf rust 1.64.0
  install_from_asdf golang 1.19
  install_from_asdf aws-vault 6.5.0
  install_from_asdf awscli 2.7.32
  install_from_asdf kubectl 1.25.1
  install_krew
  install_from_asdf helm 3.9.4
  install_from_asdf kustomize 4.5.7
  install_from_asdf k9s 0.26.3
  install_from_asdf kubectx 0.9.4
  install_from_asdf viddy 0.3.6
  install_from_brew hadolint
  install_from_brew minamijoyo/hcledit/hcledit
  install_from_brew jless
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
