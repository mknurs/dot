#!/bin/bash

chosen=$(/usr/bin/git --git-dir=/home/mkn/.cfg/ --work-tree=/home/mkn/ ls-tree -r --full-name --name-only master | rofi -theme config -dmenu -i)

if [[ $chosen == "" ]]; then
	exit
else
	xterm -e nvim $chosen
fi
