#!/usr/bin/env zsh

function surround-with-set-x () {
  local buffer="$BUFFER"

  if ! (( ${#BUFFER//[[:space:]]} )) buffer="$history[$(( HISTCMD - 1 ))]"

  BUFFER="set -x; $buffer; set +x"
  CURSOR+=${#:-'set -x; '}
}

zle -N          surround-with-set-x
bindkey '^[S'   surround-with-set-x
bindkey '^[^[s' surround-with-set-x
