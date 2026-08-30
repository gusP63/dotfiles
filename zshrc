alias ODIN_ROOT="~/Builds/odin"
export PATH="$ODIN_ROOT:$PATH"
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="evan"
#PROMPT='%F{cyan}%~%f %F{gray}>%f '

PROMPT_COMMAND='echo -e -n "\\x1b[5 q"'
precmd() { eval "$PROMPT_COMMAND" }

zstyle ':omz:update' mode disabled  # disable automatic updates
DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="false"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="dd/mm/yyyy"
plugins=(
    zoxide 
    colored-man-pages
    history-substring-search
    sudo
    timer
    zsh-autosuggestions
    fast-syntax-highlighting
)

# User configuration
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

alias day="ps aux | grep foot | awk '{print $2}' | head -n 1 | xargs kill -s SIGUSR2 &> /dev/null"
alias night="ps aux | grep foot | awk '{print $2}' | head -n 1 | xargs kill -s SIGUSR1 &> /dev/null"

alias v="nvim"
alias notes="cd ~/Notes && nvim -S .sess.vim -c 'colorscheme retrobox' -c 'set wrap' -c 'set linebreak'"
alias vi="nvim --noplugin"

alias dot="git -C $DOTS"
alias vimrc="nvim $DOTS/config/nvim/init.lua"
alias zshrc="nvim $DOTS/zshrc"
alias fishrc="nvim $DOTS/config/fish/config.fish"
alias hyprrc="nvim $DOTS/config/hypr/"
alias waybarrc="nvim $DOTS/config/waybar/"
alias rofirc="nvim $DOTS/config/rofi/config.rasi"
alias footrc="nvim $DOTS/config/foot/foot.ini"
alias tmuxrc="nvim ~/.tmux.conf"
alias pianotermrc="nvim $DOTS/config/pianoterm/config"
alias sshrc="nvim $HOME/.ssh/config"
alias sourcerc="source $HOME/.zshrc"

alias sysupdate="bash $DOTS/config/user/scripts/system_update.sh"
alias obsidian="nvim $HOME/Vault"
alias playswitch="gamemoderun $MEDIA/Games/ryujinx/publish/Ryujinx"
alias clonesite="wget --mirror --convert-links --adjust-extension --page-requisites --no-parent"
alias scratch='nvim $(mktemp)'
alias chat='$HOME/.config/scripts/local_chat.sh'
alias serve="kiwix-serve -d -p 1024 $MEDIA/Kiwix/wikipedia_en_all_maxi_2026-02.zim $MEDIA/Kiwix/archlinux_en_all_maxi_2025-09.zim"
alias wifi_enable="sudo $HOME/.config/scripts/wifi_on.sh"
alias wifi_disable="sudo $HOME/.config/scripts/wifi_off.sh"
alias hypnosis="mpv $HOME/Documents/hypnosis.webm"

function touchsh () {
    touch $1
    chmod +x $1
    echo '#!/bin/bash' >> $1
}

#bindkey '^F' forward-char

export ANDROID_HOME="$HOME/Builds/android-sdk"
export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8
source $ZSH/oh-my-zsh.sh

bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
