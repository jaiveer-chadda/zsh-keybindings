#!/usr/bin/env zsh

# —— Helper Functions ——————————————————————————————————————————————————————— #

function _set_mark() { if ! (( REGION_ACTIVE )) zle set-mark-command; }

# —— Select Left/Right —————————————————————————————————————————————————————— #

function select-char-left  () { _set_mark; zle     backward-char; }
function select-char-right () { _set_mark; zle      forward-char; }

function select-word-left  () { _set_mark; zle     backward-word; }
function select-word-right () { _set_mark; zle      forward-word; }

function select-line-left  () { _set_mark; zle beginning-of-line; }
function select-line-right () { _set_mark; zle       end-of-line; }

zle -N select-char-left ; zle -N select-word-left ; zle -N select-line-left
zle -N select-char-right; zle -N select-word-right; zle -N select-line-right

bindkey '^[[1;2D'  select-char-left   #   ⇧ <-
bindkey '^[[1;2C'  select-char-right  #   ⇧ ->

bindkey '^[[1;4D'  select-word-left   # ⌥ ⇧ <-
bindkey '^[[1;4C'  select-word-right  # ⌥ ⇧ ->

bindkey '^[[jC;SD' select-line-left   # ⌘ ⇧ <-
bindkey '^[[jC;SC' select-line-right  # ⌘ ⇧ ->

# —— Cancel Region —————————————————————————————————————————————————————————— #

function cancel-char-left  () { REGION_ACTIVE=0; zle     backward-char; }
function cancel-char-right () { REGION_ACTIVE=0; zle      forward-char; }

function cancel-word-left  () { REGION_ACTIVE=0; zle     backward-word; }
function cancel-word-right () { REGION_ACTIVE=0; zle      forward-word; }

function cancel-line-left  () { REGION_ACTIVE=0; zle beginning-of-line; }
function cancel-line-right () { REGION_ACTIVE=0; zle       end-of-line; }

zle -N cancel-char-left; zle -N cancel-char-right
zle -N cancel-word-left; zle -N cancel-word-right
zle -N cancel-line-left; zle -N cancel-line-right

bindkey '^[^[[D' cancel-char-left   # ⎋,   <-
bindkey '^[^[[C' cancel-char-right  # ⎋,   ->

bindkey '^[^[b'  cancel-word-left   # ⎋, ⌥ <-
bindkey '^[^[f'  cancel-word-right  # ⎋, ⌥ ->

bindkey '^[^A'   cancel-line-left   # ⎋, ⌘ <-
bindkey '^[^E'   cancel-line-right  # ⎋, ⌘ ->

# —— Copy Region ———————————————————————————————————————————————————————————— #

function copy-region () {
  if ! (( REGION_ACTIVE )) return

  if (( CURSOR < MARK )) { left=$CURSOR right=$MARK; } \
  else                   { left=$MARK right=$CURSOR; }

  echo -nE "$BUFFER[left+1,right]" | pbcopy
  REGION_ACTIVE=0
}

zle -N          copy-region
bindkey '^[].c' copy-region  # ⌘ ⌥ C

# —— Cut Region ————————————————————————————————————————————————————————————— #

function cut-region () {
  if ! (( REGION_ACTIVE )) return

  if (( CURSOR < MARK )) { left=$CURSOR right=$MARK; } \
  else                   { left=$MARK right=$CURSOR; }

  echo -nE "$BUFFER[left+1,right]" | pbcopy
  zle kill-region
  REGION_ACTIVE=0
}

zle -N          cut-region
bindkey '^[].x' cut-region  # ⌘ X

# —— Delete Region —————————————————————————————————————————————————————————— #

function delete-region-or-char () {
  if (( REGION_ACTIVE )) {
    zle kill-region
    REGION_ACTIVE=0

  } else {
    zle backward-delete-char
  }
}

zle -N       delete-region-or-char
bindkey '^?' delete-region-or-char  # ⌫

# —— Quote Region ——————————————————————————————————————————————————————————— #

function quote-region-or-insert () {
  local -r quote="$KEYS[-1]"
  if ! (( REGION_ACTIVE )) { zle self-insert "$quote"; return; }

  local -i 10 left right

  if (( CURSOR < MARK )) { left=$CURSOR right=$MARK; } \
  else                   { left=$MARK right=$CURSOR; }

  BUFFER="$BUFFER[1,left]$quote$BUFFER[left+1,right]$quote$BUFFER[right+1,-1]"
  CURSOR=$right+1

  REGION_ACTIVE=0
}

zle -N     quote-region-or-insert
bindkey \' quote-region-or-insert  # '
bindkey \" quote-region-or-insert  # "

# ——————————————————————————————————————————————————————————————————————————— #
