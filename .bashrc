#
# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ -f ~/.welcome_screen ]] && . ~/.welcome_screen

_set_my_PS1() {
    PS1='[\u@\h \W]\$ '
    if [ "$(whoami)" = "liveuser" ] ; then
        local iso_version="$(grep ^VERSION= /usr/lib/endeavouros-release 2>/dev/null | cut -d '=' -f 2)"
        if [ -n "$iso_version" ] ; then
            local prefix="eos-"
            local iso_info="$prefix$iso_version"
            PS1="[\u@$iso_info \W]\$ "
        fi
    fi
}
_set_my_PS1
unset -f _set_my_PS1

ShowInstallerIsoInfo() {
    local file=/usr/lib/endeavouros-release
    if [ -r $file ] ; then
        cat $file
    else
        echo "Sorry, installer ISO info is not available." >&2
    fi
}


[[ "$(whoami)" = "root" ]] && return

[[ -z "$FUNCNEST" ]] && export FUNCNEST=100          # limits recursive functions, see 'man bash'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac



## Use the up and down arrow keys for finding a command in history
## (you can write some initial letters of the command first).
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

#
. "$HOME/.cargo/env"

function py {
    python3 -c "from math import *; print($*)"
}

function spell() {
    local candidates oldifs word array_pos
    oldifs="$IFS"
    IFS=':'

    # Parse the apsell format and return a list of ":" separated words
    read -a candidates <<< "$(printf "%s\n" "$1" \
        | aspell -a \
        | awk -F':' '/^&/ {
            split($2, a, ",")
            result=""
            for (x in a) {
                gsub(/^[ \t]/, "", a[x])
                result = a[x] ":" result
            }
            gsub(/:$/, "", result)
            print result
        }')"

    # Reverse number and print the parsed bash array because the list comes
    # out of gawk backwards
    for item in "${candidates[@]}"; do
        printf '%s\n' "$item"
    done \
        | tac \
        | nl \
        | less -FirSX

    printf "[ $(tput setaf 2)?$(tput sgr0) ]\t%s" \
        'Enter the choice (empty to cancel, 0 for input): '
    read index

    [[ -z "$index" ]] && return
    [[  "$index" == 0 ]] && word="$1"

    [[ -z "$word" ]] && {
        array_pos=$(( ${#candidates[@]} - index ))
        word="${candidates[$array_pos]}"
    }

    [[ -n "$word" ]] && {
        printf "$word" | xsel -p
        printf "Copied '%s' to clipboard!\n" "$word"
    } || printf "[ $(tput setaf 1):($(tput sgr0) ] %s\n" 'No match found'


    IFS="$oldifs"
}

export PATH=$PATH:$HOME/.local/bin
eval "$(starship init bash)"
