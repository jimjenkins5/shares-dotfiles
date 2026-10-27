#!/usr/bin/env bash

export DOTFILES_DIR="$HOME/.config/coderv2/dotfiles"

if [ ! -d "$HOME/.vim" ]; then
  ln -s "$DOTFILES_DIR/vim" "$HOME/.vim"
fi

if [ ! -f "$HOME/.vimrc" ]; then
  ln -s "$DOTFILES_DIR/vimrc" "$HOME/.vimrc"
fi

sudo apt install -y vim

update-profile.sh "source $DOTFILES_DIR/home/start.sh"
