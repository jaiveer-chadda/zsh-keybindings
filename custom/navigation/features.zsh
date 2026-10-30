#!/usr/bin/env zsh

# ——————————————————————————————————————————————————————————————————————————— #

# Make the `⌘ ←` command behave more like it does in VS Code.
function zle-start-of-line () {
  local -r l_line="${LBUFFER##*$'\n'}" # the line to the left of the cursor

  # if the line has some characters before it, but not exclusively spaces
  if [[ -n "$l_line" && "${l_line//[[:space:]]}" == '' ]] {
    # then go to the very beginning of the line
    zle beginning-of-line
  } else {
    # otherwise, go to the first non-space character in the line
    zle vi-first-non-blank
  }

  __ZLE_CURSOR_VISPOS=-1
}

# ——————————————————————————————————————————————————— #

function zle-end-of-line () {
  # `vi-end-of-line` ensures that pressing `⌘ →` at the end of a line won't
  #  make the cursor go to the next line
  zle vi-end-of-line
  __ZLE_CURSOR_VISPOS=-1
}

# ——————————————————————————————————————————————————————————————————————————— #

zle -N zle-start-of-line ; bindkey '^A' zle-start-of-line  # ⌘ ←
zle -N zle-end-of-line   ; bindkey '^E' zle-end-of-line    # ⌘ →

# ——————————————————————————————————————————————————————————————————————————— #

function zle-backward-word () { zle backward-word; __ZLE_CURSOR_VISPOS=-1; }
function zle-forward-word  () { zle  forward-word; __ZLE_CURSOR_VISPOS=-1; }

zle -N zle-backward-word ; bindkey '^[b' zle-backward-word # ⌥ ←
zle -N zle-forward-word  ; bindkey '^[f' zle-forward-word  # ⌥ →

# ——————————————————————————————————————————————————————————————————————————— #
# ——————————————————————————————————————————————————————————————————————————— #

bindkey '^[[5~' history-beginning-search-backward  # ⇞
bindkey '^[[6~' history-beginning-search-forward   # ⇟

# ——————————————————————————————————————————————————————————————————————————— #
