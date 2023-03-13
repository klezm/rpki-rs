FROM mcr.microsoft.com/devcontainers/rust:0-1-bullseye

RUN sudo apt update && \
    sudo apt install -y \
        ca-certificates curl gnupg lsb-release \
        curl wget git gcc rsync build-essential \
        pkg-config libssl-dev
        # bat mc expect colorized-logs \
        # p7zip p7zip-full

# cargo-fuzz requires rust nightly
RUN rustup install nightly

# Add sources of standard library for rust-analyzer extension in VSCode
RUN rustup component add rust-src rust-analyzer clippy rustfmt

RUN cargo +nightly install cargo-fuzz
    # cargo-test-fuzz afl
