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

    if [[ "$command" == 'self-insert' ]] continue

    binding="${binding//'^'\[/⎋ }"
    binding="${binding//'^'/⌃}"

    bindings[$binding]="$command"
  }

  local bind; local -i 10 max_len=-1
  for bind ("${(@k)bindings}") if (( $#bind > max_len )) max_len=${#bind}

  for bind in "${(@ko)bindings}"; {
    echo "${(r:$max_len:)bind}  $bindings[$bind]"
  }

}
