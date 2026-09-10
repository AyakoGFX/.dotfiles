set fish_greeting # Suppresses fish's intro message


# System Aliases & Environment
alias kill-emacs="pkill emacs"
alias hx="helix"
alias emacsclient-start="emacs --daemon"
alias emacsclient-stop="emacsclient -e '(kill-emacs)'"
alias ec="emacsclient -t"

# PATH Setup (prevents duplicates in $PATH)
fish_add_path "$HOME/.local/scripts"
fish_add_path "$HOME/.local/bin"
fish_add_path "$HOME/bin"
