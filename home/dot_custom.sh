export AWS_VAULT_BACKEND=file
export AWS_CONFIG_FILE=/run/agenix/aws
export EDITOR=vim
export PATH=$HOME/.local/share/mise/shims:$PATH
export TENV_AUTO_INSTALL=true

# powerline-go if available for PS1
( mise which powerline-go >/dev/null 2>&1 ) && PS1="$(`mise which powerline-go` -error $? -jobs ${${(%):%j}:-0})" || :

alias pbcopy="xclip -sel clip"
alias rlp="source ~/.custom.sh"
( mise which kubectl >/dev/null 2>&1 ) && alias k=$(mise which kubectl)

# Direnv setup
( mise which direnv >/dev/null 2>&1 ) && eval "$(direnv hook zsh)" || :

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

[[ $(uname -r) == *"microsoft"* ]] && cd ~
