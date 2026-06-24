#!/usr/bin/env zsh

function zle-run-wh () {
  if ! (( ${#BUFFER//[[:space:]]} )) { zle beep; return; }

  local entry=

  if (( REGION_ACTIVE )) {
    local -i 10 left right
    if (( CURSOR < MARK )) { left=$CURSOR right=$MARK; } \
    else                   { left=$MARK right=$CURSOR; }

    entry="${(*)${(*)BUFFER[left+1,right]/#[[:space:]]##}/%[[:space:]]##}"

  } else {
    local -ra buffer=( "${(@z)BUFFER}" )
    entry="$buffer[1]"
  }

  # go down one line so we don't overwrite the command line text
  echo
  zle push-line
  wh "$entry"

  # go up one line, and the to the end of the screen, so that when we
  #  `accept-line`, it doesn't add an extra newline
  echo -n $'\e[A\e['$COLUMNS'G'
  zle accept-line
}

zle -N        zle-run-wh
bindkey '^[w' zle-run-wh
