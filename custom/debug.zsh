#!/usr/bin/env zsh

function debug zle-debug () {
  local -r NL=$'\n'
  local msg=

  msg+="CURSOR = ${(l:3:)CURSOR}   #BUFFER = ${(l:3:)#BUFFER}$NL"
  if (( REGION_ACTIVE )) \
  msg+="MARK   = ${(l:3:)MARK}   #REGION = ${(l:3:)"$(( MARK - CURSOR ))"#-}"

  zle -M "${msg%$'\n'}"
}

zle -N               zle-debug
bindkey '^X^[[47;5u' zle-debug  # ⌃X ⌃/
