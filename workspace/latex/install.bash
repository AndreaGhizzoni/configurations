#!/usr/bin/env bash

# color declaration.
L_CYAN='\033[1;36m'
#GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No color

## print $1 in green.                                                           
# $1: something to print in GREEN on stdout
function log () {
    echo -e -n "$2"; echo -e -n "${L_CYAN}==> ${NC}"; echo "$1"
}

## print $1 in green.                                                           
# $1: something to print in RED on stdout
function logError () {
    echo -e -n "$2"; echo -e -n "${RED}!!! Error: ${NC}"; echo "$1"
}

## print usage and exit.
function usageAndExit () {
    echo -e "Usage: $0 [-s|--spacing]"
    echo -e "Example: $0 -s \"   \""
    exit 1
}

## print some help string and call usageAndExit
function printHelp () {
    echo "Sript used to install golang compiler."
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

log "installing latex full..." "$spacing"
sudo apt-get install texlive-full texmaker --yes -q

TEX=$HOME/texmf
if [ -d "$TEX" ]; then
    log "$TEX already exists. Nothing to configure." "$spacing$spacing"
else
    TEX_HOME=$TEX/tex/latex
    TEX_CUSTOM=$TEX_HOME/custom
    TEX_SPELL=$TEX_HOME/myspell
    mkdir -p "$TEX_HOME"
    mkdir -p "$TEX_CUSTOM"
    mkdir -p "$TEX_SPELL"

    log "Coping custom latex library in $TEX_CUSTOM..." "$spacing$spacing"
    cp ../../tex/bytefield/bytefield.sty "$TEX_CUSTOM"
    cp ../../tex/algorithm2e/tex/algorithm2e.sty "$TEX_CUSTOM"
    cp ../../tex/graphviz/graphviz.sty "$TEX_CUSTOM" 
    cp ../../tex/mathtools/empheq.sty "$TEX_CUSTOM"
    cp ../../tex/mathtools/mathtools.sty "$TEX_CUSTOM"
    cp ../../tex/mathtools/mhsetup.sty "$TEX_CUSTOM"

    log "Coping custom dictionaries in $TEX_SPELL..." "$spacing$spacing"
    cp ../../tex/it_IT.aff ../../tex/it_IT.dic "$TEX_SPELL"

    log "REMEMBER to set textmaker dictionaries on: $TEX_SPELL" "$spacing$spacing"
fi
