function upsearch () {
  found=$(test / == "$PWD" && return || test -e "$1" && echo "$PWD" && return || cd .. && upsearch "$1")
  echo $found
}

function brew_upgrade_safe () {
  brew upgrade $(brew list | xargs echo | sed 's/packer//g' | sed 's/terraform//g' | sed 's/vault//g')
}

alias rlp=". ~/.bash_profile"

function bounce() {
  if [[ ! -d ~/.blessclient ]]; then
    pushd . >/dev/null
    git clone -b feature/allow_remote_user_specification https://github.com/stratasan/python-blessclient.git ~/.blessclient
    cd $_
    make
    popd >/dev/null
  fi
  INTERNAL_IP=$(ifconfig | grep inet | grep 192 | awk '{ print $2}')
  if [[ $(ifconfig | grep inet | grep 192 | awk '{ print $2}' | wc -l) -gt 1 ]] && [[ -z ${BLESSFIXEDIP} ]]; then
    echo "More than one internal ip found. Disable a network interface or provide it manually via env var 'BLESSFIXEDIP'"
  else
    FILE="$(mktemp)"
    rm -rf ${FILE}*
    ssh-keygen -f ${FILE} -N ""
    BLESS_IDENTITYFILE=${FILE} BLESSFIXEDIP=${BLESSFIXEDIP:-${INTERNAL_IP}} ~/.blessclient/blessclient.run --host $1 --nocache --config ~/.blessclient/blessclient.cfg --region EAST && ssh -i ${FILE} ec2-user@$1
  fi
}
