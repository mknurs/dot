#!/bin/sh

chosen=$(echo -e "Logout\nPoweroff\nReboot\nSuspend\nHibernate" | rofi -theme power -dmenu -i)

if [[ $chosen = "Logout" ]]; then
	openbox --exit
elif [[ $chosen = "Poweroff" ]]; then
	systemctl poweroff
elif [[ $chosen = "Reboot" ]]; then
	systemctl reboot
elif [[ $chosen = "Suspend" ]]; then
	systemctl suspend
elif [[ $chosen = "Hibernate" ]]; then
	systemctl hibernate
fi
