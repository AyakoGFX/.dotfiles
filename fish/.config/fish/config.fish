# some usefull resource
# How do I set or clear an environment variable
# https://fishshell.com/docs/current/faq.html

set fish_greeting # Supresses fish's intro message
set TERM xterm-256color # Sets the terminal type

function fish_prompt
    set_color red --bold
    echo -n "["
    set_color yellow --bold
    echo -n (whoami)
    set_color green --bold
    echo -n "@"
    set_color blue --bold
    echo -n (hostname)
    echo -n " "
    set_color magenta --bold
    echo -n (pwd | string replace -r "^$HOME" "~" | string trim)
    set_color red --bold
    echo -n "]"
    set_color normal
    echo -n "\$ " # Correctly escape the dollar sign
end


# Replace ls with eza
alias ls 'eza -al --color=always --group-directories-first --icons' # preferred listing
alias la 'eza -a --color=always --group-directories-first --icons' # all files and dirs
alias ll 'eza -l --color=always --group-directories-first --icons' # long format
alias lt 'eza -aT --color=always --group-directories-first --icons' # tree listing
alias l. 'eza -ald --color=always --group-directories-first --icons .*' # show only dotfiles

# Common use
alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'
alias ..... 'cd ../../../..'
alias ...... 'cd ../../../../..'
alias big 'expac -H M "%m\t%n" | sort -h | nl' # Sort installed packages according to size in MB (expac must be installed)
alias dir 'dir --color=auto'
alias fixpacman 'sudo rm /var/lib/pacman/db.lck'
alias gitpkg 'pacman -Q | grep -i "\-git" | wc -l' # List amount of -git packages
alias grep 'ugrep --color=auto'
alias egrep 'ugrep -E --color=auto'
alias fgrep 'ugrep -F --color=auto'
alias grubup 'sudo update-grub'
alias hw 'hwinfo --short' # Hardware Info
alias ip 'ip -color'
alias psmem 'ps auxf | sort -nr -k 4'
alias psmem10 'ps auxf | sort -nr -k 4 | head -10'
alias rmpkg 'sudo pacman -Rdd'
alias tarnow 'tar -acf '
alias untar 'tar -zxvf '
alias upd /usr/bin/garuda-update
alias vdir 'vdir --color=auto'
alias wget 'wget -c '
alias net-virt 'sudo virsh net-start default'

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
# alias tree='tree -a -I .git'
alias nv='nvim'
alias pnv='env NVIM_APPNAME=prim-nvim nvim'
alias knv='env NVIM_APPNAME=kick-nvim nvim'
alias mnv='env NVIM_APPNAME=nvim-myown nvim'
alias xnv='env NVIM_APPNAME=nvim-0 nvim'
alias c='clear'
alias mkd='mkdir'
alias :q='exit'
alias cr='cargo run'
alias cb='cargo build'
alias cn='cargo new'
alias tmux='tmux -u'
alias tr='tmux -u a'
alias ta='tmux -u attach -t'
alias tn='tmux new -su'
alias p='sudo pacman '
alias fix='setxkbmap -option caps:swapescape && xset r rate 250 60'
alias remap='setxkbmap -option caps:swapescape'
alias speed='xset r rate 250 60'
alias tldrf='tldr --list | fzf --preview "tldr {1}" --preview-window=right,60% | xargs tldr'
alias en='emacsclient -c'
alias e='emacsclient'
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
alias vis='nvim "+set si"'

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

# Alias's for safe and forced reboots
alias rebootsafe='sudo shutdown -r now'
alias rebootforce='sudo shutdown -r -n now'
alias deb-update='sudo nala update && sudo nala upgrade'
# Search command line history
alias h="history | grep "

#Nixos
alias nix-shell="nix-shell --run fish"

# Search running processes
alias pp="ps aux | grep "
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"

alias se='sudoedit'

alias t='termdown --blink'
# run bash cmd in fish
function b
    bash -c "$argv"
end

function sudo --description "Replacement for Bash 'sudo !!' command to run last command using sudo."
    if test "$argv" = !!
        echo sudo $history[1]
        eval command sudo $history[1]
    else
        command sudo $argv
    end
end

# Initialize zoxide in Fish shell
zoxide init fish | source

set -x EDITOR nvim
set -x VISUAL nvim

set -x KITTY_FONT_FAMILY "FiraCode Nerd Font"
set -x LC_ALL en_US.UTF-8
set -x LANG en_US.UTF-8
set -x QT_QPA_PLATFORM xcb
export QT_QPA_PLATFORM=xcb
set -Ux PATH $PATH $HOME/.local/opt/go/bin
set -x XDG_DATA_DIRS $HOME/.nix-profile/share (string replace -r '^$' /usr/share $XDG_DATA_DIRS)
set -x NIXPKGS_ALLOW_UNFREE 1
export PATH="$HOME/.local/bin:$PATH"

# export PATH=$PATH:$HOME/.local/opt/go/bin
# set -gx XDG_DATA_DIRS "/home/$USER/.nix-profile/share" $XDG_DATA_DIRS
# export XDG_DATA_DIRS="/home/$USER/.nix-profile/share:$XDG_DATA_DIRS"
# python
# Based on https://gist.github.com/bastibe/c0950e463ffdfdfada7adf149ae77c6f
# Changes:
# * Instead of overriding cd, we detect directory change. This allows the script to work
#   for other means of cd, such as z.
# * Update syntax to work with new versions of fish.
# * Handle virtualenvs that are not located in the root of a git directory.

function shortcut-help
    echo "
*Move cursor*
Ctrl + a    Go to the beginning of the line (Home)
Ctrl + e    Go to the End of the line (End)
Alt + b     Back (left) one word
Alt + f     Forward (right) one word
Ctrl + f    Forward one character
Ctrl + b    Backward one character
Ctrl + xx   Toggle between the start of line and current cursor position

*Edit*
Ctrl + u    Cut the line before the cursor position
Alt + Del   Delete the Word before the cursor
Alt + d     Delete the Word after the cursor
Ctrl + d    Delete character under the cursor
Ctrl + h    Delete character before the cursor (backspace)
Ctrl + w    Cut the Word before the cursor to the clipboard
Ctrl + k    Cut the Line after the cursor to the clipboard
Alt + t     Swap current word with previous
Ctrl + t    Swap the last two characters before the cursor (typo)
Esc + t     Swap the last two words before the cursor.
Ctrl + y    Paste the last thing to be cut (yank)
Alt + u     UPPER capitalize every character from the cursor to the end of the current word.
Alt + l     Lower the case of every character from the cursor to the end of the current word.
Alt + c     Capitalize the character under the cursor and move to the end of the word.
Alt + r     Cancel the changes and put back the line as it was in the history (revert)
Ctrl + _    Undo

*History*
Ctrl + r    Recall the last command including the specified character(s) (equivalent to : vim ~/.bash_history).
Ctrl + p    Previous command in history (i.e. walk back through the command history)
Ctrl + n    Next command in history (i.e. walk forward through the command history)
Ctrl + s    Go back to the next most recent command.
Ctrl + o    Execute the command found via Ctrl+r or Ctrl+s
Ctrl + g    Escape from history searching mode
Alt + .     Use the last word of the previous command
"
end
# PATH
set -gx PATH $HOME/.local/bin $PATH

# SPECIAL FUNCTIONS
# Extracts any archive(s)
function extract
    for archive in $argv
        if test -f $archive
            switch $archive
                case *.tar.bz2
                    tar xvjf $archive
                case *.tar.gz
                    tar xvzf $archive
                case *.bz2
                    bunzip2 $archive
                case *.rar
                    rar x $archive
                case *.gz
                    gunzip $archive
                case *.tar
                    tar xvf $archive
                case *.tbz2
                    tar xvjf $archive
                case *.tgz
                    tar xvzf $archive
                case *.zip
                    unzip $archive
                case *.Z
                    uncompress $archive
                case *.7z
                    7z x $archive
                case '*'
                    echo "don't know how to extract '$archive'..."
            end
        else
            echo "'$archive' is not a valid file!"
        end
    end
end

# for bash
# extract() {
# 	for archive in "$@"; do
# 		if [ -f "$archive" ]; then
# 			case $archive in
# 			*.tar.bz2) tar xvjf $archive ;;
# 			*.tar.gz) tar xvzf $archive ;;
# 			*.bz2) bunzip2 $archive ;;
# 			*.rar) rar x $archive ;;
# 			*.gz) gunzip $archive ;;
# 			*.tar) tar xvf $archive ;;
# 			*.tbz2) tar xvjf $archive ;;
# 			*.tgz) tar xvzf $archive ;;
# 			*.zip) unzip $archive ;;
# 			*.Z) uncompress $archive ;;
# 			*.7z) 7z x $archive ;;
# 			*) echo "don't know how to extract '$archive'..." ;;
# 			esac
# 		else
# 			echo "'$archive' is not a valid file!"
# 		fi
# 	done
# }
#

export MANPAGER="less -r --use-color -Dd+r -Du+b"


# function fzf_find_files
#     set selected (find . | fzf)
#     if test -n "$selected"
#         if test -d "$selected"
#             cd "$selected"
#         else if test -f "$selected"
#             nvim "$selected"
#         end
#     end
# end
#
# bind \cg 'fzf_find_files'
#
# function fzf_find_dir
#     set selected (find . -type d | fzf)
#     if test -n "$selected"
#         cd "$selected"
#     end
# end

# Generated for envman. Do not edit.
#test -s ~/.config/envman/load.fish; and source ~/.config/envman/load.fish
