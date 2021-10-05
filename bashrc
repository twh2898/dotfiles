#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


## Path

export PATH="$PATH:$HOME/.local/bin:$HOME/.scripts"

## SSH Auth
if [[ ! -f $XDG_RUNTIME_DIR/ssh-agent.env ]]; then
	ssh-agent > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi

if [[ ! "$SSH_AUTH_SOCK" ]]; then
	eval "$(<"$XDG_RUNTIME_DIR/ssh-agent.env")"
fi

## Theme and Background

if [[ ! -f ~/.last_background ]]; then
    echo light > ~/.last_background
fi

function light() {
    . ~/.scripts/change_theme light
}

function gray() {
    . ~/.scripts/change_theme gray
}

function dark() {
    . ~/.scripts/change_theme dark
}

export BACKGROUND=$(cat ~/.last_background)
export -f light
export -f gray
export -f dark

## Aliases

alias ss='sudo systemctl'

alias ls='ls -h --color=always --group-directories-first'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'

alias cls='clear && ls'
alias cll='clear && ll'
alias cla='clear && la'
alias clla='clear && lla'

alias ping4='ping -c 4'
alias pingg='ping4 google.com'
alias ping8='ping4 8.8.8.8'

alias df='df -h'
alias du='du -h'

alias less='less -r'

alias gcc='gcc -fdiagnostics-color=always'
alias g++='g++ -fdiagnostics-color=always'

alias push='git push'
alias pull='git pull'
alias merge='git merge'
alias commit='git commit'
alias checkout='git checkout'
alias gsync='git checkout master && git pull && git merge local && git push'
alias gl='git log --oneline --graph --decorate --branches'
alias gs='git status'
alias gd='git diff'
alias ga='git add'
alias c='git commit -am'
alias ca='git add . && git commit -m'
alias gc='git commit'
alias gcm='git commit -m'

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

check_git() {
	git branch 2>&1 | grep -i "^\*"
}

check_ssh() {
	if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
		#echo SSH
        echo -e "${GRAY}\u@\h "
	fi
}

# Full PS1 line
#export PS1="${RED}[${YELLOW}\u${GREEN}@${CYAN}\h ${MAGENTA}\w${RED}]${YELLOW}\$(check_git)${RESET}\n${YELLOW}\$(check_ssh)${WHITE}\$ ${RESET}"

# Minimal PS1 line
export PS1="${RED}[${MAGENTA}\w${RED}]${YELLOW}$(check_git) $(check_ssh)${WHITE}\$ ${RESET}"
