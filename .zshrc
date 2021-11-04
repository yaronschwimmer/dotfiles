#zmodload zsh/zprof
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/yaron/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="zsh2000"
ZSH_THEME="yaron"
#ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    docker
    docker-compose
    golang
    zsh-autosuggestions
    #    zsh-syntax-highlighting
)
#export ZSH_HIGHLIGHT_MAXLENGTH=60
source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
###################################################
#########  Aliases and functions ##################
###################################################
function fawk {
    if [ -n "${2}" ]; then
        delim="-F \"${2}\""
    fi
    first="awk $delim '{print "
    last="}'"
    cmd="${first}\$${1}${last}"
    eval $cmd
}

# instead of typing 'cd ../..' write 'up 2'
function up()
{
    local d=""
    limit=$1
    for ((i=1 ; i <= limit ; i++))
    do
        d=$d/..
    done

    d=$(echo $d | sed 's/^\///')
    if [ -z "$d" ]; then
        d=..
    fi
    cd $d
}

function _calc {
    _arguments -C \
        "1: :(expression)" \
        "2: :(precision)"
    }

function calc() {
    expr=$1
    p=$2
    if [ -z $p ]; then
        p=0
    fi
    bc -l <<< "scale=$p; $expr"
}
compdef _calc calc

function timestamp() {
    date +%s000
}

function killport()
{
    lsof -i :$1 | awk 'NR!=1{print $2}' | xargs kill -9
}

alias ls='exa'
alias ll='ls -ahlF'
alias la='ls -A'
alias l='ll -CFh'
alias lh='ls -h'

alias cd..='cd ..'
alias gti='git'
alias ndoe='node'
alias path='echo -e ${PATH//:/\\n}'

alias here='open "`pwd`"'

alias dockerrm='docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)'
alias dockerstop='docker stop $(docker ps -aq)'

alias pbc=pbcopy
alias pbp=pbpaste
alias pjq='pbpaste | jq .'

alias sssh='ssh -q -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'
# alias python='python3'
# alias pip='pip3'
alias meld="/Applications/Meld.app/Contents/MacOS/Meld"
alias uuid="uuidgen | awk '{print tolower($1)}'"
alias bat='bat --style=changes,numbers'
alias cat=bat
alias vi='nvim'
alias kc='kubectl'

###################################
######## Environment ##############
###################################

export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history

export GOPATH=$HOME/work/go
export PATH=$PATH:$HOME/bin
export PATH=$PATH:$(go env GOPATH)/bin
export PATH=$PATH:$HOME/caddy
export PATH=$PATH:$HOME/ngrok
export PATH=$PATH:$HOME/work/scripts
export PATH=$PATH:$HOME/dev/flutter/bin/
export ANDROID_HOME=$HOME/Library/Android/sdk/
export PATH=${PATH}:$HOME/Library/Android/sdk/tools
export JAVA_HOME=/Library/Java/JavaVirtualMachines/openjdk.jdk/Contents/Home

export GPG_TTY=$(tty)

# Credentials
if [ -f "/Users/yaron/.credentials" ]; then
    source /Users/yaron/.credentials
fi

#export NVM_DIR=~/.nvm

#source $(brew --prefix nvm)/nvm.sh
eval "$(fnm env)"

#nvm() {
#    echo "🚨 NVM not loaded! Loading now..."
#    unset -f nvm
#    export NVM_PREFIX=$(brew --prefix nvm)
#    [ -s "$NVM_PREFIX/nvm.sh" ] && . "$NVM_PREFIX/nvm.sh"
#    nvm "$@"
#}

fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
    compinit
done
compinit -C

#if [ -f $(brew --prefix)/etc/profile.d/z.sh ]; then source $(brew --prefix)/etc/profile.d/z.sh; fi
eval "$(jump shell --bind=z)"

#zprof

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/yaron/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/yaron/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/yaron/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/yaron/google-cloud-sdk/completion.zsh.inc'; fi


