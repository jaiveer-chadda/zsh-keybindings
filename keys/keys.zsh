#!/usr/bin/env zsh

# —— Meta ——————————————————————————————————————————————————————————————————— #

bindkey -R '!'-'~'  self-insert
bindkey ' '         magic-space

# —— Up/Down Navigation ————————————————————————————————————————————————————— #

bindkey '^[[A'        up-line-or-search     # ↑
bindkey '^[[B'      down-line-or-search     # ↓
bindkey '^[OA'        up-line-or-history    # ⎋ ↑
bindkey '^[OB'      down-line-or-history    # ⎋ ↓

bindkey '^[[5~'     history-beginning-search-backward  # ⇞
bindkey '^[[6~'     history-beginning-search-forward   # ⇟

# —— Left/Right Navigation —————————————————————————————————————————————————— #

bindkey '^[[1;5C'    forward-word
bindkey '^[[1;5D'   backward-word

# —— Editing ———————————————————————————————————————————————————————————————— #

bindkey '^X^O'      overwrite-mode    # mapped to `⌥ o`
bindkey '^@'        set-mark-command  # mapped to `⌃ ⇥`
bindkey '^[m'       copy-prev-shell-word

# —— Deleting ——————————————————————————————————————————————————————————————— #

bindkey '^[[3;5~'   kill-word
bindkey '^[w'       kill-region
bindkey '^[^?'      kill-region
bindkey '^U'        kill-whole-line     # mapped to `⌘ ⌥ ⌫`
bindkey '^[^U'      backward-kill-line  # mapped to `⌘   ⌫`

# —— Undo/Redo —————————————————————————————————————————————————————————————— #

bindkey '^_'        undo  # mapped to `⌘   Z`
bindkey '^[^[^?'    redo  # mapped to `⌘ ⇧ Z`

# —— Completion ————————————————————————————————————————————————————————————— #

bindkey '^[[Z'      reverse-menu-complete

# —— Macros ————————————————————————————————————————————————————————————————— #

zle -N lsjv
bindkey -s '^[l'    '^Qcl^J'

# —— Other —————————————————————————————————————————————————————————————————— #

# ——————————————————————————————————————————————————————————————————————————— #
