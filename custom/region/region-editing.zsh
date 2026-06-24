#!/usr/bin/env zsh

# —— Copy Region ———————————————————————————————————————————————————————————— #

function copy-region () {
  if ! (( REGION_ACTIVE )) return

  if (( CURSOR < MARK )) { left=$CURSOR right=$MARK; } \
  else                   { left=$MARK right=$CURSOR; }

  echo -nE "$BUFFER[left+1,right]" | pbcopy
  REGION_ACTIVE=0
}

zle -N          copy-region
bindkey '^[].c' copy-region  # ⌘ ⌥ C

# —— Cut Region ————————————————————————————————————————————————————————————— #

function cut-region () {
  if ! (( REGION_ACTIVE )) return

  if (( CURSOR < MARK )) { left=$CURSOR right=$MARK; } \
  else                   { left=$MARK right=$CURSOR; }

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

function surround-region-or-insert () {
  if ! (( REGION_ACTIVE )) { zle self-insert "$KEYS[-1]"; return; }

  local -r lChar="$KEYS[-1]"
  case "$lChar" { #
    ( '(' ) rChar=')'      ;;
    ( '[' ) rChar=']'      ;;
    ( '{' ) rChar='}'      ;;
    ( '<' ) rChar='>'      ;;
    (  *  ) rChar="$lChar" ;;
  }

  local -i 10 left right
  if (( CURSOR < MARK )) { left=$CURSOR right=$MARK; } \
  else                   { left=$MARK right=$CURSOR; }

  BUFFER="$BUFFER[1,left]$lChar$BUFFER[left+1,right]$rChar$BUFFER[right+1,-1]"
  CURSOR=$right+1
  REGION_ACTIVE=0
}

zle -N surround-region-or-insert

() {
  local char
  for char in "${(@s::):-"\"'()[]{}<>"}"; {
    bindkey -- "$char" surround-region-or-insert
  }
}

# ——————————————————————————————————————————————————————————————————————————— #
