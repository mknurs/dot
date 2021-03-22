#!/bin/sh

# PATH
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
	PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
	PATH="$HOME/.local/bin:$PATH"
fi

#ENVIRONMENT
export TERM=xterm-termite
export EDITOR=nvim

# autostart startx
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ] ; then
	exec startx "$HOME/.config/X11/ob-xinitrc"
fi
