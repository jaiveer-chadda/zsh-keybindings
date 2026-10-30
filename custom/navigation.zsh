#!/usr/bin/env zsh

# ——————————————————————————————————————————————————————————————————————————— #

function zle-line-up zle-line-down () {

  # get the last word of the function name
  local -r move="${${(%):-%N}##*-}"

  # ————————————————————————————————————————————————————————————————————————— #

  # if we're moving upwards
  if [[ $move == 'up' ]] {
    # and we're on the first line
    if [[ $LBUFFER != *$'\n'* ]] {
      # then perform the default behaviour for the up arrow
      zle up-line-or-beginning-search
      return
    }

  # if we're moving downwards, and we're on the last line
  } elif [[ $RBUFFER != *$'\n'* ]] {
    zle down-line-or-beginning-search # run the function for the down arrow
    return
  }

  # ————————————————————————————————————————————————————————————————————————— #

  local -ri 10 TABSIZE=8

  local    before="${LBUFFER%$'\n'*}"   # everything before the current line
  local     after="${RBUFFER#*$'\n'}"   # everything after the current line

  local prev_line="${before##*$'\n'}"   # the full previous line
  local next_line="${after%%$'\n'*}"    # the full next line

  local  cur_line="${LBUFFER##*$'\n'}"  # current line, up to the cursor

  # ————————————————————————————————————————————————————————————————————————— #

  local char
  local -i 10 column char_count

  # visual column of the cursor (a tab advances to the next tab stop)
  # note: this expansion has to be left unquoted - it doesn't work otherwise
  for char in ${(s::)cur_line}; {
    if [[ $char == $'\t' ]] {
      (( column += TABSIZE - ( column % TABSIZE ) ))

    } else {
      (( column++ ))
    }
  }

  # ————————————————————————————————————————————————————————————————————————— #

  local -i 10 width next_col prev_col

  if [[ $move == up ]] {
    # walk the previous line until we reach that column (or run out of line)
    for char in ${(s::)prev_line}; {
      if [[ $char == $'\t' ]] {
        (( width = TABSIZE - prev_col % TABSIZE ))
      } else {
        (( width = 1 ))
      }

      (( prev_col +  width > column      )) && break
      (( prev_col += width, char_count++ ))
    }

    # start offset of the previous line + number of chars we stepped over
    (( CURSOR = $#before - $#prev_line + char_count ))

  } else { # ———————————————————————————————————————————————————————————————— #

    for char in ${(s::)next_line}; {
      if [[ $char == $'\t' ]] {
        (( width = TABSIZE - next_col % TABSIZE ))
      } else {
        (( width = 1 ))
      }

      (( next_col +  width > column      )) && break
      (( next_col += width, char_count++ ))
    }

    # start offset of the next line + number of chars we stepped over
    (( CURSOR += $#RBUFFER - $#after + char_count ))
  }

  # ————————————————————————————————————————————————————————————————————————— #

  return 0
}

# ——————————————————————————————————————————————————————————————————————————— #

autoload -Uz {up,down}-line-or-beginning-search

zle -N              up-line-or-beginning-search
zle -N            down-line-or-beginning-search

zle -N zle-line-up  ; bindkey '^[[A' zle-line-up    # ↑
zle -N zle-line-down; bindkey '^[[B' zle-line-down  # ↓

# ——————————————————————————————————————————————————————————————————————————— #
