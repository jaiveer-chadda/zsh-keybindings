#!/usr/bin/env zsh

function zle-run-man () {
  local entry=

  if (( REGION_ACTIVE )) {
    local -i 10 left right
    if (( CURSOR < MARK )) { left=$CURSOR right=$MARK; } \
    else                   { left=$MARK right=$CURSOR; }

    entry="${(*)${(*)BUFFER[left+1,right]/#[[:space:]]##}/%[[:space:]]##}"

  } else {
    local -a words

    if (( ${#BUFFER//[[:space:]]} )) {
      words=( "${(@z)BUFFER}" )
    } else {
      words=( "${(@z)history[$(( HISTCMD - 1 ))]}" )
    }

    entry="$words[1]"
    if [[ "$entry" == (bundle|fish|git|gh|npm|port) ]] entry+="-$words[2]"
  }

  # go down one line so we don't overwrite the command line text
  echo
  zle push-line

  MANWIDTH=$(( COLUMNS - 4 )) man "$entry"

  # go up one line, and the to the end of the screen, so that when we
  #  `accept-line`, it doesn't add an extra newline
  echo -n $'\e[A\e['$COLUMNS'G'
  zle accept-line
}

zle -N        zle-run-man
bindkey '^[h' zle-run-man
