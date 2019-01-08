function upsearch () {
  found=$(test / == "$PWD" && return || test -e "$1" && echo "$PWD" && return || cd .. && upsearch "$1")
  echo $found
}

lower_res() {
  xrandr --output HDMI-1 --mode 2560x1440
}

raise_res() {
  xrandr --output HDMI-1 --mode 3840x2160
}

function brew_upgrade_safe () {
  brew upgrade $(brew list | xargs echo | sed 's/packer//g' | sed 's/terraform//g' | sed 's/vault//g')
}

function bpr () {
  open -a "Google Chrome" https://bitbucket.org/built/built-$1/pull-requests/new
}

alias rlp=". ~/.bash_profile"
function fix_screen() {
  [[ ! -d /var/run/screen ]] && (sudo mkdir /var/run/screen && sudo chmod 777 /var/run/screen)
}

function bounce() {
  INTERNAL_IP=$(ifconfig | grep inet | grep 192 | awk '{ print $2}')
  if [[ $(ifconfig | grep inet | grep 192 | awk '{ print $2}' | wc -l) -gt 1 ]] && [[ -z ${BLESSFIXEDIP} ]]; then
    echo "More than one internal ip found. Disable a network interface or provide it manually via env var 'BLESSFIXEDIP'"
  else
    FILE="$(mktemp)"
    rm -rf ${FILE}*
    ssh-keygen -f ${FILE} -N ""
    BLESS_USER=marc
    BLESS_IDENTITYFILE=${FILE} BLESSFIXEDIP=${BLESSFIXEDIP:-${INTERNAL_IP}} ~/.blessclient/blessclient.run --host $1 --nocache --config ~/.blessclient/blessclient.cfg --region EAST && ssh -i ${FILE} ${BLESS_USER}@$1
  fi
}

alias awslogslist="aws logs describe-log-groups | jq -r '.logGroups[].logGroupName'"
