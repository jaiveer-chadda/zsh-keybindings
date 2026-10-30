#!/usr/bin/env zsh

# ——————————————————————————————————————————————————————————————————————————— #

# Make the `⌘ ←` command behave more like it does in VS Code.
function zle-first-non-blank () {
  local -r l_line="${LBUFFER##*$'\n'}" # the line to the left of the cursor

  # if the line has some characters before it, but not exclusively spaces
  if [[ -n "$l_line" && "${l_line//[[:space:]]}" == '' ]] {
    # then go to the very beginning of the line
    zle beginning-of-line
  } else {
    # otherwise, go to the first non-space character in the line
    zle vi-first-non-blank
  }
}

# ——————————————————————————————————————————————————————————————————————————— #

zle -N       zle-first-non-blank

bindkey '^A' zle-first-non-blank  # ⌘ ←
bindkey '^E' vi-end-of-line       # ⌘ →
# `vi-end-of-line` ensures that pressing `⌘ →` at the end of a line won't make
#  you go to the next line

# ——————————————————————————————————————————————————————————————————————————— #

bindkey '^[[5~' history-beginning-search-backward  # ⇞
bindkey '^[[6~' history-beginning-search-forward   # ⇟

# ——————————————————————————————————————————————————————————————————————————— #
