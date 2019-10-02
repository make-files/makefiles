#!/usr/bin/env bash
source "$MF_ROOT/lib/core/include/common.bash"

LIB="$1"
HOOK="$2"

"$MF_ROOT/lib/$LIB/bin/hooks/$HOOK"
