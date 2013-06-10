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
else
  U=$SUDO_USER
fi

home_dir=$(getent passwd "$U" | cut -d: -f 6)

terminal_dotfiles=("bashrc" "bash_aliases" "vimrc.after" "vimrc.before" "gitconfig" "tmux.conf")
terminal_directories=("scripts")

echo -e "${green}Installing necessary packages${white}"
packages="python-pip tmux"
apt-get install -y $packages

cd $home_dir

echo -e "${green}Installing Powerline plugin for command prompt, vim and tmux${white}"
echo -e "${green}Cloning powerline source${white}"
sudo -u $U -H pip install --user git+git://github.com/Lokaltog/powerline

if [[ ! -f /home/$U/.fonts/PowerlineSymbols.otf ]]
then
  echo -e "${green}Downloading PowerlineSymbols.otf font${white}"
  sudo -u $U -H wget https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf
  sudo -u $U -H mkdir -p /home/$U/.fonts/
  mv PowerlineSymbols.otf /home/$U/.fonts/
fi

if [[ ! -f /home/$U/.config/fontconfig/conf.d/10-powerline-symbols.conf ]]
then
  echo -e "${green}Downloading Powerline fontconfig${white}"
  sudo -u $U -H wget https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf
  sudo -u $U -H mkdir -p /home/$U/.config/fontconfig/conf.d/
  mv 10-powerline-symbols.conf /home/$U/.config/fontconfig/conf.d/
fi

echo -e "${green}Copying powerline configuration files${white}"

if [[ ! -d /home/$U/.config/powerline ]]
then
  sudo -u $U -H mkdir /home/$U/.config/powerline
  sudo -u $U -H cp -R /home/$U/.local/lib/python2.7/site-packages/powerline/config_files/* /home/$U/.config/powerline
fi

if [[ -f /home/$U/.config/powerline/themes/shell/default.json ]]
then
  mv /home/$U/.config/powerline/themes/shell/default.json /home/$U/.config/powerline/themes/shell/default.json.old
elif [[ -h /home/$U/.config/powerline/themes/shell/default.json ]]
then
  rm /home/$U/.config/powerline/themes/shell/default.json
fi

if [[ -f /home/$U/.config/powerline/colorschemes/shell/default.json ]]
then
  mv /home/$U/.config/powerline/colorschemes/shell/default.json /home/$U/.config/powerline/colorschemes/shell/default.json.old
elif [[ -h /home/$U/.config/powerline/colorschemes/shell/default.json ]]
then
  rm /home/$U/.config/powerline/colorschemes/shell/default.json
fi

if [[ -f /home/$U/.config/powerline/themes/tmux/default.json ]]
then
  mv /home/$U/.config/powerline/themes/tmux/default.json /home/$U/.config/powerline/themes/tmux/default.json.old
elif [[ -h /home/$U/.config/powerline/themes/tmux/default.json ]]
then
  rm /home/$U/.config/powerline/themes/tmux/default.json
fi

sudo -u $U -H ln -s $target/../../powerline_config/theme.default.json /home/$U/.config/powerline/themes/shell/default.json
sudo -u $U -H ln -s $target/../../powerline_config/colorschemes.default.json /home/$U/.config/powerline/colorschemes/shell/default.json
sudo -u $U -H ln -s $target/../../powerline_config/tmux.theme.default.json /home/$U/.config/powerline/themes/tmux/default.json

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
