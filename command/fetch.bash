#!/usr/bin/env bash
source "$MF_ROOT/lib/core/include/common.bash"

DEFAULT_ORG='make-files'

if [ $# == 0 ]; then
    echo "Usage: $(basename "$MF") fetch slug [branch]"
    echo
    echo "  Downloads an archive of a GitHub repository and stores it in the"
    echo "  cache. It prints the path to the downloaded archive. If the archive"
    echo "  is already in the cache it is not re-downloaded."
    echo
    echo "  Repository slugs without a username/organization component are"
    echo "  assumed to refer to the '$DEFAULT_ORG' organization."
    echo
    echo "  GitHub produces archives with a single top-level directory named"
    echo "  after this repository and branch name. This directory is stripped"
    echo "  from the downloaded archive."
    echo
    exit 1
fi

SLUG="$1"
if [[ $SLUG =~ ^.+/(.+)$ ]]; then
    REPO="${BASH_REMATCH[1]}"
else
    REPO="$SLUG"
    SLUG="$DEFAULT_ORG/$SLUG"
fi

BRANCH="${2:-master}"
URL="https://github.com/$SLUG/archive/$BRANCH.zip"
CACHE="$MF_ROOT/cache/github/$SLUG/$BRANCH.zip"

if [[ -f "$CACHE" ]]; then
    echo $CACHE
    exit 0
fi

DIR=$(mktemp -d)
trap "rm -rf '$DIR'" EXIT

curl \
    --fail \
    --silent \
    --show-error \
    --location \
    --create-dirs \
    --output "$DIR/archive.zip" \
    "$URL?nonce=$(uuidgen)"

unzip -q "$DIR/archive.zip" -d "$DIR"
cd "$(find "$DIR" -depth 1 -type d)"
zip -q "$DIR/archive.zip" --move --recurse-paths .
mkdir -p $(dirname "$CACHE")
mv "$DIR/archive.zip" "$CACHE"

echo $CACHE
