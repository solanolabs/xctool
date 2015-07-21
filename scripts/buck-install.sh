#!/bin/bash
# Ensure github.com/facebook/buck.git is installed

if [ -d Vendor/buck ]; then
  cur_dir=`pwd`
  cd Vendor/buck
  git pull
  cd $cur_dir  
else
  git clone https://github.com/facebook/buck.git Vendor/buck
fi