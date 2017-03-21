#!/bin/bash
#make a file executable
if [ -z "$1" ];then
  echo "File not set"
  exit 1
fi
F=$1
if [ ! -f "$F" ];then
  echo "$F is not a file!"
  exit 1
fi
git update-index --chmod=+x $F
git commit --amend -m "Making file executable."
cd ~/setup_aws
git push -f
exit 0
