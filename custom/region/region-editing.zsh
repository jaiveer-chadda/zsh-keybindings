#!/usr/bin/env zsh

# —— Copy Region ———————————————————————————————————————————————————————————— #

function copy-region () {
  if ! (( REGION_ACTIVE )) return

  local -i 10 left right
  (( CURSOR < MARK ? ( left=CURSOR,right=MARK ) : ( left=MARK,right=CURSOR ) ))

  echo -nE "$BUFFER[left+1,right]" | pbcopy
  REGION_ACTIVE=0
}

keybind '^[[(SA+c)' copy-region  ⌘ ⌥ C

# —— Cut Region ————————————————————————————————————————————————————————————— #

function cut-region () {
  if ! (( REGION_ACTIVE )) return

  local -i 10 left right
  (( CURSOR < MARK ? ( left=CURSOR,right=MARK ) : ( left=MARK,right=CURSOR ) ))

  echo -nE "$BUFFER[left+1,right]" | pbcopy
  zle kill-region
  REGION_ACTIVE=0
}

keybind '^[[(S+x)' cut-region  ⌘ X

# —— Delete Region —————————————————————————————————————————————————————————— #

function delete-region-or-char () {
  if (( REGION_ACTIVE )) {
    zle kill-region
    REGION_ACTIVE=0

  } else {
    zle backward-delete-char
  }
}

keybind '^?' delete-region-or-char  ⌫

# ——————————————————————————————————————————————————————————————————————————— #
