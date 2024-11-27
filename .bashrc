# If not running interactively, don't do anything
[[ $- != *i* ]] && return
PS1='[\u@\h \W]\$ '

# Define Editor
export EDITOR=nvim

# -----------------------------------------------------
# ALIASES
# -----------------------------------------------------
alias c='clear'
alias q='exit'
alias nf='fastfetch'
alias pf='fastfetch'
alias ff='fastfetch'
alias ls='eza -a --icons'
alias ll='eza -al --icons'
alias lt='eza -a --tree --level=1 --icons'
alias shutdown='systemctl poweroff'
alias wifi='nmtui'
alias fcd='cd $(find * -type d | fzf)'
alias mic-playback-on='pactl load-module module-loopback latency_msec=1000'
alias mic-playback-off='pactl unload-module module-loopback'
alias screenshot-copy='grim -g "$(slurp)" - | wl-copy'
alias screenshot-save='grim -g "$(slurp)" - | wl-copy'
alias hx='helix'
alias sf='fastfetch --config examples/8'
alias code='flatpak run com.visualstudio.code'

# -----------------------------------------------------
# GIT
# -----------------------------------------------------
alias gs="git status"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias gpl="git pull"
alias gst="git stash"
alias gsp="git stash; git pull"
alias gcheck="git checkout"
alias gcredential="git config credential.helper store"
alias glog='git log --decorate --oneline --graph'
alias gloog="git log --graph --pretty='''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
alias grh='git reset --soft HEAD~1'
alias gap='git commit --amend --no-edit'
alias gblame='git blame -w -C -C -C -L'

# -----------------------------------------------------
# SYSTEM
# -----------------------------------------------------
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'

# -----------------------------------------------------
# init bash programs
# -----------------------------------------------------

eval "$(starship init bash)" # Bash promt

# -----------------------------------------------------
# Fnctions
# -----------------------------------------------------
clean_except() {
  if [ -z "$1" ]; then
    echo "Usage: clean_except <extension>"
    return 1
  fi
  find . -maxdepth 1 -type f ! -name "*.$1" -delete
}

# Function to automate enabling clangd LSP support
setup_clangd_lsp() {
    # Ensure we're in a directory containing a CMakeLists.txt
    if [[ ! -f "CMakeLists.txt" ]]; then
        echo "Error: No CMakeLists.txt found in the current directory."
        return 1
    fi

    # Check if the compile_commands export line is already present
    if grep -q 'set(CMAKE_EXPORT_COMPILE_COMMANDS ON)' CMakeLists.txt; then
        echo '`set(CMAKE_EXPORT_COMPILE_COMMANDS ON)` is already present in CMakeLists.txt.'
    else
        echo 'Adding `set(CMAKE_EXPORT_COMPILE_COMMANDS ON)` to CMakeLists.txt...'

        # Insert the line after the `project(...)` line
        if grep -q '^project(' CMakeLists.txt; then
            # Use sed to append the line after the `project(...)` declaration
            sed -i '/^project(/a\
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)' CMakeLists.txt
        else
            echo "Warning: No 'project(...)' line found. Adding `set(CMAKE_EXPORT_COMPILE_COMMANDS ON)` to the top of the file."
            sed -i '1i set(CMAKE_EXPORT_COMPILE_COMMANDS ON)' CMakeLists.txt
        fi
    fi

    # Run the cmake command
    echo "Running cmake to generate compile_commands.json..."
    cmake -S . -G "Unix Makefiles" -B cmake

    # Check if the compile_commands.json was generated
    if [[ -f "cmake/compile_commands.json" ]]; then
        echo "Found compile_commands.json in cmake/ directory. Copying to project root..."
        cp cmake/compile_commands.json .
        echo "Successfully copied compile_commands.json to the project root."
    else
        echo "Error: compile_commands.json was not generated. Check the CMake configuration."
        return 1
    fi

    echo "Clangd LSP setup complete!"
}

# -----------------------------------------------------
# Fastfetch if on wm
# -----------------------------------------------------
if [[ $(tty) == *"pts"* ]]; then
  fastfetch --config examples/8
else
  echo
  if [ -f /bin/hyprctl ]; then
    echo "Start Hyprland with command Hyprland"
  fi
fi
. "$HOME/.cargo/env"

export PATH=$HOME/.local/bin:$PATH
export PATH="/usr/lib/ccache/bin/:$PATH"

if [ -d "/home/dudos/.cargo/bin" ]; then
  export PATH="/home/dudos/.cargo/bin:$PATH"
fi

[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
eval "$(atuin init bash)"

export MANPAGER='nvim +Man!'

export WASMTIME_HOME="$HOME/.wasmtime"

export PATH="$WASMTIME_HOME/bin:$PATH"
