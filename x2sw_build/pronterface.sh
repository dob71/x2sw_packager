#!/bin/bash

while [ 1 ]; do
  ./pronterface $*
  if [ $? -ne 22 ]; then
    break
  fi
done
