#!/usr/bin/env bash

export DOTFILES_DIR="$HOME/.config/coderv2/dotfiles"

mkdir -p "$HOME/.backup/dotfiles"

if [ -d "$HOME/.vim" ]; then
  mv "$HOME/.vim" "$HOME/.backup/dotfiles/.vim"
fi
ln -s "$DOTFILES_DIR/vim" "$HOME/.vim"

if [ -f "$HOME/.vimrc" ]; then
  mv "$HOME/.vimrc" "$HOME/.backup/dotfiles/.vimrc"
fi
ln -s "$DOTFILES_DIR/vimrc" "$HOME/.vimrc"

if [ -f "$HOME/.tmux.conf" ]; then
  mv "$HOME/.tmux.conf" "$HOME/.backup/dotfiles/.tmux.conf"
fi
ln -s "$DOTFILES_DIR/tmux.conf" "$HOME/.tmux.conf"

sudo apt install -y vim tmux

git config --global core.editor "vim"
git config --global push.default current

pnpm completion bash > ~/completion-for-pnpm.bash

$DOTFILES_DIR/update-profile.sh "$HOME/.profile" "source $HOME/.bashrc"
$DOTFILES_DIR/update-profile.sh "$HOME/.bashrc" "source $DOTFILES_DIR/home/start.sh"
