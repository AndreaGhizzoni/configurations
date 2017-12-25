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

## print $1 in green.                                                           
# $1: something to print in RED on stdout
function logError () {
    echo -e -n "${RED}"; echo -n "$1"; echo -e "${NC}"
}

## print usage and exit.
function usageAndExit () {
    echo -e "Usage: $0 [-s|--spacing] [-d|--destination]"
    echo -e "Example: $0 --destinantion /home/pippo/work"
    exit 1
}

## print some help string and call usageAndExit
function printHelp () {
    echo "Script used to build go workspace."
    usageAndExit
}

# check if this script is running with EUID==0 (root)
# comment the following statement if not required
if [ "$EUID" -eq 0 ]; then
    #logError "$0 must be run as root."
    logError "$0 must be executed a non-root user."
    usageAndExit
fi

# check if correct number of arguments are passed to this script.
# 0 == no parameters, 1 == 1 argument, 2 == 2 arguments [...]
if [ "$#" -eq 0 ]; then
    printHelp
fi

getopt --test > /dev/null
if [[ $? -ne 4 ]]; then
    echo "I’m sorry, $(getopt --test) failed in this environment."
    exit 1
fi

OPTIONS=hd:s:
LONGOPTIONS=help,destination:,spacing:
PARSED=$(getopt --options=$OPTIONS \
                --longoptions=$LONGOPTIONS \
                --name "$0" -- "$@")
eval set -- "$PARSED"

# now enjoy the options in order and nicely split until we see --
while true; do
    case "$1" in
        -h|--help)
            printHelp
            ;;
        -d|--destination)
            destination="$2"
            shift 2
            ;;
        -s|--spacing)
            spacing="$2"
            shift 2
            ;;
        # this case is required to handle --arg
        --)
            shift
            break
            ;;
        *)
            echo "Programming error"
            exit 3
            ;;
    esac
done


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

echo -n -e "${GREEN}$spacing building workspace..."
mkdir -p "$destination"/go
mkdir -p "$destination"/go/bin
mkdir -p "$destination"/go/pkg
mkdir -p "$destination"/go/src/github.com/AndreaGhizzoni
echo -e "done${NC}"

