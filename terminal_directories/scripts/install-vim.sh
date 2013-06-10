#!/bin/bash

set -e
set -x verbose

green='\e[0;32m'
white='\e[1;37m'

if [ -z "$SUDO_USER" ]
then
  U=$USER
else
  U=$SUDO_USER
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
target=$(readlink -f "$DIR")

home_dir=$(getent passwd "$U" | cut -d: -f 6)

echo -e "${green}Installing necessary packages for vim${white}"
packages="vim rake curl"
apt-get install -y $packages

echo -e "${green}Installing janus vim${white}"
if [ ! -f $home_dir/.vim/installed ]
then
  apt-get install -y curl rake
  sudo -u $U curl -Lo- http://bit.ly/janus-bootstrap | sudo -u $U bash
  sudo -u $U touch .vim/installed
fi

echo -e "${green}Linking vim configuration files${white}"
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
