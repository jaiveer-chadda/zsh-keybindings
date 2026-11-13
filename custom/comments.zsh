#!/usr/bin/env zsh

# WORK IN PROGRESS !!
function zle-add-comment () {
  local -r NL=$'\n'
  local -r COM='#'

  local -r pre_line="${LBUFFER%$NL*}$NL"

  local -ri 10 line_start=$(( $#pre_line + 1 ))
  local line="${BUFFER[line_start,-1]%%$NL*}"

  local -ri 10 first_occ_idx=${line[(i)[^[:space:]]]}

  (( CURSOR < $#pre_line + first_occ_idx - 1
    ? ( CURSOR = $#pre_line + first_occ_idx - 1 )
    : 0
  ))

  local temp_buf=

  if [[ $line[first_occ_idx] == $COM ]] {
    line="${line/$COM( |)}"
    temp_buf="$pre_line$line"
    LBUFFER="$temp_buf[1,CURSOR-2]"

  } else {
    line="$line[1,first_occ_idx-1]$COM $line[first_occ_idx,-1]"
    temp_buf="$pre_line$line"
    LBUFFER="$temp_buf[1,CURSOR+2]"
  }

  export __ZLE_CURSOR_VISPOS=-1
}

keybind '^[[(W+/)'  zle-add-comment  ⌘ /
