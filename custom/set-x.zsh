#!/usr/bin/env zsh

function surround-with-set-x () {
  local buffer="$BUFFER"

  if ! (( ${#BUFFER//[[:space:]]} )) buffer="$history[$(( HISTCMD - 1 ))]"

  BUFFER="set -x; $buffer; set +x"
  CURSOR+=${#:-'set -x; '}
}

keybind '^[S'   surround-with-set-x
keybind '^[^[s' surround-with-set-x
