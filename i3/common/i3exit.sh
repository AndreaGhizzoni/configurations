#!/bin/bash

function lock {
   GREY='#202020ff'
   CLEAR='#00000000'
   GREEN='#00ff00ff'
   WHITE='#ffffffff'
   RED='#ff0000bb'  # wrong
   BLUE='#0000ffff'  # verifying

   # using new i3lock: https://github.com/chrjguill/i3lock-color
   i3lock \
       -c 202020 \
       --insidevercolor=$CLEAR \
       --ringvercolor=$BLUE \
       \
       --insidewrongcolor=$CLEAR \
       --ringwrongcolor=$RED \
       \
       --insidecolor=$GREY \
       --linecolor=$GREY \
       --ringcolor=$GREEN \
       --separatorcolor=$GREEN \
       \
       --verifcolor=$WHITE \
       --timecolor=$WHITE \
       --datecolor=$WHITE \
       --layoutcolor=$WHITE \
       --keyhlcolor=$RED \
       --bshlcolor=$RED \
       \
       --radius=120 \
       --clock \
       --indicator \
       --wrongtext="Nope!" \
       --timestr="%H:%M:%S" \
       --datestr="%A, %m %Y" \
       #--veriftext="Drinking verification can..." \
       # --textsize=20
       # --modsize=10
       # --timefont=comic-sans
       # --datefont=monofur
       # etc
}

case "$1" in
    lock)
        lock
        ;;
    logout)
        i3-msg exit
        ;;
    suspend)
        lock && systemctl suspend
        ;;
    reboot)
        systemctl reboot
        ;;
    poweroff)
        systemctl poweroff
        ;;
    *)
        echo "Usage: $0 {lock|logout|suspend|reboot|poweroff}"
        exit 2
esac

exit 0
