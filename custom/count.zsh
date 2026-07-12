#!/usr/bin/env zsh

function count() {
  local text

  if ! (( REGION_ACTIVE )) {
    text="$BUFFER"

  } else {
    if (( CURSOR < MARK )) { left=$CURSOR right=$MARK; } \
    else                   { left=$MARK right=$CURSOR; }

    text="$BUFFER[left+1,right]"
  }

  local message="${#text} characters"
  local -ri 10 no_sp_count="${#text//[[:space:]]}"

  if (( no_sp_count != $#text )) message+=$'\n'"$no_sp_count without spaces"
  zle -M "$message"
}

zle -N count
# bindkey '' count
