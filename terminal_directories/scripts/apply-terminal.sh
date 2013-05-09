#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
target=$(readlink -f "$DIR")

if [ -z "$SUDO_USER" ]
then
  U=$USER
else
  U=$SUDO_USER
fi

terminal_dotfiles=("bashrc" "bash_aliases" "vimrc.after" "gitconfig" "tmux.conf")
terminal_directories=("scripts" "janus" "vim/colors")

cd /home/$U
for dotfile in "${terminal_dotfiles[@]}"
do
  if [ -h .$dotfile ]
  then
    rm .$dotfile
  elif [ -f .$dotfile ]
  then
    mv .$dotfile .$dotfile.old
  fi
  sudo -u $U ln -s $target/../../terminal_dotfiles/_$dotfile /home/$U/.$dotfile
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
  sudo -u $U ln -s $target/../../terminal_directories/$terminal_directory /home/$U/.$terminal_directory
done
