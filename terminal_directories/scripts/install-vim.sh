#!/bin/bash

if [ ! -f /home/$SUDO_USER/.vim/installed ]
then
  apt-get install -y curl rake
  sudo -u $SUDO_USER curl -Lo- http://bit.ly/janus-bootstrap | sudo -u $SUDO_USER bash
  sudo -u $SUDO_USER touch .vim/installed
fi
