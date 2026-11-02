#!/usr/bin/env zsh

function toggle-overwrite () {
  zle overwrite-mode  # toggles overwrite
  if [[ "$ZLE_STATE" == *overwrite* ]] \
    { echo -n $'\e[3 q'; } else \
    { echo -n $'\e[5 q'; }
}

keybind '^X^O' toggle-overwrite  ⌥ O
