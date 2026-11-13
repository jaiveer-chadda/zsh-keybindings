#!/usr/bin/env zsh

# The cursor's visual position on the line. Set to -1 when undefined.
export -i 10 __ZLE_CURSOR_VISPOS=-1

# ——————————————————————————————————————————————————————————————————————————— #

# make sure the visual position isn't remembered between commands
autoload -Uz add-zsh-hook
add-zsh-hook precmd _zle_precmd_reset_vispos
function _zle_precmd_reset_vispos () { export __ZLE_CURSOR_VISPOS=-1 }

# ——————————————————————————————————————————————————————————————————————————— #
