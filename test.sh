#!/bin/bash

set -eo pipefail

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -t 0 ] ; then
    ttyopt="-t"
fi

docker pull ghcr.io/axetrading/terraform-test-image:latest
docker run \
    -v ~/.aws:/root/.aws \
    -e AWS_PROFILE -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_SESSION_TOKEN \
    -e NO_DESTROY \
    --rm -i $ttyopt -w "$dir" -v "$dir:$dir" \
    ghcr.io/axetrading/terraform-test-image:latest test/check.py