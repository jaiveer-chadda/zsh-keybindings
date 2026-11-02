#!/usr/bin/env zsh

function ctrl-z () {
  if   (( $#jobstates )) { BUFFER='fg'; zle accept-line; } \
  elif (( $#BUFFER    )) {              zle push-input ; }
}

keybind '^Z' ctrl-z
