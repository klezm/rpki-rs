#!/bin/bash

SCRIPT_PATH="${BASH_SOURCE[0]:-$0}";
SCRIPT_DIR=$(dirname $SCRIPT_PATH);
WORKSPACE_DIR=$(realpath $(dirname $SCRIPT_DIR))
cd $WORKSPACE_DIR

echo "---------- rustup default ----------"
rustup default
# cargo +nightly fuzz init
# cargo +nightly fuzz add fuzz_target_rrdp
echo "---------- cargo +nightly fuzz list ----------"
cargo +nightly fuzz list
echo "---------- make-corpus.sh ----------"
$SCRIPT_DIR/make-corpus.sh
# echo "---------- delete all Cargo.lock's ----------"
# find . -name "Cargo.lock" -type f -delete -print
# echo "---------- cargo clean ./ & fuzz/ ----------"
# find . -name Cargo.toml -type f -exec dirname {} \; | xargs -t -I % cargo +nightly -C % clean
echo "---------- fuzz run ----------"
cargo +nightly --locked fuzz run fuzz_target_1 corpus/idcer -- -only_ascii=1 -seed=0 -max_total_time=10 -ignore_crashes=1
# cargo +nightly --locked fuzz run fuzz_target_rrdp corpus/xml/snapshot -- -only_ascii=1 -seed=0 -max_total_time=10 -ignore_crashes=1
