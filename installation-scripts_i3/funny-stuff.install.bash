#!/usr/bin/env bash

# color declaration.
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No color

## print $1 in green.
# $1: something to print in GREEN on stdout
function log () {
    echo -e -n "${GREEN}"; echo -n "$1"; echo -e "${NC}"
}

## print $1 in red.
# $1: something to print in RED on stdout
function logError () {
    echo -e -n "${RED}"; echo -n "$1"; echo -e "${NC}"
}

## print usage and exit.
function usageAndExit () {
    echo -e "Usage: sudo $0"
    #echo -e "Example: $0"
    exit 1
}

## print some help string and call usageAndExit
function printHelp () {
    echo "funny-stuff installation script."
    usageAndExit
}

# check if correct number of arguments are passed to this script.
# 0 == no parameters, 1 == 1 argument, 2 == 2 arguments [...]
#if [ "$#" -ne 0 ]; then
#    logError "Script arguments are missing!"
#    usageAndExit
#fi

getopt --test > /dev/null
if [[ $? -ne 4 ]]; then
    echo "I’m sorry, $(getopt --test) failed in this environment."
    exit 1
fi

OPTIONS=h
LONGOPTIONS=help
getopt --options=$OPTIONS \
       --longoptions=$LONGOPTIONS \
       --name "$0" -- "$@" > /dev/null
if [[ $? -eq 1 ]]; then # if getopt exit with 1 then some argument are wrong
    exit 2
fi

# now enjoy the options in order and nicely split until we see --
while true; do
    case "$1" in
        -h|--help)
            printHelp
            ;;
        # last characters produced by getopt
        --)
            shift
            break
            ;;
        # no more arguments
        *)
            break
            ;;
    esac
done

# check if this script is running with EUID==0 (root)
# comment the following statement if not required
if [ "$EUID" -ne 0 ]; then
    logError "$0 must be run as root."
    #logError "$0 must be executed a non-root user."
    usageAndExit
fi

# check if required packages are installed.
# if no dependencies required for this script, just skip it without modify.
# insert the required packages, space separated.
dep_req=( git python-pip stress )
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
log "=== INSTALLING FUNNY STUFF..."
apt-get install figlet cowsay sl neofetch fortune bastet lolcat -y

read -p "Copy neofetch config file? [y/n] " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
    CFG="$HOME"/.config/neofetch
    mkdir -p "$CFG"
    cp ../neofetch/* "$CFG"
fi

log "=== INSTALLING s-tui - goo.gl/YJsBJ8"
pip install s-tui

log "=== INSTALLING tty-clock"
log "installing dependencies..."
apt-get install libncurses-dev -y -qq
down="$HOME"/Documents || exit
mkdir -p "$down"/tty-clock || exit
# git clone git@github.com:AndreaGhizzoni/tty-clock.git "$down"/tty-clock
wget http://github.com/AndreaGhizzoni/tty-clock/archive/master.zip
unzip master.zip
mv tty-clock-master/* "$down"/tty-clock
rm master.zip
rm -rf tty-clock-master

origin=$(pwd)
cd "$down"/tty-clock || exit
log "compiling..."
make
cd "$origin" || exit

chown -R andrea:andrea "$down"/tty-clock

log "=== FINISH! ==="

