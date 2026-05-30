#!/usr/bin/env zsh

zmodload -i zsh/parameter

copy-output   () { echo -nE "$( eval $history[$(( HISTCMD-1 ))] )" | pbcopy; }
copy-last-cmd () { echo -nE         "$history[$(( HISTCMD-1 ))]"   | pbcopy; }

zle -N copy-output   ; bindkey '^[^L' copy-output
zle -N copy-last-cmd ; bindkey '^[c'  copy-last-cmd
