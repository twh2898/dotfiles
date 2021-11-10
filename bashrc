#
# ~/.bashrc
#

## Environment

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Path
export PATH="$PATH:$HOME/.local/bin:$HOME/.scripts"

# SSH Auth
if [[ ! -f $XDG_RUNTIME_DIR/ssh-agent.env ]]; then
    ssh-agent > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi

if [[ ! "$SSH_AUTH_SOCK" ]]; then
    eval "$(<"$XDG_RUNTIME_DIR/ssh-agent.env")"
fi

# Theme and Background
if [[ -f "~/.themerc" ]]; then
    . ~/.themerc
fi

## Aliases

# restic backup
alias rrestic="RESTIC_PASSWORD_FILE=$HOME/.restic_pass restic -r sftp:tom-lan.local:/home/deepstorage/restic"
alias rbackup="rrestic -v backup --exclude-file $HOME/.restic_exclude $HOME --tag tom-pc"

# Execute systemctl as sudo
alias ss='sudo systemctl'

# ls with human redable, color and directories first
alias ls='ls -h --color=always --group-directories-first'

# ls shorthand
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'

# Clear and ls shorthand
alias cls='clear && ls'
alias cll='clear && ll'
alias cla='clear && la'
alias clla='clear && lla'

# Human redable df and du
alias df='df -h'
alias du='du -h'

# Less use raw control caracters (allow color)
alias less='less -r'

# gcc and g++ color output
alias gcc='gcc -fdiagnostics-color=always'
alias g++='g++ -fdiagnostics-color=always'

# color grep
alias grep="grep --color=auto"

# Quick sync local branch with remote branch
# eg. gsync local master
gsync() {
    if [ $# -eq 0 ]; then
        echo "Usage: gsync <from> [to=master]"
    else
        FROM=$1
        TO=$2
        if [ -z "$TO" ]; then
            TO=master
        fi
        git checkout $TO &&
            git pull &&
            git checkout $FROM &&
            git rebase $TO &&
            git checkout $FROM &&
            git merge $TO &&
            git push &&
            git checkout $FROM
    fi
}
#export -f gsync

# Git shorthand
alias gl='git log --oneline --graph --decorate --branches'
alias gla='gl --all'
alias gs='git status'
alias gd='git diff'
alias ga='git add'
alias c='git commit -am'
alias ca='git add . && git commit -m'
alias gc='git commit'
alias gcm='git commit -m'

## mkn bash complete

complete -W "$(ls --color=never ~/.scripts/templates/)" mkn

## Terminal Colors
escaped() {
    echo -e "\001\e[$1m\002"
}

# Set
BOLD=$(escaped 1)
BRIGHT=$BOLD
DIM=$(escaped 2)
ITALIC=$(escaped 3)
UNDERLINE=$(escaped 4)
BLINK=$(escaped 5) # This does not work in most terminal emulators?
REVERSE=$(escaped 7)
HIDDEN=$(escaped 8) # Usefull for passwords

# Reset
RESET=$(escaped 0)
RESET_BOLD=$(escaped 21)
RESET_BRIGHT=$RESET_BOLD
RESET_DIM=$(escaped 22)
RESET_ITALIC=$(escaped 23)
RESET_UNDERLINE=$(escaped 24)
RESET_BLINK=$(escaped 25)
RESET_REVERSE=$(escaped 27)
RESET_HIDDEN=$(escaped 28)

# Foreground
DEFAULT=$(escaped 39)
BLACK=$(escaped 30)
RED=$(escaped 31)
GREEN=$(escaped 32)
YELLOW=$(escaped 33)
BLUE=$(escaped 34)
MAGENTA=$(escaped 35)
CYAN=$(escaped 36)
LIGHT_GRAY=$(escaped 37)
GRAY=$(escaped 90)
LIGHT_RED=$(escaped 90)
LIGHT_GREEN=$(escaped 92)
LIGHT_YELLOW=$(escaped 93)
LIGHT_BLUE=$(escaped 94)
LIGHT_MAGENTA=$(escaped 95)
LIGHT_CYAN=$(escaped 96)
WHITE=$(escaped 97)

# Foreground
BG_DEFAULT=$(escaped 49)
BG_BLACK=$(escaped 40)
BG_RED=$(escaped 41)
BG_GREEN=$(escaped 42)
BG_YELLOW=$(escaped 43)
BG_BLUE=$(escaped 44)
BG_MAGENTA=$(escaped 45)
BG_CYAN=$(escaped 46)
BG_LIGHT_GRAY=$(escaped 47)
BG_GRAY=$(escaped 100)
BG_LIGHT_RED=$(escaped 100)
BG_LIGHT_GREEN=$(escaped 102)
BG_LIGHT_YELLOW=$(escaped 103)
BG_LIGHT_BLUE=$(escaped 104)
BG_LIGHT_MAGENTA=$(escaped 105)
BG_LIGHT_CYAN=$(escaped 106)
BG_WHITE=$(escaped 107)

## PS1 Line

# Display git branch if in repo
check_git() {
    git branch 2>&1 | grep -i "^\*"
}

# Display ssh user and hostname if in ssh session
# This must be on the machine being ssh'd into
check_ssh() {
    if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
        echo -e " ${GRAY}\u@\h"
    fi
}

# Full PS1 line
#export PS1="${RED}[${YELLOW}\u${GREEN}@${CYAN}\h ${MAGENTA}\w${RED}]${YELLOW}\$(check_git)${RESET}\n${YELLOW}\$(check_ssh)${WHITE}\$ ${RESET}"

# Minimal PS1 line
export PS1="${RED}[${MAGENTA}\w${RED}]${YELLOW}\$(check_git)$(check_ssh)${WHITE}\$ ${RESET}"
