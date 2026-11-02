#!/usr/bin/env zsh

source "${${(%):-%x}:a:h}/keybind.zsh"

# —— Meta ——————————————————————————————————————————————————————————————————— #

keybind -R '!-~'      self-insert
keybind    ' '        magic-space

# —— Editing ———————————————————————————————————————————————————————————————— #

keybind    '^@'       set-mark-command         ⌃ ⇥
keybind    '^X^O'     overwrite-mode           ⌥ o

keybind    '^X^A'     _expand_alias
keybind    '^X^X'     _expand_alias

keybind    '^[m'      copy-prev-shell-word

# —— Deleting ——————————————————————————————————————————————————————————————— #

keybind    '^[[3;5~'  kill-word

keybind    '^[w'      kill-region
keybind    '^[^?'     kill-region

keybind      '^U'     backward-kill-line       ⌘   ⌫
keybind    '^[^U'     kill-whole-line          ⌘ ⌥ ⌫

# —— Undo/Redo —————————————————————————————————————————————————————————————— #

keybind       '^_'    undo                     ⌘   Z
keybind    '^[[^_'    redo                     ⌘ ⇧ Z

# —— Tab / Completion ——————————————————————————————————————————————————————— #

keybind      '^I'     complete-word              ⇥
keybind    '^[^I'     self-insert-unmeta       ⇧ ⇥
keybind    '^[[Z'     reverse-menu-complete    ⌃ ⇥

# —— Macros ————————————————————————————————————————————————————————————————— #

keybind -s '^[r'      r
keybind -s '^[l'      cl
keybind -s '^[k'     'keys | less'
keybind -s '^[e'      e

# —— Source Custom Files ———————————————————————————————————————————————————— #

() { local f; for f in "${${(%):-%x}:a:h:h}/custom/"**/*.zsh; source "$f"; }

# ——————————————————————————————————————————————————————————————————————————— #
