# dotfiles
## Setup
```
# linux
echo "alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'" >> $HOME/.bashrc
# macos
echo "alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'" >> $HOME/.zshrc

git clone --bare git@github.com:pl3lee/dotfiles.git $HOME/.cfg
config config --local status.showUntrackedFiles no
```
Now use `config` command wherever you would use `git` to modify config files.
