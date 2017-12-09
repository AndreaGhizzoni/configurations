#!/usr/bin/env bash

# color declaration.
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No color

# print $1 in green
function log () {
    echo -e -n "${GREEN}"; echo -n "$1"; echo -e "${NC}"
}

# print $1 in red
function logError () {
    echo -e -n "${RED}"; echo -n "$1"; echo -e "${NC}"
}

# usage and exit function.
function usageAndExit () {
    echo -e "Usage: sudo $0"
    #echo -e "Example: $0"
    exit 1
}

if [ "$1" = "-h" ] || [ "$1" = "--help"  ]; then
    usageAndExit
fi

# check if this script is running with EUID==0 (root)
# comment the following statement if not required
if [ "$EUID" -ne 0 ]; then
    logError "$0 must be run as root."
    usageAndExit
fi

# check if correct number of arguments are passed to this script.
# 0 == no parameters, 1 == 1 argument, 2 == 2 arguments [...]
if [ "$#" -ne 0 ]; then
    logError "Script arguments are missing!"
    usageAndExit
fi

# check if required packages are installed.
# if no dependencies required for this script, just skip it without modify.
# insert the required packages, space separated.
dep_req=( wget unzip tar )
dep_not_found=( ) # DO NOT EDIT THIS ARRAY
i=0
for dep in "${dep_req[@]}"
do
    q=$(dpkg-query -W -f='${Status}' "$dep" 2>/dev/null | grep -c "ok installed")
    if [ "$q" -eq 0 ]; then
        dep_not_found[$i]=${dep}
        ((i++))
    fi
done
if [ ${i} -ne 0 ]; then
    logError "Abort: Dependency package/s not found:"
    echo -n "${dep_not_found[@]}"
    echo ""
    exit 1
fi

# script logic start here
log "=== INSTALLING i3 POST INSTALL PROGRAMS..."
apt-get install alsa-utils pavucontrol lxappearance wicd wicd-gtk feh scrot \
    fonts-font-awesome arandr qalc libnotify-bin

fc-cache -fr --really-force

log "=== INSTALLING NEW i3lock..."
read -p "Replace i3lock with PandorasFox/i3lock-color? (required for i3exit.sh) [y/n] " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
    apt-get install pkg-config libxcb1 libpam-dev libcairo-dev \
        libxcb-composite0 libxcb-composite0-dev libxcb-xinerama0-dev \
        libev-dev libx11-dev libx11-xcb-dev libxkbcommon0 libxkbcommon-x11-0 \
        libxcb-dpms0-dev libxcb-image0-dev libxcb-util0-dev libxcb-xkb-dev \
        libxkbcommon-x11-dev libxkbcommon-dev libxcb-randr0-dev autoconf

    log "=== GETTING PandorasFox/i3lock-color..."
    wget https://github.com/PandorasFox/i3lock-color/archive/master.zip
    unzip master.zip
    cd i3lock-color-master || exit
    log "=== CONFIGURING..."
    autoreconf -i || exit 
    ./configure || exit
    log "=== MAKE & MAKE INSTALL..."
    cd x86_64-pc-linux-gnu || exit
    make && make install
fi

log "=== INSTALLING LMSENSORS..."
# from: https://askubuntu.com/questions/15832/how-do-i-get-the-cpu-temperature
read -p "Install and configure lm-sensors ? (required for i3 on laptop) [y/n] " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
    log "=== Installing lm-sensors..."
    apt-get install lm-sensors
    
    log "=== Configuring..."
    sensors-detect
    service kmod start
    systemctl enable kmod
fi

log "=== EXTRACTING WALLPAPERS..."
PICS="$HOME"/Pictures
mkdir -p $PICS
WALLPAPERS="$PICS"/wallpapers
if [ -d "$WALLPAPERS" ]; then
    tar xf ../wallpapers.tar -C "$PICS"
    log "=== WALLPAPERS EXTRACTED"
else
    log "=== WALLPAPERS FOLDER ALREADY EXISTS."
fi

log "=== To resolve some font problem just run: fonts.install"
log "=== FINISH! ==="

