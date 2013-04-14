#!/bin/bash
terminal_dotfiles=(".bashrc" ".bash_aliases" ".vimrc.after")
linked_directories=("scripts" ".janus" ".vim/colors")

cd ~
for dotfile in "${terminal_dotfiles[@]}"
do
  if [ -h $dotfile ]
  then
    rm $dotfile
  elif [ -f $dotfile ]
  then
    mv $dotfile $dotfile.old
  fi
done

for linked_directory in "${linked_directories[@]}"
do
  if [ -h $linked_directory ]
  then
    rm $linked_directory
  elif [ -d $linked_directory ]
  then
    mv $linked_directory $linked_directory.old
  fi
done

ln -s ~/myubuntu/terminal/_bash_aliases ~/.bash_aliases
ln -s ~/myubuntu/scripts ~/scripts
ln -s ~/myubuntu/terminal/_bashrc ~/.bashrc
ln -s ~/myubuntu/terminal/_vimrc.after ~/.vimrc.after
ln -s ~/myubuntu/terminal/vim/colors ~/.vim/colors
ln -s ~/myubuntu/terminal/janus ~/.janus

source .bashrc
