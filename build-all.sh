#!/bin/bash

# This script makes three versions of predator in three different directories
# configured for old GCC version 5 in /usr/bin/gcc-5
# needs git, cmake, GCC, gcc-5-plugin-dev, etc. --  see README*
## FIXME Warning: does not work yet for newer GCC

# git repository ceckout
cloneAndMerge() {
    #basebranch possibilites: master statistics michalk
    #statistics writes depth info
    #michalk is experimental branch
    BASEBRANCH=master
    DIR=$1
    BRANCH=$2
    (
    cd $DIR
    git init

    git config user.email "robot@fit.vutbr.cz"
    git config user.name "Script"

    git remote add origin ../predator-repo/
    git fetch
    git checkout $BASEBRANCH
    git merge -m "automatic merge commit" origin/$BRANCH
    )
}

# predator build
cd_make () {
    ( cd $1 ; ./switch-host-gcc.sh /usr/bin/gcc-5 )
}

# delete already existing build-dirs if repo exists
if [ -d predator-repo ]
then
  rm -rf predator predator-bfs predator-dfs
  rm predator-build-ok
fi

# copy
mkdir predator predator-dfs predator-bfs
cloneAndMerge predator     base-org
cloneAndMerge predator-dfs base-dfs
cloneAndMerge predator-bfs base-bfs

# TODO: add to repo only for predator
cp check-property.sh.in predator/sl/check-property.sh.in
# make all versions of predators
cd_make predator && cd_make predator-bfs && cd_make predator-dfs
if [ $? != 0 ]; then
	echo "Instalation failed!"
	exit 1 
fi
# mark successful completion
echo "Installation completed."
date >predator-build-ok

