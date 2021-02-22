# startx at login
if status is-login
	if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
	# start Openbox on tty1
		exec startx "$HOME/.config/X11/ob-xinitrc"
	end
end

# ALIAS
alias config='/usr/bin/git --git-dir=/home/mkn/.cfg/ --work-tree=/home/mkn/'
alias ls='ls -lah --color=auto'
alias pkglists='pacman -Qqentt > $HOME/.config/pkglist-qqentt.txt & pacman -Qqent > $HOME/.config/pkglist-qqent.txt & pacman -Qqm > $HOME/.config/pkglist-qqm.txt'
