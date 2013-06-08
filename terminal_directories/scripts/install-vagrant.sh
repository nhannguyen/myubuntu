#!/bin/bash

set -e

green='\e[0;32m'
white='\e[1;37m'

echo -e "${green}Adding virtualbox to repo list${white}"
if [ ! -f /etc/apt/source.list.d/virtualbox.list ]
then
  echo deb http://download.virtualbox.org/virtualbox/debian `lsb_release -cs` contrib | tee /etc/apt/sources.list.d/virtualbox.list
  wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O - | apt-key add -
fi

echo -e "${green}Installing virtualbox${white}"
apt-get update
apt-get install -y linux-headers-$(uname -r) dkms virtualbox-4.2 rubygems ruby-dev
echo -e "${green}Installing vagrant${white}"
gem install vagrant --no-rdoc --no-ri
