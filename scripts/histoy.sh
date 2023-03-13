du -h -d 1 | sort -h
rustup default
cargo +nightly fuzz init
cargo +nightly fuzz list
./make-corpus.sh
chmod +x make-corpus.sh
find . -name "Cargo.lock" -type f -delete -print
find . -name Cargo.toml -type f -exec dirname {} \; | xargs -t -I % cargo +nightly -C % clean
cargo +nightly --locked fuzz run fuzz_target_1 corpus/idcer -- -only_ascii=1 -seed=0 --max-total_time=30 -ignore_crashes=1
history >> history.sh
cargo test
