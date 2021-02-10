# startx at login
if status is-login
	if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
		exec startx "$HOME/.config/X11/xinitrc"
	else if test -z "$DISPLAY" -a "$XDG_VTNR" = 2
		exec startx "$HOME/.config/X11/ob-xinitrc"
	end
end

alias config='/usr/bin/git --git-dir=/home/mkn/.cfg/ --work-tree=/home/mkn/'
