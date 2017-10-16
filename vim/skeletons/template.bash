#!/usr/bin/env bash

# color declaration.
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No color

# usage and exit function.
usageAndExit(){
    echo -e "Usage: $0"
    echo -e "Example: $0"
    exit 1
}

# check if this script is running as root.
# comment the following statement if not required
if [ $UID -ne 0 ]; then
    echo -e "${RED}$0 must be run as root.${NC}"
    usageAndExit
fi

# check if correct number of parameters are passed to this script.
# change the following number
if [ "$#" -ne 1 ]; then
    echo -e "${RED}Parameters missing.${NC}"
    usageAndExit
fi

# insert the required packages, space separated
dep_req=( )
# check if required packages are installed
dep_not_found=( )
i=0
for dep in "${dep_req[@]}"
do
    q=$(dpkg-query -W -f='${Status}' ${dep} 2>/dev/null | grep -c "ok installed")
    if [ ${q} -eq 0 ]; then
        dep_not_found[$i]=${dep}
        ((i++))
    fi
done
if [ ${i} -ne 0 ]; then
    echo -e "${RED}Abort: Dependency package/s not found: ${NC}"
    printf '%s ' "${dep_not_found[@]}"
    echo ""
    exit 1
fi

# script logic start here
echo -e "${GREEN} ${NC}"

echo -e "${GREEN}Done!${NC}"
