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

function quote-region-or-insert () {
  local -r quote="$KEYS[-1]"
  if ! (( REGION_ACTIVE )) { zle self-insert "$quote"; return; }

  local -i 10 left right

  if (( CURSOR < MARK )) { left=$CURSOR right=$MARK; } \
  else                   { left=$MARK right=$CURSOR; }

  BUFFER="$BUFFER[1,left]$quote$BUFFER[left+1,right]$quote$BUFFER[right+1,-1]"
  CURSOR=$right+1

  REGION_ACTIVE=0
}

zle -N     quote-region-or-insert
bindkey \' quote-region-or-insert  # '
bindkey \" quote-region-or-insert  # "

# ——————————————————————————————————————————————————————————————————————————— #
