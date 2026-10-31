#!/usr/bin/env zsh

function keys () {
  setopt local_options warn_create_global warn_nested_var
  tabs -36

  local mode='bind'
  if     [[ "$1" == -[bk] ]] { mode='bind'   # [b]ind/[k]eys
  } elif [[ "$1" == -[fc] ]] { mode='func' } # [f]unc/[c]md

  # ——————————————————————————————————————————————————————————————————— #

  local -r HT=$'\t' NL=$'\n'
  local -r DELIM=' ::-:-:: '
  local -r ARROW=' —→ '

  local -r  SPACE='·'
  local -r ESCAPE='⎋'

  local -ra input_lines=( "${(@f)$( bindkey -L )}" )

  # ——————————————————————————————————————————————————————————————————— #

  local -A all_binds all_funcs
  local -i 10 max_func_len
  local type bind func

  local -a _bind_info
  local _raw_input _bind1 _bind2

  # —————————————————————————————————————————————————— #

  for _raw_input in "${(@)input_lines}"; {
    _bind_info=( "${(@)${(@z)_raw_input}[2,-1]}" )

    # ————————————————————————— #

    if [[ "$_bind_info[1]" == -[Rs] ]] {
      type="$_bind_info[1]"
      shift _bind_info
    } else {
      type='--'
    }

    if [[ "$_bind_info[1]" == '--' ]] shift _bind_info

    # ————————————————————————— #

    bind="$_bind_info[1]"
    func="$_bind_info[2]"

    if (( $#func > max_func_len )) max_func_len=$#func

    # ————————————————————————— #

    if [[ $type == '-R' ]] {
      # replace `"-"` at the beginning or end of the string with `"HYP"`
      bind="${(*)bind/((#s)\"-\"|\"-\"(#e))/\"HYP\"}"
      # now there should be no cases of `"-"` other than the range specifier
      _bind1="${bind%\"-\"*}\"" _bind2="\"${bind#*\"-\"}"
      # replace the `"HYP"`s we added with `"-"`
      bind="${(Q)_bind1/#%\"HYP\"/\"-\"}$ARROW${(Q)_bind2/#%\"HYP\"/\"-\"}"
    } else {
      bind="${(Q)bind}"
    }

    # bind="${${bind//'\^'/^}//'\\'/\\}"
    # bind="${bind// /$SPACE}"
    # bind="${bind//'^['/$ESCAPE}"

    # ————————————————————————— #

    all_binds[$bind-$type]="$func"
    all_funcs[$func]="$all_funcs[$func]$bind-$type$DELIM"
  }

  # ——————————————————————————————————————————————————————————————————— #

  local -ri 10 func_pad_len=$(( max_func_len + 5 ))
  local -r func_pad="$NL${(r:func_pad_len:)}"

  # —————————————————————————————————————————————————— #

  if [[ $mode == 'bind' ]] {
    local -i 10 {rawchr,escape,ctrl_x,normal}_len
    local -a    {rawchr,escape,ctrl_x,normal}_lines
    local _mapping line

    for _mapping in "${(@ok)all_binds}"; {
      func="$all_binds[$_mapping]"
      type="$_mapping[-2,-1]"
      bind="$_mapping[+1,-4]"

      line="${(r:func_pad_len:)func}$bind"

      case "$bind" {
        ( '^['*        ) escape_lines+=( "$line" ); if (( $#line > escape_len )) escape_len=$#line ;;
        ( '^X'*        ) ctrl_x_lines+=( "$line" ); if (( $#line > ctrl_x_len )) ctrl_x_len=$#line ;;
        ( ('^'|'\M-')* ) normal_lines+=( "$line" ); if (( $#line > normal_len )) normal_len=$#line ;;
        (      *       ) rawchr_lines+=( "$line" ); if (( $#line > rawchr_len )) rawchr_len=$#line ;;
      }
      # echo -E - "${(r:func_pad_len:)func}$bind"
    }

    local -i 10 _len line_count

    for _len in $#rawchr_lines $#escape_lines $#ctrl_x_lines $#normal_lines; {
      if (( _len > line_count )) line_count=$_len
    }

    local -i 10 i

    local -r DIVIDER=$'\e[2m│\e[22m'

    for i in {1..$line_count}; {
      line=
      line+="${(r:escape_len:)escape_lines[i]} $DIVIDER "
      line+="${(r:ctrl_x_len:)ctrl_x_lines[i]} $DIVIDER "
      line+="${(r:normal_len:)normal_lines[i]} $DIVIDER "
      line+="${(r:rawchr_len:)rawchr_lines[i]} $DIVIDER "

      echo -E - "$DIVIDER $line"
    }

  # —————————————————————————————————————————————————— #

  } elif [[ $mode == 'func' ]] {

    local -a _bindings
    for func in "${(@ok)all_funcs}"; {
      _bindings=( "${(@ps:$DELIM:)all_funcs[$func]%$DELIM}" )
      _bindings=( "${(@o)_bindings%???}" )

      echo -E - "${(r:func_pad_len:)func}${(pj:$func_pad:)_bindings}"
    }
  }

  # ——————————————————————————————————————————————————————————————————— #

  tabs -8
}

# ——————————————————————————————————————————————————————————————————————————— #
# ——————————————————————————————————————————————————————————————————————————— #

function keys() {
  setopt local_options warn_create_global

  local -r  rst=$'\e[m'
  local -r  red=$'\e[31m'
  local -r blue=$'\e[94m'
  local -r yellow=$'\e[33m'

  local -r NL=$'\n'
  local -ra input_lines=(
    "${(@f*)$( bindkey -L )//($NL|(#s))bindkey (-? |)/$NL}"
  )

  local -A bindings
  local -a match mbegin mend
  local line binding command

  # we're ignoring the first line, cos we added a leading newline to the array
  for line in "${(@)input_lines[2,-1]}"; {
    # firstly, remove the leading quote
    # then, from the end, greedily remove everything up to the first quote with
    #  a space in front (→) of it, that doesn't have a backslash behind (←) it
    binding="${(*)${line#\"}/%(#b)([^\\])(#B)\" */$match[1]}"
    command="${line#\"$binding\" }"

    # `self-insert` basically means do nothing, so they're irrelevant
    if [[ "$command" == 'self-insert' ]] continue

    binding="${binding//\^\[\[A/$blue↑$rst}"   # up
    binding="${binding//\^\[\[B/$blue↓$rst}"   # down
    binding="${binding//\^\[\[C/$blue→$rst}"   # right
    binding="${binding//\^\[\[D/$blue←$rst}"   # left
    binding="${binding//\^\[\[F/$blue↘$rst}"   # end
    binding="${binding//\^\[\[H/$blue↖$rst}"   # home
    binding="${binding//\^\[\[5~/$blue⇞$rst}" # pg up
    binding="${binding//\^\[\[6~/$blue⇟$rst}" # pg down

    binding="${binding// /$blue␣$rst}"
    binding="${binding//'^'\[/$red⎋$rst }"
    binding="${binding//'^'/$yellow⌃$rst}"

    binding="${(*)binding//\\(#b)([^\\])(#B)/$match[1]}"

    bindings[$binding]="$command"
  }

  local cmd bind; local -i 10 max_len=-1
  for cmd ("${(@v)bindings}") if (( $#cmd > max_len )) max_len=${#cmd}

  for bind in "${(@ko)bindings}"; {
    cmd="$bindings[$bind]"
    echo "${(r:$max_len:)cmd}  $bind"
  }

}
