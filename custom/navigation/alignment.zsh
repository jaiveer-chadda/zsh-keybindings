#!/usr/bin/env zsh

# ——————————————————————————————————————————————————————————————————————————— #

function zle-line-up zle-line-down () {

  local -r NL=$'\n' HT=$'\t'
  local -ri 10 TABSIZE=8

  # get the last word of the function name
  local -r move="${${(%):-%N}##*-}"

  local -i 2 move_up=0 move_down=1
  if [[ $move == 'up' ]] { move_up=1 move_down=0 }

  # ————————————————————————————————————————————————————————————————————————— #

  local -i 2 on_first_line=0; if [[ $LBUFFER != *$NL* ]] on_first_line=1
  local -i 2 on_final_line=0; if [[ $RBUFFER != *$NL* ]] on_final_line=1

  # if moving up and on the first line, or moving down and on the last line
  #  perform the default behaviour for the 'up' or 'down' arrows, respectively
  if (( move_up ? on_first_line : on_final_line )) {
    zle $move-line-or-beginning-search
    __ZLE_CURSOR_VISPOS=-1
    return
  }

  # ————————————————————————————————————————————————————————————————————————— #

  local -r cur_line="${LBUFFER##*$NL}"  # current line, up to the cursor

  # ————————————————————————————————————————————————————————————————————————— #

  local char
  local -i 10 cursor_pos

  # if the visual position is undefined (usually after there's been a
  #  left/right movement), then recalculate the cursor's visual position
  if (( __ZLE_CURSOR_VISPOS == -1 )) {
    # if we're on the first line,
    #  factor the prompt's length into the cursor's visual position
    if (( on_first_line )) {
      # `//$'\e['*m` removes the CSI/ANSI graphical escapes
      # `//$'\e]'*$'\a'` removes the OSC escapes added by `iterm2_precmd`
      cursor_pos="${(S)#${(S)${(%)PS1}//$'\e['*m}//$'\e]'*$'\a'}"
    }
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
    __ZLE_CURSOR_VISPOS=$cursor_pos
  } else {
    cursor_pos=$__ZLE_CURSOR_VISPOS
  }

  # ————————————————————————————————————————————————————————————————————————— #

  local -r before="${LBUFFER%$NL*}"  # everything before the current line
  local -r  after="${RBUFFER#*$NL}"  # everything after the current line

  # `$line_pos` is the visual position of the cursor after its movement
  local -i 10 width line_pos char_count
  local line=

  # find the `$line` that we'll be looking through
  if (( move_down )) {
    line="${after%%$NL*}"   # look through the next line
  } else {
    line="${before##*$NL}"  # look through the previous line

    if [[ $before != *$NL* ]] { # if we're moving upwards onto the first line
      # factor the prompt's width into finding the target visual position
      line_pos="${(S)#${(S)${(%)PS1}//$'\e['*m}//$'\e]'*$'\a'}"
    }
  }

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
  if (( move_up )) { (( CURSOR  = $#before  - $#line  + char_count )) } \
  else             { (( CURSOR += $#RBUFFER - $#after + char_count )) }

  # ————————————————————————————————————————————————————————————————————————— #

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
