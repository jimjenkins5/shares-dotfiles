#!/usr/bin/env bash

export DOTFILES_DIR="$HOME/.config/coderv2/dotfiles"

if [ ! -d "$HOME/.vim" ]; then
  ln -s "$DOTFILES_DIR/vim" "$HOME/.vim"
fi

if [ ! -f "$HOME/.vimrc" ]; then
  ln -s "$DOTFILES_DIR/vimrc" "$HOME/.vimrc"
fi

sudo apt install -y vim

git config --global core.editor "vim"
git config --global push.default current

$DOTFILES_DIR/update-profile.sh "$HOME/.profile" "source $HOME/.bashrc"
$DOTFILES_DIR/update-profile.sh "$HOME/.bashrc" "source $DOTFILES_DIR/home/start.sh"
