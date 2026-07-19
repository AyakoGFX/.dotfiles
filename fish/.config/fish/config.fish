set fish_greeting # Supresses fish's intro message

# function fish_prompt
#     set_color red --bold
#     echo -n '-> '
# end

function fish_prompt
    set -l user (whoami)
    set -l my_hostname (hostnamectl --static 2>/dev/null; or hostname; or uname -n)
    set -l pwd (prompt_pwd)
    printf "\033[1;31m[%s\033[1;33m@%s \033[1;32m%s\033[1;35m]\033[0m " $user $my_hostname $pwd
end

zoxide init fish | source

# alias emacs-restart="pkill emacs && emacs --daemon"
alias kill-emacs="pkill emacs"
alias emacsclient-start="emacs --daemon"
alias emacsclient-stop="emacsclient -e '(kill-emacs)'"
alias ec="emacsclient -t ''"
set PATH "$PATH":"$HOME/.local/scripts/"
set -gx PATH $HOME/bin $PATH
bind \cq tmux-sessionizer
