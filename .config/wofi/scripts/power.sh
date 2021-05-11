#!/bin/sh

chosen=$(echo -e "Logout\nPoweroff\nReboot\nSuspend\nHibernate" | wofi -L 5 --show dmenu)

if [[ $chosen = "Logout" ]]; then
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
