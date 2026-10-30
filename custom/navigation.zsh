#!/usr/bin/env zsh

# ——————————————————————————————————————————————————————————————————————————— #

# The cursor's visual position on the line. Set to -1 when undefined
export -i 10 __ZLE_CURSOR_VISPOS=-1

# ——————————————————————————————————————————————————————————————————————————— #

function zle-line-up zle-line-down () {

  local -r NL=$'\n' HT=$'\t'
  local -ri 10 TABSIZE=8

  # get the last word of the function name
  local -r move="${${(%):-%N}##*-}"

  # ————————————————————————————————————————————————————————————————————————— #

  local -i 2 did_hist_search=0

  # if we're moving upwards
  if [[ $move == 'up' ]] {
    # and we're on the first line
    if [[ $LBUFFER != *$NL* ]] {
      # then perform the default behaviour for the up arrow
      zle up-line-or-beginning-search
      did_hist_search=1
    }

  # if we're moving downwards, and we're on the last line
  } elif [[ $RBUFFER != *$NL* ]] {
    zle down-line-or-beginning-search # run the function for the down arrow
    did_hist_search=1
  }

  if (( did_hist_search )) {
    __ZLE_CURSOR_VISPOS=-1
    return
  }

  # ————————————————————————————————————————————————————————————————————————— #

  local -r cur_line="${LBUFFER##*$NL}"  # current line, up to the cursor

  # ————————————————————————————————————————————————————————————————————————— #

  local char
  local -i 10 cursor_pos char_count

  # if the visual position is undefined (usually after there's been)
  if (( __ZLE_CURSOR_VISPOS == -1 )) {
    # find the visual column of the cursor
    # note: this expansion has to be left unquoted - it doesn't work otherwise
    for char in ${(s::)cur_line}; {
      # if we're parsing a tab, align the cursor to the next tabstop
      if [[ $char == $HT ]] {
        (( cursor_pos += TABSIZE - ( cursor_pos % TABSIZE ) ))

      } else { # otherwise just move the cursor forward one space
        (( cursor_pos++ ))
      }
    }
  } else {
    cursor_pos=$__ZLE_CURSOR_VISPOS
  }

  # ————————————————————————————————————————————————————————————————————————— #

  local -r before="${LBUFFER%$NL*}"  # everything before the current line
  local -r  after="${RBUFFER#*$NL}"  # everything after the current line

  # `$line_pos` is the visual position of the cursor after its movement
  local -i 10 width line_pos
  local line=

  # find the `$line` that we'll be looking through - either the prev/next line
  if [[ $move == up ]] { line="${before##*$NL}" } \
  else                 { line="${after%%$NL*}"  }

  # walk the previous/next line until we reach the position that the cursor
  #  should be at, were it to move up/down a line
  for char in ${(s::)line}; {

    if [[ $char == $HT ]] { # if parsing a tab, align to the next tabstop
      (( width = TABSIZE - ( line_pos % TABSIZE ) ))
    } else { # otherwise just move the cursor forward one space
      (( width = 1 ))
    }

    # if we've gone past the end of the line, then place the cursor at the end
    (( line_pos +  width > cursor_pos  )) && break
    (( line_pos += width, char_count++ ))
  }

  # ————————————————————————————————————————————————————————————————————————— #

  # where the previous/next line starts + the number of chars before the cursor
  if [[ $move == up ]] { (( CURSOR  = $#before  - $#line  + char_count )) } \
  else                 { (( CURSOR += $#RBUFFER - $#after + char_count )) }

  # ————————————————————————————————————————————————————————————————————————— #

  __ZLE_CURSOR_VISPOS=$cursor_pos

  return 0
}

# ——————————————————————————————————————————————————————————————————————————— #
# ——————————————————————————————————————————————————————————————————————————— #

function zle-char-left  () { (( CURSOR--, __ZLE_CURSOR_VISPOS=-1 )); }
function zle-char-right () { (( CURSOR++, __ZLE_CURSOR_VISPOS=-1 )); }

# ——————————————————————————————————————————————————————————————————————————— #

autoload -Uz \
  {up,down}-line-or-beginning-search
zle -N   up-line-or-beginning-search
zle -N down-line-or-beginning-search

zle -N zle-line-up   ; bindkey '^[[A' zle-line-up     # ↑
zle -N zle-line-down ; bindkey '^[[B' zle-line-down   # ↓
zle -N zle-char-right; bindkey '^[[C' zle-char-right  # →
zle -N zle-char-left ; bindkey '^[[D' zle-char-left   # ←

# ——————————————————————————————————————————————————————————————————————————— #
# ——————————————————————————————————————————————————————————————————————————— #

function zle-first-non-blank () {
  local -r l_line="${LBUFFER##*$'\n'}"

  if [[ -n "$l_line" && "${l_line//[[:space:]]}" == '' ]] {
    zle beginning-of-line
  } else {
    zle vi-first-non-blank
  }
}

# ——————————————————————————————————————————————————————————————————————————— #

zle -N       zle-first-non-blank

bindkey '^A' zle-first-non-blank  # ⌘ →
bindkey '^E' vi-end-of-line       # ⌘ ←

# ——————————————————————————————————————————————————————————————————————————— #
