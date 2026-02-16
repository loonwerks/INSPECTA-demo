#! /bin/bash

pushd $RUST_AM_CLIENTS_ROOT
cargo run --release --bin rust-rodeo-client -- -t $HAMR_ATTESTATION_ROOT/hamr_maestro_term.json -a
cp ./testing/outputs/appsumm_response.json "$1"
popd
