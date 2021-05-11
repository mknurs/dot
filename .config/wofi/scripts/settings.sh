#!/bin/sh

chosen=$(echo -e "Volume\nNetwork\nMemory\nBattery\nTime" | wofi -L 5 --show dmenu)

if [[ $chosen = "Volume" ]]; then
	swaymsg 'exit'
elif [[ $chosen = "Poweroff" ]]; then
	systemctl poweroff
elif [[ $chosen = "Reboot" ]]; then
	systemctl reboot
elif [[ $chosen = "Suspend" ]]; then
	systemctl suspend
elif [[ $chosen = "Hibernate" ]]; then
	systemctl hibernate
fi
