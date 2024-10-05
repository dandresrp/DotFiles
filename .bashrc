#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi


export PATH=$PATH:$HOME/.dev/flutter/bin
export PATH=$PATH:$HOME/.local/bin

HISTSIZE=10000
HISTFILESIZE=20000
export TERM="xterm-256color"
export HISTCONTROL=ignoredups:erasedups
# export EDITOR="emacsclient -t -a ''"
# export VISUAL="emacsclient -c -a emacs"

shopt -s autocd
shopt -s cdspell
shopt -s cmdhist
shopt -s dotglob
shopt -s histappend
shopt -s expand_aliases
shopt -s checkwinsize

bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'
bind 'set colored-stats On'
bind 'set visible-stats On'
bind 'set mark-symlinked-directories On'
bind 'set menu-complete-display-prefix On'
bind 'set colored-completion-prefix On'
bind 'set echo-control-characters off'

set -o noclobber
set -o vi

alias ls='eza --group-directories-first --long --all --icons'
alias ll='eza --group-directories-first --long --icons'
alias grep='grep --color=auto'
# PS1='[\u@\h \W]\$ '

eval "$(oh-my-posh init bash --config "/usr/share/oh-my-posh/themes/pure.omp.json")"
