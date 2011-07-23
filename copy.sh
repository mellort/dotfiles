#!/bin/bash
for i in $(ls . | grep "rc$"); do
  echo "copying $i -> ~/.$i"
  rm ~/.$i
  ln -s $(pwd)/$i ~/.$i
done
