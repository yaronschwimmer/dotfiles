
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

function timestamp() {
    date +%s000
}

function killport()
{
    lsof -i :$1 | awk 'NR!=1{print $2}' | xargs kill -9
}

function b64() {
    echo -n "$1" | base64
}

function b64d() {
    echo -n "$1" | base64 -d
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
alias python='python3'
alias pip='pip3'
alias meld="/Applications/Meld.app/Contents/MacOS/Meld"
alias uuid="uuidgen | awk '{print tolower($1)}'"
alias bat='bat --style=changes,numbers'
alias cat=bat
alias vi='nvim'
alias kc='kubectl'


###################################
######## Environment ##############
###################################

HISTCONTROL=ignoredups:erasedups  # no duplicate entries
HISTSIZE=100000                   # big big history
HISTFILESIZE=100000               # big big history
SAVEHIST=100000
setopt share_history
setopt histignoredups
export LANG=en_US.UTF-8

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

# Case insensitive completions
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
autoload -Uz compinit && compinit

# Credentials
if [ -f "/Users/yaron/.credentials" ]; then
    source /Users/yaron/.credentials
fi


eval "$(fnm env --use-on-cd)"

fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
    compinit
done
compinit -C

eval "$(jump shell --bind=z)"


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/yaron/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/yaron/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/yaron/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/yaron/google-cloud-sdk/completion.zsh.inc'; fi

export PATH="/usr/local/opt/binutils/bin:$PATH"

# Antigen
source /usr/local/share/antigen/antigen.zsh
antigen init ~/.antigenrc

# starship prompt
eval "$(starship init zsh)"
