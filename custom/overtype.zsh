#!/usr/bin/env zsh

autoload -Uz add-zsh-hook
add-zsh-hook precmd _zle_precmd_reset_overwrite

typeset -gi 2 __ZLE_IN_OVERWRITE_MODE=0

# overwrite mode is always turned off between prompts,
#  but the cursor isn't automatically reset, so if the prompt
# was in overwrite mode at the last prompt, then reset the cursor manually
function _zle_precmd_reset_overwrite () {
  if (( __ZLE_IN_OVERWRITE_MODE )) echo -n $'\e[5 q'
  __ZLE_IN_OVERWRITE_MODE=0
}

# ——————————————————————————————————————————————————————————————————————————— #

function toggle-overwrite () {
  zle overwrite-mode  # toggles overwrite mode

  # set cursor style & overwrite mode state
  if [[ "$ZLE_STATE" == *overwrite* ]] {
    echo -n $'\e[3 q'
    typeset -gi 2 __ZLE_IN_OVERWRITE_MODE=1
  } else {
    echo -n $'\e[5 q'
    typeset -gi 2 __ZLE_IN_OVERWRITE_MODE=0
  }
}

# ——————————————————————————————————————————————————————————————————————————— #

keybind '^X^O' toggle-overwrite  ⌥ O
