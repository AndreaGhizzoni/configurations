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
    #echo -e "Usage: $0"
    #echo -e "Example: $0"
    exit 1
}

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
dep_req=( )
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

# from: https://ubuntuforums.org/showthread.php?t=1123635
# 
# ONCE INSTALLED:
# 1) hp-check
# 2) hp-setup -i
#
log "=== INSTALLING HP PRINTER DRIVER..."
apt-get install hplip libcups2 libdbus-1-dev libtool libtool-bin \
libcups2-dev cups-bsd cups-client libcupsimage2-dev python3-dev python3-pyqt4 \
gtk2-engines-pixbuf libsnmp-dev snmp-mibs-downloader libusb-1.0.0-dev \
libsane-dev openssl libjpeg-dev gtk2-engines-pixbuf xsane python3-notify2 \
python3-dbus.mainloop.qt libssl-dev
log "=== Now plug the printer usb and run the following commands:"
log "sudo hp-check$"
log "sudo hp-setup -i"
log "=== FINISH!"

