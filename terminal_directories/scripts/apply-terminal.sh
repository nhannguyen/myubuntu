#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
target=$(readlink -f "$DIR")

if [ -z "$SUDO_USER" ]
then
  U=$USER
else
  U=$SUDO_USER
fi

home_dir=$(getent passwd "$U" | cut -d: -f 6)

terminal_dotfiles=("bashrc" "bash_aliases" "vimrc.after" "vimrc.before" "gitconfig" "tmux.conf")
terminal_directories=("scripts")

cd $home_dir

# Install powerline plugin
pip install --user git+git://github.com/Lokaltog/powerline
wget https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf
mkdir -p ~/.fonts/ && mv PowerlineSymbols.otf ~/.fonts/
fc-cache -vf ~/.fonts
mkdir -p ~/.config/fontconfig/conf.d/ && mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/

for dotfile in "${terminal_dotfiles[@]}"
do
  if [ -h .$dotfile ]
  then
    rm .$dotfile
  elif [ -f .$dotfile ]
  then
    mv .$dotfile .$dotfile.old
  fi
  sudo -u $U ln -s $target/../../terminal_dotfiles/_$dotfile $home_dir/.$dotfile
done

for terminal_directory in "${terminal_directories[@]}"
do
  if [ -h .$terminal_directory ]
  then
    rm .$terminal_directory
  elif [ -d .$terminal_directory ]
  then
    mv .$terminal_directory .$terminal_directory.old
  fi
  sudo -u $U ln -s $target/../../terminal_directories/$terminal_directory $home_dir/.$terminal_directory
done
