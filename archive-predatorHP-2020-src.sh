#!/bin/bash

DATE=`date -I`
DIR=`pwd`
BASE="${DIR##*/}"
(
cd ..

zip -qr "$DIR"/PredatorHP-2020-src-${DATE}.zip $BASE -x \
  $BASE/.gitignore \
  $BASE/.git/\* \
  $BASE/predator/.gitignore \
  $BASE/predator/.travis.yml \
  $BASE/predator/.git/\* \
  $BASE/predator/fa/\*  \
  $BASE/predator/fwnull/\*  \
  $BASE/predator/tests/\*  \
  $BASE/predator/vra/\*  \
  $BASE/predator/cl_build/\*  \
  $BASE/predator/sl_build/\*  \
  $BASE/predator-dfs/.gitignore \
  $BASE/predator-dfs/.travis.yml \
  $BASE/predator-dfs/.git/\* \
  $BASE/predator-dfs/fa/\*  \
  $BASE/predator-dfs/fwnull/\*  \
  $BASE/predator-dfs/tests/\*  \
  $BASE/predator-dfs/vra/\*  \
  $BASE/predator-dfs/cl_build/\*  \
  $BASE/predator-dfs/sl_build/\*  \
  $BASE/predator-bfs/.gitignore \
  $BASE/predator-bfs/.travis.yml \
  $BASE/predator-bfs/.git/\* \
  $BASE/predator-bfs/fa/\*  \
  $BASE/predator-bfs/fwnull/\*  \
  $BASE/predator-bfs/tests/\*  \
  $BASE/predator-bfs/vra/\*  \
  $BASE/predator-bfs/cl_build/\*  \
  $BASE/predator-bfs/sl_build/\*
)
