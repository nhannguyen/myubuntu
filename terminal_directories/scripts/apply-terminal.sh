#!/bin/bash

set -e
set -x verbose

green='\e[0;32m'
white='\e[1;37m'

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
target=$(readlink -f "$DIR")

if [ -z "$SUDO_USER" ]
then
  U=$USER
  su=""
else
  U=$SUDO_USER
  su="sudo -u $U -H"
fi

home_dir=$(getent passwd "$U" | cut -d: -f 6)

terminal_dotfiles=("zshrc" "bashrc" "aliases" "vimrc.after" "vimrc.before" "gitconfig" "tmux.conf")
terminal_directories=("scripts")

cd $home_dir

echo -e "${green}Installing Powerline plugin for command prompt, vim and tmux${white}"
echo -e "${green}Cloning powerline source${white}"

if [[ ! -f $home_dir/.fonts/PowerlineSymbols.otf ]]
then
  $su mkdir -p $home_dir/.fonts/
  cp $target/../../powerline/font/PowerlineSymbols.otf $home_dir/.fonts/
fi

if [[ ! -f $home_dir/.config/fontconfig/conf.d/10-powerline-symbols.conf ]]
then
  $su mkdir -p $home_dir/.config/fontconfig/conf.d/
  cp $target/../../powerline/font/10-powerline-symbols.conf $home_dir/.config/fontconfig/conf.d/
fi

echo -e "${green}Creating powerline configuration files${white}"

if [[ -h $home_dir/.config/powerline ]]
then
  $su rm $home_dir/.config/powerline
fi

if [[ ! -d $home_dir/.config/powerline ]]
then
  $su cp -R $target/../../powerline_config $home_dir/.config/powerline
fi


echo -e "${green}Linking dotfiles${white}"
for dotfile in "${terminal_dotfiles[@]}"
do
  if [[ -h .$dotfile ]]
  then
    rm .$dotfile
  elif [[ -f .$dotfile ]]
  then
    mv .$dotfile .$dotfile.old
  fi
  $su ln -s $target/../../terminal_dotfiles/_$dotfile $home_dir/.$dotfile
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
  $su ln -s $target/../../terminal_directories/$terminal_directory $home_dir/.$terminal_directory
done
