#! /bin/bash

pushd $AM_REPOS_ROOT/rust-am-clients
cargo run --release --bin rust-rodeo-client -- -t $HAMR_ATTESTATION_ROOT/hamr_maestro_term.json -a
cp ./testing/outputs/appsumm_response.json "$1"
popd
