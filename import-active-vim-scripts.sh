#!/bin/bash

find ~/.vim/plugin -type l | xargs rm

for file in $(~/scripts/gather-active-vim-scripts.sh); do
  ln -s "$file" ~/.vim/plugin/
done
