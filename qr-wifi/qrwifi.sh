#!/usr/bin/env bash

function usage(){
    echo "No arguments supplied";
    echo "Usage $0 SSID password-file.txt";
    exit 1;
}


if [ $# -eq 0 ]; then
    usage "$0"
fi
if [ $# -eq 1 ]; then
    usage "$0"
fi

command -v qrencode >/dev/null 2>&1 || { 
    echo >&2 "I require qrencode, but it's not installed. Aborting."; 
    exit 1; 
}

if test ! -f "$2"; then
    echo "$2 is not a regular file."
    echo "Use: echo \"YourSuperSecurePass\" > password-file.txt";
    echo "And use that file as second argument of this script"
    exit 1;
fi

SSID=$1
PSW_FILE_CONTENT=$(cat "$2");
PSW_FILE_CONTENT_SANITIZED=$(echo -n "$PSW_FILE_CONTENT" | tr '\n' ' ');

OUT_PNG="wifi.png"

qrencode \
    -o ${OUT_PNG} \
    -s 20 \
    --dpi 100 \
    "WIFI:T:WPA;S:${SSID};P:${PSW_FILE_CONTENT_SANITIZED};;" || exit 1;
