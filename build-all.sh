#!/bin/bash

# This script makes three versions of predator in three different directories
# needs git, cmake, GCC, gcc-7-plugin-dev, etc. --  see README*

# number of processor units
NCPU="$(getconf _NPROCESSORS_ONLN 2>/dev/null || echo 1)"

# git repository checkout
cloneAndMerge() {
    BASEBRANCH=svcomp
    DIR=$1
    BRANCH=$2
    (
    cd $DIR
    git init

    git config user.email "robot@fit.vutbr.cz"
    git config user.name "Script"

    git remote add origin https://github.com/versokova/predator.git
    git fetch --depth 5
    git checkout $BASEBRANCH
    git merge -m "automatic merge commit" origin/$BRANCH
    )
}

# predator build
cd_make () {
    ( cd $1 ; export GCC_HOST=/usr/bin/gcc ; make -j${NCPU} )
}

# delete already existing build-dirs
rm -rf predator predator-bfs predator-dfs
rm predator-build-ok

# copy
mkdir predator predator-dfs predator-bfs
cloneAndMerge predator     svcomp-orig
cloneAndMerge predator-dfs svcomp-dfs
cloneAndMerge predator-bfs svcomp-bfs

# make all versions of predators
cd_make predator && cd_make predator-bfs && cd_make predator-dfs
if [ $? != 0 ]; then
	echo "Instalation failed!"
	exit 1 
fi
# mark successful completion
echo "Installation completed."
date >predator-build-ok

