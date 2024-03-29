#!/bin/bash

while test $# -gt 0; do
    case "$1" in
        -h|--help) echo "Usage: $0 [-h|--help] [-f|--force] [-d|--dry-run]"; exit 0;;
        -f|--force) FORCE=1;;
        -d|--dry-run) DRY=1;;
        *);;
    esac
    shift
done

if [ ! -z "$DRY" ]; then
    echo "Dry Run"
    unset FORCE
fi

if [ ! -z "$FORCE" ]; then
    echo "Forcing install"
fi

## Terminal Colors
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
RESET="\033[0;0m"

DOTFILES_FAIL=0

make_link() {
    TO_INSTALL=$1
    INSTALL_TO=$2

    if [ -z "$DRY" ]; then
        ln -s -f $TO_INSTALL $INSTALL_TO || DOTFILES_FAIL=1
    fi

    echo -e "${YELLOW}Link created${RESET} for ${CYAN}$INSTALL_TO${RESET} -> $TO_INSTALL"
}

try_link() {
    TO_INSTALL=$1
    INSTALL_TO=$2

    # Check if $INSTALL_TO already exists and is a symbolic link
    if [ -L $INSTALL_TO ]; then
        # Check if the symbolic link matches the install file
        if [ "$INSTALL_TO" -ef "$TO_INSTALL" ]; then
            echo -e "${GREEN}Already Installed${RESET}: ${CYAN}$TO_INSTALL${RESET} -> $INSTALL_TO"
        else
            if [ -z "$FORCE" ]; then
                echo -e "${RED}Warning${RESET}: Symbolic link already exists and does not match: ${CYAN}$INSTALL_TO${RESET} -> $(readlink $INSTALL_TO) expected $TO_INSTALL"
            else
                make_link $TO_INSTALL $INSTALL_TO
            fi
        fi
    elif [ -d $INSTALL_TO ]; then
        echo -e "${RED}Warning${RESET}: Directory already exists: $INSTALL_TO"
    elif [ -f $INSTALL_TO ]; then
        echo -e "${RED}Warning${RESET}: File already exists: $INSTALL_TO"
    else
        make_link $TO_INSTALL $INSTALL_TO
    fi
}

try_install() {
    # Try to install a symbolic link to $TO_INSTALL at the path $INSTALL_TO
    # if $INSTALL_TO is not provided, $HOME/.$TO_INSTALL is used as the default

    # The file or directory from linuxconf to install
    TO_INSTALL=$1

    # Where to install the file or directory
    INSTALL_TO=$2

    # If $INSTALL_TO is not provided, use $HOME/.$TO_INSTALL as the default
    if [ -z "$INSTALL_TO" ]; then
        INSTALL_TO="$HOME/.$TO_INSTALL"
    fi

    # Make $TO_INSTALL an absolute path
    TO_INSTALL="$(pwd)/files/$TO_INSTALL"

    try_link $TO_INSTALL $INSTALL_TO
}

try_install clang-format
try_install gdbinit
#try_install gitconfig
# try_install inputrc
try_install LESS_TERMCAP
#try_install restic_exclude
try_install Xdefaults

# try_install config/nvim
# try_install config/termite
# try_install scripts

mkdir -p $HOME/.config/termite
try_link $(pwd)/files/config/termite/onedark $HOME/.config/termite/config

try_link $HOME/.config/nvim $HOME/.vim
try_link $HOME/.vim/init.vim $HOME/.vimrc
try_link $HOME/.Xdefaults $HOME/.Xresources 

exit $DOTFILES_FAIL
