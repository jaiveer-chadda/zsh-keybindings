#!/usr/bin/env zsh

# ——————————————————————————————————————————————————————————————————————————— #

# Format
# ——————
# the escape will be structured as follows:
#   CSI '('
#     [repeat]
#         modifier keys, each in single-letter form   # (case-¿(in)?sensitive)
#       '+'
#         the pressed key, in its representative form # (case-sensitive)
#       '_' (only if repeating)
#     [endrepeat]
#   ')'
#
# note: numpad keys not supported yet

# ——————————————————————————————————————————— #

# BNF Grammar
# ———————————
# escape    := <CSI> '(' <sequence> { '_' <sequence> } ')'
# CSI       := '\e['
# sequence  := { <modifier> } '+' <key>
#       maybe change to: [ { <modifier> } '+' ] <key>
#
# modifier  := 'W' | 'A' | 'C' | 'F' | 'S' | 'H' | 'M'          # /[ACFHMSW]/
# key       := <lower> | <digit> | <punct-key> | <func-key> | <alias-key>
#
# punct-key := '[' | ']' | ';' | '\' | ''' | ',' | '.' | '/' | '`' | '=' | '-'
# func-key  := 'f' ( [ '1' ] <digit> | '20' )
# alias-key := /[BDEHIJKLNORSTUV]/
#
# lower     := /[a-z]/
# digit     := /[0-9]/

# ——————————————————————————————————————————— #

# Regex Grammar (extended)
# —————————————
# ignore spaces
#
# escape    := \e\[ [(] <sequence> ( _ <sequence> )* [)]
# sequence  := [ACFHMSW]* [+] <key>
# key       := (  [- \d a-z \\ ;'`/,.= \[\] ]  | <alias-key> | <func-key> )
#
# func-key  := f ( 1? \d | 20 )
# alias-key := [BDEHIJKLNORSTUV]

# ——————————————————————————————————————————— #

# Regex Grammar (condensed)
# —————————————
# ignore line breaks & leading indentation
#
#
# \e\[
# [(]
#   [ACFHMSW]*
#   [+]
#   (
#     [-\da-z\\;'`/,.=\[\]BDEHIJKLNORSTUV]
#     |
#     <f(1?\d|20)>
#   )
#   (
#     [_]
#     [ACFHMSW]*
#     [+]
#     (
#       [-\da-z\\;'`/,.=\[\]BDEHIJKLNORSTUV]
#       |
#       <f(1?\d|20)>
#     )
#   )*
# [)]

# ——————————————————————————————————————————————————————————————————————————— #

# Examples
# --------
#  Keymap Format  │  VS Code Format    │  Symbolic Format
# ────────────────│────────────────────│─────────────────
#  \e[(A+w)       │  "alt+W"           │   ⌥ W
#  \e[(CS+T)      │  "ctrl+shift+tab"  │  ⌃⇧ ↑
#  \e[(W+t_W+1)   │  "cmd+T cmd+1"     │   ⌘ T, ⌘ 1

# ——————————————————————————————————————————————————————————————————————————— #
# ——————————————————————————————————————————————————————————————————————————— #

function keymapping () {

  setopt local_options warn_create_global warn_nested_var

  # ————————————————————————————————————————————————————————————————————————— #

  local -rA _modifiers=(
    [W]='⌘:Win:Windows:Super:Cmd:Command'        [G]='⇮:AltGr:AltGraphic'
    [A]='⌥:Alt:Opt:Option'  [F]='◍:Fn:Function'  [H]='✦:Hyper'
    [C]='⌃:Ctrl:Control'    [S]='⇧:Shift'        [M]='◇:Meta'
  )

  local -rA _keymap=(
    [R]='↩:Return:Enter'  [B]='⌫:Backspace'  [E]='⎋:Escape'  [T]='⇥:Tab'
    [S]='§:SectionMark'   [D]='⌦:Delete'     [I]='⎀:Insert'

    [H]='←:Left'          [J]='↓:Down'       [K]='↑:Up'      [L]='→:Right'
    [V]='⇟:PageDown'      [U]='⇞:PageUp'     [O]='↖:Home'    [N]='↘:End'
  )

  # ————————————————————————————————————————————————————————————————————————— #

  local -r MOD="[${(@kj::)_modifiers}]#"
  local -r KEY="[${(@kj::)_keymap}a-z0-9\[\];\\',./\`=-]"

  # ————————————————————————————————————————————————————————————————————————— #

  local -a mods match mbegin mend
  local esc_seq mod key

  setopt extended_glob

  for esc_seq; {
    echo -nE "${(r:15:)esc_seq} : "

    if [[ "$esc_seq" != ($'\e'|'\e'|'^[')'[('(#b)($~MOD)($~KEY)')' ]] {
      echo 'invalid escape sequence' >&2
      continue
    }

    mods=()
    for mod in "${(@s::)match[1]}"; mods+="${_modifiers[${(U)mod}]%%:*}"

    key="$match[2]"
    key="${${_keymap[$key]%%:*}:-$key}"

    echo -E "${(j::)mods} $key"
  }

  unsetopt extended_glob
}

# ——————————————————————————————————————————————————————————————————————————— #
# ——————————————————————————————————————————————————————————————————————————— #

if [[ "$ZSH_EVAL_CONTEXT" == 'toplevel' ]] keymapping "$@"

# ——————————————————————————————————————————————————————————————————————————— #

# spell:ignoreRegexp /(?<=\[)[A-Z]+?|[A-Z]+?(?=\])/g
