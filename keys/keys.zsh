#!/usr/bin/env zsh

# —— Meta ——————————————————————————————————————————————————————————————————— #

bindkey -R '!'-'~'  self-insert
bindkey ' '         magic-space

# —— Up/Down Navigation ————————————————————————————————————————————————————— #

bindkey '^[[A'        up-line-or-search     # ↑
bindkey '^[[B'      down-line-or-search     # ↓
bindkey '^[OA'        up-line-or-search     # ⎋ ↑
bindkey '^[OB'      down-line-or-search     # ⎋ ↓

bindkey '^[[5~'       up-line-or-history    # ⇞
bindkey '^[[6~'     down-line-or-history    # ⇟

# —— Left/Right Navigation —————————————————————————————————————————————————— #

bindkey '^[[1;5C'    forward-word
bindkey '^[[1;5D'   backward-word

# —— Deleting ——————————————————————————————————————————————————————————————— #

bindkey '^[[3;5~'   kill-word
bindkey '^[w'       kill-region

# —— Completion ————————————————————————————————————————————————————————————— #

bindkey '^[[Z'      reverse-menu-complete

# —— Editing ———————————————————————————————————————————————————————————————— #

bindkey '^[m'       copy-prev-shell-word

# —— Macros ————————————————————————————————————————————————————————————————— #

bindkey -s '^[l'    '^Q ls^J'

# —— Other —————————————————————————————————————————————————————————————————— #

# ——————————————————————————————————————————————————————————————————————————— #
