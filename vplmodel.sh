#!/bin/bash

VERSION="1.0"

### BASIC ROUTINES ###

ECHO()
{
    local COMMENT=""
    if [ "$MODE" = "EVALUATE" ] ; then COMMENT="Comment :=>>" ; fi
    echo "${COMMENT}$@"
}

ECHOV()
{
    if [ "$VERBOSE" = "1" ] ; then ECHO $@ ; fi
}

ECHOD()
{
    if [ "$DEBUG" = "1" ] ; then ECHO $@ ; fi
}

### ENVIRONMENT ###

function vplmodel_checkenv()
{
    # basic environment
    [ -z "$VERSION" ] && echo "⚠ MODE variable is not defined!" && exit 0
    [ -z "$MODE" ] && echo "⚠ MODE variable is not defined!" && exit 0
    [ -z "$REPOSITORY" ] && echo "⚠ REPOSITORY variable is not defined!" && exit 0
    [ -z "$BRANCH" ] && BRANCH="master"
    [ -z "$EXO" ] && echo "⚠ EXO variable is not defined!" && exit 0
    [ -z "$RUNDIR" ] && echo "⚠ RUNDIR variable is not defined!" && exit 0
    [ -z "$DEBUG" ] && DEBUG=0
    [ -z "$VERBOSE" ] && VERBOSE=0
}

function vplmodel_saveenv()
{
    # export environment
    rm -f $RUNDIR/env.sh
    echo "VERSION=$VERSION" >> $RUNDIR/env.sh
    echo "MODE=$MODE" >> $RUNDIR/env.sh
    echo "REPOSITORY=$REPOSITORY" >> $RUNDIR/env.sh
    echo "BRANCH=$BRANCH" >> $RUNDIR/env.sh
    echo "EXO=$EXO" >> $RUNDIR/env.sh
    echo "RUNDIR=$RUNDIR" >> $RUNDIR/env.sh
    echo "DEBUG=$DEBUG" >> $RUNDIR/env.sh
    echo "VERBOSE=$VERBOSE" >> $RUNDIR/env.sh
}

function vplmodel_loadenv()
{
    [ ! -f $RUNDIR/env.sh ] && echo "⚠ File \"env.sh\" missing!" && exit 0
    source $RUNDIR/env.sh
}

function vplmodel_exportenv()
{
    export VERSION
    export MODE
    # export REPOSITORY
    # export BRANCH
    export EXO
    export RUNDIR
    export DEBUG
    export VERBOSE
}


function vplmodel_printenv()
{
    ECHOV "VERSION=$VERSION"
    ECHOV "MODE=$MODE"
    # ECHOV "REPOSITORY=$REPOSITORY" # Don't show it, because of possible login & password!!!
    # ECHOV "BRANCH=$BRANCH"
    ECHOV "EXO=$EXO"
    ECHOV "RUNDIR=$RUNDIR"
    ECHOV "DEBUG=$DEBUG"
    ECHOV "VERBOSE=$VERBOSE"
}

### DOWNLOAD ###

# TODO: add wget method

function vplmodel_clone() {
    local REPOSITORY=$1
    local BRANCH=$2
    [ -z "$REPOSITORY" ] && echo "⚠ REPOSITORY variable is not defined!" && exit 0
    git -c http.sslVerify=false clone -q -n $REPOSITORY --branch $BRANCH --depth 1 GIT
    [ ! $? -eq 0 ] && echo "⚠ GIT clone \"vplmoodle\" failure!" && exit 0
}

function vplmodel_checkout() {
    local DIR=$1
    cd GIT && git -c http.sslVerify=false checkout HEAD -- $DIR && cd
    [ ! $? -eq 0 ] && echo "⚠ GIT checkout \"$CHECKOUT\" failure!" && exit 0
}

function vplmodel_download() {
    local DIR=$1
    START=$(date +%s.%N)
    vplmodel_clone $REPOSITORY $BRANCH
    vplmodel_checkout $DIR
    END=$(date +%s.%N)
    TIME=$(python -c "print(int(($END-$START)*1E3))") # in ms
    ECHOV "Download $EXO in $TIME ms"
}

### EXECUTION ###

function vplmodel_start() {
    vplmodel_checkenv
    vplmodel_printenv
    vplmodel_download $EXO
    vplmodel_saveenv
    cp $RUNDIR/vplmodel/vpl_execution $RUNDIR
    chmod +x $RUNDIR/vpl_execution
    # => implicit execution of vpl_execution
}

# EOF