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

# print $1 in green
function logWOTag () {
    echo -e -n "${GREEN}"; echo -n "$1"; echo -e "${NC}"
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

## clone given repo
# $1 : git repo, git@github.com:USER/REPO-NAME.git
# $2 : repo destination path
function clone () {
    logWOTag "     [cloning] $1"
    git clone $1 $2
}

## pulling repo from github
# $1 : path on which call git pull
function pull () {
    logWOTag "     [pulling] $1"
    git -C $1 pull origin master
}

if [ "$1" = "-h" ] || [ "$1" = "--help"  ]; then                                
    echo "Script used to get or pull projects from repositories."
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

# TODO add more java projects
repos_name_github=( 
    JDrive
    it.unitn.disi.firstplugin
)

log "getting/pulling repositories..."
logWOTag "     unlocking keys..."
ssh-add -t 90 2>/dev/null || exit

for repo_name in "${repos_name_github[@]}"
do
    REPO_DST="$1"/java/"$repo_name"
    if [ -d "$REPO_DST" ]; then
        pull $REPO_DST
    else
        clone "git@github.com:AndreaGhizzoni"/$repo_name.git $REPO_DST
    fi
done

