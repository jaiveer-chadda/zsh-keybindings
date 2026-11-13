#!/usr/bin/env zsh

# —— Helper Functions ——————————————————————————————————————————————————————— #

function _mk_region_func() {
  local -r type="$1" scope="$2" LFunc="$3" RFunc="$4" bind="$5"
  # if `$7` is unset, substitute `${6}D` / `${6}C` for the left / right keys
  # if `$7` is set,   substitute  `$6`   /  `$7`   for the left / right keys
  local -r LKey="$6${${7:-D}/#%$7}" RKey="${7:-${6}C}"

  local setup='export __ZLE_CURSOR_VISPOS=-1; '
  if [[ "$type" == cancel ]] { setup+='REGION_ACTIVE=0'
  } else { setup+='if ! (( REGION_ACTIVE )) { zle set-mark-command; }'; }

  eval "function -- '$type-$scope-left'  () { $setup; zle '$LFunc-$scope'; }"
  eval "function -- '$type-$scope-right' () { $setup; zle '$RFunc-$scope'; }"

  keybind "^[$LKey" "$type-$scope-left"   "$bind ←"
  keybind "^[$RKey" "$type-$scope-right"  "$bind →"
}

# —— Select & Cancel Region ————————————————————————————————————————————————— #

_mk_region_func select  char  backward     forward  '  ⇧'    '[1;2'
_mk_region_func select  word  backward     forward  '⌥ ⇧'    '[1;10'
_mk_region_func select  line  beginning-of end-of   '⌘ ⇧'    '[jC;S'

_mk_region_func cancel  char  backward     forward  '⎋ +  '  '^[['
_mk_region_func cancel  word  backward     forward  '⎋ + ⌥'  '^[b' '^[f'
_mk_region_func cancel  line  beginning-of end-of   '⎋ + ⌘'  '^A'  '^E'

# ——————————————————————————————————————————————————————————————————————————— #
