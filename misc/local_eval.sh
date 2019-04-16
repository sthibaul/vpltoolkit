#!/bin/bash
[ $# -lt 2 ] && echo "⚠ Usage: $0 <exo> <inputdir> <...>" && exit 0
GIT="https://github.com/orel33/vpltoolkit.git"
BRANCH="demo"
SUBDIR=$1   # GIT SUBDIR
INPUTDIR=$2 # for local test
ARGS="${@:3}"
TKGIT="https://github.com/orel33/vpltoolkit.git"
TKBRANCH="master"
DOCKER="orel33/mydebian:latest"
RUNDIR=$(mktemp -d)
echo "RUNDIR=$RUNDIR"
( cd $RUNDIR && git clone $TKGIT -b $TKBRANCH &> /dev/null )
[ ! $? -eq 0 ] && echo "⚠ Fail to download VPL Toolkit!" && exit 0
source $RUNDIR/vpltoolkit/start.sh
DOWNLOAD $GIT $BRANCH $SUBDIR
START_OFFLINE $INPUTDIR $ARGS