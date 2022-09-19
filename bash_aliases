function upsearch () {
  found=$(test / == "$PWD" && return || test -e "$1" && echo "$PWD" && return || cd .. && upsearch "$1")
  echo $found
}

ack() {
  rg $@
}

alias k="kubectl"

alias rlp="source ~/.bash_aliases"

export AWS_REGION=us-east-1
