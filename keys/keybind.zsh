#!/usr/bin/env zsh

# ——————————————————————————————————————————————————————————————————————————— #

# this file shouldn't be executed directly - it should only be sourced
if [[ "$ZSH_EVAL_CONTEXT" == 'toplevel' ]] return 1

# ——————————————————————————————————————————————————————————————————————————— #

if (( 0 )) { # The `keybind` function's purpose is ...
  # ... to simplify these two lines (and the trailing comment)
  zle -N zle-start-of-line
  bindkey '^A' zle-start-of-line # ⌘ ←

  # into this one-liner:
  keybind '^A' zle-start-of-line '⌘ ←'

  # it also means that I won't end up forgetting to run `zle -N` every time
}

# ——————————————————————————————————————————————————————————————————————————— #
# ——————————————————————————————————————————————————————————————————————————— #

alias keybind='noglob keybind'

function keybind () {
  setopt local_options warn_create_global typeset_silent

  local mode=normal

  local opt OPTARG OPTIND
  while { getopts 'Rs' opt; } { #
    case "$opt" {
      ( R ) mode=ranged ;;
      ( s ) mode=string ;;
      ( * )
        echo -E - "${(%):-%N}: unrecognised option \`-$opt\` -" \
          'try using `bindkey` instead' >&2
        return 1
      ;;
    }
  }
  shift 'OPTIND - 1'

  # ensure `_ZSHZLE_KEYBINDINGS` is initialised as a global associative array
  typeset -gA _ZSHZLE_KEYBINDINGS &>/dev/null

  # ————————————————————————————————————————————— #

  # run the function associated with this mode
  "keybind::$mode" "$@"
  return $?

  # ————————————————————————————————————————————— #
}

# ——————————————————————————————————————————————————————————————————————————— #
# ——————————————————————————————————————————————————————————————————————————— #

if (( 0 )) { return -1
  # TODO: implement this in the normal and string modes

  # note that `¿` represents an arbitrary zsh binding

  #         function call         =>  value of $keybinds
  keybind '¿'         func '⌘ ←'  =>  '⌘ ←'   # normal, quoted binding
  keybind '¿'         func  ⌘ ←   =>  '⌘ ←'   # unquoted binding

  keybind '^A'        func        =>  '⌃ A'   # control character
  keybind 'a'         func        =>  'a'     # singe character
  keybind 'A'         func        =>  '⇧ A'   # capital letter (shifted letter)
  keybind '+'         func        =>  '⇧ ='   # shifted punctuation
  keybind 'ab'        func        =>  'a + b' # sequence
  keybind '^[a'       func        =>  '⎋ + a' # escape sequence
  keybind '\M-a'      func        =>  '◇ + a' # meta key
}

# ——————————————————————————————————————————————————————————————————————————— #

function keybind::normal () {
  local -r zsh_bind="${1:?must enter a binding sequence}"
  local -r function="${2:?must enter a function}"
  shift 2

  local -a keybinds=( "$*" )

  # ————————————————————————————————————————————— #

  # run `zle -N` iff:
  #  - `function` isn't a widget, or
  #  - `function` is a widget, but isn't a builtin or completion widget
  if [[ "$widgets[$function]" != (builtin|completion*) ]] {
    zle -N "$function" || return $?
  }

  bindkey "$zsh_bind" "$function" || return $?

  # ————————————————————————————————————————————— #

  local bind
  for bind in "${(@)keybinds:#}"; {
    # replace multiple spaces in a row with just a single space
    #  and remove all spaces from the beginning and the end
    bind="${${${(*)bind//[[:space:]]##/ }# }% }"
    _ZSHZLE_KEYBINDINGS[$bind]="$function"
  }
}

# ——————————————————————————————————————————————————————————————————————————— #
# ——————————————————————————————————————————————————————————————————————————— #

function keybind::ranged () {
  local -r    range="${1:?must enter a range}"
  local -r function="${2:?must enter a function}"

  # ————————————————————————————————————————————— #

  local -i 2 is_error=0

  local -r l_char="$range[1]"
  local r_char

  # note - this won't properly parse ranges like `^A-^C` or `\M-a-\M-c`, but
  #  I think that's fine for now - they're so rare that it doesn't rly matter
  case $#range {
    ( 2 ) r_char="$range[2]" ;;
    ( 3 ) {
      r_char="$range[3]"
      if [[ "$range[2]" != '-' ]] is_error=1
    } ;;
    ( * ) is_error=1 ;;
  }

  # make sure the range was specified in ascending order
  if (( ##$l_char > ##$r_char )) is_error=1

  # ————————————————————————————————————————————— #

  if (( is_error )) {
    echo -E - "$funcstack[2]: unrecognised range -" \
      'try using `bindkey` instead' >&2
    return 1
  }

  # ————————————————————————————————————————————— #

  if [[ "$widgets[$function]" != (builtin|completion*) ]] {
    zle -N "$function" || return $?
  }
  bindkey -R "$l_char-$r_char" "$function" || return $?

  # ————————————————————————————————————————————— #

  local bind
  for bind in {$l_char..$r_char}; _ZSHZLE_KEYBINDINGS[$bind]="$function"
}

# ——————————————————————————————————————————————————————————————————————————— #
# ——————————————————————————————————————————————————————————————————————————— #

function keybind::string () {
  local -r zsh_bind="${1:?must enter a binding sequence}"
  local -r  command="${2:?must enter a command}"
  shift 2

  local -a keybinds=( "$*" )

  # ————————————————————————————————————————————— #

  # remove everything after the first space
  if [[ $widgets[$function] != (builtin|completion*) ]] {
    zle -N "${command%% *}" || return $?
  }
  bindkey -s "$zsh_bind" "^Q$command^J" || return $?

  # ————————————————————————————————————————————— #

  local bind
  for bind in "${(@)keybinds:#}"; {
    bind="${${${(*)bind//[[:space:]]##/ }# }% }"
    _ZSHZLE_KEYBINDINGS[$bind]="$command"
  }
}

# ——————————————————————————————————————————————————————————————————————————— #
# ——————————————————————————————————————————————————————————————————————————— #
