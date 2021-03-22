#!/bin/sh

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# HISTORY
# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# WINDOW
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# PROMPT
PS1="\[\033[38;5;8m\][\u@\h\[$(tput sgr0)\] \[$(tput sgr0)\]\[$(tput bold)\]\[\033[38;5;2m\]\W\[$(tput sgr0)\]\[\033[38;5;8m\]]\[$(tput sgr0)\]\[\033[38;5;9m\]\\$\[$(tput sgr0)\] "

# COMPLETION
complete -cf sudo

# ALIAS
alias ls='ls -lah --color=auto'

# pacman
alias syy='sudo pacman -Syy'
alias syu='sudo pacman -Syu'
alias qqentt="pacman -Qqentt | grep -ve 'base' -ve '$(pacman -Qqg base-devel)'"

# dotfiles
alias config='/usr/bin/git --git-dir=/home/mkn/.cfg/ --work-tree=/home/mkn/'
alias pkglists='pacman -Qqentt > $HOME/.config/pkglist-qqentt.txt & pacman -Qqent > $HOME/.config/pkglist-qqent.txt & pacman -Qqm > $HOME/.config/pkglist-qqm.txt'
