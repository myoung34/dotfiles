export AWS_VAULT_BACKEND=file
export AWS_CONFIG_FILE=/run/agenix/aws
export EDITOR=vim
export PATH=$HOME/.local/share/mise/shims:$PATH
export TENV_AUTO_INSTALL=true

alias pbcopy="xclip -sel clip"
alias rlp="source ~/.custom.sh"
alias k=$(mise which /home/myoung/.local/share/mise/installs/kubectl/latest/bin/kubectl)

# Direnv setup
( mise which direnv >/dev/null 2>&1 ) && eval "$(direnv hook zsh)" || :

# Handle setting up tmux TPM and powerline for the first time if needed
( mkdir -p "$HOME/.tmux/plugins/tpm" || : ) >/dev/null 2>&1
[[ ! -d "$HOME/.tmux/plugins/tpm" ]] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
[[ ! -d "$HOME/.tmux_powerline" ]] && git clone https://github.com/erikw/tmux-powerline.git ~/.tmux_powerline

# Handle setting up vim NeoBundle away from nix
( mkdir -p $HOME/.vim/bundle || : ) >/dev/null 2>&1
[[ ! -d "$HOME/.vim/bundle/neobundle.vim" ]] && git clone https://github.com/Shougo/neobundle.vim $HOME/.vim/bundle/neobundle.vim

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


function upsearch () {
  found=$(test / == "$PWD" && return || test -e "$1" && echo "$PWD" && return || cd .. && upsearch "$1")
  echo $found
}


ack() {
  rg $@
}

function phage() {

  age-plugin-yubikey -l | grep Serial >/dev/null 2>&1
  YUBIKEY_DETECTED=$?
  if [[ ${YUBIKEY_DETECTED} -eq 0 ]]; then 
    echo "Detected yubikey"
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
  else
    echo "Failed to detect yubikey"
    if [[ $(uname -r) == *"microsoft"* ]]; then
            echo "Detected WSL. Make sure lsusb shows the device"
            echo "Remember to mount it from powershell:"
            echo "  usbipd list"
            echo "  usbipd bind -b <x>-<y> --force"
            echo "  usbipd attach --wsl --busid <x>-<y>"
            echo "  If attach above fails run this from WSL and try again:"
            echo "    sudo mount -t drvfs -o \"ro,umask=222\" \"C:\\Program Files\\usbipd-win\\WSL\" \"/var/run/usbipd-win\""
    fi
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
