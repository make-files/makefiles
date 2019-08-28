#!/usr/bin/env bash
set -euo pipefail

case $1 in
    spec-version)
        echo 1
        ;;
    version)
        echo 1
        ;;
    *)
        echo "unknown command '$1'" >&2
        exit 1
esac
