#!/bin/bash

set -e

# Install some basic packages
packages="git git-core vim build-essential rake curl tmux"

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

myubuntu/terminal_directories/scripts/apply-terminal.sh
