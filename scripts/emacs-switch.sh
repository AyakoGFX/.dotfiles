# cd ~/.dotfiles/
# stow -D emacs-notes/
#
# cd ~/.config
# mv emacs/ emacs.bak
# mv ~/.emacs.d.bak .emacs.d/

# undo
cd ~/.dotfiles/
stow emacs-notes/

cd ~/.config
mv emacs.bak emacs
mv ~/.emacs.d/ .emacs.d.bak
