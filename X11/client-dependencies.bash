#!/usr/bin/env bash

# color declaration.
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No color

# usage and exit function.
usageAndExit(){
    echo -e "Usage: $0"
    #echo -e "Example: $0"
    exit 1
}

# check if this script is running as root.
# comment the following statement if not required
if [ $UID -ne 0 ]; then
    echo -e "${RED}$0 must be run as root.${NC}"
    usageAndExit
fi

# script logic start here
echo -e "${GREEN} ${NC}"
echo -e "${GREEN}=== DEPENDENCIES FOR X11 FORWARDING.. ${NC}"

apt-get install xserver-xephyr

echo -e "${GREEN}=== Checking required variables... ${NC}"
# solution found here: https://goo.gl/gfHo9S
if [ -z ${DISPLAY+x} ]; then 
    echo -e "${RED}ERROR: \$DISPLAY is unset${NC}"
    exit 1
else 
    echo -e "${GREEN}-> OK: \$DISPLAY = $DISPLAY${NC}"
fi
if [ -z ${XAUTHORITY+x} ]; then 
    echo -e "${RED}ERROR: \$XAUTHORITY is unset${NC}"
    exit 1
else 
    echo -e "${GREEN}-> OK: \$XAUTHORITY = $XAUTHORITY${NC}"
fi

echo -e "${GREEN}=== FINISH!${NC}"

