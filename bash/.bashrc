[[ $- != *i* ]] && return # If not running interactively, don't do anything

shopt -s histappend # append to the history file, don't overwrite it
shopt -s checkwinsize # update the values of LINES and COLUMNS after command
shopt -s globstar # match all files and zero or more directories/subdirectories.

eval "$(lesspipe)"
eval "$(dircolors -b)"

HISTCONTROL=ignoreboth # don't put duplicate lines or lines starting with space in the history.
HISTSIZE=1000
HISTFILESIZE=2000

PATH="$HOME/bin/:$PATH"
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias emacs="emacsclient"
alias em='emacs -nw'
alias eme='emacs -r'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

export PS1="\[\e[33m\]this is green\[\e[0m\] this is normal"
