#!/bin/bash -x

set -e

green='\e[0;32m'
white='\e[1;37m'
red='\e[0;31m'

vim=0
vagrant=0

if [[ $# -gt 2 ]]
then
  echo -e "${red}Unsupported${white}"
  return 1
elif [[ $# -eq 0 ]]
then
  vim=1
  vagrant=1
else
  if [[ $1 == $2 ]]
  then
    echo -e "${red}Please select different componets to install${white}"
    return 1
  else
    if [[ $1 == "vim" || $2 == "vim" ]]
    then
      vim=1
    elif [[ $1 == "vagrant" || $2 == "vagrant" ]]
    then
      vagrant=1
    else
      echo -e "${red}Currently support vim and vagrant only${white}"
      return 1
    fi
  fi
fi

# Install some basic packages
packages="git git-core htop tmux"

echo -e "${green}Installing basic packages${white}"
apt-get update
apt-get install -y $packages

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
target=$(readlink -f "$DIR")

if [[ $vim -eq 1 ]]
then
  $target/install-vim.sh
fi

if [[ $vagrant -eq 1 ]]
then
  $target/install-vagrant.sh
fi

$target/apply-terminal.sh
