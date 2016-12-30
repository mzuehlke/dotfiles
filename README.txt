.bashrc 
=======
if [ -f ~/Projects/dotfiles/bashrc ]; then
    source ~/Projects/dotfiles/bashrc ~/Projects/dotfiles/
fi

.profile
========
if [ -f "$HOME/Projects/dotfiles/profile" ]; then
    . "$HOME/Projects/dotfiles/profile"
fi
