#!/usr/bin/env bash

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ln -s "$script_dir/vimrc" "$HOME/.vimrc"
ln -s "$script_dir/vim" "$HOME/.vim"

sudo apt install -y vim

echo "source $(script_dir)/home/start.sh" >> "$HOME/.bashrc"
