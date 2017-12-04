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
if [ "$EUID" -eq 0 ]; then
    logError "$0 is not necessary to run this as root."
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
dep_req=( git python-fontforge )
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

log "=== GETTING NERD FONTS..."
git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git nerd-fonts
cd nerd-fonts || exit

log "=== INSTALLING BASE FONTS (sudo password required)..."
sudo apt-get install fonts-font-awesome \
                     fonts-freefont-otf \
                     fonts-freefont-ttf
# all installed fonts should be under /usr/share/fonts
FONT_BASE_NAME=FreeMono.ttf
cp /usr/share/fonts/truetype/freefont/$FONT_BASE_NAME .

log "=== PATCHING $FONT_BASE_NAME ..."
cp ../../glyphs/my-glyphs.ttf src/glyphs
./font-patcher --complete --use-single-width-glyphs --careful \
    --custom my-glyphs.ttf \
    $FONT_BASE_NAME

FONT_PATCHED_NAME="FreeMono Nerd Font Complete Mono.ttf"
mkdir -p "$HOME"/.local/share/fonts/
cp "$FONT_PATCHED_NAME" "$HOME"/.local/share/fonts/

log "=== UPDATE FONTS CACHE..."
fc-cache -fr --really-force

log "=== to list the installed font use: fc-list | grep FreeMono | grep .local"
log "=== using uxterm/.Xresources to apply generated font to terminal emulator."
log "=== FINISH! ==="
