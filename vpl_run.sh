#!/bin/bash
VPLMODEL="https://github.com/orel33/vplmodel.git"
MODE="RUN"
ONLINE=1
DEBUG=1
VERBOSE=1
RUNDIR=$(mktemp -d)

cd $RUNDIR && git clone $VPLMODEL &> /dev/null && cd -
source $RUNDIR/vplmodel/toolkit.sh

# ln -sf $RUNDIR/vplmodel/vpl_execution $HOME/vpl_execution

EXO="hello"
DOWNLOAD "https://github.com/orel33/vplmodel.git" "demo" $EXO
START