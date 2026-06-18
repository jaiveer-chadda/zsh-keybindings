#!/usr/bin/env zsh

# `^[[1;2A` : ⇧ ↑     `^[[1;4A` : ⌥ ⇧ ↑
# `^[[1;2B` : ⇧ ↓     `^[[1;4B` : ⌥ ⇧ ↓
# `^[[1;2C` : ⇧ →     `^[[1;4C` : ⌥ ⇧ →
# `^[[1;2D` : ⇧ ←     `^[[1;4D` : ⌥ ⇧ ←

# ——————————————————————————————————————————————————————————————————————————— #

function _set_mark() { if (( !REGION_ACTIVE )) { zle set-mark-command; }; }

# ——————————————————————————————————————————————————————————————————————————— #

function select-left-char  () { _set_mark; zle backward-char ; }
function select-right-char () { _set_mark; zle forward-char  ; }
function select-left-word  () { _set_mark; zle backward-word ; }
function select-right-word () { _set_mark; zle forward-word  ; }

zle -N select-left-char; zle -N select-right-char
zle -N select-left-word; zle -N select-right-word

bindkey '^[[1;2D' select-left-char; bindkey '^[[1;2C' select-right-char
bindkey '^[[1;4D' select-left-word; bindkey '^[[1;4C' select-right-word

# ——————————————————————————————————————————————————————————————————————————— #

function delete-region-or-char () {
  if (( REGION_ACTIVE )) {
    zle kill-region
    REGION_ACTIVE=0

  } else {
    zle backward-delete-char
  }
}

zle -N delete-region-or-char
bindkey '^?' delete-region-or-char
