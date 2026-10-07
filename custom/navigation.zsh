#!/usr/bin/env zsh

# ——————————————————————————————————————————————————————————————————————————— #

function zle-up-line () {
  # on the first line (also covers `CURSOR == 0`) - default behaviour
  if [[ $LBUFFER != *$'\n'* ]] {
    zle up-line-or-beginning-search
    return
  }

  local -ri 10 TABSIZE=8

  local    before="${LBUFFER%$'\n'*}"   # everything before the current line
  local prev_line="${before##*$'\n'}"   # the full previous line
  local  cur_line="${LBUFFER##*$'\n'}"  # current line, up to the cursor

  local char
  local -i 10 column prev_col char_count width

  # visual column of the cursor (a tab advances to the next tab stop)
  # note: this expansion has to be left unquoted - it doesn't work otherwise
  for char in ${(s::)cur_line}; {
    if [[ $char == $'\t' ]] {
      (( column += TABSIZE - ( column % TABSIZE ) ))

    } else {
      (( column++ ))
    }
  }

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

  return 0
}

# ——————————————————————————————————————————————————————————————————————————— #

function zle-down-line () {
  # on last line - default behaviour
  if [[ $RBUFFER != *$'\n'* ]] {
    zle down-line-or-beginning-search
    return
  }

  local -ri 10 TABSIZE=8

  local     after="${RBUFFER#*$'\n'}"   # everything after the current line
  local next_line="${after%%$'\n'*}"    # the full next line
  local  cur_line="${LBUFFER##*$'\n'}"  # current line, up to the cursor

  local char
  local -i 10 column next_col char_count width

  # visual column of the cursor (a tab advances to the next tab stop)
  for char in ${(s::)cur_line}; {
    if [[ $char == $'\t' ]] {
      (( column += TABSIZE - column % TABSIZE ))

    } else {
      (( column++ ))
    }
  }

  # walk the next line until we reach that column (or run out of line)
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

  return 0
}

# ——————————————————————————————————————————————————————————————————————————— #

autoload -Uz {up,down}-line-or-beginning-search

zle -N              up-line-or-beginning-search
zle -N            down-line-or-beginning-search

zle -N zle-up-line  ; bindkey '^[[A' zle-up-line    # ↑
zle -N zle-down-line; bindkey '^[[B' zle-down-line  # ↓

# ——————————————————————————————————————————————————————————————————————————— #
