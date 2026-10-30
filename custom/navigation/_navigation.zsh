#!/usr/bin/env zsh

# The cursor's visual position on the line. Set to -1 when undefined.
export -i 10 __ZLE_CURSOR_VISPOS=-1

# ——————————————————————————————————————————————————————————————————————————— #

# make sure the visual position isn't remembered between commands
autoload -Uz add-zsh-hook
add-zsh-hook precmd _reset_zle_vispos
function _reset_zle_vispos () { __ZLE_CURSOR_VISPOS=-1 }

# ——————————————————————————————————————————————————————————————————————————— #