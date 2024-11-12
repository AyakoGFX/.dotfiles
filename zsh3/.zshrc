# setting variable's
export TERM="xterm-256color"

# my prompt
# Enable colors and change prompt:
autoload -U colors && colors	# Load colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
setopt autocd		# Automatically cd into typed directory.
stty stop undef		# Disable ctrl-s to freeze terminal.
setopt interactive_comments

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# History in cache directory:
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"
setopt inc_append_history

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



# Replace ls with eza
alias ls='eza -al --color=always --group-directories-first --icons' # preferred listing
alias la='eza -a --color=always --group-directories-first --icons'  # all files and dirs
alias ll='eza -l --color=always --group-directories-first --icons'  # long format
alias lt='eza -aT --color=always --group-directories-first --icons' # tree listing
alias l.='eza -ald --color=always --group-directories-first --icons .*' # show only dotfiles

# Common use
alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'
alias ..... 'cd ../../../..'
alias ...... 'cd ../../../../..'
alias big 'expac -H M "%m\t%n" | sort -h | nl'     # Sort installed packages according to size in MB (expac must be installed)
alias dir 'dir --color=auto'
alias fixpacman 'sudo rm /var/lib/pacman/db.lck'
alias gitpkg 'pacman -Q | grep -i "\-git" | wc -l' # List amount of -git packages
alias grep 'ugrep --color=auto'
alias egrep 'ugrep -E --color=auto'
alias fgrep 'ugrep -F --color=auto'
alias grubup 'sudo update-grub'
alias hw 'hwinfo --short'                          # Hardware Info
alias ip 'ip -color'
alias psmem 'ps auxf | sort -nr -k 4'
alias psmem10 'ps auxf | sort -nr -k 4 | head -10'
alias rmpkg 'sudo pacman -Rdd'
alias tarnow 'tar -acf '
alias untar 'tar -zxvf '
alias upd '/usr/bin/garuda-update'
alias vdir 'vdir --color=auto'
alias wget 'wget -c '

# Get fastest mirrors
alias mirror 'sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist'
alias mirrora 'sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist'
alias mirrord 'sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist'
alias mirrors 'sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist'

# Get the error messages from journalctl
alias jctl 'journalctl -p 3 -xb'

# Recent installed packages
alias rip 'expac --timefmt="%Y-%m-%d %T" "%l\t%n %v" | sort | tail -200 | nl'

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

# kill 
alias k='kill $(xprop | grep -i _NET_WM_PID | awk '\''{print $3}'\'')'

# alias chmod commands
alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

# To see if a command is aliased, a file, or a built-in command
alias checkcommand="type -t"

# Search command line history
alias h="history | grep "

# Search running processes
alias pp="ps aux | grep "
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"

eval "$(zoxide init zsh)"

# sudo nala install zsh-syntax-highlighting
# sudo nala install zsh-autosuggestions
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh 
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
