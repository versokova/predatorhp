#!/bin/bash

#echo Runs only on Ubuntu 18.04 !

BASE=PredatorHP-2020
DATE=`date -I`

SYSTEM=$(grep "^NAME=" /etc/os-release|sed 's/^NAME="\(.*\)"/\1/')
VERSION=$(grep "^VERSION_ID=" /etc/os-release|sed 's/^VERSION_ID="\(.*\)"/\1/')

echo "We are running on $SYSTEM $VERSION"

if [ "$SYSTEM" != "Ubuntu" ]; then
  echo "Run on Ubuntu, please"
  exit
fi

if [ "$VERSION" != "18.04" ]; then
  echo "Run on Ubuntu 18.04, please"
  exit
fi

DIR=`pwd`
(
cd $HOME

cp $BASE/README.md $BASE/README-SVCOMP-2020

zip -qr "$DIR"/PredatorHP-2020-bin-${DATE}.zip $BASE -i \
  $BASE/LICENSE \
  $BASE/predatorHP.py  \
  $BASE/README-SVCOMP-2020  \
  $BASE/predator/sl_build/check-property.sh  \
  $BASE/predator/sl_build/libsl.so  \
  $BASE/predator-dfs/sl_build/check-property.sh  \
  $BASE/predator-dfs/sl_build/libsl.so  \
  $BASE/predator-bfs/sl_build/check-property.sh  \
  $BASE/predator-bfs/sl_build/libsl.so
  
)
