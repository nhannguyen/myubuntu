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
if [ ! -f ~/.vim/installed ]
then
  sudo -u $SUDO_USER curl -Lo- http://bit.ly/janus-bootstrap | bash
  sudo -u $SUDO_USER touch .vim/installed
fi

# Install vagrant
apt-get install -y linux-headers-$(uname -r) dkms virtualbox-4.2 rubygems ruby-dev
gem install vagrant

terminal_dotfiles=(".bashrc" ".bash_aliases" ".vimrc.after")
linked_directories=("scripts" ".janus" ".vim/colors")

cd /home/$SUDO_USER
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

sudo -u $SUDO_USER ln -s ~/myubuntu/terminal/_bash_aliases ~/.bash_aliases
sudo -u $SUDO_USER ln -s ~/myubuntu/scripts ~/scripts
sudo -u $SUDO_USER ln -s ~/myubuntu/terminal/_bashrc ~/.bashrc
sudo -u $SUDO_USER ln -s ~/myubuntu/terminal/_vimrc.after ~/.vimrc.after
sudo -u $SUDO_USER ln -s ~/myubuntu/terminal/vim/colors ~/.vim/colors
sudo -u $SUDO_USER ln -s ~/myubuntu/terminal/janus ~/.janus

sudo -u $SUDO_USER source .bashrc
