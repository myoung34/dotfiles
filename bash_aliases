function upsearch () {
  found=$(test / == "$PWD" && return || test -e "$1" && echo "$PWD" && return || cd .. && upsearch "$1")
  echo $found
}

function brew_upgrade_safe () {
  brew upgrade $(brew list | xargs echo | sed 's/packer//g' | sed 's/terraform//g' | sed 's/vault//g')
}

alias rlp=". ~/.bash_profile"
function fix_screen() {
  [[ ! -d /var/run/screen ]] && (sudo mkdir /var/run/screen && sudo chmod 777 /var/run/screen)
}
