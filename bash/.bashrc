if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'

# Add this to your ~/.bashrc
PS1="\[\e[1;31m\][\[\e[1;33m\]\u\[\e[1;32m\]@\[\e[1;34m\]\h \[\e[1;35m\]\w\[\e[1;31m\]]\[\e[0m\]$\[\e[0m\] "

export KITTY_FONT_FAMILY="FiraCode Nerd Font"
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export QT_QPA_PLATFORM="xcb"

export EDITOR=nano
export VISUAL=nano

#nix stuff
export NIXPKGS_ALLOW_UNFREE=1
# export XDG_DATA_DIRS="/home/$USER/.nix-profile/share:$XDG_DATA_DIRS"
# export XDG_DATA_DIRS=$HOME/.nix-profile/share:"${XDG_DATA_DIRS:/usr/share/}"
# export XDG_DATA_DIRS="/home/$USER/.nix-profile/share:$XDG_DATA_DIRS"
#
export XDG_DATA_DIRS="$HOME/.nix-profile/share:/nix/var/nix/profiles/default/share:$XDG_DATA_DIRS"



alias ls='eza -al --color=always --group-directories-first --icons' # preferred listing
alias la='eza -a --color=always --group-directories-first --icons'  # all files and dirs
alias ll='eza -l --color=always --group-directories-first --icons'  # long format
alias lt='eza -aT --color=always --group-directories-first --icons' # tree listing
alias l.='eza -ald --color=always --group-directories-first --icons .*' # show only dotfiles

# Common use
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias big='expac -H M "%m\t%n" | sort -h | nl'     # Sort installed packages according to size in MB (expac must be installed)
alias dir='dir --color=auto'
alias fixpacman='sudo rm /var/lib/pacman/db.lck'
alias gitpkg='pacman -Q | grep -i "\-git" | wc -l' # List amount of -git packages
alias grep='ugrep --color=auto'
alias egrep='ugrep -E --color=auto'
alias fgrep='ugrep -F --color=auto'
alias grubup='sudo update-grub'
alias hw='hwinfo --short'                          # Hardware Info
alias ip='ip -color'
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias rmpkg='sudo pacman -Rdd'
alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias upd='/usr/bin/garuda-update'
alias vdir='vdir --color=auto'
alias wget='wget -c '

# Get the error messages from journalctl
alias jctl='journalctl -p 3 -xb'

# Recent installed packages
alias rip='expac --timefmt="%Y-%m-%d %T" "%l\t%n %v" | sort | tail -200 | nl'

# Aliases
alias tree='tree -a -I .git'
alias nv='nvim'
alias pnv='env NVIM_APPNAME=prim-nvim nvim'
alias knv='env NVIM_APPNAME=kick-nvim nvim'
alias mnv='env NVIM_APPNAME=nvim-myown nvim'
alias xnv='env NVIM_APPNAME=nvim-0 nvim'
alias c='clear'
alias mkd='mkdir'
alias :q='exit'
alias tmux='tmux -u'
alias tr='tmux -u a'
alias ta='tmux -u attach -t'
alias tn='tmux new -su'
alias p='sudo pacman '
alias fix='setxkbmap -option caps:swapescape && xset r rate 250 60'
alias tldrf='tldr --list | fzf --preview "tldr {1}" --preview-window=right,60% | xargs tldr'
alias e='emacsclient -c'
# tools
alias lin='curl -fsSL https://christitus.com/linux | sh'
alias lindev='curl -fsSL https://christitus.com/linux | sh'

# Alias's to modified commands
alias cp='cp -i'
alias mv='mv -i'
alias rm='trash -v'
alias mkdir='mkdir -p'
alias ping='ping -c 10'
alias less='less -R'
alias freshclam='sudo freshclam'
alias se='sudoedit'

eval "$(zoxide init zsh)"
