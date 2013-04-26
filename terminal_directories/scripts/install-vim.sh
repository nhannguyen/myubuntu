#!/bin/bash

if [ -z "$SUDO_USER" ]
then
  U=$USER
else
  U=$SUDO_USER
fi


if [ ! -f /home/$U/.vim/installed ]
then
  sudo -u $U curl -Lo- http://bit.ly/janus-bootstrap | sudo -u $U bash
  sudo -u $U touch .vim/installed
fi
