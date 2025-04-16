# dotfiles
## Setup
```
echo "alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'" >> $HOME/.bashrc
config config --local status.showUntrackedFiles no
git clone --bare git@github.com:pl3lee/dotfiles.git $HOME/.cfg
```
Now use `config` command wherever you would use `git` to modify config files.
