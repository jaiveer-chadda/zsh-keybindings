#!/usr/bin/env zsh

function ctrl-z () {
  if   (( $#jobstates )) { BUFFER='fg'; zle accept-line; } \
  elif (( $#BUFFER    )) {              zle push-input ; }
}

zle -N       ctrl-z
bindkey '^Z' ctrl-z
