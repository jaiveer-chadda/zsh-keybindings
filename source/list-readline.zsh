#!/usr/bin/env zsh

function keys() {
  setopt local_options warn_create_global

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

    binding="${binding// /␣}"
    binding="${binding//'^'\[/⎋ }"
    binding="${binding//'^'/⌃}"

    binding="${binding//OA/↑}"   # up
    binding="${binding//OB/↓}"   # down
    binding="${binding//OC/→}"   # right
    binding="${binding//OD/←}"   # left
    binding="${binding//OF/↘}"   # end
    binding="${binding//OH/↖}"   # home
    binding="${binding//\[5~/⇞}" # pg up
    binding="${binding//\[6~/⇟}" # pg down

    binding="${(*)binding//\\(#b)([^\\])(#B)/$match[1]}"

    bindings[$binding]="$command"
  }

  local cmd; local -i 10 max_len=-1
  for cmd ("${(@v)bindings}") if (( $#cmd > max_len )) max_len=${#cmd}

  for bind in "${(@ko)bindings}"; {
    cmd="$bindings[$bind]"
    echo "${(r:$max_len:)cmd}  $bind"
  }

}
