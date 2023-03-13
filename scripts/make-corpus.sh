#!/bin/bash

SCRIPT_PATH="${BASH_SOURCE[0]:-$0}";
SCRIPT_DIR=$(dirname $SCRIPT_PATH);
WORKSPACE_DIR=$(realpath $(dirname $SCRIPT_DIR))
cd $WORKSPACE_DIR

function reset_corpus() {
    rm -rf $WORKSPACE_DIR/corpus
    mkdir $WORKSPACE_DIR/corpus
}

function make_rsync_corpus() {
    CORPUS_RSYNC_DIR="$WORKSPACE_DIR/corpus/rsync"
    mkdir -p $CORPUS_RSYNC_DIR
    uris=(
        "rsync://host/module/$%&'()*+,-./0123456789:;=ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz~"
        "rsync://host/module/"
        "rsync://host/module/foo/"
        "rsync://host/module/foo/bar"
    )

    for ((i=0; i<${#uris[@]}; i++)); do
        printf "%s" $uris[$i] > $CORPUS_RSYNC_DIR/$i
    done
}

function copy_corpus_from_submodule() {
    echo "--------------- cer ---------------"
    mkdir -p $WORKSPACE_DIR/corpus/cer
    find $WORKSPACE_DIR -name "*.cer" ! -name "*id*" -exec cp --verbose {} $WORKSPACE_DIR/corpus/cer/ \;
    rm $WORKSPACE_DIR/corpus/cer/*incorrect*.cer
    echo "--------------- id cer ---------------"
    mkdir -p $WORKSPACE_DIR/corpus/idcer
    find $WORKSPACE_DIR -name "*id*.cer" -exec cp --verbose {} $WORKSPACE_DIR/corpus/idcer/ \;

    # echo "--------------- roa ---------------"
    # mkdir -p $WORKSPACE_DIR/corpus/roa
    # find $WORKSPACE_DIR/rpki-validator-3 -name "*.roa" -exec cp --verbose {} $WORKSPACE_DIR/corpus/roa/ \;

    echo "--------------- xml snapshot ---------------"
    mkdir -p $WORKSPACE_DIR/corpus/xml/snapshot
    find $WORKSPACE_DIR -name "*snapshot*.xml" -exec cp --verbose {} $WORKSPACE_DIR/corpus/xml/snapshot/ \;

    echo "--------------- xml notification ---------------"
    mkdir -p $WORKSPACE_DIR/corpus/xml/notification
    find $WORKSPACE_DIR -name "*notification*.xml" -exec cp --verbose {} $WORKSPACE_DIR/corpus/xml/notification/ \;
    rm $WORKSPACE_DIR/corpus/xml/notification/*lolz*.xml
    rm $WORKSPACE_DIR/corpus/xml/notification/*with-gaps*.xml

    echo "--------------- xml delta ---------------"
    mkdir -p $WORKSPACE_DIR/corpus/xml/delta
    find $WORKSPACE_DIR -name "*delta*.xml" -exec cp --verbose {} $WORKSPACE_DIR/corpus/xml/delta/ \;
}

reset_corpus
make_rsync_corpus
copy_corpus_from_submodule
