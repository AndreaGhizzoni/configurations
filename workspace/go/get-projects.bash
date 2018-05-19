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
    echo -e "Usage: $0 [-s|--spacing] [-d|--destination]"
    echo -e "Example: $0 -s \"  \" -d /home/pippo/work/java"
    exit 1
}

## print some help string and call usageAndExit
function printHelp () {
    echo "Script used to pull or clone all go project into workspace."
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

OPTIONS=hd:s:
LONGOPTIONS=help,destination:,spacing:
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
        -d|--destination)
            destination="$2"
            shift 2
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

# check if -d "destination" flag is set
if [ -z "$destination" ]; then
    #echo -e -n "$spacing"; logError "-d flag missing."
    logError "-d flag missing." "$spacing"
    exit 1
fi

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
dep_req=( git )
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

## clone given repo
# $1 : git repo, git@github.com:USER/REPO-NAME.git
# $2 : repo destination path
function clone () {
    log "[cloning] $1" "$spacing$spacing"
    git clone "$1" "$2"
}

## pulling repo from github
# $1 : path on which call git pull
function pull () {
    log "[pulling] $1" "$spacing$spacing"
    git -C "$1" pull origin master
}

## get go project in the right way
# $1 : github repository path like github.com/<USER>/<REPO>
function goget () {
    log "[getting] $1" "$spacing$spacing"
    /usr/local/go/bin/go get "$1"
}

repos_name_github=( 
    factorial
    zenium
    independent-set
    coins-change
    film-scan
    LCS
    gin-app
    go-docker
    gos
    go-introduction
    sentinel
)

log "getting/pulling repositories..." "$spacing"
log "unlocking keys..." "$spacing$spacing"
ssh-add -t 90 2>/dev/null || exit

origin=$(pwd)
cd "$destination"/go/src || exit
for repo_name in "${repos_name_github[@]}"
do
    REPO_DST=github.com/AndreaGhizzoni/"$repo_name"
    if [ -d "$REPO_DST" ]; then
        pull "$REPO_DST"
    else
        goget "$REPO_DST"
    fi
done
cd "$origin" || exit

