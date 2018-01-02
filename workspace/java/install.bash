#!/usr/bin/env bash

# color declaration.
L_CYAN='\033[1;36m'
#GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No color

## print $1 in green.                                                           
# $1: something to print in GREEN on stdout
function log () {
    echo -e -n "${L_CYAN}==> ${NC}"; echo "$1"
}

## print $1 in green.                                                           
# $1: something to print in RED on stdout
function logError () {
    echo -e -n "${RED}!!! Error: ${NC}"; echo "$1"
}

## print usage and exit.
function usageAndExit () {
    echo -e "Usage: $0 [-s|--spacing]"
    echo -e "Example: $0 -s \"   \""
    exit 1
}

## print some help string and call usageAndExit
function printHelp () {
    echo "Sript used to install java sdk from repository."
    usageAndExit
}

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

OPTIONS=hs:
LONGOPTIONS=help,spacing:
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
        -s|--spacing)
            spacing="$2"
            shift 2
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
if [ "$EUID" -eq 0 ]; then
    #logError "$0 must be run as root."
    logError "$0 must be executed a non-root user."
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

echo -e -n "$spacing"; log "installing sdk..."
echo -e -n "$spacing$spacing"; log "adding repository..."
#echo -n -e "${GREEN}    $spacing adding repository..."
sudo add-apt-repository ppa:webupd8team/java --yes &>/dev/null
#echo -e "done${NC}"

echo -e -n "$spacing$spacing"; log "updating sources..."
#echo -n -e "${GREEN}    $spacing updating sources..."
sudo apt-get update &>/dev/null
#echo -e "done${NC}"

echo -e -n "$spacing$spacing"; log "installing from repo..."
#echo -n -e "${GREEN}    $spacing installing from repo...${NC}"
sudo apt-get install oracle-java8-installer --yes -q
