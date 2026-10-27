#!/usr/bin/env bash

export DOTFILES_DIR="$HOME/.config/coderv2/dotfiles"

ln -s "$DOTFILES_DIR/vimrc" "$HOME/.vimrc"
ln -s "$DOTFILES_DIR/vim" "$HOME/.vim"

sudo apt install -y vim

update-profile.sh "$DOTFILES_DIR/home/start.sh"
