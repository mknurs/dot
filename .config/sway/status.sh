#!/bin/sh

# volume
vol="[vol: $(pamixer --get-volume-human)]"

# network
net="[net: $(iw wlan0 link | awk '/SSID/{print substr($2, 1, 3)}')]"

# memory
mem="[mem: $(free -h | awk '/Mem/ { print $3 }')]"

# battery
percent=$(acpi -b | awk -F'[^0-9]*' '{ print $3 }')

if [[ $percent -lt "15" ]]; then
	bat="[bat: <span color='#ff5533'>$percent%</span>]"
else
	bat="[bat: $percent%]"
fi


# datetime
dat=$(date "+%a %d %b %Y %H:%M")

echo $vol $net $mem $bat $dat
