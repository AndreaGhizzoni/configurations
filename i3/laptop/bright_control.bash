#!/usr/bin/env bash
set -e

if [ ! -f "/tmp/brightness_enabled" ]; then
    gksudo chmod a+rw /sys/class/backlight/intel_backlight/brightness
    touch /tmp/brightness_enabled
fi

# from here: https://goo.gl/40kUGU
file="/sys/class/backlight/intel_backlight/brightness"
current=$(cat "$file")
new="$current"

if [ "$1" = "-inc" ]
then
    new=$(( current + $2 ))
fi
if [ "$1" = "-dec" ]
then
    new=$(( current - $2 ))
fi

echo "$new" | tee "$file"
