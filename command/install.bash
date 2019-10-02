#!/usr/bin/env bash
source "$MF_ROOT/lib/core/include/common.bash"

LIB="$1"
ARCHIVE=$("$MF" fetch "lib-$LIB" "v$MF_VERSION")
unzip -q "$ARCHIVE" -d "$MF_ROOT/lib/$LIB"
