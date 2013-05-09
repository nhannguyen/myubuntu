#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
target=$(readlink -f "$DIR")
echo $target

