#!/usr/bin/env bash

# color declaration.
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No color

TAG="> [JAVA]"

# print $1 in green
function log () {
    echo -e -n "${GREEN}"; echo -n "$TAG $1"; echo -e "${NC}"
}

# print $1 in red
function logError () {
    echo -e -n "${RED}"; echo -n "$TAG $1"; echo -e "${NC}"
}

# usage and exit function.
function usageAndExit () {
    echo -e "Usage: $0 workspace-parent-absolute-path"
    echo -e "Example: $0 /home/pippo/Documents/workspace"
    exit 1
}

if [ "$1" = "-h" ] || [ "$1" = "--help"  ]; then                                
    echo "Script used to build java workspace from a given parent folder."
    usageAndExit
fi 

# check if this script is running with EUID==0 (root)
# comment the following statement if not required
if [ "$EUID" -eq 0 ]; then
    logError "It's not necessary to run this script as root."
    usageAndExit
fi

# check if correct number of arguments are passed to this script.
# 0 == no parameters, 1 == 1 argument, 2 == 2 arguments [...]
if [ "$#" -ne 1 ]; then
    logError "Script arguments are missing!"
    usageAndExit
fi


echo -n -e "${GREEN}$TAG building workspace..."

mkdir -p "$1"/java

echo -e "done${NC}"

