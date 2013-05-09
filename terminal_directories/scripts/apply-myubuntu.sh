#!/bin/bash

set -e

# Install some basic packages
packages="git git-core vim build-essential rake curl tmux"

apt-get update
apt-get install -y $packages

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
target=$(readlink -f "$DIR")

$target/install-vim.sh
$target/install-vagrant.sh
$target/apply-terminal.sh
