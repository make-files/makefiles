#!/usr/bin/env bash

echo "BUILDING $1"
TARGET="$1"

if ! [[ $TARGET =~ ^\.makefiles/(.+)/v([0-9]+)/ ]]; then
    2>&1 echo "can not build '$TARGET', target names must be of the form '.makefiles/<package>/v<version>/...'."
    exit 1
fi

REPO="${BASH_REMATCH[1]}"
VER="${BASH_REMATCH[2]}"
ARCHIVE=$("$MF" fetch "make-$REPO" "v$VER")
unzip -q "$ARCHIVE" -d "$MF_ROOT/$REPO"
