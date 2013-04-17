#!/bin/bash

# Install some basic packages
packages="git git-core vim build-essential rake curl"

# Add virtual box repo if not added
if [ ! -f /etc/apt/source.list.d/virtualbox.list ]
then
  echo deb http://download.virtualbox.org/virtualbox/debian `lsb_release -cs` contrib | tee /etc/apt/sources.list.d/virtualbox.list
  wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O - | apt-key add -
fi
apt-get update
apt-get install -y $packages

# Install janus vim
if [ ! -f /home/$SUDO_USER/.vim/installed ]
then
  sudo -u $SUDO_USER curl -Lo- http://bit.ly/janus-bootstrap | sudo -u $SUDO_USER bash
  sudo -u $SUDO_USER touch .vim/installed
fi

# Install vagrant
apt-get install -y linux-headers-$(uname -r) dkms virtualbox-4.2 rubygems ruby-dev
gem install vagrant --no-rdoc --no-ri

terminal_dotfiles=("bashrc" "bash_aliases" "vimrc.after" "gitconfig" "tmux.conf")
terminal_directories=("scripts" "janus" "vim/colors")

cd /home/$SUDO_USER
for dotfile in "${terminal_dotfiles[@]}"
do
  if [ -h .$dotfile ]
  then
    rm .$dotfile
  elif [ -f .$dotfile ]
  then
    mv .$dotfile .$dotfile.old
  fi
  sudo -u $SUDO_USER ln -s /home/$SUDO_USER/myubuntu/terminal_dotfiles/_$dotfile /home/$SUDO_USER/.$dotfile
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
  sudo -u $SUDO_USER ln -s /home/$SUDO_USER/myubuntu/terminal_directories/$terminal_directory .$terminal_directory
done
