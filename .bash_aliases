alias ls='ls --color=auto'
alias ll='ls -lav --ignore=.?*'   # show long listing of all except ".."
alias l='ls -lav --ignore=.?*'   # show long listing but no hidden dotfiles except "."
alias la='ls -la'   # show long listing but no hidden dotfiles except "."
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias gs='git status'
alias gf='git fetch'
alias gc='git clone'
alias gd='git pull'
alias ga='git add'
alias gm='git commit -m'
alias gp='git push'

alias nf='neofetch'
alias c='clear'
alias q='exit'
alias clock='tty-clock'

alias mpv='flatpak run io.mpv.Mpv'
alias discord='flatpak run com.discordapp.discord'
alias spotify='flatpak run com.spotify.Client'
alias insomnia='flatpak run rest.insomnia.insomnia'

alias mic-playback-on='pactl load-module module-loopback latency_msec=1000'
alias mic-playback-off='pactl unload-module module-loopback'

