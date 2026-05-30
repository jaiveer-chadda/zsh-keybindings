#!/usr/bin/env zsh

# With thanks to `LindsayHill` and `rothgar`
# https://github.com/rothgar/mastering-zsh/blob/master/docs/helpers/widgets.md

function prepend-sudo() {
  if [[ "$BUFFER" != 'sudo '* ]] {
    BUFFER="sudo $BUFFER"
    CURSOR+=5
  }
}

zle -N prepend-sudo
bindkey '^[s' prepend-sudo
