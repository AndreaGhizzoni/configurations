#!/usr/bin/env bash

# color declaration.
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No color

# Script description and usage
SHORT_PROGRAM_DESCRIPTION="HP printer simple installer"
USAGE=""
USAGE_EXAMPLE=""

# Script options
# example
#   OPTIONS=hx:
#   LONGOPTIONS="help,xxx:"
# then in the case switch below:
#   [...]
#       -x|--xxx)
#           NAME="$2"
#           shift 2
#           ;;
#   [...]
# means 'h' without an argument, 'x' with an argument
OPTIONS=h
LONGOPTIONS="help"

# Program Dependencies
dep_req=( )

# Run Script as root ?
RUN_AS_ROOT=1



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
function printUsageAndExit () {
    echo -e "$SHORT_PROGRAM_DESCRIPTION"

    echo -e -n "Usage  : ";
    if [ "$RUN_AS_ROOT" -eq 1 ]; then
        echo -e -n "sudo"
    fi
    echo -e " $0 $USAGE"

    echo -e -n "Example: ";
    if [ "$RUN_AS_ROOT" -eq 1 ]; then
        echo -e -n "sudo"
    fi
    echo -e " $0 $USAGE_EXAMPLE"
    
    exit 1
}



# check if this script is running with EUID==0 (root)
if [ "$RUN_AS_ROOT" -eq 1 ] && [ "$EUID" -ne 0 ]; then
    logError "$0 must be run as root."
    printUsageAndExit
fi

getopt --test > /dev/null
if [[ $? -ne 4 ]]; then
    echo "I’m sorry, $(getopt --test) failed in this environment."
    exit 1
fi
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
            printUsageAndExit            
            ;;
        ## insert new options below

        ##
        --) # last characters produced by getopt
            shift
            break
            ;;
        *) # no more arguments
            break
            ;;
    esac
done

# check if required packages are installed.
# if no dependencies required for this script, just skip it without modify.
# insert the required packages, space separated.
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

# ========================== script logic start here ===========================
# from: https://ubuntuforums.org/showthread.php?t=1123635
# 
# ONCE INSTALLED:
# 1) hp-check
# 2) hp-setup -i
#
log "=== INSTALLING HP PRINTER DRIVER..."

log "UNPLUG THE PRINTER!"
read -p "Press [Y] once done. [n] to abort this script. " -n 1 -r
echo 
if [[ $REPLY =~ ^[Yy]$ ]]; then
    apt-get install hplip libcups2 libdbus-1-dev libtool libtool-bin \
    libcups2-dev cups-bsd cups-client libcupsimage2-dev python3-dev python3-pyqt4 \
    gtk2-engines-pixbuf libsnmp-dev snmp-mibs-downloader libusb-1.0.0-dev \
    libsane-dev openssl libjpeg-dev gtk2-engines-pixbuf xsane python3-notify2 \
    python3-dbus.mainloop.qt libssl-dev -y
    log "=== Now plug the printer usb and run the following commands:"
    log "sudo hp-check$"
    log "sudo hp-setup -i"
fi

log "=== FINISH!"
