#!/usr/bin/env zsh

bindkey -R '!'-'~'  self-insert

bindkey '^[[A'        up-line-or-search     # ↑
bindkey '^[[B'      down-line-or-search     # ↓
bindkey '^[OA'        up-line-or-search     # ⎋ ↑
bindkey '^[OB'      down-line-or-search     # ⎋ ↓

bindkey '^[[5~'       up-line-or-history    # ⇞
bindkey '^[[6~'     down-line-or-history    # ⇟

bindkey '^[[1;5C'    forward-word
bindkey '^[[1;5D'   backward-word

bindkey '^[[3;5~'   kill-word
bindkey '^[[Z'      reverse-menu-complete
bindkey '^[m'       copy-prev-shell-word

bindkey '^[w'       kill-region
bindkey ' '         magic-space

bindkey -s "^[l"    "^Q ls^J"
