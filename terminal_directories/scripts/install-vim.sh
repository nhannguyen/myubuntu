#!/bin/bash

set -e

if [ -z "$SUDO_USER" ]
then
  U=$USER
else
  U=$SUDO_USER
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
target=$(readlink -f "$DIR")

home_dir=$(getent passwd "$U" | cut -d: -f 6)

if [ ! -f $home_dir/.vim/installed ]
then
  apt-get install -y curl rake
  sudo -u $U curl -Lo- http://bit.ly/janus-bootstrap | sudo -u $U bash
  sudo -u $U touch .vim/installed
fi

terminal_directories=("janus" "vim/colors")

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
