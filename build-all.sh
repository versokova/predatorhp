#!/bin/bash

# This script makes three versions of predator in three different directories
# for dependencies, see README*

# Arguments:
# --src       Only download predators
# --build     Only install predators

# export GCC_HOST="/usr/local/Cellar/gcc@9/9.3.0_1/bin/gcc-9"

SRC=true
BUILD=true

if [ `uname` = Darwin ]; then
    OPSYS='macOS'
else
    OPSYS='Linux'
fi

die() {
    printf "%s: %s\n" "$SELF" "$*" >&2
    exit 1
}

# arguments
if [ $# -eq 1 ]; then
    if [ "--src" = "$1" ]; then
        BUILD=false
    elif [ "--build" = "$1" ]; then
        SRC=false
    else die "invalid argument"
    fi
fi

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
cd_make() {
    (
        CHANGE=false
        if [ `uname` = Darwin ] && [ -z "$CXX" ]; then
            # no CXX compiler on macos, try substitue gcc for g++
            base_gcc="${GCC_HOST##*/}"
            gxx="${GCC_HOST%/*}/${base_gcc/gcc/g++}"
            if [ "$GCC_HOST" != "$gxx" ] && [ -x "$gxx" ]; then
                export CC="$GCC_HOST"
                export CXX="$gxx"
                CHANGE=true
            fi
        fi
        cd $1
        $MAKE
    )
}

rm -f predator-build-ok

if "$SRC" ; then
    # delete already existing build-dirs
    rm -rf predator predator-bfs predator-dfs
    # copy
    mkdir predator predator-dfs predator-bfs
    cloneAndMerge predator     svcomp-orig
    cloneAndMerge predator-dfs svcomp-dfs
    cloneAndMerge predator-bfs svcomp-bfs
    echo "Source code downloaded."
fi

if "$BUILD" ; then
    # number of processor units
    NCPU="$(getconf _NPROCESSORS_ONLN 2>/dev/null || echo 1)"
    MAKE="make -j${NCPU}"

    export GCC_HOST="${GCC_HOST:-/usr/bin/gcc}"
    if test "/" != "${GCC_HOST:0:1}"; then
        if echo "$GCC_HOST" | grep / >/dev/null; then
            # assume a relative path to GCC_HOST
            GCC_HOST="$(realpath "$GCC_HOST")"
        else
            # assume an executable in $PATH
            GCC_HOST="$(command -v "$GCC_HOST")"
        fi
    fi

    # check GCC_HOST
    test -x "$GCC_HOST" || die "GCC_HOST is not an executable file: $GCC_HOST"

    # try to run GCC_HOST
    "$GCC_HOST" --version || die "unable to run gcc: $GCC_HOST --version"

    # make all versions of predators
    cd_make predator && cd_make predator-bfs && cd_make predator-dfs
    if [ $? != 0 ]; then
        die "Instalation failed!"
    fi
    # mark successful completion
    echo "Installation completed."
    date >predator-build-ok
fi

if $CHANGE; then
    export CC=""
    export CXX=""
fi
