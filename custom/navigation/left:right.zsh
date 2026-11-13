#!/usr/bin/env zsh

# —— zle-char-(left|right) () ——————————————————————————————————————————————— #

function zle-char-left  () { (( CURSOR-- )); export __ZLE_CURSOR_VISPOS=-1; }
function zle-char-right () { (( CURSOR++ )); export __ZLE_CURSOR_VISPOS=-1; }

# —— zle-(back|for)ward-word () ————————————————————————————————————————————— #

function zle-backward-word { zle backward-word; export __ZLE_CURSOR_VISPOS=-1 }
function zle-forward-word  { zle  forward-word; export __ZLE_CURSOR_VISPOS=-1 }

# —— ←/→ ———————————————————————————————————————————————————————————————————— #

keybind '^[[C' zle-char-right  →
keybind '^[[D' zle-char-left   ←

# —— ⌥ ←/→ —————————————————————————————————————————————————————————————————— #

keybind '^[b' zle-backward-word  ⌥ ←
keybind '^[f' zle-forward-word   ⌥ →

# ——————————————————————————————————————————————————————————————————————————— #
# —— ⇞/⇟ ( ◍↑/◍↓ )——————————————————————————————————————————————————————————— #

keybind '^[[5~' history-beginning-search-backward  ⇞
keybind '^[[6~' history-beginning-search-forward   ⇟

# ——————————————————————————————————————————————————————————————————————————— #
