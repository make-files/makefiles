#!/usr/bin/env bash
source "$MF_ROOT/lib/core/include/common.bash"

TARGET="$1"

if ! [[ $TARGET =~ ^\.makefiles/pkg/(.+)/v([0-9]+)/ ]]; then
    2>&1 echo "can not build '$TARGET', target names must be of the form '.makefiles/pkg/<package>/v<version>/...'."
    exit 1
fi

REPO="${BASH_REMATCH[1]}"
VER="${BASH_REMATCH[2]}"

ARCHIVE=$("$MF" fetch "pkg-$REPO" "v$VER")
mkdir -p "$MF_ROOT/pkg/$REPO"
unzip -q "$ARCHIVE" -d "$MF_ROOT/pkg/$REPO/v$VER"
