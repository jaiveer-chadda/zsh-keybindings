#!/usr/bin/env zsh

# ——————————————————————————————————————————————————————————————————————————— #
# —— zle-start-of-line () ——————————————————————————————————————————————————— #

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

# —— zle-end-of-line () ————————————————————————————— #

function zle-end-of-line () {
  # `vi-end-of-line` ensures that pressing `⌘ →` at the end of a line won't
  #  make the cursor go to the next line
  zle vi-end-of-line
  __ZLE_CURSOR_VISPOS=-1
}

# —— zle-(back|for)ward-word () ————————————————————————————————————————————— #

function zle-backward-word () { zle backward-word; __ZLE_CURSOR_VISPOS=-1; }
function zle-forward-word  () { zle  forward-word; __ZLE_CURSOR_VISPOS=-1; }

# ——————————————————————————————————————————————————————————————————————————— #
# ——————————————————————————————————————————————————————————————————————————— #

# —— ⌘ ←/→ —————————————————————————————————————————————————————————————————— #

keybind '^A'    zle-start-of-line                  ⌘ ←
keybind '^E'    zle-end-of-line                    ⌘ →

# —— ⌥ ←/→ —————————————————————————————————————————————————————————————————— #

keybind '^[b'   zle-backward-word                  ⌥ ←
keybind '^[f'   zle-forward-word                   ⌥ →

# —— ⇞/⇟ ( ◍↑/◍↓ )——————————————————————————————————————————————————————————— #

keybind '^[[5~' history-beginning-search-backward  ⇞
keybind '^[[6~' history-beginning-search-forward   ⇟

# ——————————————————————————————————————————————————————————————————————————— #
