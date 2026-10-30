#!/usr/bin/env zsh

# —— Meta ——————————————————————————————————————————————————————————————————— #

bindkey -R '!-~'  self-insert
bindkey    ' '    magic-space

# —— Editing ———————————————————————————————————————————————————————————————— #

bindkey '^@'      set-mark-command  # mapped to `⌃ ⇥`
bindkey '^X^O'    overwrite-mode    # mapped to `⌥ o`

bindkey '^X^A'    _expand_alias
bindkey '^X^X'    _expand_alias

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

zle -N r      ; bindkey -s '^[r' '^Qr^J'
zle -N lsjv   ; bindkey -s '^[l' '^Qcl^J'
zle -N keys   ; bindkey -s '^[k' '^Qkeys | less^J'
zle -N clr_ln ; bindkey -s '^[e' '^Qe^J'

# —— Source Custom Files ———————————————————————————————————————————————————— #

() { local f; for f in "${${(%):-%x}:a:h:h}/custom/"**/*.zsh; source "$f"; }

# ——————————————————————————————————————————————————————————————————————————— #

# spell:ignoreRegExp /[^][A-Z]\w+/g
