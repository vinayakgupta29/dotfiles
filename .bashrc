clear ; fastfetch 
# Add custom scripts directory to PATH
alias ls='ls --color=auto'

export PATH="$HOME/scripts:$PATH"

export PATH="$HOME/bin:$PATH"
# Add Flutter to PATH
export PATH="$HOME/flutter/flutter/bin:$PATH"

export PATH="$HOME/.local/share/gem/ruby/3.4.0/bin:$PATH"

export JAVA_HOME=/usr/lib/jvm/java-21-openjdk
export PATH=$JAVA_HOME/bin:$PATH

export XCURSOR_THEME="Anya cursor"
export XCURSOR_SIZE=24

# Define path to Google Chrome executable
export CHROME_EXECUTABLE="/opt/google/chrome/chrome"

# Source GHCup environment if it exists
[ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env" # ghcup-env

force_color_prompt=yes
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced


mountntfs() {
    if [ -z "$1" ]; then
        echo "Usage: mountntfs <device>"
        return 1
    fi
    sudo mount -t ntfs-3g "$1" /mnt/ntfs_partition/
}

PS1=' \[\e[1;32m\]\u\[\e[0m\] @ \[\e[1;32m\]\h \[\e[1;34m\]\w \n \[\e[38;5;178m\]\$\[\e[0m\] '

