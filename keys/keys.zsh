#!/usr/bin/env zsh

# —— Meta ——————————————————————————————————————————————————————————————————— #

bindkey -R '!-~'  self-insert
bindkey    ' '    magic-space

# —— Up/Down Navigation ————————————————————————————————————————————————————— #

# note: these functions are secondary - the main funcs are in `navigation.zsh`

bindkey '^[OA'      up-line-or-history               # ⎋ O ↑
bindkey '^[OB'    down-line-or-history               # ⎋ O ↓

bindkey '^[[5~'   history-beginning-search-backward  # ⇞
bindkey '^[[6~'   history-beginning-search-forward   # ⇟

# —— Left/Right Navigation —————————————————————————————————————————————————— #

bindkey '^[[1;5C'  forward-word
bindkey '^[[1;5D' backward-word

# —— Editing ———————————————————————————————————————————————————————————————— #

bindkey '^X^O'    overwrite-mode    # mapped to `⌥ o`
bindkey '^@'      set-mark-command  # mapped to `⌃ ⇥`
bindkey '^[m'     copy-prev-shell-word

# —— Deleting ——————————————————————————————————————————————————————————————— #

bindkey '^[[3;5~' kill-word

bindkey '^[w'     kill-region
bindkey '^[^?'    kill-region

bindkey '^U'      backward-kill-line  # mapped to `⌘   ⌫`
bindkey '^[^U'    kill-whole-line     # mapped to `⌘ ⌥ ⌫`

# —— Undo/Redo —————————————————————————————————————————————————————————————— #

bindkey '^_'      undo  # mapped to `⌘   Z`
bindkey '^[[^_'   redo  # mapped to `⌘ ⇧ Z`

# —— Completion ————————————————————————————————————————————————————————————— #

bindkey '^[[Z'    reverse-menu-complete

# —— Macros ————————————————————————————————————————————————————————————————— #

zle -N r
bindkey -s '^[r'  '^Qr^J'

zle -N lsjv
bindkey -s '^[l'  '^Qcl^J'

zle -N keys
bindkey -s '^[k'  '^Qkeys | less^J'

zle -N clr_ln
bindkey -s '^[e'  '^Qe^J'

# —— Other —————————————————————————————————————————————————————————————————— #

bindkey '^X^A'    _expand_alias
bindkey '^X^X'    _expand_alias

# ——————————————————————————————————————————————————————————————————————————— #

() { local f; for f in "${${(%):-%x}:a:h:h}/custom/"**/*.zsh; source "$f"; }

# ——————————————————————————————————————————————————————————————————————————— #

# spell:ignoreRegExp /[^][A-Z]\w+/g
