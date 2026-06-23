#!/usr/bin/env zsh

function zle-run-man () {
  local entry=

  if (( REGION_ACTIVE )) {
    local -i 10 left right
    if (( CURSOR < MARK )) { left=$CURSOR right=$MARK; } \
    else                   { left=$MARK right=$CURSOR; }

    entry="${(*)${(*)BUFFER[left+1,right]/#[[:space:]]##}/%[[:space:]]##}"

  } else {
    local -a words=( "${(@z)BUFFER}" )
    entry="$words[1]"

    if [[ "$entry" == (bundle|fish|git|gh|npm|port) ]] entry+="-$words[2]"
  }

  man "$entry"
}

zle -N        zle-run-man
bindkey '^[h' zle-run-man
