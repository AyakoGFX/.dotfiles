
set fish_greeting                                 # Supresses fish's intro message
set TERM "xterm-256color"                         # Sets the terminal type

# name: sashimi
function fish_prompt
  set -l last_status $status
  set -l cyan (set_color -o cyan)
  set -l yellow (set_color -o yellow)
  set -g red (set_color -o red)
  set -g blue (set_color -o blue)
  set -l green (set_color -o green)
  set -g normal (set_color normal)

  set -l ahead (_git_ahead)
  set -g whitespace ' '

  if test $last_status = 0
    set initial_indicator "$green◆"
    set status_indicator "$normal❯$cyan❯$green❯"
  else
    set initial_indicator "$red✖ $last_status"
    set status_indicator "$red❯$red❯$red❯"
  end
  set -l cwd $cyan(basename (prompt_pwd))

  if [ (_git_branch_name) ]

    if test (_git_branch_name) = 'master'
      set -l git_branch (_git_branch_name)
      set git_info "$normal git:($red$git_branch$normal)"
    else
      set -l git_branch (_git_branch_name)
      set git_info "$normal git:($blue$git_branch$normal)"
    end

    if [ (_is_git_dirty) ]
      set -l dirty "$yellow ✗"
      set git_info "$git_info$dirty"
    end
  end

  # Notify if a command took more than 5 minutes
  if [ "$CMD_DURATION" -gt 300000 ]
    echo The last command took (math "$CMD_DURATION/1000") seconds.
  end

  echo -n -s $initial_indicator $whitespace $cwd $git_info $whitespace $ahead $status_indicator $whitespace
end

function _git_ahead
  set -l commits (command git rev-list --left-right '@{upstream}...HEAD' 2>/dev/null)
  if [ $status != 0 ]
    return
  end
  set -l behind (count (for arg in $commits; echo $arg; end | grep '^<'))
  set -l ahead  (count (for arg in $commits; echo $arg; end | grep -v '^<'))
  switch "$ahead $behind"
    case ''     # no upstream
    case '0 0'  # equal to upstream
      return
    case '* 0'  # ahead of upstream
      echo "$blue↑$normal_c$ahead$whitespace"
    case '0 *'  # behind upstream
      echo "$red↓$normal_c$behind$whitespace"
    case '*'    # diverged from upstream
      echo "$blue↑$normal$ahead $red↓$normal_c$behind$whitespace"
  end
end

function _git_branch_name
  echo (command git symbolic-ref HEAD 2>/dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty 2>/dev/null)
end
# Replace ls with eza
alias ls 'eza -al --color=always --group-directories-first --icons' # preferred listing
alias la 'eza -a --color=always --group-directories-first --icons'  # all files and dirs
alias ll 'eza -l --color=always --group-directories-first --icons'  # long format
alias lt 'eza -aT --color=always --group-directories-first --icons' # tree listing
alias l. 'eza -ald --color=always --group-directories-first --icons .*' # show only dotfiles

# emacs
# export EMACS_DIR="$HOME/.emacs.d-doom"
# alias doom='emacs -q --eval "(setq user-emacs-directory \"~/.emacs.d-doom\")"'

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
alias cr='cargo run'
alias cb='cargo build'
alias cn='cargo new'
alias hx='helix'
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

# kill $(xprop | grep -i _NET_WM_PID | awk '{print $3}')'


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

# Search command line history
alias h="history | grep "

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
# git
# alias g='git'
# alias ga='git add'
# alias gb='git checkout -B'
# alias gbr='git branch'
# alias gc='git commit'
# alias gca='git commit -a'
# alias gcA='git commit --amend'
# alias gcAn='git commit --amend --no-edit'
# alias gcam='git commit -am'
# alias gcl='git clone'
# alias gcm='git commit -m'
# alias gco='git checkout'
# alias gd='git diff'
# alias gds='git diff --staged'
# alias gl='git log --color --oneline --graph --full-history'
# alias gp='git push'
# alias gpl='git pull'
# alias grb='git rebase'
# alias grs='git reset'
# alias gs='git status'
# alias gsh='git show'
#
alias cleanup='sudo pacman -Rsn $(pacman -Qdtq)'
alias grub-update='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias smci='sudo make clean install'
# Path modification


# Initialize zoxide in Fish shell
zoxide init fish | source

set -x EDITOR nvim
set -x VISUAL nvim

set -x KITTY_FONT_FAMILY "FiraCode Nerd Font"
set -x LC_ALL en_US.UTF-8
set -x LANG en_US.UTF-8
set -x QT_QPA_PLATFORM xcb
export QT_QPA_PLATFORM=xcb
# if test -f ~/.Xmodmap
#     xmodmap ~/.Xmodmap
# end

set -x NIXPKGS_ALLOW_UNFREE 1
# export NIXPKGS_ALLOW_UNFREE=1 # use this in bash

# This function runs the command `find . | fzf`, which allows you to search for files using fzf
# function fzf_find
#     find . | fzf
# end
# # Bind the function to Ctrl+f
# bind \cf fzf_find

function fzf_find_files
    set selected (find . | fzf)
    if test -n "$selected"
        if test -d "$selected"
            cd "$selected"
        else if test -f "$selected"
            nvim "$selected"
        end
    end
end

bind \cg 'fzf_find_files'

function fzf_find_dir
    set selected (find . -type d | fzf)
    if test -n "$selected"
        cd "$selected"
    end
end

bind \cf 'fzf_find_dir'

# starship init fish | source
# colorscript random
# pokemon-colorscripts -r
# sysinfo-retro
# cpufetch

# echo "
# ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⠀⠀⢀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
# ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣼⣿⣼⣿⣿⣟⣿⣭⣻⣶⣴⣦⣀⠀⠀⠀⠀⠀
# ⠀⠀⠀⠀⠀⠀⠀⢀⣴⣾⢇⡌⣣⣾⣿⣿⣾⣿⣷⣸⣿⡷⣝⢿⣷⣄⠀⠀⠀
# ⠀⠀⠀⠀⠀⠀⢀⣾⣿⢹⡘⡇⢿⣿⣟⣻⢛⣹⣿⣿⣿⣷⠽⣧⣽⣿⢀⡀⠀
# ⠀⢀⠀⣠⣶⣶⡾⢛⣿⣏⠯⢁⣤⣬⣙⠻⣿⠿⣿⣿⣿⣿⣧⡙⣿⣿⣟⡁⠀
# ⢀⡀⠭⢥⣤⣤⣶⣿⡿⢸⣷⠰⣭⣙⣃⠘⢷⣶⣶⣼⣿⣿⢿⣷⣿⣿⡟⣅⠀
# ⠀⠐⢶⣖⡋⠙⢛⠫⢴⣿⢿⣀⡈⠳⣌⢿⡺⢉⣿⣾⣿⣿⣮⣿⡿⣳⢀⣏⠀
# ⠀⣀⣈⠹⣿⠿⢿⣦⣤⣭⣿⠞⠙⢲⣊⡡⡍⠘⠭⣙⡥⢿⡋⣴⣟⡵⢺⡏⠁
# ⠀⠀⠈⢳⣶⣾⠏⣩⡿⠋⠀⠀⡒⠶⣄⡀⠉⢉⠧⠶⢦⡀⠥⢉⣶⣶⠏⣇⠀
# ⠀⠀⠀⠈⠉⠁⢰⣿⣷⠀⠀⠀⠈⠲⠤⠟⠒⠂⠀⢀⣀⠁⠠⣼⣿⣯⢀⡇⠀
# ⠀⠀⠀⠀⠀⠀⠸⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⡜⠣⠤⢠⣾⣿⣿⠉⣼⠀⠀
# ⠀⠀⠀⠀⠀⠀⠀⢿⣿⡇⠀⢀⡀⠀⢀⠀⠀⡼⠀⣠⣴⣿⣿⣿⣿⢀⡏⠀⠀
# ⠀⠀⠀⠀⠀⠀⠀⠘⣿⣷⡾⠛⠛⠿⣾⣦⣰⣷⡾⠟⣿⣯⢊⡽⣿⠞⠀⠀⠀
# ⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣇⠀⢱⣶⠂⡼⠃⣿⡇⣸⠇⣧⡟⣰⣿⠀⠀⠀⠀
# ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠿⣶⣼⡯⠞⠁⢠⣿⣷⣿⣰⢏⣴⣿⡿⠀⠀⠀⠀
# ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡞⣡⡏⣿⢡⡞⣩⡿⠃⠀⠀⠀⠀
# ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡜⣹⡟⣴⢇⡿⣼⠏⠀⠀⠀⠀⠀⠀
# ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣧⡟⣾⡏⣿⡇⡟⠀⠀⠀⠀⠀⠀⠀
# ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⠙⠇⠛⠛⠁⠀⠀⠀⠀⠀⠀⠀
# ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
# ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡟⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
# ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
# " 


# Start X at login
if status is-login
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        exec startx -- -keeptty
    end
end

set -x PATH $HOME/.config/emacs/bin $PATH
set -gx PATH $HOME/.zoom $PATH
set -gx PATH $HOME/.zoom/src/ $PATH
set -gx PATH $HOME/.cargo/bin $PATH
set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin $PATH /home/ayako/.ghcup/bin # ghcup-env
