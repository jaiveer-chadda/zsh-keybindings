#!/usr/bin/env zsh

# —— Copy Region ———————————————————————————————————————————————————————————— #

function copy-region () {
  if ! (( REGION_ACTIVE )) return

  local -i 10 left right
  (( CURSOR < MARK ? ( left=CURSOR,right=MARK ) : ( left=MARK,right=CURSOR ) ))

  echo -nE "$BUFFER[left+1,right]" | pbcopy
  REGION_ACTIVE=0
}

zle -N          copy-region
bindkey '^[].c' copy-region  # ⌘ ⌥ C

# —— Cut Region ————————————————————————————————————————————————————————————— #

function cut-region () {
  if ! (( REGION_ACTIVE )) return

  local -i 10 left right
  (( CURSOR < MARK ? ( left=CURSOR,right=MARK ) : ( left=MARK,right=CURSOR ) ))

  echo -nE "$BUFFER[left+1,right]" | pbcopy
  zle kill-region
  REGION_ACTIVE=0
}

zle -N          cut-region
bindkey '^[].x' cut-region  # ⌘ X

# —— Delete Region —————————————————————————————————————————————————————————— #

function delete-region-or-char () {
  if (( REGION_ACTIVE )) {
    zle kill-region
    REGION_ACTIVE=0

  } else {
    zle backward-delete-char
  }
}

zle -N       delete-region-or-char
bindkey '^?' delete-region-or-char  # ⌫

# —— Quote Region ——————————————————————————————————————————————————————————— #

# note: this function applies to the following chars:  "'()[]{}<>
# note: for the function to work correctly, the last key of the key sequence
#        used to call the function has to be the surrounding char

function surround-region-or-insert () {
  if ! (( REGION_ACTIVE )) {
    zle self-insert "$KEYS[-1]";
    return;
  }

  local lchr="$KEYS[-1]" rchr
  case "$lchr" { #
    ( '(' ) rchr=')' ;; ( ')' ) lchr='(' rchr=')' ;;
    ( '[' ) rchr=']' ;; ( ']' ) lchr='[' rchr=']' ;;
    ( '{' ) rchr='}' ;; ( '}' ) lchr='{' rchr='}' ;;
    ( '<' ) rchr='>' ;; ( '>' ) lchr='<' rchr='>' ;;

    (  *  ) rchr="$lchr" ;;
  }

  local -i 10 left right
  (( CURSOR < MARK ? ( left=CURSOR,right=MARK ) : ( left=MARK,right=CURSOR ) ))

  BUFFER="$BUFFER[1,left]$lchr$BUFFER[left+1,right]$rchr$BUFFER[right+1,-1]"
  CURSOR=$right+1

  REGION_ACTIVE=0
}

zle -N surround-region-or-insert

# ———————————————————————————— #

function -- () {
  local char
  for char in "${(@s::):-"\"'()[]{}<>"}"; {
    bindkey -- "$char" surround-region-or-insert
  }
}

# ——————————————————————————————————————————————————————————————————————————— #

# spell:ignoreRegexp /\b[rl]chr\b/g
