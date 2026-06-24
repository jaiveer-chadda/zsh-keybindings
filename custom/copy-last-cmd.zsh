#!/usr/bin/env zsh

zmodload -i zsh/parameter

# ——————————————————————————————————————————————————————————————————————————— #

function copy-last-cmd () {
  local cmd_to_copy="$BUFFER"

  if ! (( ${#BUFFER//[[:space:]]} )) {
    cmd_to_copy="$history[$(( HISTCMD - 1 ))]"
  }
  cmd_to_copy="${cmd_to_copy%[[:space:]]}"

  echo -nE "$cmd_to_copy" | pbcopy \
    || return $?

  local -ri 10 max_len=$(( COLUMNS - ${#:-"copied: ''"} ))
  local -r cmd="${(V)cmd_to_copy}"

  if (( $#cmd <= max_len )) {
    zle -M "copied: '$cmd'";
  } else {
    zle -M "copied: '${(r:max_len-3:)cmd}..."
  }
}

# ——————————————————————————————————————————————————————————————————————————— #

function copy-current-line () {
  local -r to_copy=' | pbcopy'
  local prefix='{ ' suffix='; }'

  if ! (( ${#BUFFER//[[:space:]]} )) BUFFER="$history[$(( HISTCMD - 1 ))]"

  BUFFER="${BUFFER%[[:space:]]}"

  if [[ "$BUFFER" == *"$to_copy" ]] {
    BUFFER="${BUFFER%$to_copy}"
    return 0
  }

  local orig_buf="$BUFFER"

  if [[ "$KEYS" == $'\eC'* ]] {
    BUFFER="$BUFFER$to_copy"
    (( CURSOR >= $#orig_buf ? ( CURSOR += $#to_copy ) : 0 ))

    return 0
  }

  if [[ "$BUFFER" == *$'\n'* ]] prefix=$'\n{' suffix=$'\n}'

  BUFFER="${BUFFER#[$'\t ']}"
  orig_buf="$BUFFER"

  BUFFER="$prefix$BUFFER$suffix$to_copy"
  (( CURSOR += (CURSOR >= $#orig_buf ? $#suffix + $#to_copy : 0) + $#prefix ))

  return 0
}

# ——————————————————————————————————————————————————————————————————————————— #

bindkey '^[c'   copy-last-cmd   ; zle -N copy-last-cmd
bindkey '^[C'   copy-current-line ; zle -N copy-current-line
bindkey '^[^[C' copy-current-line

# ——————————————————————————————————————————————————————————————————————————— #

# spell:ignoreRegexp /\\([␛e]|0?33)\[[0-9;]*m\B/g
