#!/bin/bash

chosen=$(echo -e "Logout\nPoweroff\nReboot\nSuspend\nHibernate" | rofi -theme power -dmenu -i)

if [[ $chosen = "Logout" ]]; then
	openbox --exit
elif [[ $chosen = "Poweroff" ]]; then
	poweroff
elif [[ $chosen = "Reboot" ]]; then
	reboot
elif [[ $chosen = "Suspend" ]]; then
	suspend
elif [[ $chosen = "Hibernate" ]]; then
	hibernate
fi
