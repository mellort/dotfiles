#!/bin/bash
for i in inputrc pentadactylrc tmux.conf; do
  echo "copying $i -> ~/.$i"
  cp ~/.$i ~/.$i.bup
  rm ~/.$i
  ln -s $(pwd)/$i ~/.$i
done
