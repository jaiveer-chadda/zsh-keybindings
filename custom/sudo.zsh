#!/usr/bin/env zsh

# With thanks to `rothgar` and `LindsayHill`
# https://github.com/rothgar/mastering-zsh/blob/master/docs/helpers/widgets.md

function prepend-sudo() {
  if ! (( ${#BUFFER//[[:space:]]} )) {
    BUFFER="sudo $history[$(( HISTCMD - 1 ))]"
    CURSOR=$#BUFFER

  } elif [[ "$BUFFER" != 'sudo '* ]] {
    BUFFER="sudo $BUFFER"
    CURSOR+=5
  }
}

zle -N prepend-sudo
bindkey '^[s' prepend-sudo
