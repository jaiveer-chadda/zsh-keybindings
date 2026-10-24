#!/usr/bin/env zsh

# —— —— transp-chrs() —— ———————————————————————————————————————————————————— #

function  transp-chrs  transp-chrs-left  transp-chrs-right  () {

  # note: `$BUFFER[$CURSOR]` is the character behind the line cursor
  #  - i.e. if the prompt is:
  #       $ abcd|ef
  #    then:  `BUFFER='abcdef'`  `CURSOR=4`  `BUFFER[CURSOR]='d'`

  # —— Setup ——————————————————————————————————————————————————————————————— #

  setopt local_options warn_create_global warn_nested_var

  # —— Define/Declare Vars ———————————————————— #

  local -ri 10 LEFT=-1 RIGHT=1 DEFAULT=0
  local -i  10 direction=$DEFAULT

  local -r funcname="${(%):-%N}"

  # —— Determine direction ————————————————————————————————————————————————— #

  case "$funcname" {
    ( *left  ) direction=$LEFT  ;;
    ( *right ) direction=$RIGHT ;;
    ( *      ) direction=$RIGHT ;; # temp for now
  }

  # —— Find or Set Selection —————————————————— #

  local -i 10 lcur rcur

  if (( ! REGION_ACTIVE )) {
    MARK=$CURSOR-1 REGION_ACTIVE=1
    lcur=$MARK     rcur=$CURSOR

  } else {
    (( CURSOR < MARK ? ( lcur=CURSOR,rcur=MARK ) : ( lcur=MARK,rcur=CURSOR ) ))
  }

  # —— Create Buffer Sections —————————————————————————————————————————————— #

  local -r \
    left="$BUFFER[ 1        , lcur ]" \
    midl="$BUFFER[ lcur + 1 , rcur ]" \
    righ="$BUFFER[ rcur + 1 , -1   ]"

  # —— Verify Input ——————————————————————————— #

  # make sure we're not trying to shift off the end of the screen
  if (( direction == LEFT  && lcur == 0  ||
        direction == RIGHT && rcur == $#BUFFER
  )) zle beep && return 0

  # ——————————————————————————————————————————— #

  # a selection can't contain a newline, and you can't move into a newline
  # todo: add an exception for when there's only one character selected
  if [[ $midl     == *$'\n'*
     || $left[-1] ==  $'\n' && $direction -eq $LEFT
     || $righ[+1] ==  $'\n' && $direction -eq $RIGHT
  ]] zle beep && return 0

  # —— Construct New Buffer ———————————————————————————————————————————————— #

  if   (( direction == RIGHT )) { BUFFER="$left$righ[+1]$midl$righ[2,-1]"; } \
  elif (( direction == LEFT  )) { BUFFER="$left[1,-2]$midl$left[-1]$righ"; } \
  else {
    # todo: implement functionality to make this func behave a bit more like
    #       the default ⌃T (transpose-chars), where when it gets to the
    #       beginning or end of a line (note: _line_ not buffer), it
    #       transposes the chars back and forth, instead of beeping
    zle beep; zle -M 'error: not implemented'
    return 1
  }

  # —— Cleanup & Return ——————————————————————— #

  (( MARK += direction, CURSOR += direction ))
}

# ——————————————————————————————————————————————————————————————————————————— #

zle -N transp-chrs       ; bindkey '^T'       transp-chrs
zle -N transp-chrs-left  ; bindkey '^[[(A+q)' transp-chrs-left   # ⌥ q
zle -N transp-chrs-right ; bindkey '^[[(A+w)' transp-chrs-right  # ⌥ w

# ——————————————————————————————————————————————————————————————————————————— #

# spell:ignoreRegexp /\b(?:righ|[lr]cur|midl)\b/g
