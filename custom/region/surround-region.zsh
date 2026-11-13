#!/usr/bin/env zsh

# —— Surround Region ———————————————————————————————————————————————————————— #

# note: this function applies to the following chars:  "'`()[]{}<>  ”’$£
# note: for the function to work correctly, the last key of the key sequence
#        used to call the function has to be the surrounding char

function surround-region-or-insert () {
  if ! (( REGION_ACTIVE )) {
    zle self-insert "$KEYS[-1]"
    return
  }

  local lchr="$KEYS[-1]" rchr
  case "$lchr" {
    ( '('  ) rchr=')' ;; ( ')' ) lchr='(' rchr=')' ;;
    ( '['  ) rchr=']' ;; ( ']' ) lchr='[' rchr=']' ;;
    ( '{'  ) rchr='}' ;; ( '}' ) lchr='{' rchr='}' ;;
    ( '<'  ) rchr='>' ;; ( '>' ) lchr='<' rchr='>' ;;

    # surrounding sequences that are more than one char
    ( [”’] ) lchr='{ '  rchr=' }' ;; # note `”` and `’` are `⌥⇧ {` and `⌥⇧ }`
    ( '£'  ) lchr='$( ' rchr=' )' ;;
    ( '$'  ) lchr='${'  rchr='}'  ;;

    (  *   ) rchr="$lchr" ;; # applies to:  "'`
  }

  local -i 10 left right
  (( CURSOR < MARK ? ( left=CURSOR,right=MARK ) : ( left=MARK,right=CURSOR ) ))

  BUFFER="$BUFFER[1,left]$lchr$BUFFER[left+1,right]$rchr$BUFFER[right+1,-1]"

  (( MARK = left + $#lchr, CURSOR = right + $#lchr ))
}

zle -N surround-region-or-insert

# ——————————————————————————————————————————————————————————————————————————— ## ———————————————————————————— #

function -- () {
  local char; local -r surrounding_chars="\"\`'()[]{}<>£\$”’"
  for char in "${(@s::)surrounding_chars}"; {
    keybind -- "$char" surround-region-or-insert "$char"
  }
}

# ——————————————————————————————————————————————————————————————————————————— #
