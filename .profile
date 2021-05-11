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


# autostart sway
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ] ; then
	#ENVIRONMENT
	export EDITOR=nvim
	export TERM=alacritty
	export VISUAL=nvim

	#XDG
	export XDG_CONFIG_HOME=$HOME/.config
	export XDG_CACHE_HOME=$HOME/.cache
	export XDG_DATA_HOME=$HOME/.local/share
	export XDG_DATA_DIRS=/usr/local/share:/usr/share
	export XDG_CONFIG_DIRS=/etc/xdg

	#WAYLAND
	export MOZ_ENABLE_WAYLAND=1

	#NNN
	export NNN_OPTS=H
	export NNN_COLORS=1234
	export NNN_FCOLORS="1234567a"

	exec sway
fi
