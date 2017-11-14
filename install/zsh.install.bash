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
dep_req=( git curl )
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

# script logic start here
USER=andrea

log "=== INSTALL ZSH..."
apt-get install zsh

log "=== Changing shell for user $USER..."
chsh -s /bin/zsh $USER
log "=== shell changed!"

if [ -d "$HOME/.oh-my-zsh" ]; then
    logError "$HOME/.oh-my-zsh already exists. Skip download and configuration"
else
    log "=== INSTALLING oh-my-zsh..."
    su - $USER -c "curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh"
    cp ../zsh/my.zsh-theme "$HOME"/.oh-my-zsh/themes

    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git 
    mv zsh-syntax-highlighting "$HOME"/.oh-my-zsh/custom/plugins/
fi

read -p "Do you want to copy zshrc in $HOME ? [Y/n] " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
    cp ../zsh/.zshrc "$HOME"
    chown -R "$USER":"$USER" "$HOME"/.zshrc
fi

log "=== FINISH! (reboot needed)"