# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="my"

# Which plugins would you like to load? 
# (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# git       : for aliases and functions
# gradle    : add auto-complete for task
# sublime   : "st" for open file in Sublime, "stt" for open current dir
# cp        : cp with progress bar (rsync)
# gitignore : gi() alias to fetch default .gitignore files from gitignore.io
# history   : "h" for view the history, "hsi" for grep history
plugins=(git gradle sublime cp gitignore history)

source $ZSH/oh-my-zsh.sh
unsetopt SHARE_HISTORY
setopt INC_APPEND_HISTORY

# Customize to your needs...
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games
unsetopt correct_all

#========== ALIAS  more alias and stuff here: https://goo.gl/C7lsbI
#common
alias cc="clear"
alias lla="ls -lah --group-directories-first"
alias extip='curl ifconfig.me'
alias httpserver='ifconfig && python -m SimpleHTTPServer 8000'
alias pg='ping -v 8.8.8.8'
alias ns='netstat -tlnp'
alias ssdtop='sudo iotop --only'
alias update='sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y'
alias prettyjson='python -m json.tool'
alias checkpass='chracklib-check'
#git
alias gl='git log --pretty=format:"%Cgreen%h %Creset %s %Cblueby %an (%ar) %Cred %d" --graph'
alias gd='git diff --stat --color'
alias ga='git add --all .'
alias gb="git branch \$1"
alias gu="git pull"
alias gp="git push"
alias gc="git commit -m \$1"
alias gs="git show --pretty --show-signature"

#========== Android
#export NDK=/home/andrea/Android/android-ndk-r10d/
#export PATH=$PATH:$NDK
#export TOOLS=/home/andrea/Android/Sdk/tools/
#export PATH=$PATH:$TOOLS

#========== Java
# fedora
#export JAVA_HOME=/usr/java/latest/
# ubuntu
#export JAVA_HOME=/usr/lib/jvm/java-8-oracle/
#export PATH=$PATH:$JAVA_HOME/bin

#========== Groovy
#export GROOVY_HOME=/opt/groovy
#export PATH=$PATH:$GROOVY_HOME/bin

#========== Grails
#export GRAILS_HOME=/opt/grails
#export PATH=$PATH:$GRAILS_HOME/bin

#========== Gradle
#export GRADLE_HOME=/opt/gradle
#export PATH=$PATH:$GRADLE_HOME/bin

#========== Go
#export GOOS=linux
#export GOARCH=amd64
#export GOROOT=/usr/local/go
#export PATH=$PATH:$GOROOT/bin

#========== Workspaces
#export CPPPATH=~/Documents/workspace/cpp/
#export JAVAPATH=~/Documents/workspace/java/
#export GOPATH=$HOME/Documents/workspace/go
#export GOBIN=$GOPATH/bin
#export PATH=$PATH:$GOPATH/bin
#export CPATH=~/Documents/workspace/c/

#=========== workaround stuff
#alias grep="/usr/bin/grep $GREP_OPTIONS"
#unset GREP_OPTIONS
