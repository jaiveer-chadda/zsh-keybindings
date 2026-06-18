#!/usr/bin/env zsh

# `^[[A` : ↑     `^[[1;2A` : ⇧ ↑     `^[[1;4A` : ⌥ ⇧ ↑
# `^[[B` : ↓     `^[[1;2B` : ⇧ ↓     `^[[1;4B` : ⌥ ⇧ ↓
# `^[[C` : →     `^[[1;2C` : ⇧ →     `^[[1;4C` : ⌥ ⇧ →
# `^[[D` : ←     `^[[1;2D` : ⇧ ←     `^[[1;4D` : ⌥ ⇧ ←

# —— Helper Functions ——————————————————————————————————————————————————————— #

function _set_mark() { if (( !REGION_ACTIVE )) { zle set-mark-command; }; }

# —— Select Left/Right —————————————————————————————————————————————————————— #

function select-left-char  () { _set_mark; zle backward-char ; }
function select-right-char () { _set_mark; zle forward-char  ; }
function select-left-word  () { _set_mark; zle backward-word ; }
function select-right-word () { _set_mark; zle forward-word  ; }

zle -N select-left-char; zle -N select-right-char
zle -N select-left-word; zle -N select-right-word

bindkey '^[[1;2D' select-left-char   #   ⇧ <-
bindkey '^[[1;2C' select-right-char  #   ⇧ ->

bindkey '^[[1;4D' select-left-word   # ⌥ ⇧ <-
bindkey '^[[1;4C' select-right-word  # ⌥ ⇧ ->

# —— Cancel Region —————————————————————————————————————————————————————————— #

function cancel-region-left  () { REGION_ACTIVE=0; zle backward-char; }
function cancel-region-right () { REGION_ACTIVE=0; zle forward-char ; }

zle -N  cancel-region-left; zle -N cancel-region-right

bindkey '^[^[[D' cancel-region-left   # ⎋ <-
bindkey '^[^[[C' cancel-region-right  # ⎋ ->

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

  if (( REGION_ACTIVE )) {
    local -i 10 left right

    if (( CURSOR < MARK )) { left=$CURSOR right=$MARK; } \
    else                   { left=$MARK right=$CURSOR; }

    BUFFER="$BUFFER[1,left]$quote$BUFFER[left+1,right]$quote$BUFFER[right+1,-1]"
    CURSOR=$right+1

    REGION_ACTIVE=0

  } else {
    zle self-insert "$quote"
  }
}

zle -N     quote-region-or-insert
bindkey \' quote-region-or-insert  # '
bindkey \" quote-region-or-insert  # "

# ——————————————————————————————————————————————————————————————————————————— #
