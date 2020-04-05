#!/usr/bin/env bash

# color declaration.
L_CYAN='\033[1;36m'
#GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No color

## print $1 in green.                                                           
# $1  something to print in GREEN on stdout
function log () {
    echo -e -n "$2"; echo -e -n "${L_CYAN}==> ${NC}"; echo "$1"
}

## clone given repo
# $1   url  git@github.com
# $2   user  AndreaGhizzoni
# $3   remo-name  something
function clone () {
    log "[cloning] $1 $2/$3.git into $(pwd)"
    git clone -q "$1":"$2"/"$3".git "$3" || exit 1
}

ssh-add -t 1800 2>/dev/null || exit 1

mkdir java || exit 1
cd java
clone git@github.com AndreaGhizzoni nn
clone git@github.com AndreaGhizzoni graph
clone git@github.com AndreaGhizzoni tree
clone git@github.com AndreaGhizzoni sudoku
clone git@github.com AndreaGhizzoni subsetK
clone git@github.com AndreaGhizzoni JDrive
clone git@github.com AndreaGhizzoni ASDPlayGround
clone git@github.com AndreaGhizzoni Application-Util
clone git@github.com AndreaGhizzoni AUTO
clone git@github.com AndreaGhizzoni Network-Util
clone git@github.com AndreaGhizzoni Simple-Logger
clone git@github.com AndreaGhizzoni Monitoring
clone git@github.com AndreaGhizzoni IOUtil
clone git@github.com AndreaGhizzoni JXSwingPlus
clone git@github.com AndreaGhizzoni mtg
cd ..

mkdir uni || exit 1
cd uni
clone git@github.com AndreaGhizzoni thesis
clone git@github.com AndreaGhizzoni networks_course
clone git@github.com AndreaGhizzoni lfc_course
clone git@github.com AndreaGhizzoni asd_course
clone git@github.com AndreaGhizzoni prog-1_course
clone git@github.com AndreaGhizzoni fp_course
clone git@github.com AndreaGhizzoni dis2_course
clone git@github.com AndreaGhizzoni dis1_course
clone git@github.com AndreaGhizzoni db_course
clone git@github.com AndreaGhizzoni cps_course
clone git@github.com AndreaGhizzoni LFC2015-2016
clone git@github.com AndreaGhizzoni OSproject
cd ..

mkdir latex || exit 1
cd latex
clone git@github.com AndreaGhizzoni latex-templates
clone git@github.com AndreaGhizzoni business-card
clone git@github.com AndreaGhizzoni my-cv
cd ..

mkdir web || exit 1
cd web
clone git@github.com AndreaGhizzoni andreaghizzoni.github.io
cd ..

mkdir arduino || exit 1
cd arduino
clone git@github.com AndreaGhizzoni arduino-madness
cd .. 

clone git@github.com AndreaGhizzoni configurations
clone git@github.com AndreaGhizzoni ide-cfg-files
clone git@github.com AndreaGhizzoni tty-clock
clone git@github.com AndreaGhizzoni horst
clone git@github.com AndreaGhizzoni kali-live-build-configurator


















