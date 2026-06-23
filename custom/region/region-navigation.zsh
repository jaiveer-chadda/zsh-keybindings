#!/usr/bin/env zsh

# —— Helper Functions ——————————————————————————————————————————————————————— #

function _mk_region_func() {
  local -r type="$1" scope="$2" LFunc="$3" RFunc="$4"
  # if `$6` is unset, substitute `${5}D` / `${5}C` for the left / right keys
  # if `$6` is set,   substitute  `$5`   /  `$6`   for the left / right keys
  local -r LKey="$5${${6:-D}/#%$6}" RKey="${6:-${5}C}"

  local setup=
  [[ "$type" == cancel ]] && setup='REGION_ACTIVE=0' \
    || setup='if ! (( REGION_ACTIVE )) { zle set-mark-command; }'

  eval "function -- '$type-$scope-left'  () { $setup; zle '$LFunc-$scope'; }"
  eval "function -- '$type-$scope-right' () { $setup; zle '$RFunc-$scope'; }"

  zle -N "$type-$scope-left" ; bindkey "^[$LKey" "$type-$scope-left"
  zle -N "$type-$scope-right"; bindkey "^[$RKey" "$type-$scope-right"
}

# —— Select & Cancel Region ————————————————————————————————————————————————— #

_mk_region_func select  char  backward      forward  '[1;2'      #    ⇧ ←/→
_mk_region_func select  word  backward      forward  '[1;4'      #  ⌥ ⇧ ←/→
_mk_region_func select  line  beginning-of  end-of   '[jC;S'     #  ⌘ ⇧ ←/→

_mk_region_func cancel  char  backward      forward  '^[['       # ⎋,   ←/→
_mk_region_func cancel  word  backward      forward  '^[b' '^[f' # ⎋, ⌥ ←/→
_mk_region_func cancel  line  beginning-of  end-of   '^A'  '^E'  # ⎋, ⌘ ←/→

# ——————————————————————————————————————————————————————————————————————————— #
