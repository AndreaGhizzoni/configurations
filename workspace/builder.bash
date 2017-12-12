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
    echo -e "Usage: $0 [-a|--all] [-c|--create-workspace] [-i|--install] \
[-p|--getprojects]"
    echo -e "The following two example are equivalent:"
    echo -e "Example: $0 --all"
    echo -e "Example: $0 --create-workspace --install --get-projects"
    exit 1
}

function printHelp () {
    echo "Builder script for my workspace"
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

OPTIONS=hcipa
LONGOPTIONS=help,create-workspace,install,get-projects,all
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
        -c|--create-workspace)
            create=1
            shift
            ;;
        -i|--install)
            install=1
            shift
            ;;
        -p|--get-projects)
            projects=1
            shift
            ;;
        -a|--all)
            create=1
            install=1
            projects=1
            shift
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

ROOT_WORKSPACE_CONTAINER="$HOME"/Documents
ROOT_WORKSPACE="$ROOT_WORKSPACE_CONTAINER"/workspace2 # TODO change it

WORKSPACES=( java ) # TODO add workspaces

log "create \`workspace\` folder under: $ROOT_WORKSPACE_CONTAINER"
if [ -d "$ROOT_WORKSPACE" ]; then
    logError "$ROOT_WORKSPACE already exists. Nothing to do."
else
    # for each workspace in $WORKSPACES:
    # - cd into that folder
    # - ./build-workspace.bash "" $ROOT_WORKSPACE
    # - ./install.bash
    # - ./get-projects.bash $ROOT_WORKSPACE
    LOG_SPACING="    -"
    for w in "${WORKSPACES[@]}"
    do
        log "-> $w"
        cd "$w" || exit
        if [ ! -z "$create" ]; then
            ./build-workspace.bash -s "$LOG_SPACING" -d "$ROOT_WORKSPACE" || exit
        fi
        if [ ! -z "$install" ]; then
            ./install.bash -s "$LOG_SPACING" || exit
        fi
        if [ ! -z "$projects" ]; then
            ./get-projects.bash -s "$LOG_SPACING" -d "$ROOT_WORKSPACE" || exit
        fi
        cd ..
    done
fi
